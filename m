Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaBCMrq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 07:47:46 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34642 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaBCMrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 07:47:45 -0500
Date: Mon, 3 Feb 2014 12:46:59 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rob Clark <robdclark@gmail.com>, Dave Airlie <airlied@gmail.com>,
        linux-arm-kernel@lists.infradead.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140203124659.GW22609@sirena.org.uk>
References: <cover.1390986082.git.moinejf@free.fr>
 <20140202124358.GD26684@n2100.arm.linux.org.uk>
 <20140202190606.6fa193ce@armhf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ztQAJXOExAP3xDFw"
Content-Disposition: inline
In-Reply-To: <20140202190606.6fa193ce@armhf>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v5 00/23]
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ztQAJXOExAP3xDFw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Feb 02, 2014 at 07:06:06PM +0100, Jean-Francois Moine wrote:

> - the .of_match_table is not needed because the i2c client is created by
>   the i2c subsystem from the 'reg' in the DT,

It's generally better to have an explict set of OF IDs even if the
default does work - matching purely on the device name does work almost
all the time but there are collisions out there with different
manufacturers using the same prefix for their chips (the example I
always trot out is that both Wolfson and Wondermedia use "wm").

--ztQAJXOExAP3xDFw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS74/AAAoJELSic+t+oim93WQP/3fpPl9EtGKD55JmoulCZ1/I
f9qgrBWUWPheHxkYbCbRojGdttM9u+OHE65Ir5ckOAWp0m2Z6Q124gLOtuOY4QGO
ty5afEarYKtQlgqd4NvoInPuWBXklU4pTdWeuiZkOns3yVRkmYoeQwy//AuFQkK2
ByIpjK/n58c/D8Tz7YfhZCeTanHlK6Gvw3uXmeAbj9j2/vapAn5sUNGQkfAec1oR
Y/k3TKwYtcIV82I/dAY0XbCeNs48eLhlGCV/t2aF055ODd2ghwWYjgp+zy9mr1tE
v94daQEGMghkE9i3BR0UBOxbe9Kfr+xwBbFe8cjXPd079Vhq6WT0lmmHbLf00tZg
F6g/Vrs/QgUYfksCyyvuPtNHvAeDgMvWhuIuwgY4YvH7eOag43V4GV+J0wRGpmZq
YxXs2aWkJqEvxHk68oLQx6rmEuBzCAfwQqhkdy8j2I+nwLUqNxxcEPIuuUcUToOf
yjH7+svfxgfRfeF3nO8s0wUTb0BtJYIWBurxufIIgN4xP2nudPWOtcZ7Y/cHzzW+
W7kxHblozuUtBFzE19TZoSrMdSF/rHD7ZjScBHd1bQ3yzbmLORqYITjAt2dcdKOi
3flyVdp1u1oeGsdFivU/Z+z82N+qd0dMSP5fUKWDMayViMfevWJ8digCgqVHgdI7
kVi08u1MkkLsV0M9JhJn
=hWbp
-----END PGP SIGNATURE-----

--ztQAJXOExAP3xDFw--
