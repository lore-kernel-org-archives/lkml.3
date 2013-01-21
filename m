Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab3AUKzV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:55:21 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:59863 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995Ab3AUKzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:55:18 -0500
Date: Mon, 21 Jan 2013 11:49:46 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 12/33] Input: Convert to devm_ioremap_resource()
Message-ID: <20130121104946.GA27252@avionic-0098.adnet.avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
 <1358762966-20791-13-git-send-email-thierry.reding@avionic-design.de>
 <CAOh2x==ECCN-2wEkFuNQ6DN2K6LMe3kvYMXXpk1bzQvUVo19Wg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
In-Reply-To: <CAOh2x==ECCN-2wEkFuNQ6DN2K6LMe3kvYMXXpk1bzQvUVo19Wg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:BJAlA+AECYguoC3Vegqm25+uGMkLHcy7TUemI7P2ae+
 HPR28aYWD7/HlMwkT54ASuMyEz4diqMeH5Gnc+hUBApfy2gH59
 86pTqoBaaE3QJzM7m/BDdn+SLdJGoYle7Zmx+cDi6ZJiaQcBrA
 8cWvP/IGHIcFliXrU26vtTwPgnFmjsa69wHQbETIRQQEWGs4Yh
 xOI8Oc3+q10h3+y3jhM78C8Xm1mv8LgUMoAXyMGoY3s7bfCQZS
 Rpg/Cw89vPJSnjT+MU0gvat+mnFPF9hiOGD+Ge6uUkV1ZGoFu2
 D/eLijL7AjLmj9HKEg3ltrfUEreAKxqkKDyeDU5cmAr3n+qt+i
 bHps64/hOYVYOFVuIgM4hQd0sloU5wRytnUPe09eh/CnN2Cxc8
 HEa/kZ5VCG+bcbUqFbdxJlziku2pezB3bcP+78CuEq0A6WPsIB
 JUF3N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 21, 2013 at 04:15:35PM +0530, Viresh Kumar wrote:
> On Mon, Jan 21, 2013 at 3:39 PM, Thierry Reding
> <thierry.reding@avionic-design.de> wrote:
> > diff --git a/drivers/input/keyboard/spear-keyboard.c b/drivers/input/ke=
yboard/spear-keyboard.c
> > @@ -228,11 +228,9 @@ static int spear_kbd_probe(struct platform_device =
*pdev)
> >                 kbd->suspended_rate =3D pdata->suspended_rate;
> >         }
> >
> > -       kbd->io_base =3D devm_request_and_ioremap(&pdev->dev, res);
> > -       if (!kbd->io_base) {
> > -               dev_err(&pdev->dev, "request-ioremap failed for kbd_reg=
ion\n");
>=20
> I would like to keep this error message as is.

Can you specify why? devm_request_and_ioremap() and the new
devm_ioremap_resource() both already output an error message if they
can't request or ioremap the memory region, so all this does is output a
duplicate error message.

Thierry

--wac7ysb48OaltWcw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ/R1KAAoJEN0jrNd/PrOh28wP/1A81+z0Nc5XDPH2/c87P1bd
f+56aTq0x7e2QTCXVtnEg5uOA8p9LcEwnvo4Y2mWEXSb6pLaY1ZGVCh23igZiMl2
qV9trOcQlY5TPJwJhVJ/LuCcnXM4dxn2+2TrKCd5g7uliPZiRkIISQEa5CueenWm
+se+rzxIO6PqpZX0NSAfESf1uE7kwyfbvcYV9QtosUC90aElKFLb/jiH3W+cohrm
8PgO1yXUho/374oS2ZqmOazWf5DX8/4Wac0v8LnD3OgNYfOtbYait16St2lc59kX
EmzdHPHq0iAy+oD/Jh31UEzrvssGeuIsm9QlyX5F9oztlLrvjdJOJ8xktaBdEeVg
cSuDjNL49xf3WYE8KEFnUmANT0yrf9nZ9whOOR8z0fRjxzA0tTrdIuNfN2ziPDuk
Ghcrr+akoYdnUgWN7lc1OkKgZ2P88QUCjlaOYpd/a4yiH+ShjKv4SxS2aILhu4S7
kap/OC7HLB8MovDbgbDWt38I1/SjIfGT1j4F1D6AfuBZSie4sYEZNY8MhAoHBlsU
GoYjFhpcLh+MkSwW1spt4HG6s1PNqXXSQJ1b8aPLMIMjs3etrBG/oEuXBOGN+RsG
fpsL4SFmKKQxpAQcijS5v9hU4RdkH6c3DHRXFJKhvAWHx3yT0Fa71kBMzpiDqkvf
lv/lrOhwg49PmBqdeBTH
=2Ef2
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
