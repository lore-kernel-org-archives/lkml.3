Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbaFYLRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 07:17:20 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:50457 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbaFYLRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 07:17:18 -0400
Date: Wed, 25 Jun 2014 13:13:47 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>, Jingoo Han <jg1.han@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com
Subject: Re: [PATCH] pwm-backlight: use devm_gpiod_get_optional()
Message-ID: <20140625111346.GB21208@ulmo>
References: <1403687898-26881-1-git-send-email-acourbot@nvidia.com>
 <20140625095447.GT13803@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="A6N2fC+uXW/VQSAv"
Content-Disposition: inline
In-Reply-To: <20140625095447.GT13803@lee--X1>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--A6N2fC+uXW/VQSAv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 25, 2014 at 10:54:47AM +0100, Lee Jones wrote:
> > Make use of the new devm_gpiod_get_optional() to simplify the probe
> > code.
> >=20
> > Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> > ---
> >  drivers/video/backlight/pwm_bl.c | 7 ++-----
> >  1 file changed, 2 insertions(+), 5 deletions(-)
>=20
> Looks good.  Applied, thanks.

Technically pwm_bl.c is my turf. However I only adopted it way back when
the backlight subsystem was orphaned, but it seems Jingoo, Bryan and you
are taking good care of it these days, so perhaps it would be a good
idea to move it back to your custody?

Thierry

--A6N2fC+uXW/VQSAv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTqq7qAAoJEN0jrNd/PrOh1h0QALlXX0VLT7t0FlcUfmnFvwIJ
X2pc5vAX27GlOZf9kc76KIKGz7XRuAvhT9YtCHpuK7NdPAt79JK6EukwXM0QTD25
ksq2bmDzU8sU3QkpFsUs+oRhnFXO4+PHXcP8PR3XEbADJ8/BAzifak7kJcmgSQZt
FajQkO5xUO86glbs9mRhBK10MVFkzatZWEmMvnnmu4ZOvKObFc2yTO7QcqctsVSn
yvMmkGAlcJkHV531ak/I+An8L+W9+Crl/pACB5YgibySH0oVHX5YX9fyZJ6tyQ5h
HsPbBDdgnkoJGAMt9KKGNyw0CiPMRIgegsgDfpVtVEmm6KM3+JrMVTv8peJ1EJmf
Bvaezts/8GkU0Z9v3mEbnJPuuQYOPhj0jiQmJ4LonkVUt8cK1FnYvVHUPBe9XWkH
E+Q7Wm1/8nwaKvRncZanUtS0OMfaLAGblwO9JxRVNiKq3L+LY2dOOhq8nAl6KOxo
orwsAW+TuJIrh2iqNL4PthzO2mpD6r3tiHciZSwAAFTW4qBy9jEGE3egnBwEZ35S
8s++9KbZEodjBccy5v6W6Mi8+ep/DRuKej4RQjtNLyOeaG0Uen3egsBEUNWhXPzd
FlUfxDqM4WkhCFv0ekApaHv7rhPowDqYGIk5ujiVj4IpSCmfwsT0G5CbmLHiB0Va
2wFiEbceaFKTSqER10Rj
=IWMQ
-----END PGP SIGNATURE-----

--A6N2fC+uXW/VQSAv--
