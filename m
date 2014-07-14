Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbaGNJd0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 05:33:26 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:38029 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbaGNJdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 05:33:20 -0400
Date: Mon, 14 Jul 2014 11:33:11 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: linux-pwm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>,
        Liqin Chen <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>
Subject: Re: [PATCH] drivers/pwm/Kconfig: Let PWM_CLPS711X depend on HAS_IOMEM
Message-ID: <20140714093310.GC9755@ulmo>
References: <53C27247.2010300@gmail.com>
 <20140714081843.GK2081@ulmo>
 <6A7CA9C8-7BC4-44BA-AE71-63BDADFF9023@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MnLPg7ZWsaic7Fhd"
Content-Disposition: inline
In-Reply-To: <6A7CA9C8-7BC4-44BA-AE71-63BDADFF9023@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MnLPg7ZWsaic7Fhd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2014 at 05:14:05PM +0800, Chen Gang wrote:
>=20
> =E5=9C=A8 2014=E5=B9=B47=E6=9C=8814=E6=97=A5=EF=BC=8C=E4=B8=8B=E5=8D=884:=
18=EF=BC=8CThierry Reding <thierry.reding@gmail.com> =E5=86=99=E9=81=93=EF=
=BC=9A
>=20
> > On Sun, Jul 13, 2014 at 07:49:27PM +0800, Chen Gang wrote:
> >> PWM_CLPS711X needs HAS_IOMEM, so let it depend on HAS_IOMEM.
> >>=20
> >> The related error (with allmodconfig under score):
> >>=20
> >>    MODPOST 1365 modules
> >>  ERROR: "devm_ioremap_resource" [drivers/pwm/pwm-clps711x.ko] undefine=
d!
> >>=20
> >>=20
> >> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> >> ---
> >> drivers/pwm/Kconfig | 2 +-
> >> 1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > NAK given the discussion in the other thread.
> >=20
> > Thierry
>=20
> OK, thanks, and I shall continue focusing the other thread, and send rela=
ted patch after
> get conclusion (hope I can finish within this week).

Great, thanks for taking care of this.

Thierry

--MnLPg7ZWsaic7Fhd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTw6PWAAoJEN0jrNd/PrOhZ8QQAJZ8LAcQ9FYb8xKLBroBNLTB
3SvrnAbZTziD8b2CWyqemjxFRY6cBHN+JDf1XumyCF+hJsbQ+M4CvZyzM/MIvhQO
IOFWaCJMFiPHmeiMGlhje45rGf5lMXv729+WHB9coX50FKs4/9L3E3b4hf0pDSFW
PTiy5Uq3QKanP3XhmJaSSnh9ezlsDqTObZKbqSGEpBRzH0VL87NCL6xW64TZHw6R
/VnNE4q2bzyR8PFtkDvJK6UW1kq9GlYFtXFn1DR1KnIojBj1j0SrwF+EIF8UB/3B
AXsGmLAHxkA2OaDpVc9XbxW765+fXupGcUaxw2D9YcoYWaxJinjX35Mkk82hm2Pj
8RU/+WE+SgFOXuwYDw1q6+TcrgOK+LuzokhkXTvmPSRspeOX/KrahQwtaowW/bmz
FVqSUz3/xm9WSvFVOiPb1hGfrxtsC2XNjL86GJqQA/hUsQZAXEEG9RAOlV2PAL4f
EUpM/Au9QqUlQ1ts9AyB9L4vMV1oPFohnYyWT7AcYPTuCvxkI5WqEP/en12CTnqJ
LioBz7YOwuyjQbcym7tH1vkxbPhTwSnlVpob1i/s6JpZNgG0HZJwWYylbuk6cqjp
IkHKjWj5vjHucUZRHH3UhOT4C3PSrU131Z6kYeHp1X99bIg2WsUZ5w/SNB6BJ0Ln
UCFLGqFxbRtJYbf9P0OE
=pJ5I
-----END PGP SIGNATURE-----

--MnLPg7ZWsaic7Fhd--
