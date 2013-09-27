Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab3I0RCb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 13:02:31 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51109 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752377Ab3I0RC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 13:02:29 -0400
Date: Fri, 27 Sep 2013 20:02:27 +0300
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 23/26] ARM: sunxi: remove custom .init_time hook
Message-ID: <20130927170227.GW2954@lukather>
References: <1379526839-14798-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1379526839-14798-24-git-send-email-sebastian.hesselbarth@gmail.com>
 <20130925200731.GM2954@lukather>
 <5243D11A.5090808@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pzbqGaOtRNiVr7w4"
Content-Disposition: inline
In-Reply-To: <5243D11A.5090808@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pzbqGaOtRNiVr7w4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sebastian,

On Thu, Sep 26, 2013 at 08:15:54AM +0200, Sebastian Hesselbarth wrote:
> I am still waiting for some ACKs (nomadik, prima2, socfpga, nspire) and
> possibly Mike's on the clock changes.
>=20
> My current idea is to prepare a branch for Olof to pull in as whole.

Ok. That works for me. Tell me if the plan changes.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--pzbqGaOtRNiVr7w4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSRbojAAoJEBx+YmzsjxAgockQAKL+HdxebREJW8eLDWhO/PNU
2nrSj8VN8HJl7onuXxsYEqXhZAyIY24+XY4EojJgE1YFpSSntnBFd2WHDTFCmYuX
Ste9u16fHwHSnfmQ8NpDa9ML/Z3/F9VgEBJ9o7B5E3m3SGIUTstEesyC81GUEff1
m6KISrNIlS5KA5QRCGNzJkNMi01xZmZbB7a0AlPpM9WWNIz85BaPdpNmYfh75q8B
XVELTiCIbV1KpqfmUrJjyw8wUcB/K1RD2mEx1F2yv6MUjuzJLpsYcoGgicLfYDSu
yLwEvBFewn3Fz0IFB61t9j9XcbWocY/UTPW6c4AEBAXLKCFIK/KV/1rAj+XlTffN
rmuV4wiaj3wyNiBunOlsmUC9dHpSi7JQy1AoiUr32w5uvwGBBLrsf+E6tSkeUSTW
WWRa1AuJbvSB47fQFVfx8zWh9uLwbDyqvElUkBgiPnOBIawS4MrhK8vmpaxP3kJt
Luwm+2T8jeFjjt+aI+1gPnIdz4JU3VrZZ3FsryKv7e6NwwXitHRvIt6H1b/qMqNF
awEbhmvzXKPWkE2P7zfD3z7YPaf/842PddHtdfNJaZhZbGPI62xLqmy/W3btBBZz
1nvqfwmjZiM0sIpn4DmZlvNDjPuJfk84nHwneXaAh7BQmK/KEnnEZBTqG7VsOZ+T
BBVYhK5QKuRaB+8I9V2n
=9l51
-----END PGP SIGNATURE-----

--pzbqGaOtRNiVr7w4--
