Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369AbaBWHLw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 02:11:52 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49974 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbaBWHLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 02:11:48 -0500
Date: Sun, 23 Feb 2014 14:27:56 +0900
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: lgirdwood@gmail.com, lars@metafoo.de, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, b47053@freescale.com
Message-ID: <20140223052756.GL25940@sirena.org.uk>
References: <1392341676-4143-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1PHFXgj3K5uCxEyX"
Content-Disposition: inline
In-Reply-To: <1392341676-4143-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.159.64
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 0/3] Add TDM slot info OF parsing supports
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1PHFXgj3K5uCxEyX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 14, 2014 at 09:34:33AM +0800, Xiubo Li wrote:
> Change in v3:
>    - Add .of_xlate_tdm_slot_mask().
>    - Add snd_soc_of_xlate_tdm_slot_mask().
>    - Remove TDM slot masks OF parsing...
>    - Split the TDM infomation into two properties.

Applied all, thanks - this is a really nice, clear binding though I
think we will need to extend it in future to support specifying which
slots are in use by a given device.

--1PHFXgj3K5uCxEyX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTCYbZAAoJELSic+t+oim9QTUP/0PJj6TYa1vNhyJ3i6eHiz+R
viW5L15S6xnh3bEVkuVxibnuXVIxJ6fbjpjq6mt92G3Va1DYQYEg7I4yu7PEmAFQ
MbLozIkRNbfrpaCqjGGSXrI2XKLZ7M7B0nwVYn3EU37kkQMEYwWszwWJRYK8o/Iv
ry4ELPUfBGsufFJ19GRCyPunZJyRFqdt2Fd39tA7LBpDh3AMzFVfws4UUH4C8K33
GzoGOw0OZir5hms97oseKUMBitxOMTwc0XvOtDSiPO8/ql8mq7SX93ncbR6f7Ux6
jlgl9C+EQQr6WHSnEONDODL9fyRJklUneJP6lKn0RUpo6nih5HLegdpBTMHoH8e1
GNF/rmWce1lbEm17ea99iG7W/B+8sTjbFJJlJu0mmL7CyHaebA9ZadsOX0mHKWen
MHP+JgFVNzKsjiCA8zRuhUdwcF056+Bo4kwZefHl/paqKI/d1vK2G5QvN5mSVlne
PXqGUFdyNskGcfvvl9U6vhNQNGWdn5CG5EBYDYupihHbNKx4KmGJ1C06VZTR5PUp
pSR8S8J8QpDLZqYzCwijB5B1CNDvOYsVnBMi2fv/hbp/zmDtTAf0rW8vAL+yHdfu
04GeiIX4frwyhDuzGRSxbt9g4ooU2vbU2lATaRoqXwLHwSYU82CmSUKK6QP/K9BA
KzdVcTLzB2Rtd1gLuhcS
=t4hh
-----END PGP SIGNATURE-----

--1PHFXgj3K5uCxEyX--
