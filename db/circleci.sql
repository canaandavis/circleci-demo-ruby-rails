--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.2
-- Dumped by pg_dump version 9.6.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;


--
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: tablefunc; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS tablefunc WITH SCHEMA public;


--
-- Name: EXTENSION tablefunc; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION tablefunc IS 'functions that manipulate whole tables, including crosstab';


SET search_path = public, pg_catalog;

--
-- Name: pc_chartoint(character varying); Type: FUNCTION; Schema: public; Owner: canaandavis
--

CREATE FUNCTION pc_chartoint(chartoconvert character varying) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
SELECT CASE WHEN trim($1) SIMILAR TO '[0-9]+' 
        THEN CAST(trim($1) AS integer) 
    ELSE NULL END;

$_$;


ALTER FUNCTION public.pc_chartoint(chartoconvert character varying) OWNER TO canaandavis;

--
-- Name: queue_classic_notify(); Type: FUNCTION; Schema: public; Owner: canaandavis
--

CREATE FUNCTION queue_classic_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ begin
  perform pg_notify(new.q_name, '');
  return null;
end $$;


ALTER FUNCTION public.queue_classic_notify() OWNER TO canaandavis;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: account_events; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE account_events (
    id integer NOT NULL,
    key character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    "position" integer DEFAULT 0 NOT NULL,
    internal_enabled boolean DEFAULT true NOT NULL,
    duplicates boolean DEFAULT false NOT NULL,
    snooze integer DEFAULT 0 NOT NULL,
    response_days integer DEFAULT 0 NOT NULL,
    default_action_log_type integer,
    default_follow_up_log_type integer,
    default_follow_up_due_at_days integer,
    user_id integer,
    autocomplete boolean
);


ALTER TABLE account_events OWNER TO canaandavis;

--
-- Name: account_events_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE account_events_id_seq
    START WITH 119
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE account_events_id_seq OWNER TO canaandavis;

--
-- Name: account_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE account_events_id_seq OWNED BY account_events.id;


--
-- Name: account_health_grade_changes; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE account_health_grade_changes (
    id integer NOT NULL,
    account_id integer,
    new_health_grade integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE account_health_grade_changes OWNER TO canaandavis;

--
-- Name: account_health_grade_changes_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE account_health_grade_changes_id_seq
    START WITH 485188
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE account_health_grade_changes_id_seq OWNER TO canaandavis;

--
-- Name: account_health_grade_changes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE account_health_grade_changes_id_seq OWNED BY account_health_grade_changes.id;


--
-- Name: account_logs; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE account_logs (
    id integer NOT NULL,
    account_id integer,
    user_id integer,
    message_template_id integer,
    note text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    due_at timestamp without time zone,
    completed_at timestamp without time zone,
    log_type integer DEFAULT 0 NOT NULL,
    nps integer,
    parent_id integer,
    escalated boolean DEFAULT false NOT NULL,
    account_event_id integer,
    respond_at timestamp without time zone,
    source text,
    log_type_name character varying(255)
);


ALTER TABLE account_logs OWNER TO canaandavis;

--
-- Name: account_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE account_logs_id_seq
    START WITH 748691
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE account_logs_id_seq OWNER TO canaandavis;

--
-- Name: account_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE account_logs_id_seq OWNED BY account_logs.id;


--
-- Name: account_status_changes; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE account_status_changes (
    id integer NOT NULL,
    account_id integer,
    new_status integer,
    reason character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE account_status_changes OWNER TO canaandavis;

--
-- Name: account_status_changes_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE account_status_changes_id_seq
    START WITH 503140
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE account_status_changes_id_seq OWNER TO canaandavis;

--
-- Name: account_status_changes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE account_status_changes_id_seq OWNED BY account_status_changes.id;


--
-- Name: account_type_employments; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE account_type_employments (
    id integer NOT NULL,
    account_type_id integer,
    employment_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE account_type_employments OWNER TO canaandavis;

--
-- Name: account_type_employments_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE account_type_employments_id_seq
    START WITH 330157
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE account_type_employments_id_seq OWNER TO canaandavis;

--
-- Name: account_type_employments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE account_type_employments_id_seq OWNED BY account_type_employments.id;


--
-- Name: account_types; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE account_types (
    id integer NOT NULL,
    name character varying(255),
    key character varying(255),
    disclaimer text,
    signup_subdomain character varying(255),
    main_support_url character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    default_country character varying(255) DEFAULT 'US'::character varying NOT NULL,
    signup_template character varying(255) DEFAULT 'general'::character varying NOT NULL,
    aspirant boolean DEFAULT false NOT NULL,
    aspirant_account_type_id integer,
    custom_microsite_name character varying(255),
    custom_careers_title character varying(255),
    testimonial_content text,
    testimonial_attribution text,
    testimonial_logo_url character varying(255),
    signup_content text,
    signup_style text,
    signup_heading character varying(255),
    referral_message text,
    referral_button character varying(255),
    referral_thanks text,
    default_referral_plan_id integer,
    permissions text,
    account_color_primary character varying(255),
    account_description text,
    account_name_append character varying(255),
    account_name_prepend character varying(255),
    account_subdomain character varying(255),
    apply_initial_sources boolean DEFAULT false NOT NULL,
    aspirant_benchmark_title character varying(255),
    disable_coupons boolean DEFAULT false NOT NULL,
    eeoc_tracking boolean DEFAULT false NOT NULL,
    has_resumes boolean DEFAULT false NOT NULL,
    multiple_job_limit character varying(255),
    multiple_job_same_name boolean DEFAULT false NOT NULL,
    notify_locations boolean DEFAULT false NOT NULL,
    onboard boolean DEFAULT false NOT NULL,
    prevent_video boolean DEFAULT false NOT NULL,
    resume_requests_available integer,
    suppress_feed boolean DEFAULT false NOT NULL,
    user_job_title character varying(255),
    copy_logo_id integer,
    domain_id integer,
    initial_sources text,
    default_overview_builder_id integer,
    site_template_id integer,
    embedded_site_template_id integer,
    default_company_photo_id integer,
    onboarding_video_url character varying(255),
    health_grade_key_id integer,
    default_apps_filter text,
    workflow_id integer,
    brand character varying(255),
    support_email character varying(255),
    support_phone character varying(255),
    logo_file_name character varying(255),
    logo_content_type character varying(255),
    logo_file_size integer,
    logo_updated_at timestamp without time zone,
    footer_content text,
    white_label_domain_id integer,
    indeed_referral_partner_code character varying,
    white_label_ats_subdomain character varying,
    white_label_hris_subdomain character varying,
    white_label_style text,
    custom_upgrade_url character varying,
    source_name character varying,
    favicon_file_name character varying,
    favicon_content_type character varying,
    favicon_file_size integer,
    favicon_updated_at timestamp without time zone,
    account_terms_of_service text,
    user_terms_of_service text,
    activate_page_content character varying,
    activate_page_css character varying,
    copy_site_template_config_id integer,
    disclaimer_trl_key character varying,
    contact_form_url character varying
);


ALTER TABLE account_types OWNER TO canaandavis;

--
-- Name: account_types_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE account_types_id_seq
    START WITH 330066
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE account_types_id_seq OWNER TO canaandavis;

--
-- Name: account_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE account_types_id_seq OWNED BY account_types.id;


--
-- Name: accounts; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE accounts (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    description text,
    subdomain character varying(255),
    logo_file_name character varying(255),
    logo_content_type character varying(255),
    logo_file_size integer,
    logo_updated_at timestamp without time zone,
    domain_id integer,
    site_template_id integer,
    extra_field_set_id integer,
    account_type_id integer DEFAULT 0 NOT NULL,
    plan_id integer,
    subscription_id character varying(255),
    payment_status character varying(255) DEFAULT 'pending'::character varying,
    first_name character varying(255),
    last_name character varying(255),
    address character varying(255),
    city character varying(255),
    state character varying(255),
    zip character varying(255),
    phone character varying(255),
    cc_expire_at timestamp without time zone,
    company_url character varying(255),
    facebook_url character varying(255),
    linkedin_url character varying(255),
    sf_code character varying(255),
    video_url character varying(255),
    eeoc boolean DEFAULT false NOT NULL,
    coupon_expires_at timestamp without time zone,
    referral_code character varying(255),
    default_country character varying(255) DEFAULT 'US'::character varying NOT NULL,
    has_resumes boolean DEFAULT true NOT NULL,
    trial_expires_at timestamp without time zone,
    perfman_enabled boolean DEFAULT false NOT NULL,
    perfman_activated_at timestamp without time zone,
    perfman_setup_at timestamp without time zone,
    resume_requests_available integer DEFAULT 2 NOT NULL,
    next_payment_at timestamp without time zone,
    auto_renew boolean DEFAULT true NOT NULL,
    aspirant boolean DEFAULT false NOT NULL,
    agency_overview text,
    upgraded_at timestamp without time zone,
    aspirant_activated_at timestamp without time zone,
    workflow_id integer,
    account_manager_id integer,
    last_renewed_at timestamp without time zone,
    onboarded_at timestamp without time zone,
    twitter_url character varying(255),
    email character varying(255),
    cancelled_at timestamp without time zone,
    deleted_at timestamp without time zone,
    custom_microsite_name character varying(255),
    custom_careers_title character varying(255),
    payment_profile_id character varying(255),
    customer_profile_id character varying(255),
    embedded_site_template_id integer,
    cc_digits character varying(255),
    anonymous_name character varying(255),
    payment_type integer DEFAULT 0 NOT NULL,
    first_job_notified_at timestamp without time zone,
    activity_status integer DEFAULT 0 NOT NULL,
    billing_email text,
    sales_exec_id integer,
    designation integer DEFAULT 0 NOT NULL,
    health_grade integer DEFAULT 0 NOT NULL,
    permissions text,
    assessments_integration_dept character varying(255),
    background_check_account character varying(255),
    background_check_username character varying(255),
    selected_timezone character varying(255),
    aspirant_job_limit integer,
    assessments_disabled boolean DEFAULT false NOT NULL,
    assessments_outdated boolean DEFAULT false NOT NULL,
    assessments_integration boolean DEFAULT false NOT NULL,
    assessments_integration_integrate character varying(255),
    assessments_integration_company character varying(255),
    auto_refresh boolean DEFAULT false NOT NULL,
    background_check_integration boolean DEFAULT false NOT NULL,
    background_check_integration_notify text,
    force_setup boolean DEFAULT false NOT NULL,
    skip_setup boolean DEFAULT false NOT NULL,
    handyman_franchise character varying(255),
    handyman_team character varying(255),
    hide_facebook_share boolean DEFAULT false NOT NULL,
    hide_facebook_status boolean DEFAULT false NOT NULL,
    hide_linkedin_share boolean DEFAULT false NOT NULL,
    hide_linkedin_status boolean DEFAULT false NOT NULL,
    hide_twitter_share boolean DEFAULT false NOT NULL,
    hide_twitter_status boolean DEFAULT false NOT NULL,
    ignore_no_assessments boolean DEFAULT false NOT NULL,
    ignore_popup_blocker boolean DEFAULT false NOT NULL,
    ignore_resume_requests boolean DEFAULT false NOT NULL,
    internal_email_disabled boolean DEFAULT false NOT NULL,
    location_job_list boolean DEFAULT false NOT NULL,
    lock_job_description boolean DEFAULT false NOT NULL,
    override_hiring_step character varying(255),
    post_apply_redirect character varying(255),
    suppress_feed boolean DEFAULT false NOT NULL,
    assessment_override_from_id integer,
    assessment_override_to_id integer,
    coupon_expire text,
    default_app_forms text,
    site_template_config text,
    job_approval_notify text,
    embedded_site_template_config text,
    nps integer,
    cohort_id integer,
    hidden_job_templates text,
    hidden_app_forms text,
    paid_active_jobs integer,
    paid_active_locations integer,
    last_login_time_health integer,
    active_postings_health integer,
    num_applicants_health integer,
    avg_prescreen_questions_health integer,
    assessments_health integer,
    renewal_count integer DEFAULT 0 NOT NULL,
    last_scheduled_renewal timestamp without time zone,
    salesforce_id character varying(255),
    snagajob_feed_enabled boolean DEFAULT false NOT NULL,
    snagajob_industry integer,
    payroll_company_code character varying(255),
    location_num character varying(255),
    last_payment_amount integer,
    downgraded_at timestamp without time zone,
    reactivated_at timestamp without time zone,
    declined_warning_count integer DEFAULT 0,
    auto_send_fast_track_invite boolean DEFAULT false,
    indeed_advnum character varying,
    wotc_client_id character varying,
    wotc_default_location_id character varying,
    mask_rejection_email_enabled boolean DEFAULT false NOT NULL,
    enable_agg_subdomain boolean DEFAULT false NOT NULL,
    agg_subdomain character varying,
    survey_opt_in boolean DEFAULT false NOT NULL,
    progression_info text,
    header_headline character varying,
    header_tagline character varying,
    header_description text,
    perks_headline text,
    perks_tagline text,
    perks_description text,
    header_background character varying,
    background_check_type integer,
    first_app_notified_at timestamp without time zone,
    name_trl_key character varying,
    description_trl_key character varying,
    header_headline_trl_key character varying,
    header_tagline_trl_key character varying,
    header_description_trl_key character varying,
    perks_headline_trl_key character varying,
    perks_tagline_trl_key character varying,
    perks_description_trl_key character varying,
    plan_cycle_id integer,
    pending_plan_cycle_id integer,
    fifth_app_date timestamp without time zone
);


ALTER TABLE accounts OWNER TO canaandavis;

--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE accounts_id_seq
    START WITH 497301
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE accounts_id_seq OWNER TO canaandavis;

--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE accounts_id_seq OWNED BY accounts.id;


--
-- Name: agent_aliases; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE agent_aliases (
    id integer NOT NULL,
    alias character varying(255),
    email character varying(255),
    account_id integer,
    invited_at timestamp without time zone,
    activated_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    firstname character varying(255),
    lastname character varying(255),
    country character varying(255)
);


ALTER TABLE agent_aliases OWNER TO canaandavis;

--
-- Name: agent_aliases_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE agent_aliases_id_seq
    START WITH 485166
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE agent_aliases_id_seq OWNER TO canaandavis;

--
-- Name: agent_aliases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE agent_aliases_id_seq OWNED BY agent_aliases.id;


--
-- Name: answer_sets; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE answer_sets (
    id integer NOT NULL,
    owner_id integer,
    question_id integer,
    answer_id integer,
    answer_text text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    owner_type character varying(255) DEFAULT 'App'::character varying NOT NULL
);


ALTER TABLE answer_sets OWNER TO canaandavis;

--
-- Name: answer_sets_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE answer_sets_id_seq
    START WITH 482505
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE answer_sets_id_seq OWNER TO canaandavis;

--
-- Name: answer_sets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE answer_sets_id_seq OWNED BY answer_sets.id;


--
-- Name: answers; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE answers (
    id integer NOT NULL,
    name text,
    question_id integer,
    score integer,
    "position" integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    data text,
    name_trl_key character varying
);


ALTER TABLE answers OWNER TO canaandavis;

--
-- Name: answers_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE answers_id_seq
    START WITH 895873
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE answers_id_seq OWNER TO canaandavis;

--
-- Name: answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE answers_id_seq OWNED BY answers.id;


--
-- Name: api_credentials; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE api_credentials (
    id integer NOT NULL,
    name character varying(255),
    username character varying(255),
    password_digest character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE api_credentials OWNER TO canaandavis;

--
-- Name: api_credentials_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE api_credentials_id_seq
    START WITH 5
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE api_credentials_id_seq OWNER TO canaandavis;

--
-- Name: api_credentials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE api_credentials_id_seq OWNED BY api_credentials.id;


--
-- Name: app_accesses; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE app_accesses (
    id integer NOT NULL,
    user_id integer,
    application character varying(255),
    role integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE app_accesses OWNER TO canaandavis;

--
-- Name: app_accesses_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE app_accesses_id_seq
    START WITH 514240
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE app_accesses_id_seq OWNER TO canaandavis;

--
-- Name: app_accesses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE app_accesses_id_seq OWNED BY app_accesses.id;


--
-- Name: app_forms; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE app_forms (
    id integer NOT NULL,
    account_id integer,
    name character varying(255),
    content text,
    style text,
    result text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    form_type integer DEFAULT 0 NOT NULL,
    notify_completion boolean DEFAULT false,
    options text,
    archived boolean DEFAULT false NOT NULL
);


ALTER TABLE app_forms OWNER TO canaandavis;

--
-- Name: app_forms_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE app_forms_id_seq
    START WITH 480426
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE app_forms_id_seq OWNER TO canaandavis;

--
-- Name: app_forms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE app_forms_id_seq OWNED BY app_forms.id;


--
-- Name: app_updates; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE app_updates (
    id integer NOT NULL,
    app_id integer,
    user_id integer,
    owner_id integer,
    workflow_step_id integer,
    comment text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    rating integer,
    workflow_category_id integer,
    update_type integer
);


ALTER TABLE app_updates OWNER TO canaandavis;

--
-- Name: app_updates_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE app_updates_id_seq
    START WITH 7886873
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE app_updates_id_seq OWNER TO canaandavis;

--
-- Name: app_updates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE app_updates_id_seq OWNED BY app_updates.id;


--
-- Name: applicants; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE applicants (
    id integer NOT NULL,
    email character varying(255),
    firstname character varying(255),
    lastname character varying(255),
    phone character varying(255),
    address character varying(255),
    city character varying(255),
    state character varying(255),
    zip character varying(255),
    country character varying(255),
    resume_text text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    source_id integer,
    recent_title character varying(255),
    recent_employer character varying(255),
    linkedin_url character varying(255),
    cover_letter text,
    bounced_at timestamp without time zone
);


ALTER TABLE applicants OWNER TO canaandavis;

--
-- Name: applicants_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE applicants_id_seq
    START WITH 8044331
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE applicants_id_seq OWNER TO canaandavis;

--
-- Name: applicants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE applicants_id_seq OWNED BY applicants.id;


--
-- Name: application_alerts; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE application_alerts (
    id bigint NOT NULL,
    title character varying,
    body character varying,
    action_type integer DEFAULT 0,
    action_data character varying,
    alert_type integer DEFAULT 0,
    read_at timestamp without time zone,
    received_at timestamp without time zone,
    user_id bigint,
    owner_type character varying,
    owner_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE application_alerts OWNER TO canaandavis;

--
-- Name: application_alerts_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE application_alerts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE application_alerts_id_seq OWNER TO canaandavis;

--
-- Name: application_alerts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE application_alerts_id_seq OWNED BY application_alerts.id;


--
-- Name: application_phone_numbers; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE application_phone_numbers (
    id integer NOT NULL,
    number_id character varying,
    number character varying,
    national_number character varying,
    active boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    app_env integer,
    user_id bigint
);


ALTER TABLE application_phone_numbers OWNER TO canaandavis;

--
-- Name: application_phone_numbers_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE application_phone_numbers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE application_phone_numbers_id_seq OWNER TO canaandavis;

--
-- Name: application_phone_numbers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE application_phone_numbers_id_seq OWNED BY application_phone_numbers.id;


--
-- Name: appointment_updates; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE appointment_updates (
    id integer NOT NULL,
    appointment_id integer,
    start_time timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    end_time timestamp without time zone,
    current boolean DEFAULT false NOT NULL,
    timezone character varying
);


ALTER TABLE appointment_updates OWNER TO canaandavis;

--
-- Name: appointment_updates_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE appointment_updates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE appointment_updates_id_seq OWNER TO canaandavis;

--
-- Name: appointment_updates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE appointment_updates_id_seq OWNED BY appointment_updates.id;


--
-- Name: appointments; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE appointments (
    id integer NOT NULL,
    scheduler_id integer,
    scheduler_type character varying,
    schedule_owner_id integer,
    schedule_owner_type character varying,
    owner_id integer,
    owner_type character varying,
    expires_in integer,
    duration integer,
    location character varying,
    name character varying,
    status integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    reschedule_enabled_at timestamp without time zone,
    appointment_type integer DEFAULT 0,
    future_days integer DEFAULT 14
);


ALTER TABLE appointments OWNER TO canaandavis;

--
-- Name: appointments_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE appointments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE appointments_id_seq OWNER TO canaandavis;

--
-- Name: appointments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE appointments_id_seq OWNED BY appointments.id;


--
-- Name: apps; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE apps (
    id integer NOT NULL,
    applicant_id integer,
    job_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    source_id integer,
    owner_id integer,
    workflow_step_id integer,
    workflow_category_id integer,
    hiring_status character varying(255) DEFAULT 'new_app'::character varying NOT NULL,
    status_cache text,
    employee integer,
    is_benchmark boolean DEFAULT false NOT NULL,
    employment_status integer,
    reason_for_leaving character varying(255),
    employment_ended_at timestamp without time zone,
    referral_id integer,
    account_id integer,
    user_id integer,
    has_evals boolean DEFAULT true NOT NULL,
    has_goals boolean DEFAULT true NOT NULL,
    apply_type integer DEFAULT 0 NOT NULL,
    xss_lookup character varying(255),
    favorite boolean DEFAULT false NOT NULL,
    pipeline_step_id integer,
    cloned_from_resume boolean DEFAULT false NOT NULL,
    distance double precision DEFAULT 8000 NOT NULL,
    team_benchmark boolean DEFAULT false NOT NULL,
    assigned_assessments character varying(255),
    assessment_set_ids character varying(255),
    cloned_assessments integer,
    assessments_completed_at timestamp without time zone,
    pipeline boolean DEFAULT false,
    overall_rating double precision,
    days_to_fill integer,
    eeoc_job_category character varying(255),
    eeoc_gender character varying(255),
    eeoc_race character varying(255),
    eeoc_disability character varying(255),
    eeoc_veteran character varying(255),
    referred_by character varying(255),
    referred_by_email character varying(255),
    external_id character varying(255),
    application_required boolean,
    application_completed_at timestamp without time zone,
    last_indexed_at timestamp without time zone,
    user_phone_number_id bigint
);


ALTER TABLE apps OWNER TO canaandavis;

--
-- Name: apps_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE apps_id_seq
    START WITH 8034566
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE apps_id_seq OWNER TO canaandavis;

--
-- Name: apps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE apps_id_seq OWNED BY apps.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE ar_internal_metadata OWNER TO canaandavis;

--
-- Name: assessment_categories; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE assessment_categories (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    agent_aspirant integer,
    account_id integer,
    headline character varying(255),
    description text
);


ALTER TABLE assessment_categories OWNER TO canaandavis;

--
-- Name: assessment_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE assessment_categories_id_seq
    START WITH 118
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE assessment_categories_id_seq OWNER TO canaandavis;

--
-- Name: assessment_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE assessment_categories_id_seq OWNED BY assessment_categories.id;


--
-- Name: assessment_scores; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE assessment_scores (
    id integer NOT NULL,
    scoring_set_id integer,
    assessment_category_id integer,
    score integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE assessment_scores OWNER TO canaandavis;

--
-- Name: assessment_scores_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE assessment_scores_id_seq
    START WITH 29893245
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE assessment_scores_id_seq OWNER TO canaandavis;

--
-- Name: assessment_scores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE assessment_scores_id_seq OWNED BY assessment_scores.id;


--
-- Name: assessments; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE assessments (
    id integer NOT NULL,
    job_id integer,
    questionnaire_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE assessments OWNER TO canaandavis;

--
-- Name: assessments_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE assessments_id_seq
    START WITH 730540
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE assessments_id_seq OWNER TO canaandavis;

--
-- Name: assessments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE assessments_id_seq OWNED BY assessments.id;


--
-- Name: auth_results; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE auth_results (
    id integer NOT NULL,
    subscription_id character varying(255),
    payment_number character varying(255),
    response_code integer,
    response_text text,
    notified_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    payload text
);


ALTER TABLE auth_results OWNER TO canaandavis;

--
-- Name: auth_results_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE auth_results_id_seq
    START WITH 526463
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth_results_id_seq OWNER TO canaandavis;

--
-- Name: auth_results_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE auth_results_id_seq OWNED BY auth_results.id;


--
-- Name: benchmark_scores; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE benchmark_scores (
    id integer NOT NULL,
    account_type_id integer,
    question_set_id integer,
    category_id integer,
    average_score integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE benchmark_scores OWNER TO canaandavis;

--
-- Name: benchmark_scores_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE benchmark_scores_id_seq
    START WITH 1029613
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE benchmark_scores_id_seq OWNER TO canaandavis;

--
-- Name: benchmark_scores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE benchmark_scores_id_seq OWNED BY benchmark_scores.id;


--
-- Name: brands; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE brands (
    id integer NOT NULL,
    account_id integer,
    name character varying(255),
    description text,
    logo_file_name character varying(255),
    logo_content_type character varying(255),
    logo_file_size integer,
    logo_updated_at timestamp without time zone,
    site_template_id integer,
    embedded_site_template_id integer,
    company_url character varying(255),
    facebook_url character varying(255),
    linkedin_url character varying(255),
    video_url character varying(255),
    twitter_url character varying(255),
    custom_microsite_name character varying(255),
    custom_careers_title character varying(255),
    anonymous_name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    subdomain character varying(255),
    site_template_config text,
    embedded_site_template_config text,
    payroll_company_code character varying(255),
    header_headline character varying,
    header_tagline character varying,
    header_description text,
    header_background character varying,
    perks_headline character varying,
    perks_tagline character varying,
    perks_description text,
    name_trl_key character varying,
    description_trl_key character varying,
    header_headline_trl_key character varying,
    header_tagline_trl_key character varying,
    header_description_trl_key character varying,
    perks_headline_trl_key character varying,
    perks_tagline_trl_key character varying,
    perks_description_trl_key character varying
);


ALTER TABLE brands OWNER TO canaandavis;

--
-- Name: brands_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE brands_id_seq
    START WITH 480069
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE brands_id_seq OWNER TO canaandavis;

--
-- Name: brands_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE brands_id_seq OWNED BY brands.id;


--
-- Name: bug_report_comments; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE bug_report_comments (
    id integer NOT NULL,
    comment text,
    bug_report_id integer,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    bug_status integer
);


ALTER TABLE bug_report_comments OWNER TO canaandavis;

--
-- Name: bug_report_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE bug_report_comments_id_seq
    START WITH 480599
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bug_report_comments_id_seq OWNER TO canaandavis;

--
-- Name: bug_report_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE bug_report_comments_id_seq OWNED BY bug_report_comments.id;


--
-- Name: bug_reports; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE bug_reports (
    id integer NOT NULL,
    summary character varying(255),
    description text,
    example_account_id integer,
    status integer,
    reported_by character varying(255),
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    story_url character varying(255),
    reporting_account_ids character varying(255),
    client_phone character varying(255),
    client_email character varying(255),
    target_completion_date timestamp without time zone,
    issue_type integer,
    story_id integer,
    fixed_at timestamp without time zone,
    priority integer
);


ALTER TABLE bug_reports OWNER TO canaandavis;

--
-- Name: bug_reports_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE bug_reports_id_seq
    START WITH 480749
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bug_reports_id_seq OWNER TO canaandavis;

--
-- Name: bug_reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE bug_reports_id_seq OWNED BY bug_reports.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE categories (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    zip_recruiter_category character varying
);


ALTER TABLE categories OWNER TO canaandavis;

--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE categories_id_seq
    START WITH 180074
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE categories_id_seq OWNER TO canaandavis;

--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE categories_id_seq OWNED BY categories.id;


--
-- Name: cohorts; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE cohorts (
    id integer NOT NULL,
    year integer,
    month integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    billing_type integer
);


ALTER TABLE cohorts OWNER TO canaandavis;

--
-- Name: cohorts_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE cohorts_id_seq
    START WITH 480002
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE cohorts_id_seq OWNER TO canaandavis;

--
-- Name: cohorts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE cohorts_id_seq OWNED BY cohorts.id;


--
-- Name: company_photos; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE company_photos (
    id integer NOT NULL,
    owner_id integer,
    name character varying(255),
    "position" integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    company_photo_file_name character varying(255),
    company_photo_content_type character varying(255),
    company_photo_file_size integer,
    owner_type character varying(255)
);


ALTER TABLE company_photos OWNER TO canaandavis;

--
-- Name: company_photos_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE company_photos_id_seq
    START WITH 509170
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE company_photos_id_seq OWNER TO canaandavis;

--
-- Name: company_photos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE company_photos_id_seq OWNED BY company_photos.id;


--
-- Name: competencies; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE competencies (
    id integer NOT NULL,
    name character varying(255),
    prompt text,
    account_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE competencies OWNER TO canaandavis;

--
-- Name: competencies_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE competencies_id_seq
    START WITH 480541
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE competencies_id_seq OWNER TO canaandavis;

--
-- Name: competencies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE competencies_id_seq OWNED BY competencies.id;


--
-- Name: completed_forms; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE completed_forms (
    id integer NOT NULL,
    app_id integer,
    app_form_id integer,
    data text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE completed_forms OWNER TO canaandavis;

--
-- Name: completed_forms_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE completed_forms_id_seq
    START WITH 1354610
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE completed_forms_id_seq OWNER TO canaandavis;

--
-- Name: completed_forms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE completed_forms_id_seq OWNED BY completed_forms.id;


--
-- Name: coupon_appointments; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE coupon_appointments (
    id integer NOT NULL,
    coupon_id integer,
    appointment timestamp without time zone
);


ALTER TABLE coupon_appointments OWNER TO canaandavis;

--
-- Name: coupon_appointments_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE coupon_appointments_id_seq
    START WITH 15547
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE coupon_appointments_id_seq OWNER TO canaandavis;

--
-- Name: coupon_appointments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE coupon_appointments_id_seq OWNED BY coupon_appointments.id;


--
-- Name: coupons; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE coupons (
    id integer NOT NULL,
    name character varying(255),
    plan_id integer,
    expire_plan_id integer,
    expire_terms integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    account_type_id integer,
    start_at timestamp without time zone,
    end_at timestamp without time zone,
    bypass_payment boolean DEFAULT false NOT NULL
);


ALTER TABLE coupons OWNER TO canaandavis;

--
-- Name: coupons_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE coupons_id_seq
    START WITH 15195
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE coupons_id_seq OWNER TO canaandavis;

--
-- Name: coupons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE coupons_id_seq OWNED BY coupons.id;


--
-- Name: domains; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE domains (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    is_white_label boolean DEFAULT false NOT NULL
);


ALTER TABLE domains OWNER TO canaandavis;

--
-- Name: domains_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE domains_id_seq
    START WITH 6
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE domains_id_seq OWNER TO canaandavis;

--
-- Name: domains_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE domains_id_seq OWNED BY domains.id;


--
-- Name: email_recipients; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE email_recipients (
    id integer NOT NULL,
    user_id integer,
    email_recipient_id integer,
    email_address character varying(255)
);


ALTER TABLE email_recipients OWNER TO canaandavis;

--
-- Name: email_recipients_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE email_recipients_id_seq
    START WITH 480043
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE email_recipients_id_seq OWNER TO canaandavis;

--
-- Name: email_recipients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE email_recipients_id_seq OWNED BY email_recipients.id;


--
-- Name: email_threads; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE email_threads (
    id integer NOT NULL,
    uid character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE email_threads OWNER TO canaandavis;

--
-- Name: email_threads_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE email_threads_id_seq
    START WITH 1422891
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE email_threads_id_seq OWNER TO canaandavis;

--
-- Name: email_threads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE email_threads_id_seq OWNED BY email_threads.id;


--
-- Name: emails; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE emails (
    id integer NOT NULL,
    account_id integer,
    user_id integer,
    event character varying(255),
    related_id integer,
    "to" text,
    subject character varying(255),
    body text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    invite boolean DEFAULT false NOT NULL,
    location character varying(255),
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    cc text,
    "from" character varying(255),
    email_thread_id integer,
    timezone character varying(255),
    include_signature boolean,
    bcc text,
    scheduled_at timestamp without time zone,
    sent_at timestamp without time zone,
    bulk_rejection_email boolean DEFAULT false NOT NULL,
    invite_schedule boolean DEFAULT false NOT NULL,
    read_at timestamp without time zone,
    tracked boolean
);


ALTER TABLE emails OWNER TO canaandavis;

--
-- Name: emails_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE emails_id_seq
    START WITH 2108534
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE emails_id_seq OWNER TO canaandavis;

--
-- Name: emails_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE emails_id_seq OWNED BY emails.id;


--
-- Name: employments; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE employments (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    account_id integer,
    name_trl_key character varying
);


ALTER TABLE employments OWNER TO canaandavis;

--
-- Name: employments_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE employments_id_seq
    START WITH 15130
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE employments_id_seq OWNER TO canaandavis;

--
-- Name: employments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE employments_id_seq OWNED BY employments.id;


--
-- Name: external_site_links; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE external_site_links (
    id integer NOT NULL,
    name character varying(255),
    url character varying(255),
    owner_id integer,
    owner_type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    link_type integer
);


ALTER TABLE external_site_links OWNER TO canaandavis;

--
-- Name: external_site_links_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE external_site_links_id_seq
    START WITH 481891
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE external_site_links_id_seq OWNER TO canaandavis;

--
-- Name: external_site_links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE external_site_links_id_seq OWNED BY external_site_links.id;


--
-- Name: fast_track_answers; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE fast_track_answers (
    id integer NOT NULL,
    answer_id integer NOT NULL,
    category integer NOT NULL,
    job_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE fast_track_answers OWNER TO canaandavis;

--
-- Name: fast_track_answers_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE fast_track_answers_id_seq
    START WITH 886547
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE fast_track_answers_id_seq OWNER TO canaandavis;

--
-- Name: fast_track_answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE fast_track_answers_id_seq OWNED BY fast_track_answers.id;


--
-- Name: has_account_types; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE has_account_types (
    id integer NOT NULL,
    account_type_id integer,
    owner_id integer,
    owner_type character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE has_account_types OWNER TO canaandavis;

--
-- Name: has_account_types_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE has_account_types_id_seq
    START WITH 519500
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE has_account_types_id_seq OWNER TO canaandavis;

--
-- Name: has_account_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE has_account_types_id_seq OWNED BY has_account_types.id;


--
-- Name: has_apps; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE has_apps (
    id integer NOT NULL,
    app_id integer,
    owner_id integer,
    owner_type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE has_apps OWNER TO canaandavis;

--
-- Name: has_apps_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE has_apps_id_seq
    START WITH 549399
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE has_apps_id_seq OWNER TO canaandavis;

--
-- Name: has_apps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE has_apps_id_seq OWNED BY has_apps.id;


--
-- Name: has_attachments; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE has_attachments (
    id integer NOT NULL,
    owner_id integer,
    name character varying(255),
    attachment_file_name character varying(255),
    attachment_content_type character varying(255),
    attachment_file_size integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    owner_type character varying(255) DEFAULT 'App'::character varying NOT NULL,
    text_cache text,
    applicant_photo boolean DEFAULT false NOT NULL,
    tags character varying(255)
);


ALTER TABLE has_attachments OWNER TO canaandavis;

--
-- Name: has_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE has_attachments_id_seq
    START WITH 6747871
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE has_attachments_id_seq OWNER TO canaandavis;

--
-- Name: has_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE has_attachments_id_seq OWNED BY has_attachments.id;


--
-- Name: has_industries; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE has_industries (
    id integer NOT NULL,
    industry_id integer,
    owner_id integer,
    owner_type character varying(255)
);


ALTER TABLE has_industries OWNER TO canaandavis;

--
-- Name: has_industries_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE has_industries_id_seq
    START WITH 496693
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE has_industries_id_seq OWNER TO canaandavis;

--
-- Name: has_industries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE has_industries_id_seq OWNED BY has_industries.id;


--
-- Name: has_message_templates; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE has_message_templates (
    id integer NOT NULL,
    message_template_id integer,
    owner_id integer,
    owner_type character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE has_message_templates OWNER TO canaandavis;

--
-- Name: has_message_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE has_message_templates_id_seq
    START WITH 15
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE has_message_templates_id_seq OWNER TO canaandavis;

--
-- Name: has_message_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE has_message_templates_id_seq OWNED BY has_message_templates.id;


--
-- Name: has_support_team_members; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE has_support_team_members (
    id integer NOT NULL,
    user_id integer,
    account_type_id integer
);


ALTER TABLE has_support_team_members OWNER TO canaandavis;

--
-- Name: has_support_team_members_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE has_support_team_members_id_seq
    START WITH 330003
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE has_support_team_members_id_seq OWNER TO canaandavis;

--
-- Name: has_support_team_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE has_support_team_members_id_seq OWNED BY has_support_team_members.id;


--
-- Name: has_updates; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE has_updates (
    id integer NOT NULL,
    owner_id integer,
    user_id integer,
    comment text,
    rating integer,
    update_type integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    owner_type character varying(255) DEFAULT 'Resume'::character varying NOT NULL,
    account_id integer,
    status integer
);


ALTER TABLE has_updates OWNER TO canaandavis;

--
-- Name: has_updates_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE has_updates_id_seq
    START WITH 567351
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE has_updates_id_seq OWNER TO canaandavis;

--
-- Name: has_updates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE has_updates_id_seq OWNED BY has_updates.id;


--
-- Name: has_users; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE has_users (
    id integer NOT NULL,
    user_id integer,
    owner_id integer,
    owner_type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE has_users OWNER TO canaandavis;

--
-- Name: has_users_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE has_users_id_seq
    START WITH 633095
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE has_users_id_seq OWNER TO canaandavis;

--
-- Name: has_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE has_users_id_seq OWNED BY has_users.id;


--
-- Name: health_components; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE health_components (
    id integer NOT NULL,
    health_type integer,
    weight integer,
    owner_id integer,
    owner_type character varying(255),
    time_range integer
);


ALTER TABLE health_components OWNER TO canaandavis;

--
-- Name: health_components_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE health_components_id_seq
    START WITH 32
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE health_components_id_seq OWNER TO canaandavis;

--
-- Name: health_components_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE health_components_id_seq OWNED BY health_components.id;


--
-- Name: health_grade_keys; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE health_grade_keys (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE health_grade_keys OWNER TO canaandavis;

--
-- Name: health_grade_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE health_grade_keys_id_seq
    START WITH 8
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE health_grade_keys_id_seq OWNER TO canaandavis;

--
-- Name: health_grade_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE health_grade_keys_id_seq OWNED BY health_grade_keys.id;


--
-- Name: health_key_items; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE health_key_items (
    id integer NOT NULL,
    health_grade integer,
    value integer,
    health_component_id integer
);


ALTER TABLE health_key_items OWNER TO canaandavis;

--
-- Name: health_key_items_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE health_key_items_id_seq
    START WITH 92
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE health_key_items_id_seq OWNER TO canaandavis;

--
-- Name: health_key_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE health_key_items_id_seq OWNED BY health_key_items.id;


--
-- Name: hiring_status_sorting; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE hiring_status_sorting (
    id integer NOT NULL,
    hiring_status character varying(255),
    "position" integer
);


ALTER TABLE hiring_status_sorting OWNER TO canaandavis;

--
-- Name: hiring_status_sorting_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE hiring_status_sorting_id_seq
    START WITH 6
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE hiring_status_sorting_id_seq OWNER TO canaandavis;

--
-- Name: hiring_status_sorting_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE hiring_status_sorting_id_seq OWNED BY hiring_status_sorting.id;


--
-- Name: in_workflow_categories; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE in_workflow_categories (
    id integer NOT NULL,
    workflow_category_id integer,
    owner_id integer,
    owner_type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE in_workflow_categories OWNER TO canaandavis;

--
-- Name: in_workflow_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE in_workflow_categories_id_seq
    START WITH 838986
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE in_workflow_categories_id_seq OWNER TO canaandavis;

--
-- Name: in_workflow_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE in_workflow_categories_id_seq OWNED BY in_workflow_categories.id;


--
-- Name: in_workflow_steps; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE in_workflow_steps (
    id integer NOT NULL,
    workflow_step_id integer,
    owner_id integer,
    owner_type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE in_workflow_steps OWNER TO canaandavis;

--
-- Name: in_workflow_steps_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE in_workflow_steps_id_seq
    START WITH 500209
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE in_workflow_steps_id_seq OWNER TO canaandavis;

--
-- Name: in_workflow_steps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE in_workflow_steps_id_seq OWNED BY in_workflow_steps.id;


--
-- Name: industries; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE industries (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE industries OWNER TO canaandavis;

--
-- Name: industries_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE industries_id_seq
    START WITH 27
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE industries_id_seq OWNER TO canaandavis;

--
-- Name: industries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE industries_id_seq OWNED BY industries.id;


--
-- Name: invalid_emails; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE invalid_emails (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    invalid_type integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    info text
);


ALTER TABLE invalid_emails OWNER TO canaandavis;

--
-- Name: invalid_emails_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE invalid_emails_id_seq
    START WITH 533750
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE invalid_emails_id_seq OWNER TO canaandavis;

--
-- Name: invalid_emails_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE invalid_emails_id_seq OWNED BY invalid_emails.id;


--
-- Name: job_aggregators; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE job_aggregators (
    id integer NOT NULL,
    name character varying(255),
    subdomain character varying(255),
    site_template_id integer,
    embedded_site_template_id integer,
    source_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    additional_accounts text,
    include_brands boolean DEFAULT true NOT NULL,
    site_template_config text,
    account_id integer,
    header_headline character varying,
    header_tagline character varying,
    header_description text,
    header_background character varying,
    logo_url character varying,
    perks_headline character varying,
    perks_tagline character varying,
    perks_description text,
    description text,
    video_url character varying
);


ALTER TABLE job_aggregators OWNER TO canaandavis;

--
-- Name: job_aggregators_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE job_aggregators_id_seq
    START WITH 180014
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE job_aggregators_id_seq OWNER TO canaandavis;

--
-- Name: job_aggregators_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE job_aggregators_id_seq OWNED BY job_aggregators.id;


--
-- Name: job_builders; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE job_builders (
    id integer NOT NULL,
    name character varying(255),
    job_title_question_id integer,
    job_builder_option_id integer,
    job_builder_questionnaire_id integer,
    job_template text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    enabled boolean DEFAULT false NOT NULL,
    job_title_extra_question_id integer,
    filter_used_job_titles boolean DEFAULT false NOT NULL,
    country character varying(255) DEFAULT 'US'::character varying NOT NULL
);


ALTER TABLE job_builders OWNER TO canaandavis;

--
-- Name: job_builders_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE job_builders_id_seq
    START WITH 16
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE job_builders_id_seq OWNER TO canaandavis;

--
-- Name: job_builders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE job_builders_id_seq OWNED BY job_builders.id;


--
-- Name: job_categories; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE job_categories (
    category_id integer,
    job_id integer,
    id integer NOT NULL
);


ALTER TABLE job_categories OWNER TO canaandavis;

--
-- Name: job_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE job_categories_id_seq
    START WITH 1257942
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE job_categories_id_seq OWNER TO canaandavis;

--
-- Name: job_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE job_categories_id_seq OWNED BY job_categories.id;


--
-- Name: job_comments; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE job_comments (
    id integer NOT NULL,
    job_id integer,
    user_id integer,
    comment text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    comment_type integer DEFAULT 0 NOT NULL,
    reminded_at timestamp without time zone
);


ALTER TABLE job_comments OWNER TO canaandavis;

--
-- Name: job_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE job_comments_id_seq
    START WITH 481643
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE job_comments_id_seq OWNER TO canaandavis;

--
-- Name: job_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE job_comments_id_seq OWNED BY job_comments.id;


--
-- Name: job_permissions; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE job_permissions (
    id integer NOT NULL,
    user_id integer,
    job_id integer,
    access boolean DEFAULT true NOT NULL,
    notification integer DEFAULT 2 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    notify_assessments boolean DEFAULT false NOT NULL,
    notify_scorecards boolean DEFAULT false NOT NULL,
    notify_fast_track boolean DEFAULT false NOT NULL,
    notify_fast_track_sms boolean DEFAULT false NOT NULL
);


ALTER TABLE job_permissions OWNER TO canaandavis;

--
-- Name: job_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE job_permissions_id_seq
    START WITH 1185737
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE job_permissions_id_seq OWNER TO canaandavis;

--
-- Name: job_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE job_permissions_id_seq OWNED BY job_permissions.id;


--
-- Name: job_views; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE job_views (
    id integer NOT NULL,
    week date,
    account_id integer,
    job_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE job_views OWNER TO canaandavis;

--
-- Name: job_views_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE job_views_id_seq
    START WITH 3693940
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE job_views_id_seq OWNER TO canaandavis;

--
-- Name: job_views_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE job_views_id_seq OWNED BY job_views.id;


--
-- Name: jobs; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE jobs (
    id integer NOT NULL,
    name character varying(255),
    description text,
    status integer DEFAULT 1 NOT NULL,
    owner_id integer,
    country character varying(255) DEFAULT 'US'::character varying NOT NULL,
    city character varying(255),
    state character varying(255),
    zip character varying(255),
    employment_id integer,
    code character varying(255),
    questionnaire_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    hide boolean DEFAULT false NOT NULL,
    system_name character varying(255),
    job_builder_id integer,
    notification_cc text,
    refreshed_at timestamp without time zone,
    deactivated_at timestamp without time zone,
    edited_at timestamp without time zone,
    location_id integer,
    department_id integer,
    keyword_set_id integer,
    redirect_url character varying(255),
    template boolean DEFAULT false NOT NULL,
    job_template_id integer,
    prescreen_questions text,
    expire_notify text,
    anonymous boolean DEFAULT false NOT NULL,
    brand_id integer,
    external_ats_url character varying(255),
    compensation character varying(255),
    experience character varying(255),
    activate_at timestamp without time zone,
    refresh_at timestamp without time zone,
    eeoc_job_category character varying(255),
    offer_letter_template_id integer,
    video_interview_url character varying(255),
    cached_prescreen_ids text,
    workflow_id integer,
    internal_name character varying,
    digest_notified_at timestamp without time zone,
    admin_only_template boolean DEFAULT false,
    advertising_spend character varying,
    indeed_budget integer,
    indeed_sponsored boolean DEFAULT false NOT NULL,
    indeed_adv_email character varying,
    indeed_remote boolean DEFAULT false NOT NULL,
    account_type_id integer,
    ft_auto_interview_schedule boolean DEFAULT false,
    primary_language integer DEFAULT 0 NOT NULL,
    progression_checklists text,
    require_resume boolean,
    internal_only boolean DEFAULT false NOT NULL,
    indeed_adv_phone character varying,
    name_trl_key character varying,
    description_trl_key character varying
);


ALTER TABLE jobs OWNER TO canaandavis;

--
-- Name: jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE jobs_id_seq
    START WITH 626823
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE jobs_id_seq OWNER TO canaandavis;

--
-- Name: jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE jobs_id_seq OWNED BY jobs.id;


--
-- Name: keyword_sets; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE keyword_sets (
    id integer NOT NULL,
    name character varying(255),
    account_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    usage_type integer DEFAULT 0
);


ALTER TABLE keyword_sets OWNER TO canaandavis;

--
-- Name: keyword_sets_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE keyword_sets_id_seq
    START WITH 480144
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE keyword_sets_id_seq OWNER TO canaandavis;

--
-- Name: keyword_sets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE keyword_sets_id_seq OWNED BY keyword_sets.id;


--
-- Name: keywords; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE keywords (
    id integer NOT NULL,
    name character varying(255),
    keyword_set_id integer,
    keyword_type integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE keywords OWNER TO canaandavis;

--
-- Name: keywords_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE keywords_id_seq
    START WITH 483385
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE keywords_id_seq OWNER TO canaandavis;

--
-- Name: keywords_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE keywords_id_seq OWNED BY keywords.id;


--
-- Name: leads; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE leads (
    id integer NOT NULL,
    firstname character varying(255),
    lastname character varying(255),
    email character varying(255),
    phone character varying(255),
    title character varying(255),
    company character varying(255),
    employees character varying(255),
    city character varying(255),
    state character varying(255),
    account_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    industry character varying(255)
);


ALTER TABLE leads OWNER TO canaandavis;

--
-- Name: leads_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE leads_id_seq
    START WITH 15016
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE leads_id_seq OWNER TO canaandavis;

--
-- Name: leads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE leads_id_seq OWNED BY leads.id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE locations (
    id integer NOT NULL,
    account_id integer,
    name character varying(255),
    num character varying(255),
    city character varying(255),
    state character varying(255),
    zip character varying(255),
    country character varying(255) DEFAULT 'US'::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    district_id integer,
    open_zipcode boolean DEFAULT false NOT NULL,
    street character varying(255),
    phone character varying(255),
    external_ats_url character varying(255),
    assessments_integration_dept character varying(255),
    background_check_account character varying(255),
    background_check_username character varying(255),
    wotc_location_id character varying,
    payroll_company_code character varying,
    name_trl_key character varying
);


ALTER TABLE locations OWNER TO canaandavis;

--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE locations_id_seq
    START WITH 489126
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE locations_id_seq OWNER TO canaandavis;

--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE locations_id_seq OWNED BY locations.id;


--
-- Name: manage_tokens; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE manage_tokens (
    id integer NOT NULL,
    user_id integer,
    token character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE manage_tokens OWNER TO canaandavis;

--
-- Name: manage_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE manage_tokens_id_seq
    START WITH 517254
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE manage_tokens_id_seq OWNER TO canaandavis;

--
-- Name: manage_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE manage_tokens_id_seq OWNED BY manage_tokens.id;


--
-- Name: message_templates; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE message_templates (
    id integer NOT NULL,
    name character varying(255),
    subject character varying(255),
    body text,
    account_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    action_event character varying(255),
    parent_message_id integer,
    enabled boolean DEFAULT true NOT NULL,
    "primary" boolean DEFAULT false NOT NULL,
    invite boolean DEFAULT false NOT NULL,
    location text,
    include_signature boolean,
    invite_schedule boolean DEFAULT false NOT NULL,
    template_type integer DEFAULT 0
);


ALTER TABLE message_templates OWNER TO canaandavis;

--
-- Name: message_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE message_templates_id_seq
    START WITH 499007
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE message_templates_id_seq OWNER TO canaandavis;

--
-- Name: message_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE message_templates_id_seq OWNED BY message_templates.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE notifications (
    id integer NOT NULL,
    name character varying(255),
    message text,
    test text,
    expires_at timestamp without time zone,
    single boolean,
    interrupt boolean,
    action character varying(255),
    controller character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    interrupt_once boolean
);


ALTER TABLE notifications OWNER TO canaandavis;

--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE notifications_id_seq
    START WITH 330026
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE notifications_id_seq OWNER TO canaandavis;

--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE notifications_id_seq OWNED BY notifications.id;


--
-- Name: nps_responses; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE nps_responses (
    id integer NOT NULL,
    account_id integer,
    score integer,
    comment text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    user_id integer
);


ALTER TABLE nps_responses OWNER TO canaandavis;

--
-- Name: nps_responses_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE nps_responses_id_seq
    START WITH 480382
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE nps_responses_id_seq OWNER TO canaandavis;

--
-- Name: nps_responses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE nps_responses_id_seq OWNED BY nps_responses.id;


--
-- Name: oauth_access_grants; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE oauth_access_grants (
    id integer NOT NULL,
    resource_owner_id integer NOT NULL,
    application_id integer NOT NULL,
    token character varying(255) NOT NULL,
    expires_in integer NOT NULL,
    redirect_uri text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    revoked_at timestamp without time zone,
    scopes character varying(255)
);


ALTER TABLE oauth_access_grants OWNER TO canaandavis;

--
-- Name: oauth_access_grants_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE oauth_access_grants_id_seq
    START WITH 534028
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE oauth_access_grants_id_seq OWNER TO canaandavis;

--
-- Name: oauth_access_grants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE oauth_access_grants_id_seq OWNED BY oauth_access_grants.id;


--
-- Name: oauth_access_tokens; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE oauth_access_tokens (
    id integer NOT NULL,
    resource_owner_id integer,
    application_id integer,
    token character varying(255) NOT NULL,
    refresh_token character varying(255),
    expires_in integer,
    revoked_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    scopes character varying(255)
);


ALTER TABLE oauth_access_tokens OWNER TO canaandavis;

--
-- Name: oauth_access_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE oauth_access_tokens_id_seq
    START WITH 531033
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE oauth_access_tokens_id_seq OWNER TO canaandavis;

--
-- Name: oauth_access_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE oauth_access_tokens_id_seq OWNED BY oauth_access_tokens.id;


--
-- Name: oauth_applications; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE oauth_applications (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    uid character varying(255) NOT NULL,
    secret character varying(255) NOT NULL,
    redirect_uri text NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    scopes character varying(255) DEFAULT ''::character varying NOT NULL,
    account_id integer
);


ALTER TABLE oauth_applications OWNER TO canaandavis;

--
-- Name: oauth_applications_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE oauth_applications_id_seq
    START WITH 480003
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE oauth_applications_id_seq OWNER TO canaandavis;

--
-- Name: oauth_applications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE oauth_applications_id_seq OWNED BY oauth_applications.id;


--
-- Name: offer_letter_templates; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE offer_letter_templates (
    id integer NOT NULL,
    name character varying(255),
    account_id integer,
    content text,
    expire_days integer,
    notify_data text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    manager_id integer
);


ALTER TABLE offer_letter_templates OWNER TO canaandavis;

--
-- Name: offer_letter_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE offer_letter_templates_id_seq
    START WITH 480156
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE offer_letter_templates_id_seq OWNER TO canaandavis;

--
-- Name: offer_letter_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE offer_letter_templates_id_seq OWNED BY offer_letter_templates.id;


--
-- Name: offer_letter_updates; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE offer_letter_updates (
    id integer NOT NULL,
    offer_letter_id integer,
    update_type integer DEFAULT 0 NOT NULL,
    comments text,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE offer_letter_updates OWNER TO canaandavis;

--
-- Name: offer_letter_updates_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE offer_letter_updates_id_seq
    START WITH 493698
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE offer_letter_updates_id_seq OWNER TO canaandavis;

--
-- Name: offer_letter_updates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE offer_letter_updates_id_seq OWNED BY offer_letter_updates.id;


--
-- Name: offer_letters; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE offer_letters (
    id integer NOT NULL,
    owner_id integer,
    app_id integer,
    offer_letter_template_id integer,
    content text,
    expires_at timestamp without time zone,
    status integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    manager_id integer,
    expiration_reminder_sent_at timestamp without time zone,
    pay_type integer,
    pay_rate double precision,
    hire_date timestamp without time zone,
    app_update_hire_date boolean DEFAULT false NOT NULL
);


ALTER TABLE offer_letters OWNER TO canaandavis;

--
-- Name: offer_letters_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE offer_letters_id_seq
    START WITH 483766
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE offer_letters_id_seq OWNER TO canaandavis;

--
-- Name: offer_letters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE offer_letters_id_seq OWNED BY offer_letters.id;


--
-- Name: organizational_units; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE organizational_units (
    id integer NOT NULL,
    account_id integer,
    name character varying(255),
    type character varying(255),
    parent_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    payroll_company_code character varying,
    name_trl_key character varying
);


ALTER TABLE organizational_units OWNER TO canaandavis;

--
-- Name: organizational_units_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE organizational_units_id_seq
    START WITH 480692
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE organizational_units_id_seq OWNER TO canaandavis;

--
-- Name: organizational_units_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE organizational_units_id_seq OWNED BY organizational_units.id;


--
-- Name: overview_builders; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE overview_builders (
    id integer NOT NULL,
    name character varying(255),
    overview_builder_option_id integer,
    template text,
    enabled boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    teaser text
);


ALTER TABLE overview_builders OWNER TO canaandavis;

--
-- Name: overview_builders_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE overview_builders_id_seq
    START WITH 2
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE overview_builders_id_seq OWNER TO canaandavis;

--
-- Name: overview_builders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE overview_builders_id_seq OWNED BY overview_builders.id;


--
-- Name: pages; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE pages (
    id integer NOT NULL,
    name character varying(255),
    page_type integer,
    body text,
    style text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE pages OWNER TO canaandavis;

--
-- Name: pages_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE pages_id_seq
    START WITH 180221
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pages_id_seq OWNER TO canaandavis;

--
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE pages_id_seq OWNED BY pages.id;


--
-- Name: payment_transactions; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE payment_transactions (
    id integer NOT NULL,
    account_id integer,
    amount integer,
    success boolean,
    reference character varying(255),
    message text,
    action character varying(255),
    params text,
    test boolean,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    discount integer,
    invoice_num character varying(255),
    refund_transaction_id integer,
    payment_number character varying
);


ALTER TABLE payment_transactions OWNER TO canaandavis;

--
-- Name: payment_transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE payment_transactions_id_seq
    START WITH 552374
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE payment_transactions_id_seq OWNER TO canaandavis;

--
-- Name: payment_transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE payment_transactions_id_seq OWNED BY payment_transactions.id;


--
-- Name: perks; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE perks (
    id bigint NOT NULL,
    owner_id integer,
    owner_type character varying,
    "position" integer,
    icon character varying,
    headline text,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    headline_trl_key character varying,
    description_trl_key character varying
);


ALTER TABLE perks OWNER TO canaandavis;

--
-- Name: perks_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE perks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE perks_id_seq OWNER TO canaandavis;

--
-- Name: perks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE perks_id_seq OWNED BY perks.id;


--
-- Name: phone_number_owners; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE phone_number_owners (
    id integer NOT NULL,
    user_phone_number_id integer,
    owner_id integer,
    owner_type character varying,
    enabled boolean DEFAULT true
);


ALTER TABLE phone_number_owners OWNER TO canaandavis;

--
-- Name: phone_number_owners_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE phone_number_owners_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE phone_number_owners_id_seq OWNER TO canaandavis;

--
-- Name: phone_number_owners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE phone_number_owners_id_seq OWNED BY phone_number_owners.id;


--
-- Name: pipeline_steps; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE pipeline_steps (
    id integer NOT NULL,
    name character varying(255),
    "position" integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id integer
);


ALTER TABLE pipeline_steps OWNER TO canaandavis;

--
-- Name: pipeline_steps_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE pipeline_steps_id_seq
    START WITH 480012
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pipeline_steps_id_seq OWNER TO canaandavis;

--
-- Name: pipeline_steps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE pipeline_steps_id_seq OWNED BY pipeline_steps.id;


--
-- Name: plan_cycles; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE plan_cycles (
    id bigint NOT NULL,
    plan_id integer,
    billing_cycle integer DEFAULT 0 NOT NULL,
    amount integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    upsell text
);


ALTER TABLE plan_cycles OWNER TO canaandavis;

--
-- Name: plan_cycles_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE plan_cycles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE plan_cycles_id_seq OWNER TO canaandavis;

--
-- Name: plan_cycles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE plan_cycles_id_seq OWNED BY plan_cycles.id;


--
-- Name: plan_upgrades; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE plan_upgrades (
    id integer NOT NULL,
    from_id integer,
    to_id integer
);


ALTER TABLE plan_upgrades OWNER TO canaandavis;

--
-- Name: plan_upgrades_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE plan_upgrades_id_seq
    START WITH 330026
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE plan_upgrades_id_seq OWNER TO canaandavis;

--
-- Name: plan_upgrades_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE plan_upgrades_id_seq OWNED BY plan_upgrades.id;


--
-- Name: planned_follow_ups; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE planned_follow_ups (
    id integer NOT NULL,
    account_event_id integer,
    log_type integer,
    log_type_name character varying(255),
    due_at_days integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE planned_follow_ups OWNER TO canaandavis;

--
-- Name: planned_follow_ups_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE planned_follow_ups_id_seq
    START WITH 2
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE planned_follow_ups_id_seq OWNER TO canaandavis;

--
-- Name: planned_follow_ups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE planned_follow_ups_id_seq OWNED BY planned_follow_ups.id;


--
-- Name: plans; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE plans (
    id integer NOT NULL,
    name character varying(255),
    account_type_id integer DEFAULT 0 NOT NULL,
    active_jobs integer,
    billing_cycle integer DEFAULT 0 NOT NULL,
    amount integer DEFAULT 0 NOT NULL,
    description text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    trial_days integer DEFAULT 0 NOT NULL,
    hidden boolean DEFAULT false NOT NULL,
    fallback_plan_id integer,
    active_locations integer,
    cancel_notice text,
    trial_account_manager_id integer,
    job_cost integer,
    location_cost integer,
    key character varying(255),
    sales_exec_id integer,
    success_plan_id integer,
    account_manager_id integer,
    referral_amount integer,
    permissions text,
    teaser text,
    trial_ends_at timestamp without time zone,
    display_name character varying,
    add_on_teaser text
);


ALTER TABLE plans OWNER TO canaandavis;

--
-- Name: plans_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE plans_id_seq
    START WITH 330493
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE plans_id_seq OWNER TO canaandavis;

--
-- Name: plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE plans_id_seq OWNED BY plans.id;


--
-- Name: product_cycles; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE product_cycles (
    id bigint NOT NULL,
    product_id integer,
    billing_cycle integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE product_cycles OWNER TO canaandavis;

--
-- Name: product_cycles_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE product_cycles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE product_cycles_id_seq OWNER TO canaandavis;

--
-- Name: product_cycles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE product_cycles_id_seq OWNED BY product_cycles.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE products (
    id integer NOT NULL,
    key character varying(255) NOT NULL,
    name character varying(255),
    price integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    permissions text,
    short_teaser text,
    long_teaser text,
    cancel_notice text,
    feature_tags text
);


ALTER TABLE products OWNER TO canaandavis;

--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE products_id_seq
    START WITH 15004
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE products_id_seq OWNER TO canaandavis;

--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE products_id_seq OWNED BY products.id;


--
-- Name: products_plans; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE products_plans (
    product_id bigint NOT NULL,
    plan_id bigint NOT NULL
);


ALTER TABLE products_plans OWNER TO canaandavis;

--
-- Name: profiles; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE profiles (
    id integer NOT NULL,
    applicant_id integer,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    status integer DEFAULT 0 NOT NULL
);


ALTER TABLE profiles OWNER TO canaandavis;

--
-- Name: profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE profiles_id_seq
    START WITH 489014
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE profiles_id_seq OWNER TO canaandavis;

--
-- Name: profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE profiles_id_seq OWNED BY profiles.id;


--
-- Name: purchases; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE purchases (
    id integer NOT NULL,
    account_id integer NOT NULL,
    product_id integer NOT NULL,
    payment_transaction_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    active_feature boolean
);


ALTER TABLE purchases OWNER TO canaandavis;

--
-- Name: purchases_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE purchases_id_seq
    START WITH 480191
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE purchases_id_seq OWNER TO canaandavis;

--
-- Name: purchases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE purchases_id_seq OWNED BY purchases.id;


--
-- Name: question_set_owners; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE question_set_owners (
    id integer NOT NULL,
    question_set_id integer,
    owner_id integer,
    owner_type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE question_set_owners OWNER TO canaandavis;

--
-- Name: question_set_owners_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE question_set_owners_id_seq
    START WITH 503881
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE question_set_owners_id_seq OWNER TO canaandavis;

--
-- Name: question_set_owners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE question_set_owners_id_seq OWNED BY question_set_owners.id;


--
-- Name: questionnaires; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE questionnaires (
    id integer NOT NULL,
    name character varying(255),
    account_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    type character varying(255),
    timeout integer,
    notes text,
    hide_answers boolean DEFAULT false NOT NULL,
    add_comments boolean,
    frequency integer,
    due_at timestamp without time zone,
    send_at integer,
    include_goals boolean DEFAULT true NOT NULL,
    timed_notes text,
    style character varying(255),
    non_dual boolean DEFAULT false NOT NULL,
    show_chart boolean DEFAULT false NOT NULL,
    outdated boolean DEFAULT false NOT NULL,
    library boolean DEFAULT false NOT NULL,
    choose_categories boolean DEFAULT false NOT NULL,
    description text,
    additional_info text,
    data text
);


ALTER TABLE questionnaires OWNER TO canaandavis;

--
-- Name: questionnaires_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE questionnaires_id_seq
    START WITH 521189
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE questionnaires_id_seq OWNER TO canaandavis;

--
-- Name: questionnaires_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE questionnaires_id_seq OWNED BY questionnaires.id;


--
-- Name: questions; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE questions (
    id integer NOT NULL,
    name text,
    weight numeric(8,2),
    question_type integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    question_set_id integer,
    "position" integer,
    required boolean DEFAULT true NOT NULL,
    applicant_field_type character varying(255),
    assessment_category_id integer,
    hint text,
    include_in_default boolean DEFAULT false NOT NULL,
    is_goal boolean DEFAULT false NOT NULL,
    selected boolean DEFAULT false NOT NULL,
    system_question boolean DEFAULT false NOT NULL,
    frequency text,
    show_previous_manager_response boolean DEFAULT false NOT NULL,
    show_previous_employee_response boolean DEFAULT false NOT NULL,
    previous_response_above boolean DEFAULT false NOT NULL,
    show_previous_response_in_questionnaire boolean DEFAULT false NOT NULL,
    show_previous_response_in_report boolean DEFAULT false NOT NULL,
    parent_id integer,
    options text,
    prefill character varying,
    section_id bigint,
    name_trl_key character varying
);


ALTER TABLE questions OWNER TO canaandavis;

--
-- Name: questions_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE questions_id_seq
    START WITH 1380802
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE questions_id_seq OWNER TO canaandavis;

--
-- Name: questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE questions_id_seq OWNED BY questions.id;


--
-- Name: rating_scores; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE rating_scores (
    id integer NOT NULL,
    rating_id integer,
    competency_id integer,
    score integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE rating_scores OWNER TO canaandavis;

--
-- Name: rating_scores_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE rating_scores_id_seq
    START WITH 548194
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE rating_scores_id_seq OWNER TO canaandavis;

--
-- Name: rating_scores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE rating_scores_id_seq OWNED BY rating_scores.id;


--
-- Name: rating_templates; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE rating_templates (
    id integer NOT NULL,
    name character varying(255),
    account_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE rating_templates OWNER TO canaandavis;

--
-- Name: rating_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE rating_templates_id_seq
    START WITH 480109
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE rating_templates_id_seq OWNER TO canaandavis;

--
-- Name: rating_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE rating_templates_id_seq OWNED BY rating_templates.id;


--
-- Name: ratings; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE ratings (
    id integer NOT NULL,
    app_id integer,
    user_id integer,
    score integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    user_name character varying(255),
    workflow_category_id integer
);


ALTER TABLE ratings OWNER TO canaandavis;

--
-- Name: ratings_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE ratings_id_seq
    START WITH 503678
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ratings_id_seq OWNER TO canaandavis;

--
-- Name: ratings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE ratings_id_seq OWNED BY ratings.id;


--
-- Name: recent_activity; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE recent_activity (
    id bigint NOT NULL,
    app_id integer,
    activity integer,
    payload jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE recent_activity OWNER TO canaandavis;

--
-- Name: recent_activity_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE recent_activity_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE recent_activity_id_seq OWNER TO canaandavis;

--
-- Name: recent_activity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE recent_activity_id_seq OWNED BY recent_activity.id;


--
-- Name: referral_credits; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE referral_credits (
    id integer NOT NULL,
    account_id integer,
    referee_id integer,
    amount integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    applied_at timestamp without time zone
);


ALTER TABLE referral_credits OWNER TO canaandavis;

--
-- Name: referral_credits_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE referral_credits_id_seq
    START WITH 480070
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE referral_credits_id_seq OWNER TO canaandavis;

--
-- Name: referral_credits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE referral_credits_id_seq OWNED BY referral_credits.id;


--
-- Name: referral_short_urls; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE referral_short_urls (
    id integer NOT NULL,
    account_id integer,
    coupon_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE referral_short_urls OWNER TO canaandavis;

--
-- Name: referral_short_urls_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE referral_short_urls_id_seq
    START WITH 486680
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE referral_short_urls_id_seq OWNER TO canaandavis;

--
-- Name: referral_short_urls_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE referral_short_urls_id_seq OWNED BY referral_short_urls.id;


--
-- Name: reject_reason_sets; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE reject_reason_sets (
    id integer NOT NULL,
    name character varying(255),
    account_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE reject_reason_sets OWNER TO canaandavis;

--
-- Name: reject_reason_sets_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE reject_reason_sets_id_seq
    START WITH 480006
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE reject_reason_sets_id_seq OWNER TO canaandavis;

--
-- Name: reject_reason_sets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE reject_reason_sets_id_seq OWNED BY reject_reason_sets.id;


--
-- Name: reject_reasons; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE reject_reasons (
    id integer NOT NULL,
    reject_reason_set_id integer,
    "position" integer,
    description text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE reject_reasons OWNER TO canaandavis;

--
-- Name: reject_reasons_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE reject_reasons_id_seq
    START WITH 481106
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE reject_reasons_id_seq OWNER TO canaandavis;

--
-- Name: reject_reasons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE reject_reasons_id_seq OWNED BY reject_reasons.id;


--
-- Name: reports; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE reports (
    id integer NOT NULL,
    name character varying(255),
    email character varying(255),
    days character varying(255),
    params text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id integer
);


ALTER TABLE reports OWNER TO canaandavis;

--
-- Name: reports_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE reports_id_seq
    START WITH 481782
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE reports_id_seq OWNER TO canaandavis;

--
-- Name: reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE reports_id_seq OWNED BY reports.id;


--
-- Name: resume_requests; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE resume_requests (
    id integer NOT NULL,
    account_id integer,
    form_data text,
    zip character varying(255),
    status integer DEFAULT 0 NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    completed_at timestamp without time zone,
    resume_count integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    paid boolean DEFAULT false NOT NULL
);


ALTER TABLE resume_requests OWNER TO canaandavis;

--
-- Name: resume_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE resume_requests_id_seq
    START WITH 491386
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE resume_requests_id_seq OWNER TO canaandavis;

--
-- Name: resume_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE resume_requests_id_seq OWNED BY resume_requests.id;


--
-- Name: schedule_owner_proxies; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE schedule_owner_proxies (
    id bigint NOT NULL,
    name character varying,
    proxy_type integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE schedule_owner_proxies OWNER TO canaandavis;

--
-- Name: schedule_owner_proxies_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE schedule_owner_proxies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE schedule_owner_proxies_id_seq OWNER TO canaandavis;

--
-- Name: schedule_owner_proxies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE schedule_owner_proxies_id_seq OWNED BY schedule_owner_proxies.id;


--
-- Name: scheduled_app_updates; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE scheduled_app_updates (
    id bigint NOT NULL,
    app_id bigint,
    update_type integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE scheduled_app_updates OWNER TO canaandavis;

--
-- Name: scheduled_app_updates_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE scheduled_app_updates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE scheduled_app_updates_id_seq OWNER TO canaandavis;

--
-- Name: scheduled_app_updates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE scheduled_app_updates_id_seq OWNED BY scheduled_app_updates.id;


--
-- Name: scheduled_notifications; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE scheduled_notifications (
    id integer NOT NULL,
    account_id integer,
    action_event character varying(255),
    send_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE scheduled_notifications OWNER TO canaandavis;

--
-- Name: scheduled_notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE scheduled_notifications_id_seq
    START WITH 513177
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE scheduled_notifications_id_seq OWNER TO canaandavis;

--
-- Name: scheduled_notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE scheduled_notifications_id_seq OWNED BY scheduled_notifications.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE schema_migrations OWNER TO canaandavis;

--
-- Name: scoring_set_invites; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE scoring_set_invites (
    id integer NOT NULL,
    app_id integer NOT NULL,
    question_set_id integer NOT NULL,
    scoring_set_id integer,
    scheduled_at date NOT NULL,
    manager boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    notified_at timestamp without time zone,
    overdue_notified_at timestamp without time zone
);


ALTER TABLE scoring_set_invites OWNER TO canaandavis;

--
-- Name: scoring_set_invites_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE scoring_set_invites_id_seq
    START WITH 808016
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE scoring_set_invites_id_seq OWNER TO canaandavis;

--
-- Name: scoring_set_invites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE scoring_set_invites_id_seq OWNED BY scoring_set_invites.id;


--
-- Name: scoring_set_items; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE scoring_set_items (
    id integer NOT NULL,
    scoring_set_id integer,
    question_type integer,
    question_name text,
    question_id integer,
    answer_text text,
    answer_id integer,
    weight numeric(8,2),
    "position" integer,
    score integer,
    max_score integer,
    result integer DEFAULT 0
);


ALTER TABLE scoring_set_items OWNER TO canaandavis;

--
-- Name: scoring_set_items_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE scoring_set_items_id_seq
    START WITH 206573976
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE scoring_set_items_id_seq OWNER TO canaandavis;

--
-- Name: scoring_set_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE scoring_set_items_id_seq OWNED BY scoring_set_items.id;


--
-- Name: scoring_sets; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE scoring_sets (
    id integer NOT NULL,
    name character varying(255),
    user_id integer,
    owner_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    score integer,
    question_set_type character varying(255),
    complete boolean DEFAULT false NOT NULL,
    question_set_id integer,
    workflow_category_id integer,
    owner_type character varying(255) DEFAULT 'App'::character varying NOT NULL,
    user_name character varying(255),
    max_score integer,
    result integer DEFAULT 0,
    account_id integer,
    cloned boolean
);


ALTER TABLE scoring_sets OWNER TO canaandavis;

--
-- Name: scoring_sets_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE scoring_sets_id_seq
    START WITH 9695097
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE scoring_sets_id_seq OWNER TO canaandavis;

--
-- Name: scoring_sets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE scoring_sets_id_seq OWNED BY scoring_sets.id;


--
-- Name: search_logs; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE search_logs (
    id bigint NOT NULL,
    app_id integer,
    indexed_at timestamp without time zone,
    verified_at timestamp without time zone,
    attempts integer
);


ALTER TABLE search_logs OWNER TO canaandavis;

--
-- Name: search_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE search_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE search_logs_id_seq OWNER TO canaandavis;

--
-- Name: search_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE search_logs_id_seq OWNED BY search_logs.id;


--
-- Name: sections; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE sections (
    id bigint NOT NULL,
    scorecard_id bigint,
    name character varying,
    "position" integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE sections OWNER TO canaandavis;

--
-- Name: sections_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE sections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sections_id_seq OWNER TO canaandavis;

--
-- Name: sections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE sections_id_seq OWNED BY sections.id;


--
-- Name: settings; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE settings (
    id integer NOT NULL,
    var character varying(255) NOT NULL,
    value text,
    thing_id integer,
    thing_type character varying(30),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE settings OWNER TO canaandavis;

--
-- Name: settings_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE settings_id_seq
    START WITH 5153150
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE settings_id_seq OWNER TO canaandavis;

--
-- Name: settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE settings_id_seq OWNED BY settings.id;


--
-- Name: sf_codes; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE sf_codes (
    id integer NOT NULL,
    zip character varying(255),
    sf_code character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    territory_name character varying
);


ALTER TABLE sf_codes OWNER TO canaandavis;

--
-- Name: sf_codes_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE sf_codes_id_seq
    START WITH 83798
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sf_codes_id_seq OWNER TO canaandavis;

--
-- Name: sf_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE sf_codes_id_seq OWNED BY sf_codes.id;


--
-- Name: short_urls; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE short_urls (
    id integer NOT NULL,
    job_id integer,
    source_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    expired boolean DEFAULT false NOT NULL
);


ALTER TABLE short_urls OWNER TO canaandavis;

--
-- Name: short_urls_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE short_urls_id_seq
    START WITH 5990993
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE short_urls_id_seq OWNER TO canaandavis;

--
-- Name: short_urls_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE short_urls_id_seq OWNED BY short_urls.id;


--
-- Name: signatures; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE signatures (
    id integer NOT NULL,
    signature text,
    signed_by character varying(255),
    ip character varying(255),
    signer_id integer,
    signer_type character varying(255),
    document_id integer,
    document_type character varying(255),
    question_id integer,
    uid character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE signatures OWNER TO canaandavis;

--
-- Name: signatures_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE signatures_id_seq
    START WITH 590755
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE signatures_id_seq OWNER TO canaandavis;

--
-- Name: signatures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE signatures_id_seq OWNED BY signatures.id;


--
-- Name: site_templates; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE site_templates (
    id integer NOT NULL,
    name character varying(255),
    style text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    body text,
    index_page_id integer,
    job_page_id integer,
    apply_page_id integer,
    thanks_page_id integer,
    account_page_id integer,
    customizable boolean DEFAULT false NOT NULL,
    embeddable boolean DEFAULT false NOT NULL,
    edit_page_id integer,
    version integer
);


ALTER TABLE site_templates OWNER TO canaandavis;

--
-- Name: site_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE site_templates_id_seq
    START WITH 180148
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE site_templates_id_seq OWNER TO canaandavis;

--
-- Name: site_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE site_templates_id_seq OWNED BY site_templates.id;


--
-- Name: sms_messages; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE sms_messages (
    id integer NOT NULL,
    message_id character varying,
    "from" character varying NOT NULL,
    "to" character varying NOT NULL,
    direction integer,
    state integer,
    content text NOT NULL,
    sent_at timestamp without time zone,
    delivery_state integer,
    delivery_description character varying,
    delivery_code character varying,
    tag character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE sms_messages OWNER TO canaandavis;

--
-- Name: sms_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE sms_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sms_messages_id_seq OWNER TO canaandavis;

--
-- Name: sms_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE sms_messages_id_seq OWNED BY sms_messages.id;


--
-- Name: sms_receipts; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE sms_receipts (
    id integer NOT NULL,
    sms_message_id integer,
    state integer,
    delivery_state integer,
    delivery_description character varying,
    delivery_code character varying,
    payload json,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE sms_receipts OWNER TO canaandavis;

--
-- Name: sms_receipts_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE sms_receipts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sms_receipts_id_seq OWNER TO canaandavis;

--
-- Name: sms_receipts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE sms_receipts_id_seq OWNED BY sms_receipts.id;


--
-- Name: sms_thread_responses; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE sms_thread_responses (
    id bigint NOT NULL,
    sms_thread_id bigint,
    sms_message_id bigint,
    read_at timestamp without time zone,
    archived boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE sms_thread_responses OWNER TO canaandavis;

--
-- Name: sms_thread_responses_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE sms_thread_responses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sms_thread_responses_id_seq OWNER TO canaandavis;

--
-- Name: sms_thread_responses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE sms_thread_responses_id_seq OWNED BY sms_thread_responses.id;


--
-- Name: sms_threads; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE sms_threads (
    id bigint NOT NULL,
    account_id bigint,
    user_id bigint,
    active boolean DEFAULT true,
    thread_id character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    application_phone_number_id bigint,
    user_phone_number_id bigint,
    archived boolean DEFAULT false
);


ALTER TABLE sms_threads OWNER TO canaandavis;

--
-- Name: sms_threads_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE sms_threads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sms_threads_id_seq OWNER TO canaandavis;

--
-- Name: sms_threads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE sms_threads_id_seq OWNED BY sms_threads.id;


--
-- Name: sources; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE sources (
    id integer NOT NULL,
    name character varying(255),
    account_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    job_instructions text,
    source_type integer DEFAULT 0 NOT NULL,
    popup boolean DEFAULT true NOT NULL,
    renderer character varying(255)
);


ALTER TABLE sources OWNER TO canaandavis;

--
-- Name: sources_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE sources_id_seq
    START WITH 484460
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sources_id_seq OWNER TO canaandavis;

--
-- Name: sources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE sources_id_seq OWNED BY sources.id;


--
-- Name: success_notes; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE success_notes (
    id integer NOT NULL,
    note text,
    success_plan_id integer,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    parent_id integer
);


ALTER TABLE success_notes OWNER TO canaandavis;

--
-- Name: success_notes_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE success_notes_id_seq
    START WITH 15150
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE success_notes_id_seq OWNER TO canaandavis;

--
-- Name: success_notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE success_notes_id_seq OWNED BY success_notes.id;


--
-- Name: success_plans; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE success_plans (
    id integer NOT NULL,
    name character varying(255),
    account_id integer,
    goals text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE success_plans OWNER TO canaandavis;

--
-- Name: success_plans_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE success_plans_id_seq
    START WITH 480370
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE success_plans_id_seq OWNER TO canaandavis;

--
-- Name: success_plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE success_plans_id_seq OWNED BY success_plans.id;


--
-- Name: success_tasks; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE success_tasks (
    id integer NOT NULL,
    name character varying(255),
    success_plan_id integer,
    due_at timestamp without time zone,
    completed_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    due_days integer,
    details text
);


ALTER TABLE success_tasks OWNER TO canaandavis;

--
-- Name: success_tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE success_tasks_id_seq
    START WITH 484157
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE success_tasks_id_seq OWNER TO canaandavis;

--
-- Name: success_tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE success_tasks_id_seq OWNED BY success_tasks.id;


--
-- Name: suggestion_comments; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE suggestion_comments (
    id integer NOT NULL,
    suggestion_id integer,
    comment text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    user_name character varying(255)
);


ALTER TABLE suggestion_comments OWNER TO canaandavis;

--
-- Name: suggestion_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE suggestion_comments_id_seq
    START WITH 211
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE suggestion_comments_id_seq OWNER TO canaandavis;

--
-- Name: suggestion_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE suggestion_comments_id_seq OWNED BY suggestion_comments.id;


--
-- Name: suggestions; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE suggestions (
    id integer NOT NULL,
    summary character varying(255),
    description text,
    suggested_by_name character varying(255),
    suggestion_type integer,
    user_id integer,
    account_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    submitted_by character varying(255),
    status integer
);


ALTER TABLE suggestions OWNER TO canaandavis;

--
-- Name: suggestions_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE suggestions_id_seq
    START WITH 480335
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE suggestions_id_seq OWNER TO canaandavis;

--
-- Name: suggestions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE suggestions_id_seq OWNED BY suggestions.id;


--
-- Name: teams; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE teams (
    id integer NOT NULL,
    name character varying(255),
    account_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE teams OWNER TO canaandavis;

--
-- Name: teams_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE teams_id_seq
    START WITH 485049
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE teams_id_seq OWNER TO canaandavis;

--
-- Name: teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE teams_id_seq OWNED BY teams.id;


--
-- Name: testimonials; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE testimonials (
    id bigint NOT NULL,
    owner_id integer,
    owner_type character varying,
    "position" integer,
    testimonial text,
    name text,
    location text,
    title text,
    avatar text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    testimonial_trl_key character varying,
    title_trl_key character varying
);


ALTER TABLE testimonials OWNER TO canaandavis;

--
-- Name: testimonials_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE testimonials_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE testimonials_id_seq OWNER TO canaandavis;

--
-- Name: testimonials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE testimonials_id_seq OWNED BY testimonials.id;


--
-- Name: tiered_prices; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE tiered_prices (
    id bigint NOT NULL,
    product_cycle_id bigint,
    min_count integer DEFAULT 0 NOT NULL,
    amount integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE tiered_prices OWNER TO canaandavis;

--
-- Name: tiered_prices_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE tiered_prices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tiered_prices_id_seq OWNER TO canaandavis;

--
-- Name: tiered_prices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE tiered_prices_id_seq OWNED BY tiered_prices.id;


--
-- Name: tiny_prints; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE tiny_prints (
    id integer NOT NULL,
    image_file_name character varying(255),
    image_content_type character varying(255),
    account_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    image_file_size integer
);


ALTER TABLE tiny_prints OWNER TO canaandavis;

--
-- Name: tiny_prints_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE tiny_prints_id_seq
    START WITH 480238
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tiny_prints_id_seq OWNER TO canaandavis;

--
-- Name: tiny_prints_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE tiny_prints_id_seq OWNED BY tiny_prints.id;


--
-- Name: tiny_videos; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE tiny_videos (
    id integer NOT NULL,
    original_file_name character varying(255),
    original_content_type character varying(255),
    account_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    original_file_size integer
);


ALTER TABLE tiny_videos OWNER TO canaandavis;

--
-- Name: tiny_videos_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE tiny_videos_id_seq
    START WITH 2
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tiny_videos_id_seq OWNER TO canaandavis;

--
-- Name: tiny_videos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE tiny_videos_id_seq OWNED BY tiny_videos.id;


--
-- Name: tours_completions; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE tours_completions (
    id integer NOT NULL,
    user_id integer,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE tours_completions OWNER TO canaandavis;

--
-- Name: tours_completions_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE tours_completions_id_seq
    START WITH 514660
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tours_completions_id_seq OWNER TO canaandavis;

--
-- Name: tours_completions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE tours_completions_id_seq OWNED BY tours_completions.id;


--
-- Name: upvotes; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE upvotes (
    id integer NOT NULL,
    votes integer DEFAULT 0,
    user_id integer,
    suggestion_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE upvotes OWNER TO canaandavis;

--
-- Name: upvotes_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE upvotes_id_seq
    START WITH 61
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE upvotes_id_seq OWNER TO canaandavis;

--
-- Name: upvotes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE upvotes_id_seq OWNED BY upvotes.id;


--
-- Name: user_phone_numbers; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE user_phone_numbers (
    id integer NOT NULL,
    number character varying,
    enabled boolean DEFAULT true,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE user_phone_numbers OWNER TO canaandavis;

--
-- Name: user_phone_numbers_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE user_phone_numbers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE user_phone_numbers_id_seq OWNER TO canaandavis;

--
-- Name: user_phone_numbers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE user_phone_numbers_id_seq OWNED BY user_phone_numbers.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(128) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    account_id integer,
    firstname character varying(255),
    lastname character varying(255),
    description text,
    photo_file_name character varying(255),
    photo_content_type character varying(255),
    photo_file_size integer,
    photo_updated_at timestamp without time zone,
    title character varying(255),
    phone character varying(255),
    role integer,
    default_job_permission_id integer,
    account_match character varying(255),
    sent_welcome_at timestamp without time zone,
    failed_attempts integer DEFAULT 0,
    unlock_token character varying(255),
    locked_at timestamp without time zone,
    bounced_at timestamp without time zone,
    hris_employee_id integer,
    from_name_override character varying(255),
    reply_to_override character varying(255),
    email_copy_default boolean DEFAULT false NOT NULL,
    selected_timezone character varying(255),
    background_integration_allowed boolean DEFAULT false NOT NULL,
    authentication_token character varying(255),
    default_apps_filter text,
    external_schedule_url character varying(255),
    email_signature text,
    nps integer,
    primary_owner boolean,
    user_phone_number_id integer,
    password_last_reset_at timestamp without time zone,
    disabled_at timestamp without time zone,
    cant_super_impersonate boolean DEFAULT false NOT NULL,
    activate_token character varying,
    last_seen_at timestamp without time zone,
    session_data jsonb DEFAULT '{}'::jsonb NOT NULL
);


ALTER TABLE users OWNER TO canaandavis;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE users_id_seq
    START WITH 588802
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users_id_seq OWNER TO canaandavis;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: uses_app_forms; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE uses_app_forms (
    id integer NOT NULL,
    app_form_id integer,
    owner_id integer,
    owner_type character varying(255)
);


ALTER TABLE uses_app_forms OWNER TO canaandavis;

--
-- Name: uses_app_forms_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE uses_app_forms_id_seq
    START WITH 551867
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE uses_app_forms_id_seq OWNER TO canaandavis;

--
-- Name: uses_app_forms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE uses_app_forms_id_seq OWNED BY uses_app_forms.id;


--
-- Name: uses_assessment_categories; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE uses_assessment_categories (
    id integer NOT NULL,
    assessment_category_id integer,
    owner_id integer,
    owner_type character varying(255)
);


ALTER TABLE uses_assessment_categories OWNER TO canaandavis;

--
-- Name: uses_assessment_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE uses_assessment_categories_id_seq
    START WITH 1586206
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE uses_assessment_categories_id_seq OWNER TO canaandavis;

--
-- Name: uses_assessment_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE uses_assessment_categories_id_seq OWNED BY uses_assessment_categories.id;


--
-- Name: uses_competencies; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE uses_competencies (
    id integer NOT NULL,
    competency_id integer,
    owner_id integer,
    owner_type character varying(255),
    "position" integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE uses_competencies OWNER TO canaandavis;

--
-- Name: uses_competencies_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE uses_competencies_id_seq
    START WITH 815511
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE uses_competencies_id_seq OWNER TO canaandavis;

--
-- Name: uses_competencies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE uses_competencies_id_seq OWNED BY uses_competencies.id;


--
-- Name: workflow_categories; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE workflow_categories (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    hiring_step boolean DEFAULT false NOT NULL,
    pipeline_step_id integer,
    has_assessments boolean DEFAULT false NOT NULL,
    description text,
    scorecard_name character varying(255) DEFAULT 'Scorecard'::character varying,
    system_category boolean DEFAULT false,
    interview_step boolean DEFAULT false NOT NULL,
    locked_to_admin_users boolean DEFAULT false
);


ALTER TABLE workflow_categories OWNER TO canaandavis;

--
-- Name: workflow_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE workflow_categories_id_seq
    START WITH 481650
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE workflow_categories_id_seq OWNER TO canaandavis;

--
-- Name: workflow_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE workflow_categories_id_seq OWNED BY workflow_categories.id;


--
-- Name: workflow_category_holders; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE workflow_category_holders (
    id integer NOT NULL,
    workflow_id integer,
    workflow_category_id integer,
    "position" integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE workflow_category_holders OWNER TO canaandavis;

--
-- Name: workflow_category_holders_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE workflow_category_holders_id_seq
    START WITH 485554
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE workflow_category_holders_id_seq OWNER TO canaandavis;

--
-- Name: workflow_category_holders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE workflow_category_holders_id_seq OWNED BY workflow_category_holders.id;


--
-- Name: workflow_steps; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE workflow_steps (
    id integer NOT NULL,
    name character varying(255),
    "position" integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    workflow_category_id integer,
    next_status integer,
    message_template_id integer,
    message_template_type character varying(255),
    message_action_future character varying(255),
    message_action_past character varying(255)
);


ALTER TABLE workflow_steps OWNER TO canaandavis;

--
-- Name: workflow_steps_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE workflow_steps_id_seq
    START WITH 490518
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE workflow_steps_id_seq OWNER TO canaandavis;

--
-- Name: workflow_steps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE workflow_steps_id_seq OWNED BY workflow_steps.id;


--
-- Name: workflows; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE workflows (
    id integer NOT NULL,
    name character varying(255),
    account_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    offer_category_id integer,
    background_category_id integer
);


ALTER TABLE workflows OWNER TO canaandavis;

--
-- Name: workflows_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE workflows_id_seq
    START WITH 480888
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE workflows_id_seq OWNER TO canaandavis;

--
-- Name: workflows_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE workflows_id_seq OWNED BY workflows.id;


--
-- Name: zipcodes; Type: TABLE; Schema: public; Owner: canaandavis
--

CREATE TABLE zipcodes (
    id integer NOT NULL,
    zip character varying(255),
    state character varying(255),
    name character varying(255),
    latitude double precision,
    longitude double precision
);


ALTER TABLE zipcodes OWNER TO canaandavis;

--
-- Name: zipcodes_id_seq; Type: SEQUENCE; Schema: public; Owner: canaandavis
--

CREATE SEQUENCE zipcodes_id_seq
    START WITH 82010
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE zipcodes_id_seq OWNER TO canaandavis;

--
-- Name: zipcodes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: canaandavis
--

ALTER SEQUENCE zipcodes_id_seq OWNED BY zipcodes.id;


--
-- Name: account_events id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY account_events ALTER COLUMN id SET DEFAULT nextval('account_events_id_seq'::regclass);


--
-- Name: account_health_grade_changes id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY account_health_grade_changes ALTER COLUMN id SET DEFAULT nextval('account_health_grade_changes_id_seq'::regclass);


--
-- Name: account_logs id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY account_logs ALTER COLUMN id SET DEFAULT nextval('account_logs_id_seq'::regclass);


--
-- Name: account_status_changes id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY account_status_changes ALTER COLUMN id SET DEFAULT nextval('account_status_changes_id_seq'::regclass);


--
-- Name: account_type_employments id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY account_type_employments ALTER COLUMN id SET DEFAULT nextval('account_type_employments_id_seq'::regclass);


--
-- Name: account_types id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY account_types ALTER COLUMN id SET DEFAULT nextval('account_types_id_seq'::regclass);


--
-- Name: accounts id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY accounts ALTER COLUMN id SET DEFAULT nextval('accounts_id_seq'::regclass);


--
-- Name: agent_aliases id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY agent_aliases ALTER COLUMN id SET DEFAULT nextval('agent_aliases_id_seq'::regclass);


--
-- Name: answer_sets id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY answer_sets ALTER COLUMN id SET DEFAULT nextval('answer_sets_id_seq'::regclass);


--
-- Name: answers id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY answers ALTER COLUMN id SET DEFAULT nextval('answers_id_seq'::regclass);


--
-- Name: api_credentials id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY api_credentials ALTER COLUMN id SET DEFAULT nextval('api_credentials_id_seq'::regclass);


--
-- Name: app_accesses id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY app_accesses ALTER COLUMN id SET DEFAULT nextval('app_accesses_id_seq'::regclass);


--
-- Name: app_forms id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY app_forms ALTER COLUMN id SET DEFAULT nextval('app_forms_id_seq'::regclass);


--
-- Name: app_updates id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY app_updates ALTER COLUMN id SET DEFAULT nextval('app_updates_id_seq'::regclass);


--
-- Name: applicants id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY applicants ALTER COLUMN id SET DEFAULT nextval('applicants_id_seq'::regclass);


--
-- Name: application_alerts id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY application_alerts ALTER COLUMN id SET DEFAULT nextval('application_alerts_id_seq'::regclass);


--
-- Name: application_phone_numbers id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY application_phone_numbers ALTER COLUMN id SET DEFAULT nextval('application_phone_numbers_id_seq'::regclass);


--
-- Name: appointment_updates id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY appointment_updates ALTER COLUMN id SET DEFAULT nextval('appointment_updates_id_seq'::regclass);


--
-- Name: appointments id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY appointments ALTER COLUMN id SET DEFAULT nextval('appointments_id_seq'::regclass);


--
-- Name: apps id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY apps ALTER COLUMN id SET DEFAULT nextval('apps_id_seq'::regclass);


--
-- Name: assessment_categories id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY assessment_categories ALTER COLUMN id SET DEFAULT nextval('assessment_categories_id_seq'::regclass);


--
-- Name: assessment_scores id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY assessment_scores ALTER COLUMN id SET DEFAULT nextval('assessment_scores_id_seq'::regclass);


--
-- Name: assessments id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY assessments ALTER COLUMN id SET DEFAULT nextval('assessments_id_seq'::regclass);


--
-- Name: auth_results id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY auth_results ALTER COLUMN id SET DEFAULT nextval('auth_results_id_seq'::regclass);


--
-- Name: benchmark_scores id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY benchmark_scores ALTER COLUMN id SET DEFAULT nextval('benchmark_scores_id_seq'::regclass);


--
-- Name: brands id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY brands ALTER COLUMN id SET DEFAULT nextval('brands_id_seq'::regclass);


--
-- Name: bug_report_comments id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY bug_report_comments ALTER COLUMN id SET DEFAULT nextval('bug_report_comments_id_seq'::regclass);


--
-- Name: bug_reports id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY bug_reports ALTER COLUMN id SET DEFAULT nextval('bug_reports_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY categories ALTER COLUMN id SET DEFAULT nextval('categories_id_seq'::regclass);


--
-- Name: cohorts id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY cohorts ALTER COLUMN id SET DEFAULT nextval('cohorts_id_seq'::regclass);


--
-- Name: company_photos id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY company_photos ALTER COLUMN id SET DEFAULT nextval('company_photos_id_seq'::regclass);


--
-- Name: competencies id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY competencies ALTER COLUMN id SET DEFAULT nextval('competencies_id_seq'::regclass);


--
-- Name: completed_forms id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY completed_forms ALTER COLUMN id SET DEFAULT nextval('completed_forms_id_seq'::regclass);


--
-- Name: coupon_appointments id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY coupon_appointments ALTER COLUMN id SET DEFAULT nextval('coupon_appointments_id_seq'::regclass);


--
-- Name: coupons id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY coupons ALTER COLUMN id SET DEFAULT nextval('coupons_id_seq'::regclass);


--
-- Name: domains id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY domains ALTER COLUMN id SET DEFAULT nextval('domains_id_seq'::regclass);


--
-- Name: email_recipients id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY email_recipients ALTER COLUMN id SET DEFAULT nextval('email_recipients_id_seq'::regclass);


--
-- Name: email_threads id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY email_threads ALTER COLUMN id SET DEFAULT nextval('email_threads_id_seq'::regclass);


--
-- Name: emails id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY emails ALTER COLUMN id SET DEFAULT nextval('emails_id_seq'::regclass);


--
-- Name: employments id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY employments ALTER COLUMN id SET DEFAULT nextval('employments_id_seq'::regclass);


--
-- Name: external_site_links id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY external_site_links ALTER COLUMN id SET DEFAULT nextval('external_site_links_id_seq'::regclass);


--
-- Name: fast_track_answers id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY fast_track_answers ALTER COLUMN id SET DEFAULT nextval('fast_track_answers_id_seq'::regclass);


--
-- Name: has_account_types id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY has_account_types ALTER COLUMN id SET DEFAULT nextval('has_account_types_id_seq'::regclass);


--
-- Name: has_apps id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY has_apps ALTER COLUMN id SET DEFAULT nextval('has_apps_id_seq'::regclass);


--
-- Name: has_attachments id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY has_attachments ALTER COLUMN id SET DEFAULT nextval('has_attachments_id_seq'::regclass);


--
-- Name: has_industries id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY has_industries ALTER COLUMN id SET DEFAULT nextval('has_industries_id_seq'::regclass);


--
-- Name: has_message_templates id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY has_message_templates ALTER COLUMN id SET DEFAULT nextval('has_message_templates_id_seq'::regclass);


--
-- Name: has_support_team_members id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY has_support_team_members ALTER COLUMN id SET DEFAULT nextval('has_support_team_members_id_seq'::regclass);


--
-- Name: has_updates id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY has_updates ALTER COLUMN id SET DEFAULT nextval('has_updates_id_seq'::regclass);


--
-- Name: has_users id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY has_users ALTER COLUMN id SET DEFAULT nextval('has_users_id_seq'::regclass);


--
-- Name: health_components id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY health_components ALTER COLUMN id SET DEFAULT nextval('health_components_id_seq'::regclass);


--
-- Name: health_grade_keys id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY health_grade_keys ALTER COLUMN id SET DEFAULT nextval('health_grade_keys_id_seq'::regclass);


--
-- Name: health_key_items id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY health_key_items ALTER COLUMN id SET DEFAULT nextval('health_key_items_id_seq'::regclass);


--
-- Name: hiring_status_sorting id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY hiring_status_sorting ALTER COLUMN id SET DEFAULT nextval('hiring_status_sorting_id_seq'::regclass);


--
-- Name: in_workflow_categories id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY in_workflow_categories ALTER COLUMN id SET DEFAULT nextval('in_workflow_categories_id_seq'::regclass);


--
-- Name: in_workflow_steps id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY in_workflow_steps ALTER COLUMN id SET DEFAULT nextval('in_workflow_steps_id_seq'::regclass);


--
-- Name: industries id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY industries ALTER COLUMN id SET DEFAULT nextval('industries_id_seq'::regclass);


--
-- Name: invalid_emails id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY invalid_emails ALTER COLUMN id SET DEFAULT nextval('invalid_emails_id_seq'::regclass);


--
-- Name: job_aggregators id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY job_aggregators ALTER COLUMN id SET DEFAULT nextval('job_aggregators_id_seq'::regclass);


--
-- Name: job_builders id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY job_builders ALTER COLUMN id SET DEFAULT nextval('job_builders_id_seq'::regclass);


--
-- Name: job_categories id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY job_categories ALTER COLUMN id SET DEFAULT nextval('job_categories_id_seq'::regclass);


--
-- Name: job_comments id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY job_comments ALTER COLUMN id SET DEFAULT nextval('job_comments_id_seq'::regclass);


--
-- Name: job_permissions id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY job_permissions ALTER COLUMN id SET DEFAULT nextval('job_permissions_id_seq'::regclass);


--
-- Name: job_views id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY job_views ALTER COLUMN id SET DEFAULT nextval('job_views_id_seq'::regclass);


--
-- Name: jobs id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY jobs ALTER COLUMN id SET DEFAULT nextval('jobs_id_seq'::regclass);


--
-- Name: keyword_sets id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY keyword_sets ALTER COLUMN id SET DEFAULT nextval('keyword_sets_id_seq'::regclass);


--
-- Name: keywords id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY keywords ALTER COLUMN id SET DEFAULT nextval('keywords_id_seq'::regclass);


--
-- Name: leads id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY leads ALTER COLUMN id SET DEFAULT nextval('leads_id_seq'::regclass);


--
-- Name: locations id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY locations ALTER COLUMN id SET DEFAULT nextval('locations_id_seq'::regclass);


--
-- Name: manage_tokens id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY manage_tokens ALTER COLUMN id SET DEFAULT nextval('manage_tokens_id_seq'::regclass);


--
-- Name: message_templates id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY message_templates ALTER COLUMN id SET DEFAULT nextval('message_templates_id_seq'::regclass);


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY notifications ALTER COLUMN id SET DEFAULT nextval('notifications_id_seq'::regclass);


--
-- Name: nps_responses id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY nps_responses ALTER COLUMN id SET DEFAULT nextval('nps_responses_id_seq'::regclass);


--
-- Name: oauth_access_grants id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY oauth_access_grants ALTER COLUMN id SET DEFAULT nextval('oauth_access_grants_id_seq'::regclass);


--
-- Name: oauth_access_tokens id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY oauth_access_tokens ALTER COLUMN id SET DEFAULT nextval('oauth_access_tokens_id_seq'::regclass);


--
-- Name: oauth_applications id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY oauth_applications ALTER COLUMN id SET DEFAULT nextval('oauth_applications_id_seq'::regclass);


--
-- Name: offer_letter_templates id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY offer_letter_templates ALTER COLUMN id SET DEFAULT nextval('offer_letter_templates_id_seq'::regclass);


--
-- Name: offer_letter_updates id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY offer_letter_updates ALTER COLUMN id SET DEFAULT nextval('offer_letter_updates_id_seq'::regclass);


--
-- Name: offer_letters id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY offer_letters ALTER COLUMN id SET DEFAULT nextval('offer_letters_id_seq'::regclass);


--
-- Name: organizational_units id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY organizational_units ALTER COLUMN id SET DEFAULT nextval('organizational_units_id_seq'::regclass);


--
-- Name: overview_builders id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY overview_builders ALTER COLUMN id SET DEFAULT nextval('overview_builders_id_seq'::regclass);


--
-- Name: pages id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY pages ALTER COLUMN id SET DEFAULT nextval('pages_id_seq'::regclass);


--
-- Name: payment_transactions id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY payment_transactions ALTER COLUMN id SET DEFAULT nextval('payment_transactions_id_seq'::regclass);


--
-- Name: perks id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY perks ALTER COLUMN id SET DEFAULT nextval('perks_id_seq'::regclass);


--
-- Name: phone_number_owners id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY phone_number_owners ALTER COLUMN id SET DEFAULT nextval('phone_number_owners_id_seq'::regclass);


--
-- Name: pipeline_steps id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY pipeline_steps ALTER COLUMN id SET DEFAULT nextval('pipeline_steps_id_seq'::regclass);


--
-- Name: plan_cycles id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY plan_cycles ALTER COLUMN id SET DEFAULT nextval('plan_cycles_id_seq'::regclass);


--
-- Name: plan_upgrades id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY plan_upgrades ALTER COLUMN id SET DEFAULT nextval('plan_upgrades_id_seq'::regclass);


--
-- Name: planned_follow_ups id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY planned_follow_ups ALTER COLUMN id SET DEFAULT nextval('planned_follow_ups_id_seq'::regclass);


--
-- Name: plans id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY plans ALTER COLUMN id SET DEFAULT nextval('plans_id_seq'::regclass);


--
-- Name: product_cycles id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY product_cycles ALTER COLUMN id SET DEFAULT nextval('product_cycles_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY products ALTER COLUMN id SET DEFAULT nextval('products_id_seq'::regclass);


--
-- Name: profiles id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY profiles ALTER COLUMN id SET DEFAULT nextval('profiles_id_seq'::regclass);


--
-- Name: purchases id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY purchases ALTER COLUMN id SET DEFAULT nextval('purchases_id_seq'::regclass);


--
-- Name: question_set_owners id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY question_set_owners ALTER COLUMN id SET DEFAULT nextval('question_set_owners_id_seq'::regclass);


--
-- Name: questionnaires id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY questionnaires ALTER COLUMN id SET DEFAULT nextval('questionnaires_id_seq'::regclass);


--
-- Name: questions id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY questions ALTER COLUMN id SET DEFAULT nextval('questions_id_seq'::regclass);


--
-- Name: rating_scores id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY rating_scores ALTER COLUMN id SET DEFAULT nextval('rating_scores_id_seq'::regclass);


--
-- Name: rating_templates id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY rating_templates ALTER COLUMN id SET DEFAULT nextval('rating_templates_id_seq'::regclass);


--
-- Name: ratings id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY ratings ALTER COLUMN id SET DEFAULT nextval('ratings_id_seq'::regclass);


--
-- Name: recent_activity id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY recent_activity ALTER COLUMN id SET DEFAULT nextval('recent_activity_id_seq'::regclass);


--
-- Name: referral_credits id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY referral_credits ALTER COLUMN id SET DEFAULT nextval('referral_credits_id_seq'::regclass);


--
-- Name: referral_short_urls id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY referral_short_urls ALTER COLUMN id SET DEFAULT nextval('referral_short_urls_id_seq'::regclass);


--
-- Name: reject_reason_sets id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY reject_reason_sets ALTER COLUMN id SET DEFAULT nextval('reject_reason_sets_id_seq'::regclass);


--
-- Name: reject_reasons id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY reject_reasons ALTER COLUMN id SET DEFAULT nextval('reject_reasons_id_seq'::regclass);


--
-- Name: reports id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY reports ALTER COLUMN id SET DEFAULT nextval('reports_id_seq'::regclass);


--
-- Name: resume_requests id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY resume_requests ALTER COLUMN id SET DEFAULT nextval('resume_requests_id_seq'::regclass);


--
-- Name: schedule_owner_proxies id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY schedule_owner_proxies ALTER COLUMN id SET DEFAULT nextval('schedule_owner_proxies_id_seq'::regclass);


--
-- Name: scheduled_app_updates id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY scheduled_app_updates ALTER COLUMN id SET DEFAULT nextval('scheduled_app_updates_id_seq'::regclass);


--
-- Name: scheduled_notifications id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY scheduled_notifications ALTER COLUMN id SET DEFAULT nextval('scheduled_notifications_id_seq'::regclass);


--
-- Name: scoring_set_invites id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY scoring_set_invites ALTER COLUMN id SET DEFAULT nextval('scoring_set_invites_id_seq'::regclass);


--
-- Name: scoring_set_items id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY scoring_set_items ALTER COLUMN id SET DEFAULT nextval('scoring_set_items_id_seq'::regclass);


--
-- Name: scoring_sets id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY scoring_sets ALTER COLUMN id SET DEFAULT nextval('scoring_sets_id_seq'::regclass);


--
-- Name: search_logs id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY search_logs ALTER COLUMN id SET DEFAULT nextval('search_logs_id_seq'::regclass);


--
-- Name: sections id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY sections ALTER COLUMN id SET DEFAULT nextval('sections_id_seq'::regclass);


--
-- Name: settings id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY settings ALTER COLUMN id SET DEFAULT nextval('settings_id_seq'::regclass);


--
-- Name: sf_codes id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY sf_codes ALTER COLUMN id SET DEFAULT nextval('sf_codes_id_seq'::regclass);


--
-- Name: short_urls id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY short_urls ALTER COLUMN id SET DEFAULT nextval('short_urls_id_seq'::regclass);


--
-- Name: signatures id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY signatures ALTER COLUMN id SET DEFAULT nextval('signatures_id_seq'::regclass);


--
-- Name: site_templates id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY site_templates ALTER COLUMN id SET DEFAULT nextval('site_templates_id_seq'::regclass);


--
-- Name: sms_messages id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY sms_messages ALTER COLUMN id SET DEFAULT nextval('sms_messages_id_seq'::regclass);


--
-- Name: sms_receipts id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY sms_receipts ALTER COLUMN id SET DEFAULT nextval('sms_receipts_id_seq'::regclass);


--
-- Name: sms_thread_responses id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY sms_thread_responses ALTER COLUMN id SET DEFAULT nextval('sms_thread_responses_id_seq'::regclass);


--
-- Name: sms_threads id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY sms_threads ALTER COLUMN id SET DEFAULT nextval('sms_threads_id_seq'::regclass);


--
-- Name: sources id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY sources ALTER COLUMN id SET DEFAULT nextval('sources_id_seq'::regclass);


--
-- Name: success_notes id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY success_notes ALTER COLUMN id SET DEFAULT nextval('success_notes_id_seq'::regclass);


--
-- Name: success_plans id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY success_plans ALTER COLUMN id SET DEFAULT nextval('success_plans_id_seq'::regclass);


--
-- Name: success_tasks id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY success_tasks ALTER COLUMN id SET DEFAULT nextval('success_tasks_id_seq'::regclass);


--
-- Name: suggestion_comments id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY suggestion_comments ALTER COLUMN id SET DEFAULT nextval('suggestion_comments_id_seq'::regclass);


--
-- Name: suggestions id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY suggestions ALTER COLUMN id SET DEFAULT nextval('suggestions_id_seq'::regclass);


--
-- Name: teams id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY teams ALTER COLUMN id SET DEFAULT nextval('teams_id_seq'::regclass);


--
-- Name: testimonials id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY testimonials ALTER COLUMN id SET DEFAULT nextval('testimonials_id_seq'::regclass);


--
-- Name: tiered_prices id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY tiered_prices ALTER COLUMN id SET DEFAULT nextval('tiered_prices_id_seq'::regclass);


--
-- Name: tiny_prints id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY tiny_prints ALTER COLUMN id SET DEFAULT nextval('tiny_prints_id_seq'::regclass);


--
-- Name: tiny_videos id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY tiny_videos ALTER COLUMN id SET DEFAULT nextval('tiny_videos_id_seq'::regclass);


--
-- Name: tours_completions id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY tours_completions ALTER COLUMN id SET DEFAULT nextval('tours_completions_id_seq'::regclass);


--
-- Name: upvotes id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY upvotes ALTER COLUMN id SET DEFAULT nextval('upvotes_id_seq'::regclass);


--
-- Name: user_phone_numbers id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY user_phone_numbers ALTER COLUMN id SET DEFAULT nextval('user_phone_numbers_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: uses_app_forms id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY uses_app_forms ALTER COLUMN id SET DEFAULT nextval('uses_app_forms_id_seq'::regclass);


--
-- Name: uses_assessment_categories id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY uses_assessment_categories ALTER COLUMN id SET DEFAULT nextval('uses_assessment_categories_id_seq'::regclass);


--
-- Name: uses_competencies id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY uses_competencies ALTER COLUMN id SET DEFAULT nextval('uses_competencies_id_seq'::regclass);


--
-- Name: workflow_categories id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY workflow_categories ALTER COLUMN id SET DEFAULT nextval('workflow_categories_id_seq'::regclass);


--
-- Name: workflow_category_holders id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY workflow_category_holders ALTER COLUMN id SET DEFAULT nextval('workflow_category_holders_id_seq'::regclass);


--
-- Name: workflow_steps id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY workflow_steps ALTER COLUMN id SET DEFAULT nextval('workflow_steps_id_seq'::regclass);


--
-- Name: workflows id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY workflows ALTER COLUMN id SET DEFAULT nextval('workflows_id_seq'::regclass);


--
-- Name: zipcodes id; Type: DEFAULT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY zipcodes ALTER COLUMN id SET DEFAULT nextval('zipcodes_id_seq'::regclass);


--
-- Data for Name: account_events; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY account_events (id, key, name, "position", internal_enabled, duplicates, snooze, response_days, default_action_log_type, default_follow_up_log_type, default_follow_up_due_at_days, user_id, autocomplete) FROM stdin;
\.


--
-- Name: account_events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('account_events_id_seq', 119, false);


--
-- Data for Name: account_health_grade_changes; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY account_health_grade_changes (id, account_id, new_health_grade, created_at, updated_at) FROM stdin;
\.


--
-- Name: account_health_grade_changes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('account_health_grade_changes_id_seq', 485188, false);


--
-- Data for Name: account_logs; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY account_logs (id, account_id, user_id, message_template_id, note, created_at, updated_at, due_at, completed_at, log_type, nps, parent_id, escalated, account_event_id, respond_at, source, log_type_name) FROM stdin;
\.


--
-- Name: account_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('account_logs_id_seq', 748691, false);


--
-- Data for Name: account_status_changes; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY account_status_changes (id, account_id, new_status, reason, created_at, updated_at) FROM stdin;
\.


--
-- Name: account_status_changes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('account_status_changes_id_seq', 503140, false);


--
-- Data for Name: account_type_employments; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY account_type_employments (id, account_type_id, employment_id, created_at, updated_at) FROM stdin;
\.


--
-- Name: account_type_employments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('account_type_employments_id_seq', 330157, false);


--
-- Data for Name: account_types; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY account_types (id, name, key, disclaimer, signup_subdomain, main_support_url, created_at, updated_at, default_country, signup_template, aspirant, aspirant_account_type_id, custom_microsite_name, custom_careers_title, testimonial_content, testimonial_attribution, testimonial_logo_url, signup_content, signup_style, signup_heading, referral_message, referral_button, referral_thanks, default_referral_plan_id, permissions, account_color_primary, account_description, account_name_append, account_name_prepend, account_subdomain, apply_initial_sources, aspirant_benchmark_title, disable_coupons, eeoc_tracking, has_resumes, multiple_job_limit, multiple_job_same_name, notify_locations, onboard, prevent_video, resume_requests_available, suppress_feed, user_job_title, copy_logo_id, domain_id, initial_sources, default_overview_builder_id, site_template_id, embedded_site_template_id, default_company_photo_id, onboarding_video_url, health_grade_key_id, default_apps_filter, workflow_id, brand, support_email, support_phone, logo_file_name, logo_content_type, logo_file_size, logo_updated_at, footer_content, white_label_domain_id, indeed_referral_partner_code, white_label_ats_subdomain, white_label_hris_subdomain, white_label_style, custom_upgrade_url, source_name, favicon_file_name, favicon_content_type, favicon_file_size, favicon_updated_at, account_terms_of_service, user_terms_of_service, activate_page_content, activate_page_css, copy_site_template_config_id, disclaimer_trl_key, contact_form_url) FROM stdin;
\.


--
-- Name: account_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('account_types_id_seq', 330068, true);


--
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY accounts (id, name, created_at, updated_at, description, subdomain, logo_file_name, logo_content_type, logo_file_size, logo_updated_at, domain_id, site_template_id, extra_field_set_id, account_type_id, plan_id, subscription_id, payment_status, first_name, last_name, address, city, state, zip, phone, cc_expire_at, company_url, facebook_url, linkedin_url, sf_code, video_url, eeoc, coupon_expires_at, referral_code, default_country, has_resumes, trial_expires_at, perfman_enabled, perfman_activated_at, perfman_setup_at, resume_requests_available, next_payment_at, auto_renew, aspirant, agency_overview, upgraded_at, aspirant_activated_at, workflow_id, account_manager_id, last_renewed_at, onboarded_at, twitter_url, email, cancelled_at, deleted_at, custom_microsite_name, custom_careers_title, payment_profile_id, customer_profile_id, embedded_site_template_id, cc_digits, anonymous_name, payment_type, first_job_notified_at, activity_status, billing_email, sales_exec_id, designation, health_grade, permissions, assessments_integration_dept, background_check_account, background_check_username, selected_timezone, aspirant_job_limit, assessments_disabled, assessments_outdated, assessments_integration, assessments_integration_integrate, assessments_integration_company, auto_refresh, background_check_integration, background_check_integration_notify, force_setup, skip_setup, handyman_franchise, handyman_team, hide_facebook_share, hide_facebook_status, hide_linkedin_share, hide_linkedin_status, hide_twitter_share, hide_twitter_status, ignore_no_assessments, ignore_popup_blocker, ignore_resume_requests, internal_email_disabled, location_job_list, lock_job_description, override_hiring_step, post_apply_redirect, suppress_feed, assessment_override_from_id, assessment_override_to_id, coupon_expire, default_app_forms, site_template_config, job_approval_notify, embedded_site_template_config, nps, cohort_id, hidden_job_templates, hidden_app_forms, paid_active_jobs, paid_active_locations, last_login_time_health, active_postings_health, num_applicants_health, avg_prescreen_questions_health, assessments_health, renewal_count, last_scheduled_renewal, salesforce_id, snagajob_feed_enabled, snagajob_industry, payroll_company_code, location_num, last_payment_amount, downgraded_at, reactivated_at, declined_warning_count, auto_send_fast_track_invite, indeed_advnum, wotc_client_id, wotc_default_location_id, mask_rejection_email_enabled, enable_agg_subdomain, agg_subdomain, survey_opt_in, progression_info, header_headline, header_tagline, header_description, perks_headline, perks_tagline, perks_description, header_background, background_check_type, first_app_notified_at, name_trl_key, description_trl_key, header_headline_trl_key, header_tagline_trl_key, header_description_trl_key, perks_headline_trl_key, perks_tagline_trl_key, perks_description_trl_key, plan_cycle_id, pending_plan_cycle_id, fifth_app_date) FROM stdin;
\.


--
-- Name: accounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('accounts_id_seq', 497303, true);


--
-- Data for Name: agent_aliases; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY agent_aliases (id, alias, email, account_id, invited_at, activated_at, created_at, updated_at, firstname, lastname, country) FROM stdin;
\.


--
-- Name: agent_aliases_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('agent_aliases_id_seq', 485166, false);


--
-- Data for Name: answer_sets; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY answer_sets (id, owner_id, question_id, answer_id, answer_text, created_at, updated_at, owner_type) FROM stdin;
\.


--
-- Name: answer_sets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('answer_sets_id_seq', 482505, false);


--
-- Data for Name: answers; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY answers (id, name, question_id, score, "position", created_at, updated_at, data, name_trl_key) FROM stdin;
\.


--
-- Name: answers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('answers_id_seq', 895873, false);


--
-- Data for Name: api_credentials; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY api_credentials (id, name, username, password_digest, created_at, updated_at) FROM stdin;
\.


--
-- Name: api_credentials_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('api_credentials_id_seq', 5, false);


--
-- Data for Name: app_accesses; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY app_accesses (id, user_id, application, role, created_at, updated_at) FROM stdin;
\.


--
-- Name: app_accesses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('app_accesses_id_seq', 514240, false);


--
-- Data for Name: app_forms; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY app_forms (id, account_id, name, content, style, result, created_at, updated_at, form_type, notify_completion, options, archived) FROM stdin;
\.


--
-- Name: app_forms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('app_forms_id_seq', 480426, false);


--
-- Data for Name: app_updates; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY app_updates (id, app_id, user_id, owner_id, workflow_step_id, comment, created_at, updated_at, rating, workflow_category_id, update_type) FROM stdin;
\.


--
-- Name: app_updates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('app_updates_id_seq', 7886873, false);


--
-- Data for Name: applicants; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY applicants (id, email, firstname, lastname, phone, address, city, state, zip, country, resume_text, created_at, updated_at, source_id, recent_title, recent_employer, linkedin_url, cover_letter, bounced_at) FROM stdin;
\.


--
-- Name: applicants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('applicants_id_seq', 8044331, false);


--
-- Data for Name: application_alerts; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY application_alerts (id, title, body, action_type, action_data, alert_type, read_at, received_at, user_id, owner_type, owner_id, created_at, updated_at) FROM stdin;
\.


--
-- Name: application_alerts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('application_alerts_id_seq', 1, false);


--
-- Data for Name: application_phone_numbers; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY application_phone_numbers (id, number_id, number, national_number, active, created_at, updated_at, app_env, user_id) FROM stdin;
\.


--
-- Name: application_phone_numbers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('application_phone_numbers_id_seq', 1, false);


--
-- Data for Name: appointment_updates; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY appointment_updates (id, appointment_id, start_time, created_at, updated_at, end_time, current, timezone) FROM stdin;
\.


--
-- Name: appointment_updates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('appointment_updates_id_seq', 1, false);


--
-- Data for Name: appointments; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY appointments (id, scheduler_id, scheduler_type, schedule_owner_id, schedule_owner_type, owner_id, owner_type, expires_in, duration, location, name, status, created_at, updated_at, reschedule_enabled_at, appointment_type, future_days) FROM stdin;
\.


--
-- Name: appointments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('appointments_id_seq', 1, false);


--
-- Data for Name: apps; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY apps (id, applicant_id, job_id, created_at, updated_at, source_id, owner_id, workflow_step_id, workflow_category_id, hiring_status, status_cache, employee, is_benchmark, employment_status, reason_for_leaving, employment_ended_at, referral_id, account_id, user_id, has_evals, has_goals, apply_type, xss_lookup, favorite, pipeline_step_id, cloned_from_resume, distance, team_benchmark, assigned_assessments, assessment_set_ids, cloned_assessments, assessments_completed_at, pipeline, overall_rating, days_to_fill, eeoc_job_category, eeoc_gender, eeoc_race, eeoc_disability, eeoc_veteran, referred_by, referred_by_email, external_id, application_required, application_completed_at, last_indexed_at, user_phone_number_id) FROM stdin;
\.


--
-- Name: apps_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('apps_id_seq', 8034566, false);


--
-- Data for Name: ar_internal_metadata; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: assessment_categories; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY assessment_categories (id, name, created_at, updated_at, agent_aspirant, account_id, headline, description) FROM stdin;
\.


--
-- Name: assessment_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('assessment_categories_id_seq', 118, false);


--
-- Data for Name: assessment_scores; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY assessment_scores (id, scoring_set_id, assessment_category_id, score, created_at, updated_at) FROM stdin;
\.


--
-- Name: assessment_scores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('assessment_scores_id_seq', 29893245, false);


--
-- Data for Name: assessments; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY assessments (id, job_id, questionnaire_id, created_at, updated_at) FROM stdin;
\.


--
-- Name: assessments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('assessments_id_seq', 730540, false);


--
-- Data for Name: auth_results; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY auth_results (id, subscription_id, payment_number, response_code, response_text, notified_at, created_at, updated_at, payload) FROM stdin;
\.


--
-- Name: auth_results_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('auth_results_id_seq', 526463, false);


--
-- Data for Name: benchmark_scores; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY benchmark_scores (id, account_type_id, question_set_id, category_id, average_score, created_at, updated_at) FROM stdin;
\.


--
-- Name: benchmark_scores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('benchmark_scores_id_seq', 1029613, false);


--
-- Data for Name: brands; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY brands (id, account_id, name, description, logo_file_name, logo_content_type, logo_file_size, logo_updated_at, site_template_id, embedded_site_template_id, company_url, facebook_url, linkedin_url, video_url, twitter_url, custom_microsite_name, custom_careers_title, anonymous_name, created_at, updated_at, subdomain, site_template_config, embedded_site_template_config, payroll_company_code, header_headline, header_tagline, header_description, header_background, perks_headline, perks_tagline, perks_description, name_trl_key, description_trl_key, header_headline_trl_key, header_tagline_trl_key, header_description_trl_key, perks_headline_trl_key, perks_tagline_trl_key, perks_description_trl_key) FROM stdin;
\.


--
-- Name: brands_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('brands_id_seq', 480069, false);


--
-- Data for Name: bug_report_comments; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY bug_report_comments (id, comment, bug_report_id, user_id, created_at, updated_at, bug_status) FROM stdin;
\.


--
-- Name: bug_report_comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('bug_report_comments_id_seq', 480599, false);


--
-- Data for Name: bug_reports; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY bug_reports (id, summary, description, example_account_id, status, reported_by, user_id, created_at, updated_at, story_url, reporting_account_ids, client_phone, client_email, target_completion_date, issue_type, story_id, fixed_at, priority) FROM stdin;
\.


--
-- Name: bug_reports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('bug_reports_id_seq', 480749, false);


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY categories (id, name, created_at, updated_at, zip_recruiter_category) FROM stdin;
\.


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('categories_id_seq', 180074, false);


--
-- Data for Name: cohorts; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY cohorts (id, year, month, created_at, updated_at, billing_type) FROM stdin;
\.


--
-- Name: cohorts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('cohorts_id_seq', 480002, false);


--
-- Data for Name: company_photos; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY company_photos (id, owner_id, name, "position", created_at, updated_at, company_photo_file_name, company_photo_content_type, company_photo_file_size, owner_type) FROM stdin;
\.


--
-- Name: company_photos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('company_photos_id_seq', 509170, false);


--
-- Data for Name: competencies; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY competencies (id, name, prompt, account_id, created_at, updated_at) FROM stdin;
\.


--
-- Name: competencies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('competencies_id_seq', 480541, false);


--
-- Data for Name: completed_forms; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY completed_forms (id, app_id, app_form_id, data, created_at, updated_at) FROM stdin;
\.


--
-- Name: completed_forms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('completed_forms_id_seq', 1354610, false);


--
-- Data for Name: coupon_appointments; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY coupon_appointments (id, coupon_id, appointment) FROM stdin;
\.


--
-- Name: coupon_appointments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('coupon_appointments_id_seq', 15547, false);


--
-- Data for Name: coupons; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY coupons (id, name, plan_id, expire_plan_id, expire_terms, created_at, updated_at, account_type_id, start_at, end_at, bypass_payment) FROM stdin;
\.


--
-- Name: coupons_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('coupons_id_seq', 15195, false);


--
-- Data for Name: domains; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY domains (id, name, created_at, updated_at, is_white_label) FROM stdin;
\.


--
-- Name: domains_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('domains_id_seq', 6, false);


--
-- Data for Name: email_recipients; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY email_recipients (id, user_id, email_recipient_id, email_address) FROM stdin;
\.


--
-- Name: email_recipients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('email_recipients_id_seq', 480043, false);


--
-- Data for Name: email_threads; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY email_threads (id, uid, created_at, updated_at) FROM stdin;
\.


--
-- Name: email_threads_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('email_threads_id_seq', 1422891, false);


--
-- Data for Name: emails; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY emails (id, account_id, user_id, event, related_id, "to", subject, body, created_at, updated_at, invite, location, start_time, end_time, cc, "from", email_thread_id, timezone, include_signature, bcc, scheduled_at, sent_at, bulk_rejection_email, invite_schedule, read_at, tracked) FROM stdin;
\.


--
-- Name: emails_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('emails_id_seq', 2108534, false);


--
-- Data for Name: employments; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY employments (id, name, created_at, updated_at, account_id, name_trl_key) FROM stdin;
\.


--
-- Name: employments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('employments_id_seq', 15130, false);


--
-- Data for Name: external_site_links; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY external_site_links (id, name, url, owner_id, owner_type, created_at, updated_at, link_type) FROM stdin;
\.


--
-- Name: external_site_links_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('external_site_links_id_seq', 481891, false);


--
-- Data for Name: fast_track_answers; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY fast_track_answers (id, answer_id, category, job_id, created_at, updated_at) FROM stdin;
\.


--
-- Name: fast_track_answers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('fast_track_answers_id_seq', 886547, false);


--
-- Data for Name: has_account_types; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY has_account_types (id, account_type_id, owner_id, owner_type, created_at, updated_at) FROM stdin;
\.


--
-- Name: has_account_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('has_account_types_id_seq', 519500, false);


--
-- Data for Name: has_apps; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY has_apps (id, app_id, owner_id, owner_type, created_at, updated_at) FROM stdin;
\.


--
-- Name: has_apps_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('has_apps_id_seq', 549399, false);


--
-- Data for Name: has_attachments; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY has_attachments (id, owner_id, name, attachment_file_name, attachment_content_type, attachment_file_size, created_at, updated_at, owner_type, text_cache, applicant_photo, tags) FROM stdin;
\.


--
-- Name: has_attachments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('has_attachments_id_seq', 6747871, false);


--
-- Data for Name: has_industries; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY has_industries (id, industry_id, owner_id, owner_type) FROM stdin;
\.


--
-- Name: has_industries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('has_industries_id_seq', 496693, false);


--
-- Data for Name: has_message_templates; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY has_message_templates (id, message_template_id, owner_id, owner_type, created_at, updated_at) FROM stdin;
\.


--
-- Name: has_message_templates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('has_message_templates_id_seq', 15, false);


--
-- Data for Name: has_support_team_members; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY has_support_team_members (id, user_id, account_type_id) FROM stdin;
\.


--
-- Name: has_support_team_members_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('has_support_team_members_id_seq', 330003, false);


--
-- Data for Name: has_updates; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY has_updates (id, owner_id, user_id, comment, rating, update_type, created_at, updated_at, owner_type, account_id, status) FROM stdin;
\.


--
-- Name: has_updates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('has_updates_id_seq', 567351, false);


--
-- Data for Name: has_users; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY has_users (id, user_id, owner_id, owner_type, created_at, updated_at) FROM stdin;
\.


--
-- Name: has_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('has_users_id_seq', 633095, false);


--
-- Data for Name: health_components; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY health_components (id, health_type, weight, owner_id, owner_type, time_range) FROM stdin;
\.


--
-- Name: health_components_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('health_components_id_seq', 32, false);


--
-- Data for Name: health_grade_keys; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY health_grade_keys (id, name, created_at, updated_at) FROM stdin;
\.


--
-- Name: health_grade_keys_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('health_grade_keys_id_seq', 8, false);


--
-- Data for Name: health_key_items; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY health_key_items (id, health_grade, value, health_component_id) FROM stdin;
\.


--
-- Name: health_key_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('health_key_items_id_seq', 92, false);


--
-- Data for Name: hiring_status_sorting; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY hiring_status_sorting (id, hiring_status, "position") FROM stdin;
\.


--
-- Name: hiring_status_sorting_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('hiring_status_sorting_id_seq', 6, false);


--
-- Data for Name: in_workflow_categories; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY in_workflow_categories (id, workflow_category_id, owner_id, owner_type, created_at, updated_at) FROM stdin;
\.


--
-- Name: in_workflow_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('in_workflow_categories_id_seq', 838986, false);


--
-- Data for Name: in_workflow_steps; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY in_workflow_steps (id, workflow_step_id, owner_id, owner_type, created_at, updated_at) FROM stdin;
\.


--
-- Name: in_workflow_steps_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('in_workflow_steps_id_seq', 500209, false);


--
-- Data for Name: industries; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY industries (id, name, created_at, updated_at) FROM stdin;
\.


--
-- Name: industries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('industries_id_seq', 27, false);


--
-- Data for Name: invalid_emails; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY invalid_emails (id, email, invalid_type, created_at, updated_at, info) FROM stdin;
\.


--
-- Name: invalid_emails_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('invalid_emails_id_seq', 533750, false);


--
-- Data for Name: job_aggregators; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY job_aggregators (id, name, subdomain, site_template_id, embedded_site_template_id, source_id, created_at, updated_at, additional_accounts, include_brands, site_template_config, account_id, header_headline, header_tagline, header_description, header_background, logo_url, perks_headline, perks_tagline, perks_description, description, video_url) FROM stdin;
\.


--
-- Name: job_aggregators_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('job_aggregators_id_seq', 180014, false);


--
-- Data for Name: job_builders; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY job_builders (id, name, job_title_question_id, job_builder_option_id, job_builder_questionnaire_id, job_template, created_at, updated_at, enabled, job_title_extra_question_id, filter_used_job_titles, country) FROM stdin;
\.


--
-- Name: job_builders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('job_builders_id_seq', 16, false);


--
-- Data for Name: job_categories; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY job_categories (category_id, job_id, id) FROM stdin;
\.


--
-- Name: job_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('job_categories_id_seq', 1257942, false);


--
-- Data for Name: job_comments; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY job_comments (id, job_id, user_id, comment, created_at, updated_at, comment_type, reminded_at) FROM stdin;
\.


--
-- Name: job_comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('job_comments_id_seq', 481643, false);


--
-- Data for Name: job_permissions; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY job_permissions (id, user_id, job_id, access, notification, created_at, updated_at, notify_assessments, notify_scorecards, notify_fast_track, notify_fast_track_sms) FROM stdin;
\.


--
-- Name: job_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('job_permissions_id_seq', 1185737, false);


--
-- Data for Name: job_views; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY job_views (id, week, account_id, job_id, created_at, updated_at) FROM stdin;
\.


--
-- Name: job_views_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('job_views_id_seq', 3693940, false);


--
-- Data for Name: jobs; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY jobs (id, name, description, status, owner_id, country, city, state, zip, employment_id, code, questionnaire_id, created_at, updated_at, hide, system_name, job_builder_id, notification_cc, refreshed_at, deactivated_at, edited_at, location_id, department_id, keyword_set_id, redirect_url, template, job_template_id, prescreen_questions, expire_notify, anonymous, brand_id, external_ats_url, compensation, experience, activate_at, refresh_at, eeoc_job_category, offer_letter_template_id, video_interview_url, cached_prescreen_ids, workflow_id, internal_name, digest_notified_at, admin_only_template, advertising_spend, indeed_budget, indeed_sponsored, indeed_adv_email, indeed_remote, account_type_id, ft_auto_interview_schedule, primary_language, progression_checklists, require_resume, internal_only, indeed_adv_phone, name_trl_key, description_trl_key) FROM stdin;
\.


--
-- Name: jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('jobs_id_seq', 626823, false);


--
-- Data for Name: keyword_sets; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY keyword_sets (id, name, account_id, created_at, updated_at, usage_type) FROM stdin;
\.


--
-- Name: keyword_sets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('keyword_sets_id_seq', 480144, false);


--
-- Data for Name: keywords; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY keywords (id, name, keyword_set_id, keyword_type, created_at, updated_at) FROM stdin;
\.


--
-- Name: keywords_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('keywords_id_seq', 483385, false);


--
-- Data for Name: leads; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY leads (id, firstname, lastname, email, phone, title, company, employees, city, state, account_id, created_at, updated_at, industry) FROM stdin;
\.


--
-- Name: leads_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('leads_id_seq', 15016, false);


--
-- Data for Name: locations; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY locations (id, account_id, name, num, city, state, zip, country, created_at, updated_at, district_id, open_zipcode, street, phone, external_ats_url, assessments_integration_dept, background_check_account, background_check_username, wotc_location_id, payroll_company_code, name_trl_key) FROM stdin;
\.


--
-- Name: locations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('locations_id_seq', 489126, false);


--
-- Data for Name: manage_tokens; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY manage_tokens (id, user_id, token, created_at, updated_at) FROM stdin;
\.


--
-- Name: manage_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('manage_tokens_id_seq', 517254, false);


--
-- Data for Name: message_templates; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY message_templates (id, name, subject, body, account_id, created_at, updated_at, action_event, parent_message_id, enabled, "primary", invite, location, include_signature, invite_schedule, template_type) FROM stdin;
\.


--
-- Name: message_templates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('message_templates_id_seq', 499007, false);


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY notifications (id, name, message, test, expires_at, single, interrupt, action, controller, created_at, updated_at, interrupt_once) FROM stdin;
\.


--
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('notifications_id_seq', 330026, false);


--
-- Data for Name: nps_responses; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY nps_responses (id, account_id, score, comment, created_at, updated_at, user_id) FROM stdin;
\.


--
-- Name: nps_responses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('nps_responses_id_seq', 480382, false);


--
-- Data for Name: oauth_access_grants; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY oauth_access_grants (id, resource_owner_id, application_id, token, expires_in, redirect_uri, created_at, revoked_at, scopes) FROM stdin;
\.


--
-- Name: oauth_access_grants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('oauth_access_grants_id_seq', 534028, false);


--
-- Data for Name: oauth_access_tokens; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY oauth_access_tokens (id, resource_owner_id, application_id, token, refresh_token, expires_in, revoked_at, created_at, scopes) FROM stdin;
\.


--
-- Name: oauth_access_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('oauth_access_tokens_id_seq', 531033, false);


--
-- Data for Name: oauth_applications; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY oauth_applications (id, name, uid, secret, redirect_uri, created_at, updated_at, scopes, account_id) FROM stdin;
\.


--
-- Name: oauth_applications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('oauth_applications_id_seq', 480003, false);


--
-- Data for Name: offer_letter_templates; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY offer_letter_templates (id, name, account_id, content, expire_days, notify_data, created_at, updated_at, manager_id) FROM stdin;
\.


--
-- Name: offer_letter_templates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('offer_letter_templates_id_seq', 480156, false);


--
-- Data for Name: offer_letter_updates; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY offer_letter_updates (id, offer_letter_id, update_type, comments, user_id, created_at, updated_at) FROM stdin;
\.


--
-- Name: offer_letter_updates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('offer_letter_updates_id_seq', 493698, false);


--
-- Data for Name: offer_letters; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY offer_letters (id, owner_id, app_id, offer_letter_template_id, content, expires_at, status, created_at, updated_at, manager_id, expiration_reminder_sent_at, pay_type, pay_rate, hire_date, app_update_hire_date) FROM stdin;
\.


--
-- Name: offer_letters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('offer_letters_id_seq', 483766, false);


--
-- Data for Name: organizational_units; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY organizational_units (id, account_id, name, type, parent_id, created_at, updated_at, payroll_company_code, name_trl_key) FROM stdin;
\.


--
-- Name: organizational_units_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('organizational_units_id_seq', 480692, false);


--
-- Data for Name: overview_builders; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY overview_builders (id, name, overview_builder_option_id, template, enabled, created_at, updated_at, teaser) FROM stdin;
\.


--
-- Name: overview_builders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('overview_builders_id_seq', 2, false);


--
-- Data for Name: pages; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY pages (id, name, page_type, body, style, created_at, updated_at) FROM stdin;
\.


--
-- Name: pages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('pages_id_seq', 180221, false);


--
-- Data for Name: payment_transactions; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY payment_transactions (id, account_id, amount, success, reference, message, action, params, test, created_at, updated_at, discount, invoice_num, refund_transaction_id, payment_number) FROM stdin;
\.


--
-- Name: payment_transactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('payment_transactions_id_seq', 552374, false);


--
-- Data for Name: perks; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY perks (id, owner_id, owner_type, "position", icon, headline, description, created_at, updated_at, headline_trl_key, description_trl_key) FROM stdin;
\.


--
-- Name: perks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('perks_id_seq', 1, false);


--
-- Data for Name: phone_number_owners; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY phone_number_owners (id, user_phone_number_id, owner_id, owner_type, enabled) FROM stdin;
\.


--
-- Name: phone_number_owners_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('phone_number_owners_id_seq', 1, false);


--
-- Data for Name: pipeline_steps; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY pipeline_steps (id, name, "position", created_at, updated_at, account_id) FROM stdin;
\.


--
-- Name: pipeline_steps_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('pipeline_steps_id_seq', 480012, false);


--
-- Data for Name: plan_cycles; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY plan_cycles (id, plan_id, billing_cycle, amount, created_at, updated_at, upsell) FROM stdin;
\.


--
-- Name: plan_cycles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('plan_cycles_id_seq', 3, true);


--
-- Data for Name: plan_upgrades; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY plan_upgrades (id, from_id, to_id) FROM stdin;
\.


--
-- Name: plan_upgrades_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('plan_upgrades_id_seq', 330026, false);


--
-- Data for Name: planned_follow_ups; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY planned_follow_ups (id, account_event_id, log_type, log_type_name, due_at_days, created_at, updated_at) FROM stdin;
\.


--
-- Name: planned_follow_ups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('planned_follow_ups_id_seq', 2, false);


--
-- Data for Name: plans; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY plans (id, name, account_type_id, active_jobs, billing_cycle, amount, description, created_at, updated_at, trial_days, hidden, fallback_plan_id, active_locations, cancel_notice, trial_account_manager_id, job_cost, location_cost, key, sales_exec_id, success_plan_id, account_manager_id, referral_amount, permissions, teaser, trial_ends_at, display_name, add_on_teaser) FROM stdin;
\.


--
-- Name: plans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('plans_id_seq', 330495, true);


--
-- Data for Name: product_cycles; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY product_cycles (id, product_id, billing_cycle, created_at, updated_at) FROM stdin;
\.


--
-- Name: product_cycles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('product_cycles_id_seq', 1, false);


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY products (id, key, name, price, created_at, updated_at, permissions, short_teaser, long_teaser, cancel_notice, feature_tags) FROM stdin;
\.


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('products_id_seq', 15004, false);


--
-- Data for Name: products_plans; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY products_plans (product_id, plan_id) FROM stdin;
\.


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY profiles (id, applicant_id, user_id, created_at, updated_at, status) FROM stdin;
\.


--
-- Name: profiles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('profiles_id_seq', 489014, false);


--
-- Data for Name: purchases; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY purchases (id, account_id, product_id, payment_transaction_id, created_at, updated_at, active_feature) FROM stdin;
\.


--
-- Name: purchases_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('purchases_id_seq', 480191, false);


--
-- Data for Name: question_set_owners; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY question_set_owners (id, question_set_id, owner_id, owner_type, created_at, updated_at) FROM stdin;
\.


--
-- Name: question_set_owners_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('question_set_owners_id_seq', 503881, false);


--
-- Data for Name: questionnaires; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY questionnaires (id, name, account_id, created_at, updated_at, type, timeout, notes, hide_answers, add_comments, frequency, due_at, send_at, include_goals, timed_notes, style, non_dual, show_chart, outdated, library, choose_categories, description, additional_info, data) FROM stdin;
\.


--
-- Name: questionnaires_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('questionnaires_id_seq', 521189, false);


--
-- Data for Name: questions; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY questions (id, name, weight, question_type, created_at, updated_at, question_set_id, "position", required, applicant_field_type, assessment_category_id, hint, include_in_default, is_goal, selected, system_question, frequency, show_previous_manager_response, show_previous_employee_response, previous_response_above, show_previous_response_in_questionnaire, show_previous_response_in_report, parent_id, options, prefill, section_id, name_trl_key) FROM stdin;
\.


--
-- Name: questions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('questions_id_seq', 1380802, false);


--
-- Data for Name: rating_scores; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY rating_scores (id, rating_id, competency_id, score, created_at, updated_at) FROM stdin;
\.


--
-- Name: rating_scores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('rating_scores_id_seq', 548194, false);


--
-- Data for Name: rating_templates; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY rating_templates (id, name, account_id, created_at, updated_at) FROM stdin;
\.


--
-- Name: rating_templates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('rating_templates_id_seq', 480109, false);


--
-- Data for Name: ratings; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY ratings (id, app_id, user_id, score, created_at, updated_at, user_name, workflow_category_id) FROM stdin;
\.


--
-- Name: ratings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('ratings_id_seq', 503678, false);


--
-- Data for Name: recent_activity; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY recent_activity (id, app_id, activity, payload, created_at, updated_at) FROM stdin;
\.


--
-- Name: recent_activity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('recent_activity_id_seq', 1, false);


--
-- Data for Name: referral_credits; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY referral_credits (id, account_id, referee_id, amount, created_at, updated_at, applied_at) FROM stdin;
\.


--
-- Name: referral_credits_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('referral_credits_id_seq', 480070, false);


--
-- Data for Name: referral_short_urls; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY referral_short_urls (id, account_id, coupon_id, created_at, updated_at) FROM stdin;
\.


--
-- Name: referral_short_urls_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('referral_short_urls_id_seq', 486680, false);


--
-- Data for Name: reject_reason_sets; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY reject_reason_sets (id, name, account_id, created_at, updated_at) FROM stdin;
\.


--
-- Name: reject_reason_sets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('reject_reason_sets_id_seq', 480006, false);


--
-- Data for Name: reject_reasons; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY reject_reasons (id, reject_reason_set_id, "position", description, created_at, updated_at) FROM stdin;
\.


--
-- Name: reject_reasons_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('reject_reasons_id_seq', 481106, false);


--
-- Data for Name: reports; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY reports (id, name, email, days, params, created_at, updated_at, user_id) FROM stdin;
\.


--
-- Name: reports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('reports_id_seq', 481782, false);


--
-- Data for Name: resume_requests; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY resume_requests (id, account_id, form_data, zip, status, priority, completed_at, resume_count, created_at, updated_at, paid) FROM stdin;
\.


--
-- Name: resume_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('resume_requests_id_seq', 491386, false);


--
-- Data for Name: schedule_owner_proxies; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY schedule_owner_proxies (id, name, proxy_type, created_at, updated_at) FROM stdin;
\.


--
-- Name: schedule_owner_proxies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('schedule_owner_proxies_id_seq', 1, false);


--
-- Data for Name: scheduled_app_updates; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY scheduled_app_updates (id, app_id, update_type, created_at, updated_at) FROM stdin;
\.


--
-- Name: scheduled_app_updates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('scheduled_app_updates_id_seq', 1, false);


--
-- Data for Name: scheduled_notifications; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY scheduled_notifications (id, account_id, action_event, send_at, created_at, updated_at) FROM stdin;
\.


--
-- Name: scheduled_notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('scheduled_notifications_id_seq', 513177, false);


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY schema_migrations (version) FROM stdin;
20110710150146
20110624181411
20110616212129
20110616212041
20110616214447
20110609200239
20110609194439
20110616212343
20110616222217
20110616203345
20110616212449
20110626212426
20110616212747
20110616212151
20110609200221
20110616212407
20110707212719
20110618190633
20110617205823
20110707212852
20110707163407
20110626175551
20110616212434
20110713201606
20110715021302
20110715144837
20110715165938
20110715202308
20110719154750
20110720170113
20110722165458
20110726152128
20110726170806
20110727165107
20110804145858
20110818205826
20110818211405
20110819192433
20110822153346
20110822190536
20110824195611
20110826160517
20110826194812
20110826195044
20110829214815
20110830165336
20110830173705
20110831210336
20110901160702
20110906204525
20110906230615
20110907163647
20110907190827
20110908024615
20110908035206
20110914203106
20110915034829
20111006172126
20111018184211
20111021154506
20111101163449
20111102192606
20111106173104
20111103181301
20111103184710
20111107210612
20111114030858
20111201162112
20111205192211
20111212184925
20111215185444
20111216152535
20111228175621
20111228190025
20111229210808
20120103210517
20120103220707
20120106172812
20120109182842
20120110162804
20120110164326
20120110222435
20120216170233
20120221214524
20120221233426
20120222005641
20120222145644
20120222174913
20120227220558
20120228192347
20120229172722
20120229182919
20120125032021
20120306163425
20120306233057
20120307210709
20120323164909
20120327195547
20120329211148
20120330015258
20120409204944
20120413155642
20120413144224
20120419165113
20120420205455
20120426154430
20120502204919
20120511225703
20120523194808
20120523201339
20120524153953
20120530163028
20120531164346
20120606175601
20120606192405
20120608200910
20120610212735
20120611141314
20120611182125
20120617202725
20120626185811
20120627204315
20120629151043
20120702203406
20120703150925
20120710145915
20120710231816
20120711182736
20120728215847
20120729233605
20120731235840
20120813191747
20120905194808
20120907152043
20120912154701
20120912220938
20120926191009
20120926214210
20121003160409
20121004222745
20121019153547
20121019160025
20121026194117
20121026211809
20121031155204
20121101180937
20121112190811
20121115165616
20121126170230
20121130155856
20121207173234
20121219175744
20121219205224
20121222180354
20121227191412
20130104005143
20130104172205
20130105193821
20130123164347
20121211174627
20130319151138
20130326191018
20130327151531
20130328231335
20130404165650
20130408191046
20130408194427
20130409170534
20130416203234
20130424205836
20130501202214
20130503002724
20130503030605
20130507214950
20130513165204
20130516190334
20130517173825
20130520203230
20130522002914
20130522182306
20130523162911
20130524151402
20130529175242
20130613171239
20130614153557
20130718175657
20130718194915
20130719191731
20130725191450
20130820233248
20130903154642
20130906150848
20130909192408
20130918191150
20130923213602
20130924194722
20130925153940
20130926193718
20130927234804
20131004145159
20131007142826
20131002153704
20131004153657
20131009214323
20131010183525
20131014235553
20131015143005
20131015183411
20131016170540
20131016171054
20131016202046
20131018144906
20131030161442
20131031163926
20131105154002
20131105160349
20131105210540
20131106160746
20131106205759
20131107225318
20131113230404
20131115155734
20131115210153
20131118174534
20131119180346
20131111202547
20131122193307
20131125193003
20131125213919
20131126201603
20131127164358
20131202212455
20131205161209
20131203175634
20131203181645
20131216220438
20131231002152
20140103185912
20140106202809
20140108184638
20140120214751
20140121160155
20140120200544
20140210204956
20140211193644
20140211210906
20140212175048
20140317192527
20140304210825
20140320165844
20140320211627
20140321163334
20140402211657
20140409200147
20140411143511
20140417220344
20140421164425
20140422172604
20140423180139
20140423162638
20140428183605
20140429162657
20140430200406
20140507172530
20140514212848
20140513195358
20140513201528
20140513202714
20140516160510
20140520231141
20140521145827
20140512172959
20140528170718
20140528202021
20140529205413
20140603151806
20140611161148
20140613205551
20140616152305
20140616180123
20140617151215
20140617160748
20140617165735
20140618203437
20140619201038
20140623153205
20140701182930
20140701185525
20140701213225
20140530201201
20140707211514
20140729025735
20140729150026
20140812192259
20140730152854
20140801195534
20140825153106
20140904150044
20140909134701
20140915205022
20140917201355
20140919162343
20140922145847
20140930162500
20141001154759
20141002203301
20141008224011
20141009181911
20141008182433
20141013162122
20141013160438
20141023161043
20141031201552
20141112222123
20141112162818
20141112213436
20141113230424
20141117215629
20141203161022
20141202214540
20141202231748
20141203052127
20141206155243
20141206160108
20141207050512
20141208163713
20141211025942
20141211051928
20150115155558
20150224202610
20150219195117
20150220192148
20150303041550
20150305050424
20150310160206
20150320001923
20150403144231
20150403193504
20150406201714
20150414165058
20150414214909
20150427151221
20150428160056
20150427214801
20150504144634
20150507193806
20150519150620
20150519150621
20150519150622
20150519151125
20150519151922
20150519183950
20150528160738
20150528201638
20150601205401
20150529193753
20150602201752
20150606160539
20150623194338
20150706173505
20150714184002
20150714184210
20150708212229
20150708220948
20150708222812
20150708223012
20150713202008
20150715145044
20150716202649
20150717162905
20150608151228
20150608151356
20150615172715
20150618132914
20150618151944
20150721162732
20150727174043
20150730183830
20150803210216
20150818204315
20150831152723
20150831201713
20150826194309
20150828163402
20150901191238
20150902145952
20150903132436
20150904155604
20150908180507
20150909052326
20150917190314
20150924181802
20150925163329
20150925192609
20150925195217
20150928151135
20150928162757
20150928173916
20150928190453
20151003152410
20151003190143
20151014152635
20151014161059
20151015160926
20151015192022
20151016194455
20151026192820
20151028153840
20151112154501
20151103214326
20151103224135
20151104205917
20151111211751
20151113165259
20151130182829
20151210201558
20151211222554
20160111204929
20160125214524
20160128171808
20160129032212
20160201204452
20160202211726
20160211230830
20160223195829
20160223202545
20160122153416
20160122161213
20160126210921
20160126214649
20160126214706
20160126214921
20160126220111
20160202200306
20160202212210
20160302175531
20160302181306
20160309002540
20160321165321
20160224164540
20160226191250
20160310191002
20160325103727
20160325171403
20160328165340
20160321193604
20160328172926
20160328190400
20160401154910
20160323224313
20160323230015
20160310221820
20160310223651
20160316201455
20160316223828
20160316224137
20160316224300
20160316231020
20160317014700
20160329224245
20160329225249
20160329225509
20160329230619
20160401172712
20160404031633
20160404031827
20160404031956
20160406144927
20160413171713
20160414160230
20160412140620
20160418213338
20160419193325
20160419201426
20160419173243
20160503003324
20160513222508
20160516154358
20160520192954
20160524145522
20160527202809
20160601200140
20160603190007
20160512202502
20160517230809
20160518192113
20160524225819
20160608192307
20160609195642
20160609213611
20160616221132
20160608180024
20160608202011
20160624210250
20160720174806
20160715185212
20160719160248
20160719164246
20160719220016
20160726151551
20160729185357
20160801184002
20160804140917
20160815194016
20160809215323
20160820013302
20160919173801
20160928205119
20161004201346
20160818170508
20161006184951
20161006215556
20161010210424
20161011181315
20161014160601
20161102211527
20161028002633
20161130160605
20161117215934
20161117232434
20161118004103
20161118201821
20161118205528
20161118223539
20161119005325
20161119035325
20161121183406
20161122171328
20161128205810
20161129222751
20161130205736
20161208215030
20161219202729
20161219214500
20161219215200
20170103170710
20170106164550
20170119214630
20170131202534
20170203005615
20170224164232
20170301181410
20161208231638
20170329212036
20170417213032
20170418211037
20170421172026
20170424200446
20170502170713
20170526201814
20170531224900
20170602190902
20170531145957
20170531155831
20170601190518
20170623180718
20170706162916
20170710175721
20170626210923
20170713152037
20170714162016
20170719181822
20170721193012
20170811181421
20170814164250
20170814201420
20170818203351
20170828151831
20170907161104
20170908193626
20170913203122
20170905202052
20170915020731
20170915153348
20170725172337
20170725204113
20170725225817
20170824190420
20170824200356
20170824230526
20170825165220
20170825170814
20170828173154
20170911172153
20170913014906
20170913195612
20170913224455
20170914183936
20170915212348
20170919162102
20170920052325
20170921164651
20170925214603
20171002182547
20171010195621
20171018033352
20171018195345
20171018154505
20171114192804
20171116202253
20171116232559
20171122175717
20171108193135
20171129184756
20171127174234
20171130153609
20171127180639
20171109170657
20171120155028
20171130175249
20171204215631
20171204215616
20171206171505
20171206213821
20171212214351
20171215024423
20171213223313
20171218212754
20171219195852
20171220161551
20171220180720
20171220212407
20180106221611
20180112214534
20180116225302
20180117165437
20180123155516
20180124201700
20180129213255
20180124193517
20180105192918
20180103160825
20180215153512
20180216173547
20180219195853
20180220231804
20180223205835
20180226161845
20180209202038
20180301183200
20180302201439
20180305222638
20180308211141
20180129181833
20180129182832
20180129224828
20180130155522
20180130184717
20180130215653
20180201220141
20180201221638
20180209194042
20180209194256
20180212210212
20180313141400
20180320142442
20180320163331
20180406160153
20180411151911
20180412202334
20180416141503
20180416172248
20180417144917
20180419204928
20180425192810
20180430151211
20180430182636
20180502151252
20180502172749
20180503160502
20180508033559
20180510173554
20180517182704
20180518211934
20180525134957
20180530194235
20180531192104
20180531192336
20180601152102
20180617233327
20180625151222
20180706152720
20180725152230
20180726201411
20180803172644
20180808184941
20180812205947
20180703161223
\.


--
-- Data for Name: scoring_set_invites; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY scoring_set_invites (id, app_id, question_set_id, scoring_set_id, scheduled_at, manager, created_at, updated_at, notified_at, overdue_notified_at) FROM stdin;
\.


--
-- Name: scoring_set_invites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('scoring_set_invites_id_seq', 808016, false);


--
-- Data for Name: scoring_set_items; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY scoring_set_items (id, scoring_set_id, question_type, question_name, question_id, answer_text, answer_id, weight, "position", score, max_score, result) FROM stdin;
\.


--
-- Name: scoring_set_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('scoring_set_items_id_seq', 206573976, false);


--
-- Data for Name: scoring_sets; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY scoring_sets (id, name, user_id, owner_id, created_at, updated_at, score, question_set_type, complete, question_set_id, workflow_category_id, owner_type, user_name, max_score, result, account_id, cloned) FROM stdin;
\.


--
-- Name: scoring_sets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('scoring_sets_id_seq', 9695097, false);


--
-- Data for Name: search_logs; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY search_logs (id, app_id, indexed_at, verified_at, attempts) FROM stdin;
\.


--
-- Name: search_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('search_logs_id_seq', 1, false);


--
-- Data for Name: sections; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY sections (id, scorecard_id, name, "position", created_at, updated_at) FROM stdin;
\.


--
-- Name: sections_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('sections_id_seq', 1, false);


--
-- Data for Name: settings; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY settings (id, var, value, thing_id, thing_type, created_at, updated_at) FROM stdin;
\.


--
-- Name: settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('settings_id_seq', 5153151, true);


--
-- Data for Name: sf_codes; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY sf_codes (id, zip, sf_code, created_at, updated_at, territory_name) FROM stdin;
\.


--
-- Name: sf_codes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('sf_codes_id_seq', 83798, false);


--
-- Data for Name: short_urls; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY short_urls (id, job_id, source_id, created_at, updated_at, expired) FROM stdin;
\.


--
-- Name: short_urls_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('short_urls_id_seq', 5990993, false);


--
-- Data for Name: signatures; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY signatures (id, signature, signed_by, ip, signer_id, signer_type, document_id, document_type, question_id, uid, created_at, updated_at) FROM stdin;
\.


--
-- Name: signatures_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('signatures_id_seq', 590755, false);


--
-- Data for Name: site_templates; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY site_templates (id, name, style, created_at, updated_at, body, index_page_id, job_page_id, apply_page_id, thanks_page_id, account_page_id, customizable, embeddable, edit_page_id, version) FROM stdin;
\.


--
-- Name: site_templates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('site_templates_id_seq', 180148, false);


--
-- Data for Name: sms_messages; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY sms_messages (id, message_id, "from", "to", direction, state, content, sent_at, delivery_state, delivery_description, delivery_code, tag, created_at, updated_at) FROM stdin;
\.


--
-- Name: sms_messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('sms_messages_id_seq', 1, false);


--
-- Data for Name: sms_receipts; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY sms_receipts (id, sms_message_id, state, delivery_state, delivery_description, delivery_code, payload, created_at, updated_at) FROM stdin;
\.


--
-- Name: sms_receipts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('sms_receipts_id_seq', 1, false);


--
-- Data for Name: sms_thread_responses; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY sms_thread_responses (id, sms_thread_id, sms_message_id, read_at, archived, created_at, updated_at) FROM stdin;
\.


--
-- Name: sms_thread_responses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('sms_thread_responses_id_seq', 1, false);


--
-- Data for Name: sms_threads; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY sms_threads (id, account_id, user_id, active, thread_id, created_at, updated_at, application_phone_number_id, user_phone_number_id, archived) FROM stdin;
\.


--
-- Name: sms_threads_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('sms_threads_id_seq', 1, false);


--
-- Data for Name: sources; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY sources (id, name, account_id, created_at, updated_at, job_instructions, source_type, popup, renderer) FROM stdin;
\.


--
-- Name: sources_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('sources_id_seq', 484460, false);


--
-- Data for Name: success_notes; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY success_notes (id, note, success_plan_id, user_id, created_at, updated_at, parent_id) FROM stdin;
\.


--
-- Name: success_notes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('success_notes_id_seq', 15150, false);


--
-- Data for Name: success_plans; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY success_plans (id, name, account_id, goals, created_at, updated_at) FROM stdin;
\.


--
-- Name: success_plans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('success_plans_id_seq', 480370, false);


--
-- Data for Name: success_tasks; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY success_tasks (id, name, success_plan_id, due_at, completed_at, created_at, updated_at, due_days, details) FROM stdin;
\.


--
-- Name: success_tasks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('success_tasks_id_seq', 484157, false);


--
-- Data for Name: suggestion_comments; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY suggestion_comments (id, suggestion_id, comment, created_at, updated_at, user_name) FROM stdin;
\.


--
-- Name: suggestion_comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('suggestion_comments_id_seq', 211, false);


--
-- Data for Name: suggestions; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY suggestions (id, summary, description, suggested_by_name, suggestion_type, user_id, account_id, created_at, updated_at, submitted_by, status) FROM stdin;
\.


--
-- Name: suggestions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('suggestions_id_seq', 480335, false);


--
-- Data for Name: teams; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY teams (id, name, account_id, created_at, updated_at) FROM stdin;
\.


--
-- Name: teams_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('teams_id_seq', 485049, false);


--
-- Data for Name: testimonials; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY testimonials (id, owner_id, owner_type, "position", testimonial, name, location, title, avatar, created_at, updated_at, testimonial_trl_key, title_trl_key) FROM stdin;
\.


--
-- Name: testimonials_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('testimonials_id_seq', 1, false);


--
-- Data for Name: tiered_prices; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY tiered_prices (id, product_cycle_id, min_count, amount, created_at, updated_at) FROM stdin;
\.


--
-- Name: tiered_prices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('tiered_prices_id_seq', 1, false);


--
-- Data for Name: tiny_prints; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY tiny_prints (id, image_file_name, image_content_type, account_id, created_at, updated_at, image_file_size) FROM stdin;
\.


--
-- Name: tiny_prints_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('tiny_prints_id_seq', 480238, false);


--
-- Data for Name: tiny_videos; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY tiny_videos (id, original_file_name, original_content_type, account_id, created_at, updated_at, original_file_size) FROM stdin;
\.


--
-- Name: tiny_videos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('tiny_videos_id_seq', 2, false);


--
-- Data for Name: tours_completions; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY tours_completions (id, user_id, name, created_at, updated_at) FROM stdin;
\.


--
-- Name: tours_completions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('tours_completions_id_seq', 514660, false);


--
-- Data for Name: upvotes; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY upvotes (id, votes, user_id, suggestion_id, created_at, updated_at) FROM stdin;
\.


--
-- Name: upvotes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('upvotes_id_seq', 61, false);


--
-- Data for Name: user_phone_numbers; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY user_phone_numbers (id, number, enabled, created_at, updated_at) FROM stdin;
\.


--
-- Name: user_phone_numbers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('user_phone_numbers_id_seq', 3, true);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY users (id, email, encrypted_password, reset_password_token, reset_password_sent_at, remember_created_at, sign_in_count, current_sign_in_at, last_sign_in_at, current_sign_in_ip, last_sign_in_ip, created_at, updated_at, account_id, firstname, lastname, description, photo_file_name, photo_content_type, photo_file_size, photo_updated_at, title, phone, role, default_job_permission_id, account_match, sent_welcome_at, failed_attempts, unlock_token, locked_at, bounced_at, hris_employee_id, from_name_override, reply_to_override, email_copy_default, selected_timezone, background_integration_allowed, authentication_token, default_apps_filter, external_schedule_url, email_signature, nps, primary_owner, user_phone_number_id, password_last_reset_at, disabled_at, cant_super_impersonate, activate_token, last_seen_at, session_data) FROM stdin;
\.


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('users_id_seq', 588804, true);


--
-- Data for Name: uses_app_forms; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY uses_app_forms (id, app_form_id, owner_id, owner_type) FROM stdin;
\.


--
-- Name: uses_app_forms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('uses_app_forms_id_seq', 551867, false);


--
-- Data for Name: uses_assessment_categories; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY uses_assessment_categories (id, assessment_category_id, owner_id, owner_type) FROM stdin;
\.


--
-- Name: uses_assessment_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('uses_assessment_categories_id_seq', 1586206, false);


--
-- Data for Name: uses_competencies; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY uses_competencies (id, competency_id, owner_id, owner_type, "position", created_at, updated_at) FROM stdin;
\.


--
-- Name: uses_competencies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('uses_competencies_id_seq', 815511, false);


--
-- Data for Name: workflow_categories; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY workflow_categories (id, name, created_at, updated_at, hiring_step, pipeline_step_id, has_assessments, description, scorecard_name, system_category, interview_step, locked_to_admin_users) FROM stdin;
\.


--
-- Name: workflow_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('workflow_categories_id_seq', 481676, true);


--
-- Data for Name: workflow_category_holders; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY workflow_category_holders (id, workflow_id, workflow_category_id, "position", created_at, updated_at) FROM stdin;
\.


--
-- Name: workflow_category_holders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('workflow_category_holders_id_seq', 485580, true);


--
-- Data for Name: workflow_steps; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY workflow_steps (id, name, "position", created_at, updated_at, workflow_category_id, next_status, message_template_id, message_template_type, message_action_future, message_action_past) FROM stdin;
\.


--
-- Name: workflow_steps_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('workflow_steps_id_seq', 490518, false);


--
-- Data for Name: workflows; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY workflows (id, name, account_id, created_at, updated_at, offer_category_id, background_category_id) FROM stdin;
\.


--
-- Name: workflows_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('workflows_id_seq', 480890, true);


--
-- Data for Name: zipcodes; Type: TABLE DATA; Schema: public; Owner: canaandavis
--

COPY zipcodes (id, zip, state, name, latitude, longitude) FROM stdin;
\.


--
-- Name: zipcodes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: canaandavis
--

SELECT pg_catalog.setval('zipcodes_id_seq', 82010, false);


--
-- Name: account_events account_events_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY account_events
    ADD CONSTRAINT account_events_pkey PRIMARY KEY (id);


--
-- Name: account_health_grade_changes account_health_grade_changes_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY account_health_grade_changes
    ADD CONSTRAINT account_health_grade_changes_pkey PRIMARY KEY (id);


--
-- Name: account_logs account_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY account_logs
    ADD CONSTRAINT account_logs_pkey PRIMARY KEY (id);


--
-- Name: account_status_changes account_status_changes_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY account_status_changes
    ADD CONSTRAINT account_status_changes_pkey PRIMARY KEY (id);


--
-- Name: account_type_employments account_type_employments_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY account_type_employments
    ADD CONSTRAINT account_type_employments_pkey PRIMARY KEY (id);


--
-- Name: account_types account_types_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY account_types
    ADD CONSTRAINT account_types_pkey PRIMARY KEY (id);


--
-- Name: has_account_types account_types_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY has_account_types
    ADD CONSTRAINT account_types_sources_pkey PRIMARY KEY (id);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: agent_aliases agent_aliases_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY agent_aliases
    ADD CONSTRAINT agent_aliases_pkey PRIMARY KEY (id);


--
-- Name: answers answers_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY answers
    ADD CONSTRAINT answers_pkey PRIMARY KEY (id);


--
-- Name: api_credentials api_credentials_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY api_credentials
    ADD CONSTRAINT api_credentials_pkey PRIMARY KEY (id);


--
-- Name: app_accesses app_accesses_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY app_accesses
    ADD CONSTRAINT app_accesses_pkey PRIMARY KEY (id);


--
-- Name: answer_sets app_answers_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY answer_sets
    ADD CONSTRAINT app_answers_pkey PRIMARY KEY (id);


--
-- Name: has_attachments app_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY has_attachments
    ADD CONSTRAINT app_attachments_pkey PRIMARY KEY (id);


--
-- Name: app_forms app_forms_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY app_forms
    ADD CONSTRAINT app_forms_pkey PRIMARY KEY (id);


--
-- Name: app_updates app_updates_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY app_updates
    ADD CONSTRAINT app_updates_pkey PRIMARY KEY (id);


--
-- Name: applicants applicants_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY applicants
    ADD CONSTRAINT applicants_pkey PRIMARY KEY (id);


--
-- Name: application_alerts application_alerts_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY application_alerts
    ADD CONSTRAINT application_alerts_pkey PRIMARY KEY (id);


--
-- Name: application_phone_numbers application_phone_numbers_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY application_phone_numbers
    ADD CONSTRAINT application_phone_numbers_pkey PRIMARY KEY (id);


--
-- Name: appointment_updates appointment_updates_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY appointment_updates
    ADD CONSTRAINT appointment_updates_pkey PRIMARY KEY (id);


--
-- Name: appointments appointments_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY appointments
    ADD CONSTRAINT appointments_pkey PRIMARY KEY (id);


--
-- Name: apps apps_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY apps
    ADD CONSTRAINT apps_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: assessment_categories assessment_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY assessment_categories
    ADD CONSTRAINT assessment_categories_pkey PRIMARY KEY (id);


--
-- Name: assessment_scores assessment_scores_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY assessment_scores
    ADD CONSTRAINT assessment_scores_pkey PRIMARY KEY (id);


--
-- Name: assessments assessments_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY assessments
    ADD CONSTRAINT assessments_pkey PRIMARY KEY (id);


--
-- Name: auth_results auth_results_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY auth_results
    ADD CONSTRAINT auth_results_pkey PRIMARY KEY (id);


--
-- Name: benchmark_scores benchmark_scores_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY benchmark_scores
    ADD CONSTRAINT benchmark_scores_pkey PRIMARY KEY (id);


--
-- Name: brands brands_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY brands
    ADD CONSTRAINT brands_pkey PRIMARY KEY (id);


--
-- Name: bug_report_comments bug_report_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY bug_report_comments
    ADD CONSTRAINT bug_report_comments_pkey PRIMARY KEY (id);


--
-- Name: bug_reports bug_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY bug_reports
    ADD CONSTRAINT bug_reports_pkey PRIMARY KEY (id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: cohorts cohorts_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY cohorts
    ADD CONSTRAINT cohorts_pkey PRIMARY KEY (id);


--
-- Name: company_photos company_photos_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY company_photos
    ADD CONSTRAINT company_photos_pkey PRIMARY KEY (id);


--
-- Name: competencies competencies_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY competencies
    ADD CONSTRAINT competencies_pkey PRIMARY KEY (id);


--
-- Name: completed_forms completed_forms_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY completed_forms
    ADD CONSTRAINT completed_forms_pkey PRIMARY KEY (id);


--
-- Name: coupon_appointments coupon_appointments_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY coupon_appointments
    ADD CONSTRAINT coupon_appointments_pkey PRIMARY KEY (id);


--
-- Name: coupons coupons_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY coupons
    ADD CONSTRAINT coupons_pkey PRIMARY KEY (id);


--
-- Name: domains domains_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY domains
    ADD CONSTRAINT domains_pkey PRIMARY KEY (id);


--
-- Name: email_recipients email_recipients_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY email_recipients
    ADD CONSTRAINT email_recipients_pkey PRIMARY KEY (id);


--
-- Name: email_threads email_threads_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY email_threads
    ADD CONSTRAINT email_threads_pkey PRIMARY KEY (id);


--
-- Name: emails emails_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY emails
    ADD CONSTRAINT emails_pkey PRIMARY KEY (id);


--
-- Name: employments employments_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY employments
    ADD CONSTRAINT employments_pkey PRIMARY KEY (id);


--
-- Name: external_site_links external_site_links_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY external_site_links
    ADD CONSTRAINT external_site_links_pkey PRIMARY KEY (id);


--
-- Name: fast_track_answers fast_track_answers_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY fast_track_answers
    ADD CONSTRAINT fast_track_answers_pkey PRIMARY KEY (id);


--
-- Name: has_apps has_apps_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY has_apps
    ADD CONSTRAINT has_apps_pkey PRIMARY KEY (id);


--
-- Name: has_industries has_industries_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY has_industries
    ADD CONSTRAINT has_industries_pkey PRIMARY KEY (id);


--
-- Name: has_message_templates has_message_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY has_message_templates
    ADD CONSTRAINT has_message_templates_pkey PRIMARY KEY (id);


--
-- Name: has_support_team_members has_support_team_members_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY has_support_team_members
    ADD CONSTRAINT has_support_team_members_pkey PRIMARY KEY (id);


--
-- Name: has_users has_users_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY has_users
    ADD CONSTRAINT has_users_pkey PRIMARY KEY (id);


--
-- Name: health_components health_components_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY health_components
    ADD CONSTRAINT health_components_pkey PRIMARY KEY (id);


--
-- Name: health_grade_keys health_grade_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY health_grade_keys
    ADD CONSTRAINT health_grade_keys_pkey PRIMARY KEY (id);


--
-- Name: health_key_items health_key_items_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY health_key_items
    ADD CONSTRAINT health_key_items_pkey PRIMARY KEY (id);


--
-- Name: hiring_status_sorting hiring_status_sorting_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY hiring_status_sorting
    ADD CONSTRAINT hiring_status_sorting_pkey PRIMARY KEY (id);


--
-- Name: in_workflow_categories in_workflow_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY in_workflow_categories
    ADD CONSTRAINT in_workflow_categories_pkey PRIMARY KEY (id);


--
-- Name: in_workflow_steps in_workflow_steps_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY in_workflow_steps
    ADD CONSTRAINT in_workflow_steps_pkey PRIMARY KEY (id);


--
-- Name: industries industries_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY industries
    ADD CONSTRAINT industries_pkey PRIMARY KEY (id);


--
-- Name: invalid_emails invalid_emails_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY invalid_emails
    ADD CONSTRAINT invalid_emails_pkey PRIMARY KEY (id);


--
-- Name: job_aggregators job_aggregators_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY job_aggregators
    ADD CONSTRAINT job_aggregators_pkey PRIMARY KEY (id);


--
-- Name: job_builders job_builders_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY job_builders
    ADD CONSTRAINT job_builders_pkey PRIMARY KEY (id);


--
-- Name: job_categories job_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY job_categories
    ADD CONSTRAINT job_categories_pkey PRIMARY KEY (id);


--
-- Name: job_comments job_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY job_comments
    ADD CONSTRAINT job_comments_pkey PRIMARY KEY (id);


--
-- Name: job_permissions job_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY job_permissions
    ADD CONSTRAINT job_permissions_pkey PRIMARY KEY (id);


--
-- Name: job_views job_views_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY job_views
    ADD CONSTRAINT job_views_pkey PRIMARY KEY (id);


--
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- Name: keyword_sets keyword_sets_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY keyword_sets
    ADD CONSTRAINT keyword_sets_pkey PRIMARY KEY (id);


--
-- Name: keywords keywords_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY keywords
    ADD CONSTRAINT keywords_pkey PRIMARY KEY (id);


--
-- Name: leads leads_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY leads
    ADD CONSTRAINT leads_pkey PRIMARY KEY (id);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: manage_tokens manage_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY manage_tokens
    ADD CONSTRAINT manage_tokens_pkey PRIMARY KEY (id);


--
-- Name: message_templates message_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY message_templates
    ADD CONSTRAINT message_templates_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: nps_responses nps_responses_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY nps_responses
    ADD CONSTRAINT nps_responses_pkey PRIMARY KEY (id);


--
-- Name: oauth_access_grants oauth_access_grants_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY oauth_access_grants
    ADD CONSTRAINT oauth_access_grants_pkey PRIMARY KEY (id);


--
-- Name: oauth_access_tokens oauth_access_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY oauth_access_tokens
    ADD CONSTRAINT oauth_access_tokens_pkey PRIMARY KEY (id);


--
-- Name: oauth_applications oauth_applications_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY oauth_applications
    ADD CONSTRAINT oauth_applications_pkey PRIMARY KEY (id);


--
-- Name: offer_letter_templates offer_letter_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY offer_letter_templates
    ADD CONSTRAINT offer_letter_templates_pkey PRIMARY KEY (id);


--
-- Name: offer_letter_updates offer_letter_updates_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY offer_letter_updates
    ADD CONSTRAINT offer_letter_updates_pkey PRIMARY KEY (id);


--
-- Name: offer_letters offer_letters_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY offer_letters
    ADD CONSTRAINT offer_letters_pkey PRIMARY KEY (id);


--
-- Name: organizational_units organizational_units_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY organizational_units
    ADD CONSTRAINT organizational_units_pkey PRIMARY KEY (id);


--
-- Name: overview_builders overview_builders_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY overview_builders
    ADD CONSTRAINT overview_builders_pkey PRIMARY KEY (id);


--
-- Name: pages pages_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: payment_transactions payment_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY payment_transactions
    ADD CONSTRAINT payment_transactions_pkey PRIMARY KEY (id);


--
-- Name: perks perks_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY perks
    ADD CONSTRAINT perks_pkey PRIMARY KEY (id);


--
-- Name: phone_number_owners phone_number_owners_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY phone_number_owners
    ADD CONSTRAINT phone_number_owners_pkey PRIMARY KEY (id);


--
-- Name: pipeline_steps pipeline_steps_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY pipeline_steps
    ADD CONSTRAINT pipeline_steps_pkey PRIMARY KEY (id);


--
-- Name: plan_cycles plan_cycles_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY plan_cycles
    ADD CONSTRAINT plan_cycles_pkey PRIMARY KEY (id);


--
-- Name: plan_upgrades plan_upgrades_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY plan_upgrades
    ADD CONSTRAINT plan_upgrades_pkey PRIMARY KEY (id);


--
-- Name: planned_follow_ups planned_follow_ups_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY planned_follow_ups
    ADD CONSTRAINT planned_follow_ups_pkey PRIMARY KEY (id);


--
-- Name: plans plans_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY plans
    ADD CONSTRAINT plans_pkey PRIMARY KEY (id);


--
-- Name: product_cycles product_cycles_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY product_cycles
    ADD CONSTRAINT product_cycles_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: purchases purchases_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY purchases
    ADD CONSTRAINT purchases_pkey PRIMARY KEY (id);


--
-- Name: question_set_owners question_set_owners_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY question_set_owners
    ADD CONSTRAINT question_set_owners_pkey PRIMARY KEY (id);


--
-- Name: questionnaires questionnaires_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY questionnaires
    ADD CONSTRAINT questionnaires_pkey PRIMARY KEY (id);


--
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- Name: rating_scores rating_scores_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY rating_scores
    ADD CONSTRAINT rating_scores_pkey PRIMARY KEY (id);


--
-- Name: rating_templates rating_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY rating_templates
    ADD CONSTRAINT rating_templates_pkey PRIMARY KEY (id);


--
-- Name: ratings ratings_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY ratings
    ADD CONSTRAINT ratings_pkey PRIMARY KEY (id);


--
-- Name: recent_activity recent_activity_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY recent_activity
    ADD CONSTRAINT recent_activity_pkey PRIMARY KEY (id);


--
-- Name: referral_credits referral_credits_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY referral_credits
    ADD CONSTRAINT referral_credits_pkey PRIMARY KEY (id);


--
-- Name: referral_short_urls referral_short_urls_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY referral_short_urls
    ADD CONSTRAINT referral_short_urls_pkey PRIMARY KEY (id);


--
-- Name: reject_reason_sets reject_reason_sets_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY reject_reason_sets
    ADD CONSTRAINT reject_reason_sets_pkey PRIMARY KEY (id);


--
-- Name: reject_reasons reject_reasons_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY reject_reasons
    ADD CONSTRAINT reject_reasons_pkey PRIMARY KEY (id);


--
-- Name: reports reports_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);


--
-- Name: resume_requests resume_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY resume_requests
    ADD CONSTRAINT resume_requests_pkey PRIMARY KEY (id);


--
-- Name: has_updates resume_updates_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY has_updates
    ADD CONSTRAINT resume_updates_pkey PRIMARY KEY (id);


--
-- Name: schedule_owner_proxies schedule_owner_proxies_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY schedule_owner_proxies
    ADD CONSTRAINT schedule_owner_proxies_pkey PRIMARY KEY (id);


--
-- Name: scheduled_app_updates scheduled_app_updates_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY scheduled_app_updates
    ADD CONSTRAINT scheduled_app_updates_pkey PRIMARY KEY (id);


--
-- Name: scheduled_notifications scheduled_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY scheduled_notifications
    ADD CONSTRAINT scheduled_notifications_pkey PRIMARY KEY (id);


--
-- Name: scoring_set_invites scoring_set_invites_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY scoring_set_invites
    ADD CONSTRAINT scoring_set_invites_pkey PRIMARY KEY (id);


--
-- Name: scoring_set_items scoring_set_items_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY scoring_set_items
    ADD CONSTRAINT scoring_set_items_pkey PRIMARY KEY (id);


--
-- Name: scoring_sets scoring_sets_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY scoring_sets
    ADD CONSTRAINT scoring_sets_pkey PRIMARY KEY (id);


--
-- Name: search_logs search_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY search_logs
    ADD CONSTRAINT search_logs_pkey PRIMARY KEY (id);


--
-- Name: sections sections_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY sections
    ADD CONSTRAINT sections_pkey PRIMARY KEY (id);


--
-- Name: settings settings_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);


--
-- Name: sf_codes sf_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY sf_codes
    ADD CONSTRAINT sf_codes_pkey PRIMARY KEY (id);


--
-- Name: short_urls short_urls_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY short_urls
    ADD CONSTRAINT short_urls_pkey PRIMARY KEY (id);


--
-- Name: signatures signatures_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY signatures
    ADD CONSTRAINT signatures_pkey PRIMARY KEY (id);


--
-- Name: site_templates site_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY site_templates
    ADD CONSTRAINT site_templates_pkey PRIMARY KEY (id);


--
-- Name: sms_messages sms_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY sms_messages
    ADD CONSTRAINT sms_messages_pkey PRIMARY KEY (id);


--
-- Name: sms_receipts sms_receipts_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY sms_receipts
    ADD CONSTRAINT sms_receipts_pkey PRIMARY KEY (id);


--
-- Name: sms_thread_responses sms_thread_responses_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY sms_thread_responses
    ADD CONSTRAINT sms_thread_responses_pkey PRIMARY KEY (id);


--
-- Name: sms_threads sms_threads_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY sms_threads
    ADD CONSTRAINT sms_threads_pkey PRIMARY KEY (id);


--
-- Name: sources sources_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY sources
    ADD CONSTRAINT sources_pkey PRIMARY KEY (id);


--
-- Name: success_notes success_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY success_notes
    ADD CONSTRAINT success_notes_pkey PRIMARY KEY (id);


--
-- Name: success_plans success_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY success_plans
    ADD CONSTRAINT success_plans_pkey PRIMARY KEY (id);


--
-- Name: success_tasks success_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY success_tasks
    ADD CONSTRAINT success_tasks_pkey PRIMARY KEY (id);


--
-- Name: suggestion_comments suggestion_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY suggestion_comments
    ADD CONSTRAINT suggestion_comments_pkey PRIMARY KEY (id);


--
-- Name: suggestions suggestions_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY suggestions
    ADD CONSTRAINT suggestions_pkey PRIMARY KEY (id);


--
-- Name: teams teams_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- Name: testimonials testimonials_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY testimonials
    ADD CONSTRAINT testimonials_pkey PRIMARY KEY (id);


--
-- Name: tiered_prices tiered_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY tiered_prices
    ADD CONSTRAINT tiered_prices_pkey PRIMARY KEY (id);


--
-- Name: tiny_prints tiny_prints_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY tiny_prints
    ADD CONSTRAINT tiny_prints_pkey PRIMARY KEY (id);


--
-- Name: tiny_videos tiny_videos_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY tiny_videos
    ADD CONSTRAINT tiny_videos_pkey PRIMARY KEY (id);


--
-- Name: tours_completions tours_completions_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY tours_completions
    ADD CONSTRAINT tours_completions_pkey PRIMARY KEY (id);


--
-- Name: upvotes upvotes_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY upvotes
    ADD CONSTRAINT upvotes_pkey PRIMARY KEY (id);


--
-- Name: user_phone_numbers user_phone_numbers_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY user_phone_numbers
    ADD CONSTRAINT user_phone_numbers_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: uses_app_forms uses_app_forms_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY uses_app_forms
    ADD CONSTRAINT uses_app_forms_pkey PRIMARY KEY (id);


--
-- Name: uses_assessment_categories uses_assessment_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY uses_assessment_categories
    ADD CONSTRAINT uses_assessment_categories_pkey PRIMARY KEY (id);


--
-- Name: uses_competencies uses_competencies_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY uses_competencies
    ADD CONSTRAINT uses_competencies_pkey PRIMARY KEY (id);


--
-- Name: workflow_categories workflow_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY workflow_categories
    ADD CONSTRAINT workflow_categories_pkey PRIMARY KEY (id);


--
-- Name: workflow_category_holders workflow_category_holders_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY workflow_category_holders
    ADD CONSTRAINT workflow_category_holders_pkey PRIMARY KEY (id);


--
-- Name: workflow_steps workflow_steps_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY workflow_steps
    ADD CONSTRAINT workflow_steps_pkey PRIMARY KEY (id);


--
-- Name: workflows workflows_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY workflows
    ADD CONSTRAINT workflows_pkey PRIMARY KEY (id);


--
-- Name: zipcodes zipcodes_pkey; Type: CONSTRAINT; Schema: public; Owner: canaandavis
--

ALTER TABLE ONLY zipcodes
    ADD CONSTRAINT zipcodes_pkey PRIMARY KEY (id);


--
-- Name: app_updates_owner_id_idx; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX app_updates_owner_id_idx ON app_updates USING btree (owner_id);


--
-- Name: applicants_email_idx; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX applicants_email_idx ON applicants USING btree (email);


--
-- Name: apps_is_benchmark_idx; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX apps_is_benchmark_idx ON apps USING btree (is_benchmark);


--
-- Name: apps_owner_id_idx; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX apps_owner_id_idx ON apps USING btree (owner_id);


--
-- Name: index_account_logs_on_account_event_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_account_logs_on_account_event_id ON account_logs USING btree (account_event_id);


--
-- Name: index_account_logs_on_account_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_account_logs_on_account_id ON account_logs USING btree (account_id);


--
-- Name: index_account_logs_on_completed_at; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_account_logs_on_completed_at ON account_logs USING btree (completed_at);


--
-- Name: index_account_logs_on_created_at; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_account_logs_on_created_at ON account_logs USING btree (created_at);


--
-- Name: index_account_logs_on_due_at; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_account_logs_on_due_at ON account_logs USING btree (due_at);


--
-- Name: index_account_logs_on_log_type; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_account_logs_on_log_type ON account_logs USING btree (log_type);


--
-- Name: index_account_logs_on_user_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_account_logs_on_user_id ON account_logs USING btree (user_id);


--
-- Name: index_account_status_changes_on_account_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_account_status_changes_on_account_id ON account_status_changes USING btree (account_id);


--
-- Name: index_account_type_employments_on_account_type_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_account_type_employments_on_account_type_id ON account_type_employments USING btree (account_type_id);


--
-- Name: index_account_types_on_key; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_account_types_on_key ON account_types USING btree (key);


--
-- Name: index_account_types_on_white_label_domain_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_account_types_on_white_label_domain_id ON account_types USING btree (white_label_domain_id);


--
-- Name: index_accounts_on_account_type; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_accounts_on_account_type ON accounts USING btree (account_type_id);


--
-- Name: index_accounts_on_cohort_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_accounts_on_cohort_id ON accounts USING btree (cohort_id);


--
-- Name: index_accounts_on_name; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_accounts_on_name ON accounts USING btree (name);


--
-- Name: index_accounts_on_payment_status; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_accounts_on_payment_status ON accounts USING btree (payment_status);


--
-- Name: index_accounts_on_subdomain; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE UNIQUE INDEX index_accounts_on_subdomain ON accounts USING btree (subdomain);


--
-- Name: index_accounts_on_zip; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_accounts_on_zip ON accounts USING btree (zip);


--
-- Name: index_acct_type_employments_on_acct_type_id_and_employment_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_acct_type_employments_on_acct_type_id_and_employment_id ON account_type_employments USING btree (account_type_id, employment_id);


--
-- Name: index_agent_aliases_on_alias; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_agent_aliases_on_alias ON agent_aliases USING btree (alias);


--
-- Name: index_answers_on_question_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_answers_on_question_id ON answers USING btree (question_id);


--
-- Name: index_app_accesses_on_user_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_app_accesses_on_user_id ON app_accesses USING btree (user_id);


--
-- Name: index_app_answers_on_app_id_and_question_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_app_answers_on_app_id_and_question_id ON answer_sets USING btree (owner_id, question_id);


--
-- Name: index_app_forms_on_account_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_app_forms_on_account_id ON app_forms USING btree (account_id);


--
-- Name: index_app_updates_on_app_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_app_updates_on_app_id ON app_updates USING btree (app_id);


--
-- Name: index_app_updates_on_app_id_and_workflow_category_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_app_updates_on_app_id_and_workflow_category_id ON app_updates USING btree (app_id, workflow_category_id);


--
-- Name: index_app_updates_on_created_at; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_app_updates_on_created_at ON app_updates USING btree (created_at);


--
-- Name: index_app_updates_on_user_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_app_updates_on_user_id ON app_updates USING btree (user_id);


--
-- Name: index_applicants_on_firstname; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_applicants_on_firstname ON applicants USING gin (firstname gin_trgm_ops);


--
-- Name: index_applicants_on_lastname; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_applicants_on_lastname ON applicants USING gin (lastname gin_trgm_ops);


--
-- Name: index_applicants_on_zip; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_applicants_on_zip ON applicants USING btree (zip);


--
-- Name: index_application_alerts_on_owner_type_and_owner_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_application_alerts_on_owner_type_and_owner_id ON application_alerts USING btree (owner_type, owner_id);


--
-- Name: index_application_alerts_on_received_at; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_application_alerts_on_received_at ON application_alerts USING btree (received_at);


--
-- Name: index_application_alerts_on_user_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_application_alerts_on_user_id ON application_alerts USING btree (user_id);


--
-- Name: index_application_phone_numbers_on_user_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_application_phone_numbers_on_user_id ON application_phone_numbers USING btree (user_id);


--
-- Name: index_appointment_updates_on_appointment_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_appointment_updates_on_appointment_id ON appointment_updates USING btree (appointment_id);


--
-- Name: index_appointment_updates_on_start_time; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_appointment_updates_on_start_time ON appointment_updates USING btree (start_time);


--
-- Name: index_apps_on_account_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_apps_on_account_id ON apps USING btree (account_id);


--
-- Name: index_apps_on_applicant_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_apps_on_applicant_id ON apps USING btree (applicant_id);


--
-- Name: index_apps_on_created_at; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_apps_on_created_at ON apps USING btree (created_at);


--
-- Name: index_apps_on_employee; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_apps_on_employee ON apps USING btree (employee);


--
-- Name: index_apps_on_external_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_apps_on_external_id ON apps USING btree (external_id);


--
-- Name: index_apps_on_hiring_status; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_apps_on_hiring_status ON apps USING btree (hiring_status);


--
-- Name: index_apps_on_job_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_apps_on_job_id ON apps USING btree (job_id);


--
-- Name: index_apps_on_job_id_and_applicant_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_apps_on_job_id_and_applicant_id ON apps USING btree (job_id, applicant_id);


--
-- Name: index_apps_on_pipeline_step_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_apps_on_pipeline_step_id ON apps USING btree (pipeline_step_id);


--
-- Name: index_apps_on_referred_by; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_apps_on_referred_by ON apps USING btree (referred_by) WHERE ((referred_by IS NOT NULL) AND ((referred_by)::text <> ''::text));


--
-- Name: index_apps_on_source_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_apps_on_source_id ON apps USING btree (source_id);


--
-- Name: index_apps_on_user_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_apps_on_user_id ON apps USING btree (user_id);


--
-- Name: index_apps_on_user_phone_number_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_apps_on_user_phone_number_id ON apps USING btree (user_phone_number_id);


--
-- Name: index_apps_on_workflow_category_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_apps_on_workflow_category_id ON apps USING btree (workflow_category_id);


--
-- Name: index_assessment_categories_on_account_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_assessment_categories_on_account_id ON assessment_categories USING btree (account_id);


--
-- Name: index_assessment_scores_on_assessment_category_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_assessment_scores_on_assessment_category_id ON assessment_scores USING btree (assessment_category_id);


--
-- Name: index_assessment_scores_on_scoring_set_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_assessment_scores_on_scoring_set_id ON assessment_scores USING btree (scoring_set_id);


--
-- Name: index_assessments_on_job_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_assessments_on_job_id ON assessments USING btree (job_id);


--
-- Name: index_assessments_on_questionnaire_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_assessments_on_questionnaire_id ON assessments USING btree (questionnaire_id);


--
-- Name: index_auth_results_on_payment_number; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_auth_results_on_payment_number ON auth_results USING btree (payment_number);


--
-- Name: index_auth_results_on_subscription_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_auth_results_on_subscription_id ON auth_results USING btree (subscription_id);


--
-- Name: index_benchmark_scores_on_account_type_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_benchmark_scores_on_account_type_id ON benchmark_scores USING btree (account_type_id);


--
-- Name: index_benchmark_scores_on_category_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_benchmark_scores_on_category_id ON benchmark_scores USING btree (category_id);


--
-- Name: index_benchmark_scores_on_question_set_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_benchmark_scores_on_question_set_id ON benchmark_scores USING btree (question_set_id);


--
-- Name: index_brands_on_account_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_brands_on_account_id ON brands USING btree (account_id);


--
-- Name: index_bug_report_comments_on_bug_report_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_bug_report_comments_on_bug_report_id ON bug_report_comments USING btree (bug_report_id);


--
-- Name: index_bug_reports_on_user_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_bug_reports_on_user_id ON bug_reports USING btree (user_id);


--
-- Name: index_categories_jobs_on_category_id_and_job_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_categories_jobs_on_category_id_and_job_id ON job_categories USING btree (category_id, job_id);


--
-- Name: index_company_photos_on_owner_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_company_photos_on_owner_id ON company_photos USING btree (owner_id);


--
-- Name: index_competencies_on_account_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_competencies_on_account_id ON competencies USING btree (account_id);


--
-- Name: index_completed_forms_on_app_form_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_completed_forms_on_app_form_id ON completed_forms USING btree (app_form_id);


--
-- Name: index_completed_forms_on_app_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_completed_forms_on_app_id ON completed_forms USING btree (app_id);


--
-- Name: index_coupon_appointments_on_coupon_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_coupon_appointments_on_coupon_id ON coupon_appointments USING btree (coupon_id);


--
-- Name: index_coupons_on_account_type_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_coupons_on_account_type_id ON coupons USING btree (account_type_id);


--
-- Name: index_coupons_on_plan_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_coupons_on_plan_id ON coupons USING btree (plan_id);


--
-- Name: index_email_recipients_on_user_id_and_email_recipient_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE UNIQUE INDEX index_email_recipients_on_user_id_and_email_recipient_id ON email_recipients USING btree (user_id, email_recipient_id);


--
-- Name: index_email_threads_on_uid; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE UNIQUE INDEX index_email_threads_on_uid ON email_threads USING btree (uid);


--
-- Name: index_emails_on_account_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_emails_on_account_id ON emails USING btree (account_id);


--
-- Name: index_emails_on_email_thread_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_emails_on_email_thread_id ON emails USING btree (email_thread_id);


--
-- Name: index_emails_on_event; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_emails_on_event ON emails USING btree (event);


--
-- Name: index_emails_on_related_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_emails_on_related_id ON emails USING btree (related_id);


--
-- Name: index_employments_on_account_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_employments_on_account_id ON employments USING btree (account_id);


--
-- Name: index_external_site_links_on_owner_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_external_site_links_on_owner_id ON external_site_links USING btree (owner_id);


--
-- Name: index_fast_track_answers_on_answer_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_fast_track_answers_on_answer_id ON fast_track_answers USING btree (answer_id);


--
-- Name: index_fast_track_answers_on_job_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_fast_track_answers_on_job_id ON fast_track_answers USING btree (job_id);


--
-- Name: index_has_account_types_on_account_type_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_has_account_types_on_account_type_id ON has_account_types USING btree (account_type_id);


--
-- Name: index_has_account_types_on_owner_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_has_account_types_on_owner_id ON has_account_types USING btree (owner_id);


--
-- Name: index_has_account_types_on_owner_type; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_has_account_types_on_owner_type ON has_account_types USING btree (owner_type);


--
-- Name: index_has_apps_on_app_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_has_apps_on_app_id ON has_apps USING btree (app_id);


--
-- Name: index_has_apps_on_owner_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_has_apps_on_owner_id ON has_apps USING btree (owner_id);


--
-- Name: index_has_attachments_on_owner_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_has_attachments_on_owner_id ON has_attachments USING btree (owner_id);


--
-- Name: index_has_attachments_on_owner_type; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_has_attachments_on_owner_type ON has_attachments USING btree (owner_type);


--
-- Name: index_has_support_team_members_on_user_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_has_support_team_members_on_user_id ON has_support_team_members USING btree (user_id);


--
-- Name: index_has_updates_on_owner_id_and_owner_type_and_account_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_has_updates_on_owner_id_and_owner_type_and_account_id ON has_updates USING btree (owner_id, owner_type, account_id);


--
-- Name: index_has_users_on_owner_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_has_users_on_owner_id ON has_users USING btree (owner_id);


--
-- Name: index_has_users_on_owner_type; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_has_users_on_owner_type ON has_users USING btree (owner_type);


--
-- Name: index_has_users_on_user_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_has_users_on_user_id ON has_users USING btree (user_id);


--
-- Name: index_hiring_status_sorting_on_hiring_status; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_hiring_status_sorting_on_hiring_status ON hiring_status_sorting USING btree (hiring_status);


--
-- Name: index_in_workflow_categories_on_owner_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_in_workflow_categories_on_owner_id ON in_workflow_categories USING btree (owner_id);


--
-- Name: index_in_workflow_categories_on_owner_type; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_in_workflow_categories_on_owner_type ON in_workflow_categories USING btree (owner_type);


--
-- Name: index_in_workflow_categories_on_workflow_category_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_in_workflow_categories_on_workflow_category_id ON in_workflow_categories USING btree (workflow_category_id);


--
-- Name: index_in_workflow_steps_on_owner_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_in_workflow_steps_on_owner_id ON in_workflow_steps USING btree (owner_id);


--
-- Name: index_in_workflow_steps_on_workflow_step_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_in_workflow_steps_on_workflow_step_id ON in_workflow_steps USING btree (workflow_step_id);


--
-- Name: index_invalid_emails_on_email; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_invalid_emails_on_email ON invalid_emails USING btree (email);


--
-- Name: index_job_aggregators_on_account_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_job_aggregators_on_account_id ON job_aggregators USING btree (account_id);


--
-- Name: index_job_aggregators_on_subdomain; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_job_aggregators_on_subdomain ON job_aggregators USING btree (subdomain);


--
-- Name: index_job_comments_on_job_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_job_comments_on_job_id ON job_comments USING btree (job_id);


--
-- Name: index_job_permissions_on_job_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_job_permissions_on_job_id ON job_permissions USING btree (job_id);


--
-- Name: index_job_permissions_on_user_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_job_permissions_on_user_id ON job_permissions USING btree (user_id);


--
-- Name: index_job_permissions_on_user_id_and_job_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_job_permissions_on_user_id_and_job_id ON job_permissions USING btree (user_id, job_id);


--
-- Name: index_job_views_on_account_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_job_views_on_account_id ON job_views USING btree (account_id);


--
-- Name: index_job_views_on_job_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_job_views_on_job_id ON job_views USING btree (job_id);


--
-- Name: index_job_views_on_week; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_job_views_on_week ON job_views USING btree (week);


--
-- Name: index_jobs_on_brand_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_jobs_on_brand_id ON jobs USING btree (brand_id);


--
-- Name: index_jobs_on_department_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_jobs_on_department_id ON jobs USING btree (department_id);


--
-- Name: index_jobs_on_location_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_jobs_on_location_id ON jobs USING btree (location_id);


--
-- Name: index_jobs_on_name; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_jobs_on_name ON jobs USING gin (name gin_trgm_ops);


--
-- Name: index_jobs_on_name_and_created_at; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_jobs_on_name_and_created_at ON jobs USING btree (name, created_at);


--
-- Name: index_jobs_on_owner_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_jobs_on_owner_id ON jobs USING btree (owner_id);


--
-- Name: index_jobs_on_refreshed_at; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_jobs_on_refreshed_at ON jobs USING btree (refreshed_at);


--
-- Name: index_jobs_on_status; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_jobs_on_status ON jobs USING btree (status);


--
-- Name: index_jobs_on_zip; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_jobs_on_zip ON jobs USING btree (zip);


--
-- Name: index_keyword_sets_on_account_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_keyword_sets_on_account_id ON keyword_sets USING btree (account_id);


--
-- Name: index_keywords_on_keyword_set_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_keywords_on_keyword_set_id ON keywords USING btree (keyword_set_id);


--
-- Name: index_locations_on_account_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_locations_on_account_id ON locations USING btree (account_id);


--
-- Name: index_locations_on_district_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_locations_on_district_id ON locations USING btree (district_id);


--
-- Name: index_locations_on_name; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_locations_on_name ON locations USING btree (name);


--
-- Name: index_manage_tokens_on_token; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_manage_tokens_on_token ON manage_tokens USING btree (token);


--
-- Name: index_manage_tokens_on_user_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_manage_tokens_on_user_id ON manage_tokens USING btree (user_id);


--
-- Name: index_message_templates_on_account_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_message_templates_on_account_id ON message_templates USING btree (account_id);


--
-- Name: index_nps_responses_on_account_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_nps_responses_on_account_id ON nps_responses USING btree (account_id);


--
-- Name: index_oauth_access_grants_on_token; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE UNIQUE INDEX index_oauth_access_grants_on_token ON oauth_access_grants USING btree (token);


--
-- Name: index_oauth_access_tokens_on_refresh_token; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE UNIQUE INDEX index_oauth_access_tokens_on_refresh_token ON oauth_access_tokens USING btree (refresh_token);


--
-- Name: index_oauth_access_tokens_on_resource_owner_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_oauth_access_tokens_on_resource_owner_id ON oauth_access_tokens USING btree (resource_owner_id);


--
-- Name: index_oauth_access_tokens_on_token; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE UNIQUE INDEX index_oauth_access_tokens_on_token ON oauth_access_tokens USING btree (token);


--
-- Name: index_offer_letter_templates_on_account_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_offer_letter_templates_on_account_id ON offer_letter_templates USING btree (account_id);


--
-- Name: index_offer_letter_updates_on_offer_letter_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_offer_letter_updates_on_offer_letter_id ON offer_letter_updates USING btree (offer_letter_id);


--
-- Name: index_offer_letter_updates_on_user_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_offer_letter_updates_on_user_id ON offer_letter_updates USING btree (user_id);


--
-- Name: index_offer_letters_on_app_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_offer_letters_on_app_id ON offer_letters USING btree (app_id);


--
-- Name: index_offer_letters_on_offer_letter_template_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_offer_letters_on_offer_letter_template_id ON offer_letters USING btree (offer_letter_template_id);


--
-- Name: index_organizational_units_on_account_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_organizational_units_on_account_id ON organizational_units USING btree (account_id);


--
-- Name: index_organizational_units_on_parent_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_organizational_units_on_parent_id ON organizational_units USING btree (parent_id);


--
-- Name: index_organizational_units_on_type; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_organizational_units_on_type ON organizational_units USING btree (type);


--
-- Name: index_payment_transactions_on_account_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_payment_transactions_on_account_id ON payment_transactions USING btree (account_id);


--
-- Name: index_payment_transactions_on_payment_number; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_payment_transactions_on_payment_number ON payment_transactions USING btree (payment_number);


--
-- Name: index_perks_on_owner_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_perks_on_owner_id ON perks USING btree (owner_id);


--
-- Name: index_perks_on_owner_type; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_perks_on_owner_type ON perks USING btree (owner_type);


--
-- Name: index_plans_on_account_type_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_plans_on_account_type_id ON plans USING btree (account_type_id);


--
-- Name: index_products_on_key; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_products_on_key ON products USING btree (key);


--
-- Name: index_products_plans_on_plan_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_products_plans_on_plan_id ON products_plans USING btree (plan_id);


--
-- Name: index_products_plans_on_product_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_products_plans_on_product_id ON products_plans USING btree (product_id);


--
-- Name: index_profiles_on_applicant_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_profiles_on_applicant_id ON profiles USING btree (applicant_id);


--
-- Name: index_purchases_on_account_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_purchases_on_account_id ON purchases USING btree (account_id);


--
-- Name: index_purchases_on_active_feature; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_purchases_on_active_feature ON purchases USING btree (active_feature) WHERE (active_feature IS TRUE);


--
-- Name: index_question_set_owners_on_owner_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_question_set_owners_on_owner_id ON question_set_owners USING btree (owner_id);


--
-- Name: index_question_set_owners_on_owner_type; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_question_set_owners_on_owner_type ON question_set_owners USING btree (owner_type);


--
-- Name: index_question_set_owners_on_question_set_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_question_set_owners_on_question_set_id ON question_set_owners USING btree (question_set_id);


--
-- Name: index_questionnaires_on_account_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_questionnaires_on_account_id ON questionnaires USING btree (account_id);


--
-- Name: index_questionnaires_on_type; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_questionnaires_on_type ON questionnaires USING btree (type);


--
-- Name: index_questions_on_parent_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_questions_on_parent_id ON questions USING btree (parent_id);


--
-- Name: index_questions_on_question_set_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_questions_on_question_set_id ON questions USING btree (question_set_id);


--
-- Name: index_questions_on_question_set_id_and_assessment_category_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_questions_on_question_set_id_and_assessment_category_id ON questions USING btree (question_set_id, assessment_category_id);


--
-- Name: index_questions_on_section_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_questions_on_section_id ON questions USING btree (section_id);


--
-- Name: index_rating_scores_on_rating_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_rating_scores_on_rating_id ON rating_scores USING btree (rating_id);


--
-- Name: index_ratings_on_app_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_ratings_on_app_id ON ratings USING btree (app_id);


--
-- Name: index_ratings_on_user_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_ratings_on_user_id ON ratings USING btree (user_id);


--
-- Name: index_recent_activity_on_activity; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_recent_activity_on_activity ON recent_activity USING btree (activity);


--
-- Name: index_recent_activity_on_app_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_recent_activity_on_app_id ON recent_activity USING btree (app_id);


--
-- Name: index_recent_activity_on_payload; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_recent_activity_on_payload ON recent_activity USING gin (payload);


--
-- Name: index_reports_on_user_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_reports_on_user_id ON reports USING btree (user_id);


--
-- Name: index_resume_requests_on_account_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_resume_requests_on_account_id ON resume_requests USING btree (account_id);


--
-- Name: index_resume_updates_on_resume_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_resume_updates_on_resume_id ON has_updates USING btree (owner_id);


--
-- Name: index_scheduled_app_updates_on_app_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_scheduled_app_updates_on_app_id ON scheduled_app_updates USING btree (app_id);


--
-- Name: index_scheduled_notifications_on_account_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_scheduled_notifications_on_account_id ON scheduled_notifications USING btree (account_id);


--
-- Name: index_scoring_set_invites_on_app_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_scoring_set_invites_on_app_id ON scoring_set_invites USING btree (app_id);


--
-- Name: index_scoring_set_invites_on_question_set_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_scoring_set_invites_on_question_set_id ON scoring_set_invites USING btree (question_set_id);


--
-- Name: index_scoring_set_items_on_answer_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_scoring_set_items_on_answer_id ON scoring_set_items USING btree (answer_id);


--
-- Name: index_scoring_set_items_on_answer_text; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_scoring_set_items_on_answer_text ON scoring_set_items USING gin (answer_text gin_trgm_ops);


--
-- Name: index_scoring_set_items_on_question_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_scoring_set_items_on_question_id ON scoring_set_items USING btree (question_id);


--
-- Name: index_scoring_set_items_on_scoring_set_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_scoring_set_items_on_scoring_set_id ON scoring_set_items USING btree (scoring_set_id);


--
-- Name: index_scoring_sets_on_result; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_scoring_sets_on_result ON scoring_sets USING btree (result);


--
-- Name: index_scoring_sets_on_score; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_scoring_sets_on_score ON scoring_sets USING btree (score);


--
-- Name: index_scoring_sets_on_user_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_scoring_sets_on_user_id ON scoring_sets USING btree (user_id);


--
-- Name: index_search_logs_on_app_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_search_logs_on_app_id ON search_logs USING btree (app_id);


--
-- Name: index_search_logs_on_indexed_at; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_search_logs_on_indexed_at ON search_logs USING btree (indexed_at);


--
-- Name: index_search_logs_on_verified_at; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_search_logs_on_verified_at ON search_logs USING btree (verified_at);


--
-- Name: index_sections_on_scorecard_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_sections_on_scorecard_id ON sections USING btree (scorecard_id);


--
-- Name: index_settings_on_thing_type_and_thing_id_and_var; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE UNIQUE INDEX index_settings_on_thing_type_and_thing_id_and_var ON settings USING btree (thing_type, thing_id, var);


--
-- Name: index_sf_codes_on_zip; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_sf_codes_on_zip ON sf_codes USING btree (zip);


--
-- Name: index_short_urls_on_job_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_short_urls_on_job_id ON short_urls USING btree (job_id);


--
-- Name: index_short_urls_on_job_id_and_source_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_short_urls_on_job_id_and_source_id ON short_urls USING btree (job_id, source_id);


--
-- Name: index_short_urls_on_source_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_short_urls_on_source_id ON short_urls USING btree (source_id);


--
-- Name: index_signatures_on_document_id_and_document_type; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_signatures_on_document_id_and_document_type ON signatures USING btree (document_id, document_type);


--
-- Name: index_signatures_on_question_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_signatures_on_question_id ON signatures USING btree (question_id);


--
-- Name: index_signatures_on_signer_id_and_signer_type; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_signatures_on_signer_id_and_signer_type ON signatures USING btree (signer_id, signer_type);


--
-- Name: index_sms_messages_on_message_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_sms_messages_on_message_id ON sms_messages USING btree (message_id);


--
-- Name: index_sms_thread_responses_on_sms_message_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_sms_thread_responses_on_sms_message_id ON sms_thread_responses USING btree (sms_message_id);


--
-- Name: index_sms_thread_responses_on_sms_thread_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_sms_thread_responses_on_sms_thread_id ON sms_thread_responses USING btree (sms_thread_id);


--
-- Name: index_sms_threads_on_account_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_sms_threads_on_account_id ON sms_threads USING btree (account_id);


--
-- Name: index_sms_threads_on_application_phone_number_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_sms_threads_on_application_phone_number_id ON sms_threads USING btree (application_phone_number_id);


--
-- Name: index_sms_threads_on_thread_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_sms_threads_on_thread_id ON sms_threads USING btree (thread_id);


--
-- Name: index_sms_threads_on_user_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_sms_threads_on_user_id ON sms_threads USING btree (user_id);


--
-- Name: index_sms_threads_on_user_phone_number_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_sms_threads_on_user_phone_number_id ON sms_threads USING btree (user_phone_number_id);


--
-- Name: index_sources_on_account_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_sources_on_account_id ON sources USING btree (account_id);


--
-- Name: index_sources_on_name; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_sources_on_name ON sources USING btree (name);


--
-- Name: index_teams_on_account_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_teams_on_account_id ON teams USING btree (account_id);


--
-- Name: index_testimonials_on_owner_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_testimonials_on_owner_id ON testimonials USING btree (owner_id);


--
-- Name: index_testimonials_on_owner_type; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_testimonials_on_owner_type ON testimonials USING btree (owner_type);


--
-- Name: index_tiered_prices_on_product_cycle_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_tiered_prices_on_product_cycle_id ON tiered_prices USING btree (product_cycle_id);


--
-- Name: index_tiny_prints_on_account_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_tiny_prints_on_account_id ON tiny_prints USING btree (account_id);


--
-- Name: index_tours_completions_on_user_id_and_name; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE UNIQUE INDEX index_tours_completions_on_user_id_and_name ON tours_completions USING btree (user_id, name);


--
-- Name: index_users_on_account_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_users_on_account_id ON users USING btree (account_id);


--
-- Name: index_users_on_authentication_token; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_users_on_authentication_token ON users USING btree (authentication_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_uses_app_forms_on_app_form_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_uses_app_forms_on_app_form_id ON uses_app_forms USING btree (app_form_id);


--
-- Name: index_uses_app_forms_on_owner_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_uses_app_forms_on_owner_id ON uses_app_forms USING btree (owner_id);


--
-- Name: index_uses_assessment_categories_on_assessment_category_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_uses_assessment_categories_on_assessment_category_id ON uses_assessment_categories USING btree (assessment_category_id);


--
-- Name: index_uses_assessment_categories_on_owner_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_uses_assessment_categories_on_owner_id ON uses_assessment_categories USING btree (owner_id);


--
-- Name: index_uses_competencies_on_competency_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_uses_competencies_on_competency_id ON uses_competencies USING btree (competency_id);


--
-- Name: index_uses_competencies_on_owner_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_uses_competencies_on_owner_id ON uses_competencies USING btree (owner_id);


--
-- Name: index_uses_competencies_on_owner_type; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_uses_competencies_on_owner_type ON uses_competencies USING btree (owner_type);


--
-- Name: index_workflow_categories_on_hiring_step; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_workflow_categories_on_hiring_step ON workflow_categories USING btree (hiring_step) WHERE (hiring_step IS TRUE);


--
-- Name: index_workflow_categories_on_pipeline_step_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_workflow_categories_on_pipeline_step_id ON workflow_categories USING btree (pipeline_step_id);


--
-- Name: index_workflow_category_holders_on_position; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_workflow_category_holders_on_position ON workflow_category_holders USING btree ("position");


--
-- Name: index_workflow_category_holders_on_workflow_category_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_workflow_category_holders_on_workflow_category_id ON workflow_category_holders USING btree (workflow_category_id);


--
-- Name: index_workflow_category_holders_on_workflow_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_workflow_category_holders_on_workflow_id ON workflow_category_holders USING btree (workflow_id);


--
-- Name: index_workflow_steps_on_workflow_category_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_workflow_steps_on_workflow_category_id ON workflow_steps USING btree (workflow_category_id);


--
-- Name: index_workflows_on_account_id; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_workflows_on_account_id ON workflows USING btree (account_id);


--
-- Name: index_zipcodes_on_zip; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX index_zipcodes_on_zip ON zipcodes USING btree (zip);


--
-- Name: scoring_sets_owner_id_idx; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX scoring_sets_owner_id_idx ON scoring_sets USING btree (owner_id);


--
-- Name: scoring_sets_question_set_id_idx; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX scoring_sets_question_set_id_idx ON scoring_sets USING btree (question_set_id);


--
-- Name: scoring_sets_question_set_type_idx; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE INDEX scoring_sets_question_set_type_idx ON scoring_sets USING btree (question_set_type);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: canaandavis
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: public; Type: ACL; Schema: -; Owner: canaandavis
--

GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

