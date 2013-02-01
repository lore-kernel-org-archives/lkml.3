Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab3BASbi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 13:31:38 -0500
Received: from ngcobalt07.manitu.net ([217.11.48.107]:54718 "EHLO
	ngcobalt07.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600Ab3BASbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 13:31:35 -0500
X-manitu-Original-Sender-IP: 127.0.0.1
X-manitu-Original-Receiver-Name: ngcobalt07.manitu.net
Date: Fri, 1 Feb 2013 19:30:47 +0100
From: Roland Eggner <edvx1@systemanalysen.net>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Dmitry Voytik <dvv.kernel@gmail.com>, Michal Marek <mmarek@suse.cz>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH resend v3 2/3] kconfig: nconf:  rewrite labels of
 function keys line
Message-ID: <20130201183047.GC11098@mobil.systemanalysen.net>
Reply-To: Roland Eggner <edvx1@systemanalysen.net>
Mail-Followup-To: "Yann E. MORIN" <yann.morin.1998@free.fr>,
	Dmitry Voytik <dvv.kernel@gmail.com>, Michal Marek <mmarek@suse.cz>,
	Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org
References: <20130201182237.GA11098@mobil.systemanalysen.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="69pVuxX8awAiJ7fD"
Content-Disposition: inline
In-Reply-To: <20130201182237.GA11098@mobil.systemanalysen.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--69pVuxX8awAiJ7fD
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

>From: Roland Eggner <edvx1@systemanalysen.net>

More reasonable labels of function keys line.  Rename labels and keep menu=
=20
width, as required for fitting on COLUMNS=3D80 terminals:
=E2=80=A2  s/Insts/Help 2/
=E2=80=A2  s/Config/ShowAll/

Signed-off-by: Roland Eggner <edvx1@systemanalysen.net>
---
scripts/kconfig/nconf.c |  8 ++++----
1 files changed, 4 insertions(+), 4 deletions(-)

To be applied on vanilla 3.8-rc3

diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
--- a/scripts/kconfig/nconf.c
+++ b/scripts/kconfig/nconf.c
@@ -312,19 +312,19 @@ struct function_keys function_keys[] =3D {
 	},
 	{
 		.key_str =3D "F2",
-		.func =3D "Sym Info",
+		.func =3D "SymInfo",
 		.key =3D F_SYMBOL,
 		.handler =3D handle_f2,
 	},
 	{
 		.key_str =3D "F3",
-		.func =3D "Insts",
+		.func =3D "Help 2",
 		.key =3D F_INSTS,
 		.handler =3D handle_f3,
 	},
 	{
 		.key_str =3D "F4",
-		.func =3D "Config",
+		.func =3D "ShowAll",
 		.key =3D F_CONF,
 		.handler =3D handle_f4,
 	},
@@ -348,7 +348,7 @@ struct function_keys function_keys[] =3D {
 	},
 	{
 		.key_str =3D "F8",
-		.func =3D "Sym Search",
+		.func =3D "SymSearch",
 		.key =3D F_SEARCH,
 		.handler =3D handle_f8,
 	},

--=20
Roland Eggner

--69pVuxX8awAiJ7fD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlEMCdcACgkQdN/hKfT7G/JugwCgp4W7H99DY14iHOFeDQuGowfz
q9cAn3ktvLHwOENBMtHRAIlmP5aEX6r+
=/LKQ
-----END PGP SIGNATURE-----

--69pVuxX8awAiJ7fD--
