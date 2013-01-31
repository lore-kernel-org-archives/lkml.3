Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab3AaNGm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 08:06:42 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51757 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753872Ab3AaNGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 08:06:40 -0500
Date: Thu, 31 Jan 2013 21:06:33 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ASoC: Ux500: Fix build error pertaining to missing
 include file
Message-ID: <20130131130631.GA12824@opensource.wolfsonmicro.com>
References: <1359635640-1932-1-git-send-email-lee.jones@linaro.org>
 <20130131123744.GG11078@opensource.wolfsonmicro.com>
 <20130131130340.GB2042@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
In-Reply-To: <20130131130340.GB2042@gmail.com>
X-Cookie: You'll be sorry...
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 31, 2013 at 01:03:40PM +0000, Lee Jones wrote:
> On Thu, 31 Jan 2013, Mark Brown wrote:
> > On Thu, Jan 31, 2013 at 12:34:00PM +0000, Lee Jones wrote:

> > > Some compilers complain when building sound for MOP500:

> > > sound/soc/ux500/mop500.c:27:27:
> > >         fatal error: mop500_ab8500.h: No such file or directory

> > Should be kernel version dependant I expect...

> What do you mean?

I'm a bit surprised the compiler would change something like that, I'd
expect it to be more the build system.

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRCmxMAAoJELSic+t+oim9BakP/38PRkZEaLsE/isHW5fdJy04
IH1OKQ36Ntoo3tNTDsRBtyn+NzyHS+5y2R1wm/SWeV8vKEN4P6BMdXW+WGuIPrIp
Q/2ggAxq1ChsqoJvNl7LFYG32BLQwTPESJDpkvnpZ7wVjLsOuvLhIva+xqA1sz3c
wiyn3f9HHquQaBmbwqjpYVFqB9a01RyQGPwYoTJ2ulQnCywAMgNwaxsvs8/2mQi0
A6KLjeIHWjgVHRsoUwEnluMvbqxmPe4K8bGVpKA9P5F7xAyJi1u9CNiidxWKTYAQ
eWcySCiQNncBXcdLgIYaT/vy85PVPIBHYn/5ccKX3iyKdFWzYWtcdSeT3cs+sb8a
qy6AZL2bA7pC5vKp/ITyhRUBfDLavTqYUVh0+JGEJeza77tk9F6H7gcUya/3w/bC
aFg+iXHDnWf21fyeiKoaSd+X0q0yIDpbFSqcRPLYy0dvZTG6rHsQzXIuV5MmwP5R
3GNVIkseVB8/lGoNAmC8NLVx4K/ZUNjzFFMZe0CJSYIoEWXtrgeKxdkbaB5jPKKB
Wb2g57HykENzKVHoWDEKJUi6sWdvwvS5gSOOp0v3Js66Wavj2vlu1ebc4FtjJxbx
U5/ljNHhgXoKaJJNBIKKSywX4drgptMWZA4qcJ3ANNEEy09PmNC0QEsaYlymrnxY
1Re9fMGLD+YBKhKIPs9n
=crB6
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--
