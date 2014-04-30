Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759479AbaD3UNF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 16:13:05 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47028 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbaD3UND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 16:13:03 -0400
Date: Wed, 30 Apr 2014 15:12:48 -0500
From: Felipe Balbi <balbi@ti.com>
To: "Bird, Tim" <Tim.Bird@sonymobile.com>
CC: "Ivan T. Ivanov" <iivanov@mm-sol.com>, "balbi@ti.com" <balbi@ti.com>,
        Timothy Bird <tbird20d@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v7 16/20] usb: phy: msm: Fix PTS definitions for MSM USB
 controller
Message-ID: <20140430201248.GG3839@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398354495-20782-1-git-send-email-iivanov@mm-sol.com>
 <1398354495-20782-17-git-send-email-iivanov@mm-sol.com>
 <20140430162705.GL23679@saruman.home>
 <uukd0l7rkvba4wtolmxef0a4.1398881225694@email.android.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LiQwW4YX+w4axhAx"
Content-Disposition: inline
In-Reply-To: <uukd0l7rkvba4wtolmxef0a4.1398881225694@email.android.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--LiQwW4YX+w4axhAx
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Apr 30, 2014 at 08:07:05PM +0200, Bird, Tim wrote:
> Signed-off-by:Tim Bird <Tim.bird@sonymobile.com>

thanks Tim but I already had your SoB in the patch, I need Ivan's :-)

>=20
> Sent from my Sony Xperia=E2=84=A2 smartphone
>=20
> ---- Felipe Balbi wrote ----
>=20
> >On Thu, Apr 24, 2014 at 06:48:11PM +0300, Ivan T. Ivanov wrote:
> >> From: Tim Bird <tbird20d@gmail.com>
> >>=20
> >> Fix the value used for Parallel Transceiver Select (PTS) for the MSM U=
SB
> >> controller.  This is a standard chipidea PORTSC definition, where
> >> a PHY_TYPE of 10b (<<30) is ULPI and 11b (<<30) is SERIAL.
> >> Fix the definitions and use them correctly in the driver code.
> >>=20
> >> Signed-off-by: Tim Bird <tim.bird@sonymobile.com>
> >
> >since you're the one sending the patch, you must add your signed-off-by
> >too. If you reply with your SoB I'll add to proper patches.

--=20
balbi

--LiQwW4YX+w4axhAx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTYVlAAAoJEIaOsuA1yqREIgsQAIbpA5OvT1TTySScxreeIuF+
dQca6uaezPXEOIYX7K5PiOuMhq49x5QOkaJdS9wGdX16HGpd6t/1dUa69+wOMyJD
PyPO5QlAqHXe8PiyIUfXEjoUN9sTIkgh3rQJwx1a5fJhwweya71/29GZ4naVPsxj
1eQmSRPOmVYq9VDBf/0aFZNArgygH79BgHIXvvnCIVWGC5cefBz9wE7au0oskUS9
C9R5AtpnrBNLgOVtuFjzR0gPP9uopXonNGKmyf2Zx/LRlkygdPZZKO4TOXg/UjgG
pe3mHsV6FpaZETDTKdtN5b3isCzRZkrAL96lMaQiv5G39HrOO0qkYvikp5Z/vn2g
ojzY6QqRe7oM98cKo7RhHc2PvKJSNetI2W9Pr4bpCjS72gZbTm6JX6Z3eGEDCU/B
1VyXiA2NUgvB5Ch1rD9gdzzegXh1cP2Ui4wK4xi9YzYsTfVqxlO2W5Vz9EnhQPuP
j+LjVOMOuzNIsCO6lwkxTqTs3wHBM+wzfbukKCohHI68tMoc+jIlcBTPLIOye/+7
Fo4efsJZSvbhwwifM9IMyb0K1B44KJCT1u1PiaoHv3jk5La/3bn5z9++6i9XWcwM
sYxbz5WVlZlFocdO2IbYxeSWJjOyX9eKybIZeFtRYJy17dW55SV5P0qq8VbEx8+H
LYgA0zUjIzw+LJPIWXcI
=hquh
-----END PGP SIGNATURE-----

--LiQwW4YX+w4axhAx--
