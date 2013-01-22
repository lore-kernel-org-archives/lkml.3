Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab3AVLuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 06:50:04 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:55442 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995Ab3AVLtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 06:49:52 -0500
Date: Tue, 22 Jan 2013 12:49:14 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 08/33] gpio: Convert to devm_ioremap_resource()
Message-ID: <20130122114914.GA6121@avionic-0098.adnet.avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
 <1358762966-20791-9-git-send-email-thierry.reding@avionic-design.de>
 <CACRpkdb8VEUENBD8nSexYYPekDp082mK-A07hw7e8VmVSxZS3A@mail.gmail.com>
 <50FE7A57.4010205@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
In-Reply-To: <50FE7A57.4010205@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:3zyLsYdDJ3384NNSwh8/wZr7JubJUn4RQY+/z0a94FE
 2j8wCi9Xp5vxBDPv03jj59QG+4kSjLb/+Qvknl9C0E1YafepNg
 gXMevAtLHzCVdN3BTaHBiLBvG4yN2SRKEQ/1RZtaYmhatv/EhD
 YnlAW0m4R54FgLan0eEB7/4uZHx8PjZ81vor29E/xXKFDV7lfv
 tyTzJhAk1trMqcWaV4g7s2O9oQDllSj+Qn3KOKdcmi/fmR+EF2
 +a7++fql20oV23ctl6JCKBX4GhW8Tr6Z3z3PHskXrpDU8YIvi7
 KHmJ4H3BIwgymbpGHI9vXK9PorXo/B0mWE5TiRa9FLOyJSZvT0
 J756Ht+2oskkR8ISiwJm8Lf8gOrXakPbawi7LiOIoqTDqvytwi
 Ctbfvgqoa1JeN6Z1uEMURni13a3iZavZaU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 22, 2013 at 12:39:03PM +0100, Gregory CLEMENT wrote:
> On 01/22/2013 11:15 AM, Linus Walleij wrote:
> > On Mon, Jan 21, 2013 at 11:09 AM, Thierry Reding
> > <thierry.reding@avionic-design.de> wrote:
> >=20
> >> Convert all uses of devm_request_and_ioremap() to the newly introduced
> >> devm_ioremap_resource() which provides more consistent error handling.
> >>
> >> devm_ioremap_resource() provides its own error messages so all explicit
> >> error messages can be removed from the failure code paths.
> >>
> >> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> >> Cc: Grant Likely <grant.likely@secretlab.ca>
> >> Cc: Linus Walleij <linus.walleij@linaro.org>
> >=20
> > Is the interface already in-kernel so I should apply this or is it
> > added as part of this series so you're searching an ACK?
>=20
> I don't know if I was really the one you were looking for (either
> you wanted to send it to an other Greg(ory) or to Thomas Petazzoni who
> wrote the gpio-mvebu.c driver). However, that's fortunate because
> Thomas is currently in on vacations, so I apply this patch and the
> first of the series, I built, compiled and tested it on an Aramda XP DB
> board. Everything is OK for me.
>=20
> So for sure you can have my
> Tested-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
>=20
> and as the code looks good, so for what it's worth, you can even get my
> Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>

Great! Thanks for testing!

Thierry

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ/ny6AAoJEN0jrNd/PrOhJKwP/RoayKfG6EhBlCKCKrLvzXfR
r3oaWhunaEme/ycVoksT1OjAFUS5F5WSCFQgmOv/uyp45nj5kHVETdGN5Nw0EXD9
ljkpYGG+kCQl3vCD50wGC3k14motFXDPzTu0LAICtbdMrIQybQg+Sny3B6cFXUgT
k8BNvZNgUsi3YnvSU1W3WqZNZkQj2hNFIi3l8xdLTlH6GZfH/F7fdVyAGMkwY4Wg
HO0S8YwfUDZ93zHcKhn8CMyVioG+4NVw/4HshjWAkkg4gokB6bIAZT4vHxiqWRmW
Om4Tqms6ptg6EGxPwDy2+MP0+9I8wkoXBV3vVREDufP4kac7fcuYRMiA2LoKoriR
dyjOSq5JL5emOztoo2FL0V9ogIPs/9fYUjBfYV4J5GgrjHcccS2lLF7NzxOzHhIF
ejfTGPL/UHmv8AptJIAuxy2PNZUGRG3kveXu9RuL6U7QeVuhw1QZ95valv91LvVt
o5C9hYn1Jjveonh1W0RDeyQqsShaxv3Na2w9o39XPBf0b76DCvrs5g2Qkp3WnhGL
uYlF3/aIuhuOdVvXXSetIVEdu6LdGnE5qX1A2rhq5/LUjwXV5CzkxgEJcLSyi9Ay
9c/RL3uPdtbtCOe9Ank037CCKFvSdobBo3+EdY164Ysn9gbKncVxYa6LqyOsbD0f
Dj+7IMfPIcNfJnwHiGby
=PP9y
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
