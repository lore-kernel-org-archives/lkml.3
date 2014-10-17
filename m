Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561AbaJQXo5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 19:44:57 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42135 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335AbaJQXo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 19:44:56 -0400
Date: Fri, 17 Oct 2014 18:44:45 -0500
From: Felipe Balbi <balbi@ti.com>
To: Steve French <smfrench@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: current mainline doesn't boot
Message-ID: <20141017234445.GA28891@saruman>
Reply-To: <balbi@ti.com>
References: <CAH2r5mvBOJHLbRXHMt50E97_1E2Q8F_=PH9=u6N3yuuqSQVmDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
In-Reply-To: <CAH2r5mvBOJHLbRXHMt50E97_1E2Q8F_=PH9=u6N3yuuqSQVmDg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Oct 17, 2014 at 05:44:02PM -0500, Steve French wrote:
> Anyone know a workaround for the problem booting current mainline?
> 3.17 works fine for me, but recent mainline since 3.17 goes to a black
> screen near the end of boot as X is about to start.
>=20
> I also tried the Ubuntu build of the day (which also is based on
> current mainline but with the Ubuntu config just in case it was some
> driver issue) which fails the same way.

you need to provide more information, here are a few queries which might
help:

1. which architecture ?
2. Can you get a serial console to get some dmesg output ?
3. after screen is black, can you ctrl + alt + F1 and get a console ?
4. where's you .config ?

--=20
balbi

--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUQantAAoJEIaOsuA1yqREZcIQALXEfnj5/HVsG7kaSGKd3KIb
s4InlhWlS0SWstVEMC3uBWmJ/R4aocRTYq8QHrg/Cs8MdJtLGO3CmEJmOuscRfxC
9w1iXSpyIV4tDb46mse9I2EeaoLTRYiyKFU8AQXhmn2i+/v9UzowrNl2Hyo/z6Ro
Gj8DaEX61tHCpVD+wIQcYJRtICo/TIW/HKM+15rMo81+yOerXvcz7JiijAo0fj3/
s0QLiCgrFNlJUz8CzhuFZJj+SKlplOg8Z2MfB7Imoqo8Oyz0z+/UKHTuhH9cunQo
2ZapOYrS2jxIhOyGVhNQ3VsH9SoLXQwDZUCV9YQc18YRIyGrHq7fepMHoLY0vZ7v
FNJ/GTmhTi+63imfXL0ups26LwkOaSKSB6WKCl/xIX1fdzgcnNgoItNHALaOppBd
Sh3qurmuakwWEgb120BJTBoLj4A/KVgPQKbjM4jr5A8XwsZARmXSKmN9FHXjc3FT
Zr2DuR6eGTGVgPNhlYGocLH+VBGu4bGsI97diNQvCEdKbK8CbbiYXk5jcn3RxvY5
Q1XZDIDr70+KCwv61ctwN8ZqqDKONmY0sB6ZNzrdGFv4HcwOEbWGq1cW8Bp2jr8j
7sw4oE3rxBvJpdCGYe8qUDakfaQPL15WL+9kBm9lXDYcyECbWUgxpBUfsNoT+71X
N8rHfkCbcsxxEjve8Rpx
=wPO6
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
