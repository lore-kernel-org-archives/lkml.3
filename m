Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab3LSSXV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 13:23:21 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:46310 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755716Ab3LSSXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 13:23:14 -0500
Date: Thu, 19 Dec 2013 12:22:27 -0600
From: Felipe Balbi <balbi@ti.com>
To: boris brezillon <b.brezillon@overkiz.com>
CC: <balbi@ti.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Landley <rob@landley.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Jiri Prchal <jiri.prchal@aksignal.cz>,
        Ben Gamari <bgamari.foss@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Pekon Gupta <pekon@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Subject: Re: [RFC PATCH] gpio: add GPIO hogging mechanism
Message-ID: <20131219182227.GB4536@saruman.home>
Reply-To: <balbi@ti.com>
References: <1387463671-1164-1-git-send-email-b.brezillon@overkiz.com>
 <1387463671-1164-2-git-send-email-b.brezillon@overkiz.com>
 <20131219164109.GB27409@kroah.com>
 <20131219164737.GA4536@saruman.home>
 <52B32A70.1080700@overkiz.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+g7M9IMkV8truYOl"
Content-Disposition: inline
In-Reply-To: <52B32A70.1080700@overkiz.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--+g7M9IMkV8truYOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 19, 2013 at 06:18:40PM +0100, boris brezillon wrote:
> Hello Felipe,
>=20
> On 19/12/2013 17:47, Felipe Balbi wrote:
> >On Thu, Dec 19, 2013 at 08:41:09AM -0800, Greg Kroah-Hartman wrote:
> >>On Thu, Dec 19, 2013 at 03:34:31PM +0100, Boris BREZILLON wrote:
> >>>GPIO hogging is a way to request and configure specific GPIO without
> >>>explicitly requesting it in the device driver.
> >>>
> >>>The request and configuration procedure is handled in the core device
> >>>driver code before the driver probe function is called.
> >>>
> >>>It allows specific GPIOs to be configured without any driver specific =
code.
> >>>
> >>>Particularly usefull when a external device is connected to a bus and =
the
> >>>bus connections depends on an external switch controlled by a GPIO pin.
> >for external switches, you probably need a pinctrl-gpio driver.
> >
> Do you mean using pinctrl pinconf to configure the PIN as output-high or
> output-low ?
>=20
> This was my first proposal
> (see https://www.mail-archive.com/devicetree@vger.kernel.org/msg05829.htm=
l).

that's quite a weird argument from Linus W, considering you _do_ have a
discrete mux on the board.

We have quite a few of such "crazy" scenarios here at TI and we were
going to send a pinctrl-gpio driver. If that's not acceptable, then I
suppose there is no way to boot from NAND on a board where NAND signals
go through a discrete mux where the select signal is a GPIO pin.

--=20
balbi

--+g7M9IMkV8truYOl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSszljAAoJEIaOsuA1yqREtgsP/1WvRak84V4bEBUj0U5HHlIx
NS8+0pCNsRInkUB0lE9RlmxUoy5wUG93Ya54d3B1mwpi5ELxO9ypj+vjL4zZhfdG
f3/ltNclqcZvIHViUkEIWZNTPHEMR7EyEeJIzeDIUsDxwoYOvmecIpF0ESLixgXc
Ae2EWQ6w39nJRvLsRT8WnzCewvQ/Q2P88jAN87QWAcnw3p4cuxdMMirhe0ShXn80
MLW4oOPvhIYQpsrjqEa4eKzInXaUvmqXoRUB7hXpLB1vwxUpxfjiMo3XJg0kvzqC
beMefSJUfIZiLov9ZMprGCuOynlH65hNaaTLPcI9bT+0IIlsWZKvZdBZM5sMLTbN
68Auywnds/ulskm8pOXzN09SpQB4Z1x6BnsCJpoemelPT9B04f4bCUU0ws0KwmeM
oA0PeYmvKCfx5KPezxpXLoMTvnzVYF5YKBwdTHS1/Dq0XlaIOzGf+yuH0B3kulYw
G6xfbbpu59rcAdEGkg/nYEvSJh9C78BZeVMbgtFsatcu/iom9FD8w3X6t24IA21E
s8Ffitm92Z78MA7Gdn4O32nT8ssg2SKcNHnhqyNuBPK+kCZ+Hkn73UIuQp8oHxPh
mFYXznNa3bqKnlDAwCQQo3ohBuvqsl069YI9qBY7a9CS9Q8v/B6Dp3y49ZMKAnMf
m1U7f8WuqmtkRbBiQTb5
=Ly0q
-----END PGP SIGNATURE-----

--+g7M9IMkV8truYOl--
