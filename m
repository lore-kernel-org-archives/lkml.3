Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256AbaBTKX0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 05:23:26 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47039 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbaBTKXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 05:23:25 -0500
Date: Thu, 20 Feb 2014 18:40:38 +0900
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: myungjoo.ham@samsung.com, cw00.choi@samsung.com, dmitry.torokhov@gmail.com,
        lgirdwood@gmail.com, lars@metafoo.de, peter.ujfalusi@ti.com,
        jarkko.nikula@bitmer.com, eric.y.miao@gmail.com,
        haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux@arm.linux.org.uk
Message-ID: <20140220094038.GC2669@sirena.org.uk>
References: <1392736948-26623-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1392736948-26623-4-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K/LzB6MLpuRxEY5S"
Content-Disposition: inline
In-Reply-To: <1392736948-26623-4-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.156.234
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 03/17 v2] ASoC: dapm: Add locking to
 snd_soc_dapm_xxxx_pin functions
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--K/LzB6MLpuRxEY5S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 18, 2014 at 03:22:14PM +0000, Charles Keepax wrote:
> The snd_soc_dapm_xxxx_pin all require the dapm_mutex to be held when
> they are called as they edit the dirty list, however very few of the
> callers do so.

Applied, thanks.

--K/LzB6MLpuRxEY5S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBc2SAAoJELSic+t+oim9CeIP/1GYQUTE7lufeZxzveEPiAGH
H6tsYp1T+PHXYb2mvB43xKLvvIOwLForMEHLulloWUjIKiGkTC8xo39kfpz5pfam
ap9vTHYSwXaBjSXYVPiXZPG63/FSFc1s2eB+ed+g9uw7886jzC/ItX4zdUR0816B
9Gz7ZVfo+NbqmQbsTen0z8LOMXnL0t24PIFGbbczugbYpGP+w6lso53xafmrrIi9
sNyw1dxCsSwaGhsAgiQ5S1ON2xBsYDQd4ww33EfOSNl1WFpqDTiH/ba9neu+S07D
kfIxJlr6a24VNIbF9iuH2E3oPnS0OFralmtfoe0StrQMDH0cyxcJJ9AQj3Z+yj3S
Vms8YdAT0/8b8W1EIlPfUGO6dnRDUho9i+y/sp/8+kA+aMk8k0bR37UEyd+QoYBk
K0z93sJTQjZO94b80fV9oq6k+EroS/OxcnqFZUb+owAam9A92eT2KVljcZCVONOv
aKIZX4nZ6/plOvlK8os7N9sL9zGETI9wfqrexQFyOSsVi3hvbGyvzdQ2Tg5TQBLp
WMjrUl6tFhmDfB5DMzGeRfnBRo6OEd5cPxqooHi2zrGDTLiCFj8tiIXAwb80CU0l
Co6Qdq6deLXHTYaFAK+RnPkeKdHjywvUdDlbTdwIlhu74dk0Ka5Y0AOS6oEJsRNY
ymTF4hxIxPoti+oDZcQb
=5/sj
-----END PGP SIGNATURE-----

--K/LzB6MLpuRxEY5S--
