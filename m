Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424Ab3A3H6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 02:58:48 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:49622 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab3A3H6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 02:58:46 -0500
Date: Wed, 30 Jan 2013 08:58:36 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, gnurou@gmail.com
Subject: Re: [PATCH] pwm-backlight: handle BL_CORE_FBBLANK state
Message-ID: <20130130075835.GA13543@avionic-0098.mockup.avionic-design.de>
References: <1359526755-21145-1-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
In-Reply-To: <1359526755-21145-1-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:O7GKPfrzloJr0narfkfzEROoXYDbpsvPKWYJFhAHO4s
 ht3bTW0Cooj4H8zCUayneoKV4CwTSsyOzee2Tgk1hTKZWIfTr3
 bI1sX1DY5OHV3gK9s7S7ft9u5GCpmo1ssxkk0QPGMpdFRZsKsS
 ovyqFqB2/MiC8RRWPcPcOjlFIgO1783vVathy2w3O+HDDrpwoB
 3Zl4/gUrMVLvmeNtJy0Q9DlK7HMpt63YDccf9/qTUuXSaOYGc6
 yz4HJVId72H9l1pweQPVOerhgl9RFbQBfg6Kx3Rrc2xnKjrIGL
 UR2Au0g2vFwi6uaoWWCg0Q/UQqnIRFUjQc3iOEtBFi13B/4Cu+
 rX4XqQ0S9s7OTvZQKMlVNFPdyPG8HKcCkKKT0sPIH5ffasCFTc
 kpQtoZKS2NzU5DIqW+wFK2LwvxQI404/5AQpuP7z4rwhQe2U26
 K+HdH
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 30, 2013 at 03:19:15PM +0900, Alexandre Courbot wrote:
> According to include/linux/backlight.h, the fb_blank field is to be
> removed and blank status should preferably be set by setting the
> BL_CORE_FBBLANK bit of the state field. This patch ensures this
> condition is also taken into account when updating the backlight state.
>=20
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  drivers/video/backlight/pwm_bl.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)

Applied, thanks.

Thierry

--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRCNKrAAoJEN0jrNd/PrOhSOkQAKDVZHTAUGff58w9kY4q4fm7
VXs1MT1VQ/nNYYmlPwtjM7fGVph/hbfqSdskvUw49mNlHEwP9XCP94A52Bjm1tSF
0+YAJQspME5AGlx7RROqFu967P9T34UBqGk0YlcXw0B+AH1hc6cpfo18xTZbMpCv
r97O6QkO968ps9agcrUk0Ohm7nH5OMt8a/IXLjUmq7MU/cN6UDGengQlmYT4znvz
+GfbXnHC3OL+N6n9i8PXZtjTfd11+dQmWzhTbw9g0E+uVHjVBpBJypDKs9vG1YaR
WB0xTlLU1w2sBOADghF8WMh8SZE6TIQPAygXdOxtAjo3MrTf5fj8VkwXOaIILFAt
+pneJiGavmJSRVRf1xedHBxgkfeHB/nFeIYkpuWGQhxlc0Gv09kZw2oTSy1FKXht
DYFtGP/MZCPg6aUfap5loLNTigK72RVzFXoEN0ImdOg/27VYTUbvCbKfPp53ZRWr
7rhcP4XIhB2AkhY9iwFxx8vY3pJKVSHPEYkYpNeo0/Km5S3zvn8Vb++4fx8Ey/Km
5jJOTuidQYNUT8tD8AYoEfyx+RIvy6Ox4fDkhw2qUbFInceE32noum+V7VcUMR/8
PWQFh3WY+iZwyuktCmM9pwAd4vH7C70oykir0SLhNH2IzAT2A3fOZCyzyAsCj66x
gpmt+IMHwq3qYm17cr3W
=kVbD
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
