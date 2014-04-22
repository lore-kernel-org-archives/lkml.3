Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924AbaDVPUY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:20:24 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49704 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933154AbaDVPUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:20:15 -0400
Date: Tue, 22 Apr 2014 17:18:40 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Chen-Yu Tsai <wens@csie.org>, Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Subject: Re: [PATCH 2/7] gpiolib: Support purely name based gpiod lookup in
 device trees
Message-ID: <20140422151840.GH24905@lukather>
References: <1397544101-18135-1-git-send-email-wens@csie.org>
 <1397544101-18135-3-git-send-email-wens@csie.org>
 <CACRpkdZ+3dnhoj1TS4KSVUP8iFHsjjwop-FG2Nf07YtH6aSO_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7J16OGEJ/mt06A90"
Content-Disposition: inline
In-Reply-To: <CACRpkdZ+3dnhoj1TS4KSVUP8iFHsjjwop-FG2Nf07YtH6aSO_Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7J16OGEJ/mt06A90
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Tue, Apr 22, 2014 at 05:00:17PM +0200, Linus Walleij wrote:
> On Tue, Apr 15, 2014 at 8:41 AM, Chen-Yu Tsai <wens@csie.org> wrote:
>=20
> > This patch enables gpio-names based gpiod lookup in device tree usage,
> > which ignores the index passed to gpiod_get_index. If this fails, fall
> > back to the original function-index ("con_id"-gpios) based lookup schem=
e,
> > for backward compatibility and any drivers needing more than one GPIO
> > for any function.
> >
> > Signed-off-by: Chen-Yu Tsai <wens@csie.org>
>=20
> This looks a bit scary and I cannot claim to realize the entire semantic
> effect of this patch, but if it's the way to go then OK.
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>=20
> Shall I just apply this to the GPIO tree or are you carrying it along with
> the other stuff?

This patch has a dependency on the first patch of this serie, since it
uses a binding that was documented there.

Maybe you'll want to wait for the ACK from the DT maintainers to merge
this one.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--7J16OGEJ/mt06A90
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTVohQAAoJEBx+YmzsjxAghikP/3+d7x/cOh/rUcDI1bOWK4Fx
0XjUbtBEF2sOa19nAZHtEd+fRUa+KbhmTAUZ0OaEHsPpi6Xr/lfOTifV4yEZFSDm
Nz1PkCgNYjxm/NG2d8Q4qj46pZW6O0Qz4JjN+MvgAV0QZmEzfHS9ChQ+tytumouo
KwD+aQkmIb0BnT+76WJ53fDGgKK7Q7OfwNSf6gdhM3+1x8uRfIebW86W+rEW8CQZ
8+R/Pa5cHmJPn0gZ+Gy/zvbANgRx8/egGRc0WyVGHn9Pj4oeksxs0KccosR8njwm
/Hsqvo055C4rWxvpDexOWMEnPNi6kC30OU1RoOS1dacitiiABNV28AMqJDpwBxbd
/irRyFIuCu59Y2k837qusFhat5YvV0sDONnTq3R0FxFAM8x7gXjUiA89n3clvcE2
kcwCnePsAhkEAgXbcgDJw0x3WsuNc/2zTSedIMSttC6glOZds/t/sHlqMCixNrIs
sCYDbnRyzz+JK5N+BdBjLjheJj/HswrcSU5pIxTQyYwYxzEs+Iv/KPmTnYiHHFYx
mQffbuRiz9ar6TnkeA7WqHN/rQCuxMxbGDJlL+l+Xt2aB07ErIdnshuvIMmS7r/K
eu+Hd1EuOSTuKBmOTGHJplpSRoUnPPDyy1VjP6HgCmoXAwElWyDQmLh+2g+guCLr
4blTWUNXARWmv6zkR4si
=qTY8
-----END PGP SIGNATURE-----

--7J16OGEJ/mt06A90--
