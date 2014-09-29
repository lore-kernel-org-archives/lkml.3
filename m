Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbaI2JzL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 05:55:11 -0400
Received: from top.free-electrons.com ([176.31.233.9]:45416 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753238AbaI2JzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 05:55:05 -0400
Date: Mon, 29 Sep 2014 11:52:27 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Shuge <shuge@allwinnertech.com>, Meng Zhang <kevin@allwinnertech.com>,
        ctl <ctl@merrii.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: Re: [PATCH v2 6/7] devicetree: bindings: Document supported
 Allwinner sunxi SoCs
Message-ID: <20140929095227.GD4388@lukather>
References: <1411570141-29960-1-git-send-email-wens@csie.org>
 <1411570141-29960-7-git-send-email-wens@csie.org>
 <20140925133609.GK15315@lukather>
 <CAGb2v65pKo=6BC-HaMsEMq-bcQcoHZNc9GiX+kfTBgP1PE5wMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TD8GDToEDw0WLGOL"
Content-Disposition: inline
In-Reply-To: <CAGb2v65pKo=6BC-HaMsEMq-bcQcoHZNc9GiX+kfTBgP1PE5wMg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TD8GDToEDw0WLGOL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 27, 2014 at 09:08:46PM +0800, Chen-Yu Tsai wrote:
> On Thu, Sep 25, 2014 at 9:36 PM, Maxime Ripard
> <maxime.ripard@free-electrons.com> wrote:
> > On Wed, Sep 24, 2014 at 10:49:00PM +0800, Chen-Yu Tsai wrote:
> >> This adds a list of supported Allwinner SoC bindings.
> >>
> >> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> >> ---
> >>  Documentation/devicetree/bindings/arm/sunxi.txt | 12 ++++++++++++
> >>  1 file changed, 12 insertions(+)
> >>  create mode 100644 Documentation/devicetree/bindings/arm/sunxi.txt
> >>
> >> diff --git a/Documentation/devicetree/bindings/arm/sunxi.txt b/Documen=
tation/devicetree/bindings/arm/sunxi.txt
> >> new file mode 100644
> >> index 0000000..d7d1039
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/arm/sunxi.txt
> >> @@ -0,0 +1,12 @@
> >> +Allwinner sunXi Platforms Device Tree Bindings
> >> +
> >> +Each device tree must specify which Allwinner SoC it uses,
> >> +using one of the following compatible stirngs:
> >                                          ^ strings
>=20
> Will fix.
>=20
> >> +
> >> +  allwinner,sun4i-a10
> >> +  allwinner,sun5i-a10s
> >> +  allwinner,sun5i-a13
> >> +  allwinner,sun6i-a31
> >> +  allwinner,sun7i-a20
> >> +  allwinner,sun8i-a23
> >> +  allwinner,sun9i-a80
> >
> > Maybe you can just add this info to the already existing README?
>=20
> AFAIK the bindings are where they're supposed to be.
>=20
> Putting the bindings outside of devicetree/bindings is unexpected
> and confusing.

Ah, yes...

Sorry about the noise, I was somehow convinced our README were under
that directory, but you're obviously right :)

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--TD8GDToEDw0WLGOL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUKSvbAAoJEBx+YmzsjxAgV8sP/00C1oriJbCIQ3jqAr9v1gv4
Gqdk5t3LNlNTr/J2x5E+NfPlk3y0QcT9oLZHew23V//nPO5b4eI/FOCkA7tWu+fA
5G48apmYsBHxu6mYXClKh7sNimnAIdt38OVghz/5bJSss1SkUozYzExLEDPxvL1k
/OOpOD6VNku83uFpmbDXdywQujBKK92qheBfDNJF6+xzgt4bySEyBPDTps+FksgR
+leZ/3Qf0uqE88vKuAlEftn9pc9dOAW98WD5fbiZvIplv/wQirzBRI6+EZ4fM6vj
HJHWnDU6Di5teooNuasxpHINYeDBdnAr6ZkowRxoowwCxLsxCKpbdMl1cAZAOX9g
Log3WKz8sEZHUSWTFonQs/0QBIkxg3gsR96ydivQoUadxy0gg6XUHYr6H+AQLaLA
yAgcYR8l5AIeREKvCQckOjIOEWmkTeR7gItlhCo6/Ahf1/jJWdKwRQFmXI+p3ZRL
Ms8/shR3hA90Zsz6r4Zr1NIIMiE5cpiaZA5jqwwq7CGmM4O5u0s67NiyB/dfPrWD
0FU2RA9fU5za7Zg5XO5kCC4bIyxuNIdg1tt9a7k+tJXoAQ64c2RPGMpioP7oXUcK
pTUR5f3TLNo7DD++hhorgRzTityqaQP4Zuoqvy2xbKUZE9rSebAt1gkOXVZ0y5nS
88nMGEVlGNmccGtoDCMi
=61GK
-----END PGP SIGNATURE-----

--TD8GDToEDw0WLGOL--
