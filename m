Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290Ab3G3JA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:00:27 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:39786 "EHLO
	mail.free-electrons.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755529Ab3G3JAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:00:24 -0400
Date: Tue, 30 Jul 2013 11:00:20 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        Albert ARIBAUD <albert.u.boot@aribaud.net>,
        Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH 07/10] pinctrl: sunxi: Add Allwinner A31 pins set
Message-ID: <20130730090020.GF1441@lukather>
References: <1374618312-19001-1-git-send-email-maxime.ripard@free-electrons.com>
 <1374618312-19001-8-git-send-email-maxime.ripard@free-electrons.com>
 <CACRpkdZ1RhsLMC0xWDDr9Hmy78i+uU-9x0-2Y+_NvRZ-yefmVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXr400anF0jyguTS"
Content-Disposition: inline
In-Reply-To: <CACRpkdZ1RhsLMC0xWDDr9Hmy78i+uU-9x0-2Y+_NvRZ-yefmVw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BXr400anF0jyguTS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Mon, Jul 29, 2013 at 06:20:13PM +0200, Linus Walleij wrote:
> On Wed, Jul 24, 2013 at 12:25 AM, Maxime Ripard
> <maxime.ripard@free-electrons.com> wrote:
>=20
> > The Allwinner A31 SoC uses the same IP than the one found in the
> > A10/A13, with only different pins. Add the pins and the associated
> > functions found in the A31.
> >
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>=20
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>=20
> Will you carry this through ARM SoC or do you want me to merge
> this into the pinctrl tree? It seems pretty independent.

I'd prefer if you could merge it through the pinctrl tree.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--BXr400anF0jyguTS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR94CkAAoJEBx+YmzsjxAgDsEP/1LKwK0YexuHGl6CSt9byI9E
X0yqRNYsUSUqjNqLan0jEA5w84ZxGv5a9loYrKh0vWYzllZUtDjZ9sAsrB3qWIvo
On6A86kFRQf7qBDKTdHWaWJILrR9bqsPQq5vJz6dTjABdfo8ZmZ8xRDFbfzl8mgI
/T9A1zEBXtSu5sYeOf747jzd5UU5vhF2zS0o8VUyqvab6d8wZEjAz2s8R891u8Nf
YEBz0gMYQFV7sFW9sZlfk1RD1zkCmQrPJbpZd7Vx7xJFSuJCOinK1DjckYNya7WY
kDuUPuh2Z3oW3nkeIXfhDx5B5uJfh3FdVg69VXS+zKcbaZz3JQ+VO0YvyIwJn7Ti
6AqbW5oMH1NJ3AAay07XVHF0EMQqmxEalmjb+ZjIVGEgHK8OFzdioq8aHmrSdBpx
+j8djh8pGKgYjZ6rrMX+9NVTZZ6lclxu+LsGFxvpROcderMH4dTzTwI2EMMPu7RQ
hyh3PfRzrwnNNoI7HZ4XOnzdrdwMoo7hatQWbLFQZ3UrdDNDtzlRdsdMJ93OoY8d
QEW/uC8uLln89PbibE1E+AEwcexrmxc8sDv8GPdYNu1DaCEE8XosCQk50+Plor+F
yB77RDyaYDNDbPHeBbtOapQxnlz5Rtrne0jjCzfpY78WbSLucmuIq0BV7lP1lPLl
9I0obY3qJZ9feq2lHSVp
=MQko
-----END PGP SIGNATURE-----

--BXr400anF0jyguTS--
