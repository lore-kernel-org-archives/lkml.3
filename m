Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188AbbA2B0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:26:45 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38408 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbbA2BZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:25:53 -0500
Date: Wed, 28 Jan 2015 19:29:07 +0000
From: Mark Brown <broonie@kernel.org>
To: Peter Rosin <peda@lysator.liu.se>
Cc: alsa-devel@alsa-project.org, Peter Rosin <peda@axentia.se>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Liam Girdwood <lgirdwood@gmail.com>,
        Clemens Ladisch <clemens@ladisch.de>,
        Lars-Peter Clausen <lars@metafoo.de>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20150128192907.GH21293@sirena.org.uk>
References: <1422454572-7847-1-git-send-email-peda@lysator.liu.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="zsrtqxSV3n+NPNGz"
Content-Disposition: inline
In-Reply-To: <1422454572-7847-1-git-send-email-peda@lysator.liu.se>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 0/7] ASoC: pcm512x: Clock master modes
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zsrtqxSV3n+NPNGz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 28, 2015 at 03:16:05PM +0100, Peter Rosin wrote:
> From: Peter Rosin <peda@axentia.se>
>=20
> Hi!
>=20
> [ Note that the dt change is in patch 5/7, for those only interested
>   in that particular bit. ]

Applied all except the register default change, thanks.

--zsrtqxSV3n+NPNGz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUyTiCAAoJECTWi3JdVIfQbJoH/iTTNvZhgl3mcybxLYN0wVp6
bd6k3XwxivuGduqy9A5XTUFjf9//B1cUaJ3ACux6zgUEBU78a+HFPG4N6/3eXnKa
nAfug1+nyhePl3iTow3NaO+GbG7+7mhGpeZImTFAztnas2SS7wa55YkwAyjuJoNw
xoSepBHqM3zSRMHPQqaVKIT2sf6pg84bc7+5SZyT9FwWy+na+MQS/SbH/as52Vaf
wN2RIu5AzcBQBaibuaaADaDkiPR56RaElCsByNSDKnfXo78K7ORJSGfS1uyDJa7b
DucCVTLzAROZOF1qB/T+sKdfcwkM+F9lBjfhzesmJc0DlBm8h4ZiM2fnmDq3qLI=
=nx76
-----END PGP SIGNATURE-----

--zsrtqxSV3n+NPNGz--
