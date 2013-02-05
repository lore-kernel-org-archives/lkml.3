Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178Ab3BEPiN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 10:38:13 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:50371 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab3BEPiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 10:38:10 -0500
Date: Tue, 5 Feb 2013 16:38:07 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Kirkwood: Add missing linux/i2c.h include
Message-ID: <20130205153807.GA22220@avionic-0098.mockup.avionic-design.de>
References: <1360077025-8046-1-git-send-email-thierry.reding@avionic-design.de>
 <20130205153411.GV14746@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
In-Reply-To: <20130205153411.GV14746@titan.lakedaemon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:NyOizw9K8VZnJ5D7yayC4S1HZpqCm15oqDw/SXEyejC
 yiVwGA9C6lfh5yIk4VqIUexwGXON1ARGg0YDZK8KzG7qjh6zhQ
 cI9c6KbceyPwRDFINJCutde6Br6p0FrNGiZLKpd1j7lHd/PvQo
 sLECIVmMth8ErgSy1qGfEFBGCdeN41IUXKOJF9txxwYhXzN0dy
 EVkUtLFyE2JBtWAGT9j22Vd1cxaqntZe8FZ/+dQHDVH9z+fZS3
 W9ZJiCyXWhiaA45QK7EmY+YP/SZTzrpDMwV2QrlA6bXS8YXNZ9
 fNoNDr3UATLWyAuTeY1vy33IuLUkq3r3n0MkOaWZNZWDwmrexo
 IPKQnVHUPkncN6kxECnIfFuYbUYzFXn6c/JaPLE7HXSZcQDUWs
 Kq5j/hLy011vh9fcHEbuNYNmkKIcpBN58xmtys2I07Ak+Hgzaf
 c90k0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 05, 2013 at 10:34:11AM -0500, Jason Cooper wrote:
> Thierry,
>=20
> On Tue, Feb 05, 2013 at 04:10:25PM +0100, Thierry Reding wrote:
> > The nsa310 board uses I2C_BOARD_INFO and i2c_register_board_info(), both
> > of which are defined in the linux/i2c.h header file.
> >=20
> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> > ---
> >  arch/arm/mach-kirkwood/board-nsa310.c | 1 +
> >  1 file changed, 1 insertion(+)
>=20
> What is this based against?  We're in the process of removing this whole
> file for v3.9 (pinctrl, mv643xx_eth, and i2c)...

It's based on today's linux-next, so if you're going to drop that file
for 3.9 I guess you can ignore the patch.

Thierry

--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRESdfAAoJEN0jrNd/PrOhYXQP/ihWioAKeFFeEDg6gQiGrFyM
WUnBK7VfPvfjDB9tWxFqo25e2B3Vwpph1c0c/EWZE/FMGpnN1JsLg6uybDP3qhA6
JxISb5Ifw3QyKrmXCMNT/H/9pAW8zi+VfpvyM4RkuHv3PN4z7xrF05C9gYRPooL+
jfB06LF1HAlkSqP/c4wVVD3Vk5u4T1E9JOlsFDZLd323TetTHfj0xVQ77k6aqkep
HUVJBRD08E0g4kxPpResoeSbsIK3u+3lj0UUIfSp/JjAi5dWG5skPjifG9Sg9mWE
1gQV6QjBuyhbyrOlO/w04S3TMQ/BXIVmIQNqQ8oO6EoXz0vPzlJUUTfG3C9oUUsu
uxskpzGcDpYGLvwqe/kN3sp/S0oqD3KlAtODj/2hoSkCVAwMIidvo2eKRortYVdp
+Uc6ygYCk0RrWly1IX8epnt3gxM9fwIvCVwjVcOfEj7IZrwU3pZtFpH48cBQTFA4
o3CQlr0vSeBHBZBg4tnXCwhYnTzlvFOOfqYO2npsL7NHfpcPzDnJF0lQqzDEFjzL
Avx6cDRDBkh23diRHTGCpWLP/SDow8cU0qvtL4C7DWSYggwlk5UDHJvo5rEamF9c
nUOggkcG7vyX5Ho6Y/DNqizyvP3F6x5MjHH5OlLaaO3Qoo7Wn1W4knmF69hgDTJz
LL6SvDSul2+aI5wMUCOc
=A92a
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
