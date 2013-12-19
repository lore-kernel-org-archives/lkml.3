Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab3LSQs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:48:29 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:41343 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755393Ab3LSQs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:48:27 -0500
Date: Thu, 19 Dec 2013 10:47:37 -0600
From: Felipe Balbi <balbi@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Boris BREZILLON <b.brezillon@overkiz.com>, Rob Landley <rob@landley.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Jiri Prchal <jiri.prchal@aksignal.cz>,
        Ben Gamari <bgamari.foss@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [RFC PATCH] gpio: add GPIO hogging mechanism
Message-ID: <20131219164737.GA4536@saruman.home>
Reply-To: <balbi@ti.com>
References: <1387463671-1164-1-git-send-email-b.brezillon@overkiz.com>
 <1387463671-1164-2-git-send-email-b.brezillon@overkiz.com>
 <20131219164109.GB27409@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
In-Reply-To: <20131219164109.GB27409@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 19, 2013 at 08:41:09AM -0800, Greg Kroah-Hartman wrote:
> On Thu, Dec 19, 2013 at 03:34:31PM +0100, Boris BREZILLON wrote:
> > GPIO hogging is a way to request and configure specific GPIO without
> > explicitly requesting it in the device driver.
> >=20
> > The request and configuration procedure is handled in the core device
> > driver code before the driver probe function is called.
> >=20
> > It allows specific GPIOs to be configured without any driver specific c=
ode.
> >=20
> > Particularly usefull when a external device is connected to a bus and t=
he
> > bus connections depends on an external switch controlled by a GPIO pin.

for external switches, you probably need a pinctrl-gpio driver.

--=20
balbi

--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSsyMpAAoJEIaOsuA1yqRExS0P/1wtnAocUCNJISCVJ/DqjF11
XAoRoOiM5Y3izG33kbnZE1vSArFuJYd4UCDXQywbn8ljAJQ/5Kx2lQKYTHOhRMLN
fF1ciDv4NfuvKK/e2wGK3v4GJg7MaUqCmwl3wutdUa3+o0n/kL06ncz3Ny41ft5p
Wassj3JY4loqBEH9rX8pCxbPmhZJHn6rqB3S4yvUHFopf08YvSKKpb38xUtY1vUu
24gvUQayeenSHF3uPN1hEkICaezSAsjhOkGT2vlfG+BayQd6ltiSfTj1KysoI7xe
cedIz4LrEaOuOIDBUUqlAPYKlF+yDZLgE1oRJ0jjgKzJYQJPXjI0tFN29LlBbElA
U14GoStm/JqbeLUc1tIxjG3vren1A5IJqvii7CAuINHAF3HRz4otXWe52W6iAk6u
UWYRzn7jU3OEWHw4BYNhO7IK0y2YEEuTYDnxBPXFp8VyHj24pQ8eCyfoLFuYckSt
A4KV1oTP3PtBZsiFvQLwRt1Qkg/6vt5PvxBGfpHFYkvd79EKohE5WJZzNo9w2t3Z
s9P2hDv2SSEbpfjVfCHfq6yP0gXVJa2/celzvWBc5s7vk+6KQgyjyvhLHHehJ2a/
s08hwz7OXQEy0U4XoE8UzZUPq8pkc9I7sk4EankaYr1FQpSs45oC94I9v70TOLog
D8zleZv0y4JnD/xLu9KV
=7IMU
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
