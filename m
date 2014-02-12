Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbaBLPdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 10:33:05 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40852 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbaBLPdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 10:33:01 -0500
Date: Wed, 12 Feb 2014 15:32:40 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: lgirdwood@gmail.com, Guangyu.Chen@freescale.com, perex@perex.cz,
        tiwai@suse.de, shawn.guo@linaro.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140212153240.GV28112@sirena.org.uk>
References: <1392104569-27792-1-git-send-email-Li.Xiubo@freescale.com>
 <1392104569-27792-2-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w3FC1ngOohd+pYSp"
Content-Disposition: inline
In-Reply-To: <1392104569-27792-2-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/2] ASoC: fsl-esai: big-endian support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--w3FC1ngOohd+pYSp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 11, 2014 at 03:42:49PM +0800, Xiubo Li wrote:
> For most platforms, the CPU and ESAI device is in the same endianess
> mode. While for the LS1 platform, the CPU is in LE mode and the ESAI
> is in BE mode.

Applied, thanks.

--w3FC1ngOohd+pYSp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+5QVAAoJELSic+t+oim9WIMP/0UbAleCWhd7JqqKymUJADpP
tHyEC1tztKCtatDS9XFtoANVR0expg4/FDsC1eSKkuSjvXRTK0sgaKJoehWjutEn
8PXT/56F3FaoDJ2Tt/tVCuOWGjjBYtBMDCAHalaJ+OVqPUGI3icuKzKODxF46l3C
FpWceOzG4DVr9VBRE2VAkrgK7uAk95Srzx3eIoOjWBv8XqtRAZAq8fQWFFw8wuX4
QgxYkHeNknf4Ww0bSfmXmyrN9in97SpW/zzgxFu58hYrq36gvIFRIFE8FMdT/m/M
vRAsx+5hPVXEmO9ixnEkIRK9l3nzHlIQfXXFMTo4Gzejxswwjn5OE5r8wql653Yn
/5Hfy/uBV8vjbOexK0CwXEYx+rn47NJgtMnGJnyw1QoicVgX+aJLM4YB9iFRrkeN
OdVWVZpnmvRRhHrHvSAyRH+dezMbVTUfAZ4oaqyb7gI9JGdEIUKbAHGie0WVfLSf
gDpOHyQPSEzYuP3L3DHjqZVaaX1z3lbHY7E9IZ4EVAYloE3i/KR78VCFhWVZzi60
XUVD0Wyaz3MB9lOCdUOO0qYAAi4WaKjy+H8jb7Tj4ynKjx4+ZrKXnRp7ZZ34yYyK
a0WOzUk8HVF/S9+GftY+ieofmc0BJA+3K1hVKBZN3cxCs/l/NwZlX9LAPpI9PcDK
+MhY9vR+rFgJ+NqMhL8S
=Dyi9
-----END PGP SIGNATURE-----

--w3FC1ngOohd+pYSp--
