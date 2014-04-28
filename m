Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613AbaD1PBI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 11:01:08 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:44960 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557AbaD1PBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 11:01:03 -0400
Date: Mon, 28 Apr 2014 16:59:31 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: linux-pwm@vger.kernel.org, broonie@kernel.org, swarren@nvidia.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] pwm: ftm-pwm: Convert to direct regmap API usage.
Message-ID: <20140428145930.GC28443@ulmo>
References: <1395377590-23537-1-git-send-email-Li.Xiubo@freescale.com>
 <1395377590-23537-3-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7DO5AaGCk89r4vaK"
Content-Disposition: inline
In-Reply-To: <1395377590-23537-3-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7DO5AaGCk89r4vaK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 21, 2014 at 12:53:09PM +0800, Xiubo Li wrote:
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>  drivers/pwm/pwm-fsl-ftm.c | 83 +++++++++++++++++++++++++----------------------
>  1 file changed, 44 insertions(+), 39 deletions(-)

This could explain the advantages of converting to regmap. Looking at
this diffstat above, it's not immediately obvious that there's an
advantage because you end up adding 5 lines.

Again I'm guessing this is in preparation to add endianess support, and
it will be really easy to add that using regmap, so the gains will only
become obvious later on.

That's the kind of thing I'd like to see in the patch description. It
tells me why this patch makes sense.

Thierry

--7DO5AaGCk89r4vaK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTXmzSAAoJEN0jrNd/PrOhvRYP/jYJ24/oiAcaY67EZ5u1XPlT
HCT4KC2+n6zRh0tZVaKNK8cgcCr3eWD/cA536ItuPICy3pQ0MZob13tHHXb9ZNFq
5YxJFV5aGq438s+3+i1/c4JmQFpBKwdFcQoO4VP+VLeidGeVpiz6DfIPT5k4e7J1
IHv8bG6J3Lh67YMi0T+CirlVZyouSBXBrotTTSbYajg5ZYWZoHNLKlH2u7sHpPvw
IkHc+74kPWttR19vgB2cRRGwwwZJPpGOFIe5OUYKt2Tj/snSZ1yaa0lgl10KOIva
nLXKIvjE4whaO70S69SMxHgJq3Vxw4Kcp4s/ZKIBDcij6lrwbFSWDD5Ksjv6TAts
aYZI1a7M30+xheJYr1/3SQdzppg7L0nQRxKfi8BNktUDizUfTG+dxfqIZgGYDFQG
wm+KHw30R89mWdKFztEy0rRcWxQhKBglbmU3D/LqvP0uET1vhTvpycdxEnoq1/N9
sPf6/D/LQYYhACTdztuJW17+NL8yFLrSX8Pd1+iipNIYtE98ToIDj+uTDDaHziro
vDRSGkyPwH8lY2zwGvZdO3NZh4daI+u9ToOIaniro/wOEKwozfOJhrGzrY9UjqzF
ZAWYjD4TcMV3V8jt6D7Md8ZPmMIJVIc8qJVBewZzp31DzCSULWzSm0ceOgK3+U2J
IEAkt6AOdY/0kp5KN8Gd
=Fa26
-----END PGP SIGNATURE-----

--7DO5AaGCk89r4vaK--
