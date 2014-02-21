Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879AbaBUPdL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 10:33:11 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:34814 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755483AbaBUPdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 10:33:10 -0500
Date: Fri, 21 Feb 2014 09:31:16 -0600
From: Felipe Balbi <balbi@ti.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: Kishon Vijay Abraham I <kishon@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Felipe Balbi <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kernel@pengutronix.de>
Subject: Re: [PATCH] phy: restrict Samsung S5P/Exynos drivers to the
 respective architectures
Message-ID: <20140221153116.GC31902@saruman.home>
Reply-To: <balbi@ti.com>
References: <1392991526-20895-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5UGlQXeG3ziZS81+"
Content-Disposition: inline
In-Reply-To: <1392991526-20895-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--5UGlQXeG3ziZS81+
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 21, 2014 at 03:05:26PM +0100, Uwe Kleine-K=F6nig wrote:
> Enabling these drivers on platforms not created by Samsung is useless
> unless you're doing compile tests. So don't offer the users to enable
> them without COMPILE_TEST for configs with S5P/Exynos disabled.
>=20
> Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

fine by me

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--5UGlQXeG3ziZS81+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTB3FEAAoJEIaOsuA1yqRExkcP/3T2SUxrk1IjXQhV+siEGRvF
g6dp9rMvxfRxczq6NxfaKTDFJ47Vfd0NpA7UDOYVo7IUYobLn3e6WpUAjxAQmyVC
5YluBQxaVeafTlsdh/wsulySQ/rS6kduDai0ntCkjezMR3paF8SjoZN6Qxa4Uaqn
c2zCRa5oYbA7dah4uJ4YaxcWKJm2KqzwyTETu0otOqUfnrQVWRFzcPaji7fceeBt
QJfLmp6YeBlK9tPlpPEmNdxmVti/lsVESpkxWOUtYYkkjyQ7pho43q+yw+EueXQI
i2qZRa2Hco+JNX4VmcYsTRybXrRNtjHAXUjVwDyxzL7I40ckBv1fLRmfTtLAJUcq
v3qZ/N6UpCNvUUo9IZqvTZXq0pnhqVhefxEoAZilkgEfGXZDMsGwpjcgS5rBb0cY
LxrlBnjklLLnvWZYhcqyixPfx4HvaYhLw9K/RZyZcEGZj6E9/NluPIF+ktYJ6BRR
fZ7rHG+q/syAXfRxCMBU0dbVwyHOOBz22nPlO6imEfor+a8eJhJs2NumxDwuk5IH
zU4MAaM0n65Be0RmAoE2jmfFzn5Q/B4UR1/SAWk8B0Nb4w7bJgGxJkwtNW/NDKbd
Q+B14GAAFUQCEhKLyd0inv35cLBmeW89zBTJ2m+3Jh1Br3ub3CfmFBCirnw3JzMX
5tPBtZsW03uOTnUJRqcf
=ovH6
-----END PGP SIGNATURE-----

--5UGlQXeG3ziZS81+--
