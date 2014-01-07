Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbaAGRGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 12:06:00 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48441 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbaAGRFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 12:05:52 -0500
Date: Tue, 7 Jan 2014 17:05:38 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20140107170538.GA31886@sirena.org.uk>
References: <1388630905-1321-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r2/fuxH/oC33tddT"
Content-Disposition: inline
In-Reply-To: <1388630905-1321-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] ASoC: soc-core: add snd_soc_of_parse_master_clkdir()
 for dt
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r2/fuxH/oC33tddT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 02, 2014 at 10:48:25AM +0800, Xiubo Li wrote:
> This patch adds snd_soc_of_parse_master_clkdir() and supports below
> style on dt:
>=20
> master-clkdir-out;
>=20
> If this property is absent 0 will be returned, 1 otherwise.
> 0 : SND_SOC_CLOCK_IN
> 1 : SND_SOC_CLOCK_OUT

This is mostly OK code wise, though it would be good to use those
constants in the code.  However I'm still not sure about it being a good
idea - it's similar issues to those with clock IDs but less strong.  Do
you have a user in mind?

--r2/fuxH/oC33tddT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSzDPfAAoJELSic+t+oim9+AYP/3WOJVaFYod0qh226+S6Pea9
BQTQJI+U3zMri6QgVsavf7M2ZwJUru6oxJTaafVMCuIK6JgHk1zhx5y0zEmLqBtX
4rcpzohrcWfptvTSt6Z/x/r0oh78N5TtbPCnJ79SVjSXmF0F1WpAxjPfMfNW+NHS
+05T6+hVcwji2szsrsOoJ4zwA476KG4MkfxuR1wAJeMil8hKNLfDXwR6dujhxXp/
lFIHT22/r51/3Wm6yXP5q3fakXWvmJYjrJ2PytzUj6vJPHWe9cHc2dllatfcyDDE
Qzs1wGFo6yIoE0J7s92XcVCuDbVFrDWON6UnCX6pyKWwBgKa9HtYsBUOda0rxI4e
91r9+zJZVHX93YSA2v54tWMjLSy7dnMYs8woIreILz0rzRDV1hQaxz+e/VMjCDdZ
O6QbMFFY9LkiuGee+/HeB03EBpQZeI13vXz8B9kIP/O+UNOPWrCI1+8qZI/rOqEE
EPFl3GlD/nB/yNHfinxFoiaTCMs5F3LMXM60HsYz0yV+D8XE/f2F2yqFuyjaHfQt
otMINbH+ekaJTXxRX6m7fqL/6mqalfgr0SEeMTwYY1bnE6IPoWaLUVQyZSKZ+UGg
//rHc2LucalRElmTj9XoCAgzxSLwcnFwRmuJk0z0NWi5kgib4FkQ2MAUS8BQwb4p
roQaupCQzFTeVeUxgsY6
=rA5V
-----END PGP SIGNATURE-----

--r2/fuxH/oC33tddT--
