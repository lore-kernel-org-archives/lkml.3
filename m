Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab3AVK0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 05:26:16 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:51143 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981Ab3AVK0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 05:26:13 -0500
Date: Tue, 22 Jan 2013 11:25:59 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 08/33] gpio: Convert to devm_ioremap_resource()
Message-ID: <20130122102558.GA10716@avionic-0098.adnet.avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
 <1358762966-20791-9-git-send-email-thierry.reding@avionic-design.de>
 <CACRpkdb8VEUENBD8nSexYYPekDp082mK-A07hw7e8VmVSxZS3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
In-Reply-To: <CACRpkdb8VEUENBD8nSexYYPekDp082mK-A07hw7e8VmVSxZS3A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:giU2y0kEg/Ecj99QwadAXR8u/liX2JOzjgpeXwWgLXL
 CGpVpXNttm+YhVYuycr+2XjeYdSvEax4B3UZYqTsdI+VlxWOmR
 c4Y4hDbYtyv+uHzPGKZ2oATxBA4Wxyx9JBLoWWZ7hsxxwSJx+1
 UdAfmoRYuI2Zj/uyZ2s5y5y8mqGn62Y+yf4go+Yb/FCq8MqGHJ
 0mL0TQHrNuEVcTkpD30JiMvswgq9DvBxvVF6KAbOm9/jHouEnm
 florAk9MAc5uOYIhU8oFzu9QQzVU6XpXfiDhTCfPezC0lHFhSd
 UZJCV75W95vC7q9hgFW1yaRqn/Uwb8/inXPAdQ6Fh0uGyqv0+G
 JgJbmJqRZ3cixU3e/7getwudiQQa97JBs8Kd8jyjuXee4neQBN
 DPaPviQVpTfgzJQagiJXeZ7YfmHuN9daME=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 22, 2013 at 11:15:11AM +0100, Linus Walleij wrote:
> On Mon, Jan 21, 2013 at 11:09 AM, Thierry Reding
> <thierry.reding@avionic-design.de> wrote:
>=20
> > Convert all uses of devm_request_and_ioremap() to the newly introduced
> > devm_ioremap_resource() which provides more consistent error handling.
> >
> > devm_ioremap_resource() provides its own error messages so all explicit
> > error messages can be removed from the failure code paths.
> >
> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> > Cc: Grant Likely <grant.likely@secretlab.ca>
> > Cc: Linus Walleij <linus.walleij@linaro.org>
>=20
> Is the interface already in-kernel so I should apply this or is it
> added as part of this series so you're searching an ACK?

It is part of this series, so your Acked-by would be great. Other
maintainers have done the same. Initially I had thought that it might be
easier if the patches went in through individual trees, but since the
first patch is a dependency, maybe it'd be better to take them all
through a single tree.

Greg, any comments? Would you be willing to take the series through your
driver-core tree once all Acked-bys are there? Alternatively I guess we
could take the first patch into linux-next, at which point maintainers
could take this through the individual trees.

Thierry

--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ/mk2AAoJEN0jrNd/PrOhgPIQAKa+SAyuz+XFvqrJea79C3Df
giO+cscBbD2pOaJj5Jn0CP1Pb053xzYOMbOIaYixYOuhMQrERZX4oR97L49zSfYU
00lx8CddjbFpP/ooZcTevf7ZLCMhFxB1p9lV3EfrSRnK2Lo6+Y1LELEyRZTSUl2B
kicPZjDqqLrTHVOqPCI4acqBJrHO/PMgmC4IW8Ez1zJ+RVgr9uiO6Fgzify5x01N
qU9TqdXKWeebBK5OuMIk7EJ7nFBA6792h2zUjyJdk2YUsgcUJ811idddrCdyJCYH
m1awIyNww1vGOMEpooonvmdcdwD6FsZxGDrAC6k3XuXlqflr5jzBSK/n0ZUoedh3
T05XFQFb4CkEuB8yMFtyrtShE+dnkTbIGI3ArMyQFwxeE2BHEfUB55NK6CJqfzId
qK+mRJlo2OAh0I/7um+4C5U9Us9M1x9IwzVMqJ/Cjnv+ztiaE0vd5vONXFdMMVQq
x3wxKJ1resH4gPI0Y0u4NEJRI+bv/l3TLsOFQhOwVR2nl93qh6xYMF0AvsOr6Q4E
kYu0bjiQpnq24KM4SDFJ0Z9MHCCkQazpy3eMzcVxakeMYKSBVeqQ7QjOsMD7lKNd
w86T/nz0+tNliYrPE33+M3bZJTqxGVZGa1AeAtINwacxraqwL8+U45VYxI6pKbi6
VJObh6Dryigm9ZLkZaBe
=osRb
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
