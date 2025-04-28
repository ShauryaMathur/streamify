--
-- PostgreSQL database dump
--

-- Dumped from database version 15.3
-- Dumped by pg_dump version 15.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: fn_tracks_by_album(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fn_tracks_by_album(p_album_id integer) RETURNS TABLE(track_id integer, name text, composer text, milliseconds integer, unit_price numeric)
    LANGUAGE sql
    AS $$
    SELECT Track_ID, Name, Composer, Milliseconds, Unit_Price
    FROM   Track
    WHERE  Album_ID = p_album_id
    ORDER  BY Track_ID;
$$;


--
-- Name: sp_apply_album_discount(integer, numeric); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.sp_apply_album_discount(IN p_album_id integer, IN p_discount_pct numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- guard: reject negative prices
    IF p_discount_pct < -100 THEN
        RAISE EXCEPTION 'Discount may not reduce price below 0';
    END IF;

    UPDATE Track
    SET    Unit_Price = ROUND(Unit_Price * (1 - p_discount_pct/100.0), 2)
    WHERE  Album_ID = p_album_id;
END;
$$;


--
-- Name: sp_insert_track(text, text, text, text, text, text, integer, integer, numeric); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.sp_insert_track(IN p_album_title text, IN p_artist_name text, IN p_track_name text, IN p_genre_name text, IN p_media_name text, IN p_composer text, IN p_milliseconds integer, IN p_bytes integer, IN p_price numeric)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_artist_id   INTEGER;
    v_album_id    INTEGER;
    v_genre_id    INTEGER;
    v_media_id    INTEGER;
BEGIN
    -- Artist  ────────────────────────────────────────────────
    INSERT INTO Artist (Name) VALUES (p_artist_name)
      ON CONFLICT (Name) DO NOTHING;

    SELECT Artist_ID INTO v_artist_id
    FROM   Artist  WHERE Name = p_artist_name;

    -- Album   ────────────────────────────────────────────────
    INSERT INTO Album (Title, Artist_ID)
    VALUES (p_album_title, v_artist_id)
      ON CONFLICT (Title, Artist_ID) DO NOTHING;

    SELECT Album_ID INTO v_album_id
    FROM   Album WHERE Title = p_album_title
                  AND   Artist_ID = v_artist_id;

    -- Lookup tables (Genre, MediaType) ───────────────────────
    INSERT INTO Genre (Name) VALUES (p_genre_name)
      ON CONFLICT (Name) DO NOTHING;

    SELECT Genre_ID INTO v_genre_id FROM Genre WHERE Name = p_genre_name;

    INSERT INTO Media_Type (Name) VALUES (p_media_name)
      ON CONFLICT (Name) DO NOTHING;

    SELECT Media_Type_ID INTO v_media_id
    FROM   Media_Type WHERE Name = p_media_name;

    -- Track  ─────────────────────────────────────────────────
    INSERT INTO Track (Name, Composer, Milliseconds, Bytes,
                       Unit_Price, Album_ID, Genre_ID, Media_Type_ID)
    VALUES (p_track_name, p_composer, p_milliseconds, p_bytes,
            p_price,      v_album_id, v_genre_id,  v_media_id);
END;
$$;


--
-- Name: sp_remove_track_from_playlist(integer, integer, boolean); Type: PROCEDURE; Schema: public; Owner: -
--

CREATE PROCEDURE public.sp_remove_track_from_playlist(IN p_playlist_id integer, IN p_track_id integer, IN p_drop_empty boolean DEFAULT true)
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM Playlist_Track
    WHERE  Playlist_ID = p_playlist_id
    AND    Track_ID    = p_track_id;

    IF p_drop_empty THEN
        DELETE FROM Playlist
        WHERE  Playlist_ID = p_playlist_id
        AND    NOT EXISTS (
                 SELECT 1 FROM Playlist_Track
                 WHERE  Playlist_ID = p_playlist_id);
    END IF;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: album; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.album (
    album_id integer NOT NULL,
    title character varying(160) NOT NULL,
    artist_id integer NOT NULL
);


--
-- Name: album_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.album_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: album_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.album_id_seq OWNED BY public.album.album_id;


--
-- Name: artist; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.artist (
    artist_id integer NOT NULL,
    name character varying(120)
);


--
-- Name: artist_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.artist_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: artist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.artist_id_seq OWNED BY public.artist.artist_id;


--
-- Name: customer; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.customer (
    customer_id integer NOT NULL,
    first_name character varying(40) NOT NULL,
    last_name character varying(20) NOT NULL,
    company character varying(80),
    address character varying(70),
    city character varying(40),
    state character varying(40),
    country character varying(40),
    postal_code character varying(10),
    phone character varying(24),
    email character varying(60) NOT NULL,
    support_rep_id integer
);


--
-- Name: employee; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.employee (
    employee_id integer NOT NULL,
    last_name character varying(20) NOT NULL,
    first_name character varying(20) NOT NULL,
    title character varying(30),
    reports_to integer,
    birth_date timestamp without time zone,
    hire_date timestamp without time zone,
    address character varying(70),
    city character varying(40),
    state character varying(40),
    country character varying(40),
    postal_code character varying(10),
    phone character varying(24),
    email character varying(60)
);


--
-- Name: genre; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.genre (
    genre_id integer NOT NULL,
    name character varying(120)
);


--
-- Name: genre_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.genre_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: genre_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.genre_id_seq OWNED BY public.genre.genre_id;


--
-- Name: invoice; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.invoice (
    invoice_id integer NOT NULL,
    customer_id integer NOT NULL,
    invoice_date timestamp without time zone NOT NULL,
    billing_address character varying(70),
    billing_city character varying(40),
    billing_state character varying(40),
    billing_country character varying(40),
    billing_postal_code character varying(10),
    total numeric(10,2) NOT NULL
);


--
-- Name: invoice_line; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.invoice_line (
    invoice_line_id integer NOT NULL,
    invoice_id integer NOT NULL,
    track_id integer NOT NULL,
    unit_price numeric(10,2) NOT NULL,
    quantity integer NOT NULL
);


--
-- Name: media_type; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.media_type (
    media_type_id integer NOT NULL,
    name character varying(120)
);


--
-- Name: mediatype_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mediatype_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mediatype_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mediatype_id_seq OWNED BY public.media_type.media_type_id;


--
-- Name: playlist; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.playlist (
    playlist_id integer NOT NULL,
    name character varying(120)
);


--
-- Name: playlist_track; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.playlist_track (
    playlist_id integer NOT NULL,
    track_id integer NOT NULL
);


--
-- Name: track; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.track (
    track_id integer NOT NULL,
    name character varying(200) NOT NULL,
    album_id integer,
    media_type_id integer NOT NULL,
    genre_id integer,
    composer character varying(220),
    milliseconds integer NOT NULL,
    bytes integer,
    unit_price numeric(10,2) NOT NULL
);


--
-- Name: track_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.track_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: track_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.track_id_seq OWNED BY public.track.track_id;


--
-- Name: album album_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.album ALTER COLUMN album_id SET DEFAULT nextval('public.album_id_seq'::regclass);


--
-- Name: artist artist_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.artist ALTER COLUMN artist_id SET DEFAULT nextval('public.artist_id_seq'::regclass);


--
-- Name: genre genre_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.genre ALTER COLUMN genre_id SET DEFAULT nextval('public.genre_id_seq'::regclass);


--
-- Name: media_type media_type_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_type ALTER COLUMN media_type_id SET DEFAULT nextval('public.mediatype_id_seq'::regclass);


--
-- Name: track track_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.track ALTER COLUMN track_id SET DEFAULT nextval('public.track_id_seq'::regclass);


--
-- Name: album album_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.album
    ADD CONSTRAINT album_pkey PRIMARY KEY (album_id);


--
-- Name: artist artist_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.artist
    ADD CONSTRAINT artist_pkey PRIMARY KEY (artist_id);


--
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (customer_id);


--
-- Name: employee employee_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (employee_id);


--
-- Name: genre genre_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.genre
    ADD CONSTRAINT genre_pkey PRIMARY KEY (genre_id);


--
-- Name: invoice_line invoice_line_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoice_line
    ADD CONSTRAINT invoice_line_pkey PRIMARY KEY (invoice_line_id);


--
-- Name: invoice invoice_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoice
    ADD CONSTRAINT invoice_pkey PRIMARY KEY (invoice_id);


--
-- Name: media_type media_type_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_type
    ADD CONSTRAINT media_type_pkey PRIMARY KEY (media_type_id);


--
-- Name: playlist playlist_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playlist
    ADD CONSTRAINT playlist_pkey PRIMARY KEY (playlist_id);


--
-- Name: playlist_track playlist_track_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playlist_track
    ADD CONSTRAINT playlist_track_pkey PRIMARY KEY (playlist_id, track_id);


--
-- Name: track track_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.track
    ADD CONSTRAINT track_pkey PRIMARY KEY (track_id);


--
-- Name: album uq_album_title_per_artist; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.album
    ADD CONSTRAINT uq_album_title_per_artist UNIQUE (title, artist_id);


--
-- Name: artist uq_artist_name; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.artist
    ADD CONSTRAINT uq_artist_name UNIQUE (name);


--
-- Name: genre uq_genre_name; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.genre
    ADD CONSTRAINT uq_genre_name UNIQUE (name);


--
-- Name: media_type uq_mediatype_name; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.media_type
    ADD CONSTRAINT uq_mediatype_name UNIQUE (name);


--
-- Name: album_artist_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX album_artist_id_idx ON public.album USING btree (artist_id);


--
-- Name: customer_support_rep_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX customer_support_rep_id_idx ON public.customer USING btree (support_rep_id);


--
-- Name: employee_reports_to_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX employee_reports_to_idx ON public.employee USING btree (reports_to);


--
-- Name: invoice_customer_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX invoice_customer_id_idx ON public.invoice USING btree (customer_id);


--
-- Name: invoice_line_invoice_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX invoice_line_invoice_id_idx ON public.invoice_line USING btree (invoice_id);


--
-- Name: invoice_line_track_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX invoice_line_track_id_idx ON public.invoice_line USING btree (track_id);


--
-- Name: playlist_track_playlist_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX playlist_track_playlist_id_idx ON public.playlist_track USING btree (playlist_id);


--
-- Name: playlist_track_track_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX playlist_track_track_id_idx ON public.playlist_track USING btree (track_id);


--
-- Name: track_album_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX track_album_id_idx ON public.track USING btree (album_id);


--
-- Name: track_genre_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX track_genre_id_idx ON public.track USING btree (genre_id);


--
-- Name: track_media_type_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX track_media_type_id_idx ON public.track USING btree (media_type_id);


--
-- Name: album album_artist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.album
    ADD CONSTRAINT album_artist_id_fkey FOREIGN KEY (artist_id) REFERENCES public.artist(artist_id);


--
-- Name: customer customer_support_rep_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_support_rep_id_fkey FOREIGN KEY (support_rep_id) REFERENCES public.employee(employee_id);


--
-- Name: employee employee_reports_to_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_reports_to_fkey FOREIGN KEY (reports_to) REFERENCES public.employee(employee_id);


--
-- Name: invoice invoice_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoice
    ADD CONSTRAINT invoice_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id);


--
-- Name: invoice_line invoice_line_invoice_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoice_line
    ADD CONSTRAINT invoice_line_invoice_id_fkey FOREIGN KEY (invoice_id) REFERENCES public.invoice(invoice_id);


--
-- Name: invoice_line invoice_line_track_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoice_line
    ADD CONSTRAINT invoice_line_track_id_fkey FOREIGN KEY (track_id) REFERENCES public.track(track_id);


--
-- Name: playlist_track playlist_track_playlist_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playlist_track
    ADD CONSTRAINT playlist_track_playlist_id_fkey FOREIGN KEY (playlist_id) REFERENCES public.playlist(playlist_id);


--
-- Name: playlist_track playlist_track_track_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playlist_track
    ADD CONSTRAINT playlist_track_track_id_fkey FOREIGN KEY (track_id) REFERENCES public.track(track_id);


--
-- Name: track track_album_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.track
    ADD CONSTRAINT track_album_id_fkey FOREIGN KEY (album_id) REFERENCES public.album(album_id);


--
-- Name: track track_genre_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.track
    ADD CONSTRAINT track_genre_id_fkey FOREIGN KEY (genre_id) REFERENCES public.genre(genre_id);


--
-- Name: track track_media_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.track
    ADD CONSTRAINT track_media_type_id_fkey FOREIGN KEY (media_type_id) REFERENCES public.media_type(media_type_id);


--
-- PostgreSQL database dump complete
--

