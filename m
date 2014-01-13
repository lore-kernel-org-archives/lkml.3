Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645AbaAMRQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:16:30 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53609 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbaAMRQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 12:16:26 -0500
Date: Mon, 13 Jan 2014 17:16:14 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: lgirdwood@gmail.com, kuninori.morimoto.gx@renesas.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20140113171614.GD29039@sirena.org.uk>
References: <1389592438-13761-1-git-send-email-Li.Xiubo@freescale.com>
 <1389592438-13761-6-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Nachn7RqbTHiMSEX"
Content-Disposition: inline
In-Reply-To: <1389592438-13761-6-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: May I ask a question?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv2 5/6] ASoC: fsl: Add VF610 simple audio card widgets
 driver.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Nachn7RqbTHiMSEX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 13, 2014 at 01:53:57PM +0800, Xiubo Li wrote:
> This is the SGTL5000 codec based off-CODEC widgets supports.
>=20
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>  sound/soc/fsl/Kconfig                     | 25 ++++++++++++++++++
>  sound/soc/fsl/Makefile                    |  3 +++
>  sound/soc/fsl/snd-soc-simple-card-vf610.c | 43 +++++++++++++++++++++++++=
++++++

My previous comment on this still stands - if we're adding an explicit
machine driver for a simple card that defeats the point of having simple
card in the first place, the system may as well just have a normal
machine driver.

--Nachn7RqbTHiMSEX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS1B9bAAoJELSic+t+oim9BnsP+wSGqvNOGzs9e3yopJTBMgWl
LVsDpWD4M0WtqTw8Q3N3MWZLPAmU49mxTN2xhoWojNRjICPZI+jvO1jdEuatz/78
lx5kne81YU+oG8yCCEBDXT449nMKQWR/dfC3ZB+KJCYuJ8SECgzJwDd5hOSXc0Lx
983olXCsgUQcUmDKGGcbwhWDv+82x2GsabWJ/8idyWtLogKl9OQYJeIAbFS3nqWP
BOlXfXJ0061M3LAPWU58MRYLZoW+Jq3ikcg07b90DPBkzzZcHR2RG98J/CiE7dMh
Id9Gp7PEB/kAkmV1qRcKoQ1uz0a80RkvVhoRN+QmVi4bEK8G9hndUcc/GQKroxrK
DuUOq8/B56LOPU7LqbusXSeD4uvL837y6e/SMX/3slGZ8LvDVEt41CKcyEsdHsMe
CXnOEwUcb0kwi/flKU6VhCUlHyjpJ2aRMV9apqyogLmUlPOXqS//6wiKcbIIZ6mJ
jo1kfap/Y+EynWsTUNSKGOWxNO3TwBgb+P6pmdr552gAdLl4gE0tuzRGEYB2Opvj
mutDNP05V8mWkieyujpIcyR2IPEZOILJP0lzlkqRNAaHYea3z5CWUT8Gie32Uk06
KLouAozxHfo1dVSDNsCv46NF5FScneAnKLmyAQkNKISD7un8mNLrqPtrLl0ylYET
U5+22Y/ZoKQfKj/oo9u0
=4Lox
-----END PGP SIGNATURE-----

--Nachn7RqbTHiMSEX--
