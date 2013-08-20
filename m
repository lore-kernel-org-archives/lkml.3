Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426Ab3HTKvy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 06:51:54 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44285 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab3HTKvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 06:51:52 -0400
Date: Tue, 20 Aug 2013 11:51:39 +0100
From: Mark Brown <broonie@kernel.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, kernel-janitors@vger.kernel.org,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, linux-omap@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20130820105139.GL30073@sirena.org.uk>
References: <1376902316-18520-1-git-send-email-Julia.Lawall@lip6.fr>
 <1376902316-18520-2-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KjG/elEj40fDqMBW"
Content-Disposition: inline
In-Reply-To: <1376902316-18520-2-git-send-email-Julia.Lawall@lip6.fr>
X-Cookie: There is a fly on your nose.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/6] ASoC: omap: simplify
 platform_get_resource_byname/devm_ioremap_resource
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KjG/elEj40fDqMBW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 19, 2013 at 10:51:51AM +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> Remove unneeded error handling on the result of a call to
> platform_get_resource_byname when the value is passed to devm_ioremap_res=
ource.

Applied, thanks.

--KjG/elEj40fDqMBW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSE0o4AAoJELSic+t+oim946UP/2FUpnHZ4XPlWCG8ipTV91x/
sr/qCKcgLUZpuRe+xxXWn5Atk/5CYkwPtRiy471ah+QVLNN070vAh6I/fyOdDaLc
+X4AR898rv3mDfwoWQFPmiETM/jmqHfRuSjjNCvWljsCNOlYYPQ+lgpOJwcUQPae
gFCECXEd+t61AyYOhWstNUcEvq/I4Fj1FSbr08ThTHKGp6BHfcgbYUad/Yc0a1Ky
rXNyKToj7g9PBu/6VdFrakYJg4X1ygJQLvDKEu9hPYBSQjWpiQCYM6OTljeEuzCB
pNPvf4CdqPCOEW1ThPsRIuvQhCzysc5jjeqcxIxQ4tQc7wEULYQKeEP2x7ajHTk1
fIiBWjjaHZXHMdfhkZZt6zYe5YuJO2Yx5I1vJ9llY90OXMfiEIBu4fKr6Cc6TxOd
NVrsTvH08dS0BE8tIzokxQqzX0AbPuuZ0gnCVekoo20J6IJmPhJ2AGVMpMbqXgJk
S4U94frGXZw5Ws3JsHioaJnomWOB28QMkvH4O93U+9MRIIqBUXaxPxwGN36i3zQA
w5T9S4JNQ4wf3kigk8k5nSh7ZSelw51zg+sxDMdHu5+b2xBegs25mqnZbG+CGTex
Bgj5udIFzHhnNfcUewFpjatOEGCH9idQ5EmwJlHqPpOOfvSy+LQ5HOnyeDC/gtP0
OBrFsZYJgCsItMvacK4x
=Fgtl
-----END PGP SIGNATURE-----

--KjG/elEj40fDqMBW--
