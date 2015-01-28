Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbbA2BZy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:25:54 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38406 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbbA2BZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:25:51 -0500
Date: Wed, 28 Jan 2015 19:31:10 +0000
From: Mark Brown <broonie@kernel.org>
To: Bo Shen <voice.shen@atmel.com>
Cc: nicolas.ferre@atmel.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-sound@vger.kernel.org,
        Alexander Morozov <linux@meltdown.ru>
Message-ID: <20150128193110.GI21293@sirena.org.uk>
References: <1422329800-28481-1-git-send-email-voice.shen@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="hZNcg5Zgu0ROmvXA"
Content-Disposition: inline
In-Reply-To: <1422329800-28481-1-git-send-email-voice.shen@atmel.com>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 1/2] ASoC: codecs: wm8904: add dt ids table
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hZNcg5Zgu0ROmvXA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 27, 2015 at 11:36:39AM +0800, Bo Shen wrote:
> From: Alexander Morozov <linux@meltdown.ru>
>=20
> The WM8904 and WM8918 has the same data type, while the WM8912
> has different data type. So, use the data in dt ids table to
> distinguish them.

Applied both, thanks - please use subjct lines matching the style for
the subsystem and CC maintainers (including driver maintainers).

--hZNcg5Zgu0ROmvXA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUyTj9AAoJECTWi3JdVIfQvGsH/1WOvFO1DaNSf9xCwdhhKk/3
QDEey4WnmaU8bsBlecqtyoNVeKw01ymjETR0b7r5fTq5vNCJQNbaoIbId7g1YxDI
Q7ReZcl5JTLFus5sZlW4y0+94vGLjOxqecmIKWw4hIlwpAV2gpBrO49DlMcjw3y7
tpDvLJfrX+Su+mgkE9+N7MXWrK7BAARZ72PlN3Y5PvDY8UAq6lH08nqvlUfIkniC
0c818pv7xvH4K75DI/lDPTSt1+h+wT3LKeHlpxQXiGFsZa7SmryvGIDFac1zy8jT
BttMGkAzdxs9ua8kU9MJ9JtNADqgAoqT+1njgDwSM/v8Sb2CTtlHTMuE9B03/90=
=u0Lg
-----END PGP SIGNATURE-----

--hZNcg5Zgu0ROmvXA--
