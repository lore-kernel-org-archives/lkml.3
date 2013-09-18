Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab3IRRhm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 13:37:42 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41758 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613Ab3IRRhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 13:37:40 -0400
Date: Wed, 18 Sep 2013 12:36:36 -0500
From: Felipe Balbi <balbi@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Linus Walleij <linus.walleij@linaro.org>, Felipe Balbi <balbi@ti.com>,
        George Cherian <george.cherian@ti.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Subject: Re: PCF857x and 16-bit GPIO expanders
Message-ID: <20130918173636.GT21559@radagast>
Reply-To: <balbi@ti.com>
References: <20130917190732.GD15645@radagast>
 <CACRpkdYn8yaTyFJMaC3vK4kGrQsaZpAX=pyn5y33ers7QhQ_pg@mail.gmail.com>
 <2356541.62QktiIBr5@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="80Ds8Z/hZmemMosa"
Content-Disposition: inline
In-Reply-To: <2356541.62QktiIBr5@avalon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--80Ds8Z/hZmemMosa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Sep 18, 2013 at 07:18:04PM +0200, Laurent Pinchart wrote:
> On Wednesday 18 September 2013 13:16:27 Linus Walleij wrote:
> > On Tue, Sep 17, 2013 at 9:07 PM, Felipe Balbi <balbi@ti.com> wrote:
> > > has anyone ever successfully using gpio-pcf857x.c driver with 16-bit
> > > gpio expanders ? We're having some issues here where toggling the last
> > > gpio pin (gpio 15) on a PCF8575 device causes platform to hang and I
> > > can't come up with any explanation of why would it hang...
> >=20
> > Bouncing the question to George, Laurent and Kuninori...
>=20
> I've got a board with a PCF8575 chip, but it uses I/Os 8 to 14 only as fa=
r as=20
> I know.
>=20
> I can try toggling I/O 15, but that will need to wait until next week as =
I'm=20
> currently travelling without access to the hardware.

alright, that'd help me a lot :-) Just want to make sure if we're having
a board issue, or PCF8575 is a bit screwy ;-)

Thanks

--=20
balbi

--80Ds8Z/hZmemMosa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSOeSkAAoJEIaOsuA1yqREUAoP/RmjGgpunquif5il7vnvP9+P
Be+5vMynpoVFe6idESL1nDSriXnLAeUJ36AhIz1IqAxnkCXdH3iGzQmgXCSmrXBf
Kbuaa0A3UCcWKSHpwLv092o6ie/EOFIQTEpYhs+Pe9xTX/3HpAam3zDeulFJIs0h
S8AUmHj6+4rRW3w5nkwCuICP2jtNLX4rXvKMjkwTWltqLwlZcf8pPhGMh2Uoe3IV
lFtcfdsg0usDiXGf4+kHA9y8S4IQuWe/JO3klIKFsE/CJt7ParhQGTMN98zMGIaC
J2Lju8S08/7phfC6nUT5U3k74OKXcIkGsvGo7Kq1vLoA6c5Pz+urRNmb7xYmqOWD
Itg2ezH9aaFyW7/kABCHmDyR+JPKuU+dwtuTcvaOxhZME1jrrficyABGh+gGgS8O
p/W9eSHHv8nmfEcWZIsXOHuXExvrVRh76K7ZppuI2qsBh+6QZpnlBxTjRXMy9l90
Y4Y/cIF2PBcvGLeWla8+s0X33TBTJecgF8Eq1ZpOQynlvbozdFuIfraC8Aa3AI0R
2ONWdVMjtFKri78yjgDxM+qQPT5PBDfXhXYW0OqHeyFwLm3oQSDi5lTtrkV67Erd
/zg0R0zu7K8djnIADGGykcDL5jj+gpEIq0igWaApQz967cvxNLTZKNzNoybBlCUP
t1DL2qEfP4UbS/poTRPX
=ZauD
-----END PGP SIGNATURE-----

--80Ds8Z/hZmemMosa--
