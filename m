Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbaAIPcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 10:32:32 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50173 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbaAIPcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 10:32:25 -0500
Date: Thu, 9 Jan 2014 15:31:58 +0000
From: Mark Brown <broonie@kernel.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        dp@opensource.wolfsonmicro.com, ckeepax@opensource.wolfsonmicro.com,
        yongjun_wei@trendmicro.com.cn, patches@opensource.wolfsonmicro.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20140109153158.GB12858@sirena.org.uk>
References: <CAPgLHd_bNPEJmkjtmbeDrtmVMo5G7ELNCuyKuwT7Qa=weqh8kA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oLBj+sq0vYjzfsbl"
Content-Disposition: inline
In-Reply-To: <CAPgLHd_bNPEJmkjtmbeDrtmVMo5G7ELNCuyKuwT7Qa=weqh8kA@mail.gmail.com>
X-Cookie: Gravity brings me down.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH -next] ASoC: wm_adsp: Fix sparse non static symbol warning
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oLBj+sq0vYjzfsbl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 09, 2014 at 10:22:35PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>=20
> Fixes the following sparse warning:
>=20
> sound/soc/codecs/wm_adsp.c:1500:6: warning:
>  symbol 'wm_adsp2_boot_work' was not declared. Should it be static?

This was already fixed.

--oLBj+sq0vYjzfsbl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSzsDqAAoJELSic+t+oim9exgP/iQ9Xe9j1HP4xJpmEeLXzoJF
23gwcNlIwQjvnPYzYy5RJDvcp9/Q3tw+qtjDCAD5XG+/MY63GgJTdD4uivLd8i9g
uGhjdi8IuJcZ/nijx0WRLZNQctgCXMDM5CSBV8gFh3x7MblrFLUv8b/0DZshyCan
9tRh0IB2HgOsXPNOmA4kUnwICyk4++tC/TpauDMArH9CW0knifG5QxKxOiEIuORi
MRtZQyV9Xf4Jar2ZEdD1Zje4KlV52GzHRyf0hUVfaZjX2pPi1jYRB41HgmeZ3f+3
wQGDqoYdRJLyLocXhifLByDL4+hV3wbrix6ggExs/SZmetqEz6ORZHzbFWg2cTMs
K4nIjar8E3/LUHi5XiD3ssrsE90VoNRfxqfPjmab2zTPYzOGDpAtJxe/kj8SmcNn
R5eaDczoDHZggSvPOtTBQvN/bPToyg88oA1EqkKxpMpt4Dy8cnt+0iBiqEE3KzmT
3ULOEcQug4i8r/BShvCkPsOU1WwIkK9zIlDBGDQju9bk6NyZgOv2VmR3gGt4iPIR
Yml8bcgPI81EHVHFzcgUUJr5uXDevwmhCPIH3F33nJN3sUjMuBXI3okFWdsdYm20
f1O9vjy+u9/2GayWHGRFNa5RVaXv43u4LwXYKlJMEZ5HkM7gQYzY8vbIYOhA75fr
drV9pmHP+G2MwuDE/swf
=6Bfz
-----END PGP SIGNATURE-----

--oLBj+sq0vYjzfsbl--
