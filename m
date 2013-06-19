Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964855Ab3FSTox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 15:44:53 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34665 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757362Ab3FSTov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 15:44:51 -0400
Date: Wed, 19 Jun 2013 22:44:46 +0300
From: Felipe Balbi <balbi@ti.com>
To: Grygorii Strashko <grygorii.strashko@ti.com>
CC: <balbi@ti.com>, Wolfram Sang <wsa@the-dreams.de>,
        Tony Lindgren <tony@atomide.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH 5/5] i2c: omap: remove omap_i2c_isr() hw irq handler
Message-ID: <20130619194446.GG4779@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1370630768-4077-1-git-send-email-grygorii.strashko@ti.com>
 <1370630768-4077-6-git-send-email-grygorii.strashko@ti.com>
 <20130607190750.GF15295@arwen.pp.htv.fi>
 <51C1FBC5.1030109@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m972NQjnE83KvVa/"
Content-Disposition: inline
In-Reply-To: <51C1FBC5.1030109@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--m972NQjnE83KvVa/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 19, 2013 at 09:43:17PM +0300, Grygorii Strashko wrote:
> Hi Felipe,
>=20
> On 06/07/2013 10:07 PM, Felipe Balbi wrote:
> >Hi,
> >
> >On Fri, Jun 07, 2013 at 09:46:08PM +0300, Grygorii Strashko wrote:
> >>The omap_i2c_isr() does the irq check and schedules threaded handler if=
 any of
> >>enabled IRQs is active, but currently the I2C IRQs are enabled just onc=
e,
> >>when I2C IP is enabling (transfer started) and they aren't changed afte=
r that.
> >>More over, now the I2C INTC IRQ is disabled when I2C IP is idled.
> >>Thus, I2C IRQs will start coming only when we want that, and there is
> >>no sense to have omap_i2c_isr() anymore:
> >so ? we still want to check if this device generated IRQs in hardirq
> >context. What if the IRQ line is shared ?
> >
> Pleas see, https://patchwork.kernel.org/patch/2689211/
> [1/5] i2c: omap: fix spurious IRQs: disable/enable IRQ at INTC when idle
>=20
> It covers shared IRQ problem

then you don't need $SUBJECT.

--=20
balbi

--m972NQjnE83KvVa/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRwgouAAoJEIaOsuA1yqREakAP/2WXc2sDuaXyC1ELVK7kCotf
L6yU5J1N2CcvEPtfuHmupHXAuwpkdilbF5q3HPDYbpQr1eRRQG0UfezkC4Thgeui
nYRDLjkO3SIJFgJqErkO9bsa+x4LK3k7dnUmLZiCPC+JszFIv6LNHtLgazAqQ+0M
HkOr9QX8aaM9CasesiayxWpXUbrsx10tCH7dTLzMu1vgepB2I+0ZcyBMPauEVwun
69U+C4+6HfC5iUezBhMneSqV+sbpaYvrWLWGjd//e2BZU8/E4GrW+2V5IDevr0e0
k0GiFJtPxc7J+g2Q7QQnqqVZuZV6gbjzpPgGd1ek3zQjdw2HkpQzIbwB7xzwRNwn
yEIVO4jvS/yDe0IWgug3bs4fntjInMLYXeYxItcu79Zonw2KCpfFRr7WEOxqkfyC
dywHrp/SaQwxy0LIg+bNtINsm78OLtDGEHlGFQdskqfGfpVMXfPNSO0hbA6P0ftE
tVERl0pnYrZvjXUgyHVBK1Ea9jtqxdyKm5ROKuOnPj0DktKO9Au6tplgY0rV4Ky2
6RJaYD3P8R8VrpFWx+gL3BgeydhTqQk576N98Dp2x4rw1SKMOhoc0qKdF3pb0eq4
ujR8o0hZeQ0iVfRnTvn0SHZBe1dinzHOLbszJA4hDFSVjPU2zio8vEhjkKor2BbC
FLqFd1pJ91aEBDRJX5tD
=EtuX
-----END PGP SIGNATURE-----

--m972NQjnE83KvVa/--
