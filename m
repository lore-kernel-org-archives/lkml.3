Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab3GYPhc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 11:37:32 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57852 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755609Ab3GYPha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 11:37:30 -0400
Date: Thu, 25 Jul 2013 18:37:15 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Bin Liu <binmlist@gmail.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <balbi@ti.com>,
        <george.cherian@ti.com>
Subject: Re: [PATCH 06/16] usb: musb: dsps: rename ti81xx_driver_data to
 am33xx_driver_data
Message-ID: <20130725153655.GA31835@radagast>
Reply-To: <balbi@ti.com>
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
 <1374516607-2705-7-git-send-email-bigeasy@linutronix.de>
 <CADYTM3avh7GFTDQW01FnojKZkmL0_hi+=K-VVwCw5peJL2hwTA@mail.gmail.com>
 <20130725144118.GA5412@linutronix.de>
 <CADYTM3bJZKUjgddP1pddZvqg7CfVyayxEXfBoJFrhean79+ykA@mail.gmail.com>
 <51F14165.3060803@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V0207lvV8h4k8FAm"
Content-Disposition: inline
In-Reply-To: <51F14165.3060803@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--V0207lvV8h4k8FAm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jul 25, 2013 at 05:16:53PM +0200, Sebastian Andrzej Siewior wrote:
> On 07/25/2013 05:12 PM, Bin Liu wrote:
> > Sebastian,
>=20
> Hi Bin,
>=20
> >> Is it really there or was it never there and it has been added to TRM =
by
> >> accident?
> > The EOI register IS in the USB subsystem of AM33xx, but the SoC does
> > not use it because it uses level triggering for USB interrupt.
>=20
> I see.
>=20
> >>> But I am not sure if it is a good idea to remove eoi from the musb_ds=
ps
> >>> driver. If the intension is to merge the support for other SoC, such =
as
> >>> AM35xx, AM18xx, then EOI handling might be still needed. I just don't=
 know
> >>> how those devices use EOI.
> >>
> >> If one of the architectures gets added which need an EOI then the offs=
et
> >> can be 0 and the EOI will happen only if it is !=3D 0.
> > This patch cleaned up the use of EOI. Do you mean EOI handling will be
> > added back with condition EOI offset !=3D 0, when the support of new
> > device which uses EIO is added?
>=20
> That is my intention.

right, I agree. If there are no users for the code, just delete it. If,
eventually, some platform comes to need it, then we add it *after* the
platform's base code is merged.

--=20
balbi

--V0207lvV8h4k8FAm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR8UYqAAoJEIaOsuA1yqRETaIP/3aLk7dM5CnwJQHX0fTmIvkZ
vCLh2lxE5At/QV1Yrw1UXhTmeixVjpi9cddapk06gCE33p8tI7a4PtAoOMSeCh7c
1KP1/z24H4ASXJ8KWbLM73Lv9MTy5Y3qWeTr+7U/+nKvR3G/KMg2lZIbGsfwQGwX
P5+BUxaHu2CuDthciIwgKL/CJxS+Egn1UIDrPBhAF4uv8feRycqXW4roq7hrUdjY
L6Auwd1zPA4McArBeFC1QczGhVCEPv4uXvbRYcDs4nyN48T0ERx6/5XxDzR1/p6e
neNR1WyGe8o42WiXb/vLwBbkVV0wNBG7wowoq4qXsVNLEJSKFZq0/YQyL/RvideU
quIDB5GluCUYw+ldaZlCBl7ujGvEuBSBUX69MW2inkSfo61woO/b4rVWaRTC8ySy
1J7SsRoX0rPTBJPI2IjH6j9/f+uiuR7FV+JjgmQC4Kh0kDZm8kc0uGv5bBgZ7je3
MwBDAbR46j9LypgegbbaLwu2OilsQ0RaXkm2tZTF+j1RxuhhaH/ZHlcq44jgbkEY
T4uWs5QeGJpjcWc6W4HfbqNwyAFBPoIHbJaughwDr50ZCFvN747hXgysmNcW4l8v
ZGF/+bJJkq2weGFjjpeNcqRXCLMi5D6vHttyL8goRKUNZ5mgjGjlabc1nBx6LgfK
P6S/SwJoGqwJfcSc5hOj
=5zP1
-----END PGP SIGNATURE-----

--V0207lvV8h4k8FAm--
