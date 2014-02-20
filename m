Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107AbaBTK1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 05:27:46 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47118 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbaBTK1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 05:27:44 -0500
Date: Thu, 20 Feb 2014 19:27:25 +0900
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, dmitry.torokhov@gmail.com,
        lgirdwood@gmail.com, lars@metafoo.de, peter.ujfalusi@ti.com,
        jarkko.nikula@bitmer.com, eric.y.miao@gmail.com,
        haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux@arm.linux.org.uk
Message-ID: <20140220102725.GL2669@sirena.org.uk>
References: <1392736948-26623-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1392736948-26623-11-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FGcBKnxp2SANuUww"
Content-Disposition: inline
In-Reply-To: <1392736948-26623-11-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.156.234
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 10/17 v2] ASoC: mfld_machine: Update locking around use
 of DAPM pin API
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FGcBKnxp2SANuUww
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 18, 2014 at 03:22:21PM +0000, Charles Keepax wrote:
> The pin updates in this driver look like they are intended to be done
> atomically, update to do so.

Applied, thanks.

--FGcBKnxp2SANuUww
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBdiKAAoJELSic+t+oim9BoAP/0DKFuvOjnQTMH3ZxpvaxnHl
Gh/R8FEM++8wKJR+3GHU/c5NuPQO3u0g3bDFh0zYrZLdmnN0jfYEJc8IPTXHVaKI
+hSC/tHpieQwdz/gc6RwUutFYeOLAF3/PTzOxQZSlN2m8mhW3kVnw6ovEnbr299r
Y3I515c7rMM9wPB9xrwvwb9cRwj/HbxjySKwxyRwGn3OhFS52FY87CxxRZH+k7vV
uA3EhL44v/L1y65Kp1UmEHCbksdkIjdqyvp18Txtq+bkqAru8qVZQ+TliUhRJcdz
1YST1Hdv/TaP94Do7p4KnrSplbUluWIFYv2b+33gv25QY38gG4whBX6lM0XY68LM
tqLZWH0mKymBC4+H70a/GbhrRmCVanNbYDXgIhDqX4LsYzqxxX2nBoCSVSuO77FZ
u30BWKz0i+ISrPFBmTpzi/6Pckv116dwwa5P8b7QD6voL/UaXxYGSz9HQxnox/r7
rTt+LC5+HSNmsV00jQ/aoHcQqfVToqdpr+CfW+7LEUZ5kFfhGySNIToL1S5ORqvz
uTzIT5uNZrjjppN5V8Y96YvpebI1JK/AJjhgdNqdKnF/rPSxHfdqxr6DwAZyu7am
H8Uq54ro4KjmhvL4GsCogvLDAmbVsadrcuDtQN+s+Wa220NdR4cB0aXfwpyXvGaf
20PxeNTaCdCCo3GaYgAL
=yame
-----END PGP SIGNATURE-----

--FGcBKnxp2SANuUww--
