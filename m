Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab3CUDbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 23:31:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57722 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753916Ab3CUDbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 23:31:48 -0400
Message-ID: <1363836697.31336.101.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 16/40] Revert duplicated perf commit.
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andrew Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Date: Thu, 21 Mar 2013 03:31:37 +0000
In-Reply-To: <20130318211017.418070837@linuxfoundation.org>
References: <20130318211016.254453918@linuxfoundation.org>
	 <20130318211017.418070837@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-hTds1h3L06jW36OmwPAZ"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:5944:e226:2c7e:1b17
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-hTds1h3L06jW36OmwPAZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-03-18 at 14:10 -0700, Greg Kroah-Hartman wrote:
> 3.0-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> This reverts commit 2431496fbdd142ccc83138d94f3f510a36ce9270 as it was
> applied incorrectly twice.
>=20
> Thanks to Jiri for pointing this out.
>=20
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Jiri Slaby <jslaby@suse.cz>
> Cc: Andrew Vagin <avagin@openvz.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>

3.2.y had the same problem, so I'm making a similar revert there.

Ben.

> ---
>  tools/perf/util/trace-event-parse.c |    2 --
>  1 file changed, 2 deletions(-)
>=20
> --- a/tools/perf/util/trace-event-parse.c
> +++ b/tools/perf/util/trace-event-parse.c
> @@ -1582,8 +1582,6 @@ process_symbols(struct event *event, str
>  	field =3D malloc_or_die(sizeof(*field));
> =20
>  	type =3D process_arg(event, field, &token);
> -	while (type =3D=3D EVENT_OP)
> -		type =3D process_op(event, field, &token);
>  	if (test_type_token(type, token, EVENT_DELIM, ","))
>  		goto out_free;
> =20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=20
Ben Hutchings
It is easier to write an incorrect program than to understand a correct one=
.

--=-hTds1h3L06jW36OmwPAZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUUp/Gee/yOyVhhEJAQpTJA/9F/p6Zaguh15VDPF7YqSRuMU0r7FJo2cm
2nA3Pr5zRlGDlhIR7FzvMAyjbt1MAvRhA8tKbSmdS2VyBFCFm/p/EZl6l5xG9O3W
acd4V7OCq+SGvWYfgeFTJqwSzu0evxR37ECkkgDXoakD0fhQkGBpEmtRJU0vIkZP
jaOrTGjB9gYWaUxVmBfQC46AcsoWyu/cZgbUPpRsfrcCKungPcLFVpWeBzCRQx5+
tHQJTztt8wn2GkwUvVK8p6AfsfOO7pyjmCzsqgMrY/MrzDrb8oxZQeYnGf5s/h5H
ovjo/dDQ7oqbgeRO3MRcUdW1ernfAN8DR1VWbq0Eh6fneFuy5dKMIQY7A6KJqwE6
E/JyNZENwsspiHrACWA6cABjzFcm2zjJu96/ElRvcp8gvELFROOt11tSX99TF9r/
INbA67/KvD/bIoK85NsyHRBMx0XcbogQv1q7MoLXUpsuwK4VSEehrSWJwKYfew6D
I8WW289NV/gxP/9hnWkLV+YyMPjTAnyo/Et4quzCj0NFtv/ISGGtGcAg49AwD0/s
xdR5tqH7EqSzAbQFHgmyeb9g5ifXQn5DgIt5mNTVtiP0xZFktRwqU+4/zdP4h1/9
yA73RTt/4nahkOG97sgqueh8dY9T6vRnjkqgnjkoaAHIXqwdnoJxpkV3JanbZ1Qk
kPRBwwG4CRU=
=wVjy
-----END PGP SIGNATURE-----

--=-hTds1h3L06jW36OmwPAZ--
