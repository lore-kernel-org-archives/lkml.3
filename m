Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759791Ab3BZI5i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 03:57:38 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:49522 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758719Ab3BZI5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 03:57:37 -0500
Date: Tue, 26 Feb 2013 09:57:33 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>
Subject: Re: [PATCH 2/2] pwm_backlight: remove unnecessary ifdefs
Message-ID: <20130226085733.GA17147@avionic-0098.mockup.avionic-design.de>
References: <001301ce1330$05b74d60$1125e820$%han@samsung.com>
 <001401ce1330$50d64260$f282c720$%han@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
In-Reply-To: <001401ce1330$50d64260$f282c720$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:qdDh+JAetJ2VFqvcghWav/SjlPWGaPoFOU6sT9lmRt3
 G7mojU6x3Y1ZmDKfNUUgnmDVMtxkk1K3dNEwVQnGTi7djKAVpA
 g6V/NaeuhcFAHD/iMhaclOHULyyRrVC7botbYtPf4xDt9sPv2M
 btDewCNRrc1Bd9Cdph6st7D9dfC4o67JDPX5JGU+qqoOhs2rgY
 PKVOaOZbA3FOICTOYpsyqaEgqmdMaduqrbMJGNSyVER0gd3pKs
 3CORkR6K5w9MgR/rPY4q3kXAxApyd2CNr4zaKxRW1NZSGVXCrv
 Cn0qrFe6NWZZF8owe5VR6ZKBo8TXkTLXQJwIvivWC/jIy47v+D
 GcQZ7QBt+yY/rHRtgxABGtb69uS9zREz607xrXVrLtkI/aXcZ/
 FKES7+NRm2FyzZtSV7gs9pdcCnYV87LTHM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 25, 2013 at 05:15:47PM +0900, Jingoo Han wrote:
> When the macro such as SIMPLE_DEV_PM_OPS is used, there is
> no need to use '#ifdef CONFIG_PM' to prevent build error. Thus,
> this patch removes unnecessary ifdefs.
>=20
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> Cc: Thierry Reding <thierry.reding@avionic-design.de>
> ---
>  drivers/video/backlight/pwm_bl.c |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)

Applied, thanks. I haven't been able to push it out yet, since
gitorious.org seems to have some downtime.

Thierry

--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRLHj9AAoJEN0jrNd/PrOhJ5UP/AgmL48+boaCgoQuJsES2XR7
jT3oImVmaJotwMLydkB0qGQatY6LkzgbqdxgPPTRoVH3LDYFUiUzDLlBD0v+kJ9O
b02xJasX7vdmqd4ll913NxOjn+bCb30TQuWaIZQCfQYyZLRaJEYVdQe0P4sZW3wv
2Nil8cPIOdn4KMeq7TV/cws9Iy5aPYoar/r5UawpFHySBOug2pCp3DUZrc36+TPf
mUB9VUPR1RA1TMaxXBqtFgMh2ti/wcTGyPiFQrtUkqsow2ph3Xy0+66ygs5ExfjD
w5r9rXbUI1zUHlFW0dzuE4ybUn3Clx8WcGbaSd3/YhOKc5CQ6YVJViN7uxz0+LC+
2Z/qkAf8iyduT0GX/sa9FKIMTt/OV36Ku+UpIm/3xf3yNfntTUuGNcBwBlHIR+mj
A66RqcvmpfG/SVzFFLH7fFkiGP8w/1tMfvFgzI7sMvBF+eQdmYw3v7hfb5WV7uke
Q+dYW+SaFXwHcit+7zhGntAssYIjNzBwOhYTjVFJbJmD5nnhh6nw7ORhr953Q5K+
OExUu9bnD9BYDnamHmDX8rpn4ZBJNfuk8Qtge9W5Px2oAn3M3Bb8l1XDFQaQcFgR
dvm/UAUfpEmjd/5d/+st/uqO05nTQICx+d12PlPJp/Zp6pcUyexeYBpegTU4gJNt
kMbxa1tkjD9lRHFpBm6O
=BYeW
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
