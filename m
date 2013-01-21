Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab3AUFx1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 00:53:27 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:36277 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab3AUFx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 00:53:26 -0500
Date: Mon, 21 Jan 2013 16:53:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the gpio-lw tree
Message-Id: <20130121165324.84199b6341090d4bc0836534@canb.auug.org.au>
In-Reply-To: <20130121062011.GC2272@S2100-06.ap.freescale.net>
References: <20130118140346.3f9b182aa7daa175b4f136bf@canb.auug.org.au>
	<20130118080211.GA8706@S2101-09.ap.freescale.net>
	<20130119104045.80e588ed651f40d8c567b7d6@canb.auug.org.au>
	<20130121062011.GC2272@S2100-06.ap.freescale.net>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__21_Jan_2013_16_53_24_+1100_jlPb4YmeQu38z+7S"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__21_Jan_2013_16_53_24_+1100_jlPb4YmeQu38z+7S
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Shawn,

On Mon, 21 Jan 2013 14:20:13 +0800 Shawn Guo <shawn.guo@linaro.org> wrote:
>
> On Sat, Jan 19, 2013 at 10:40:45AM +1100, Stephen Rothwell wrote:
> >=20
> > On Fri, 18 Jan 2013 16:02:13 +0800 Shawn Guo <shawn.guo@linaro.org> wro=
te:
> > >
> > > My bad, sorry for that.  I just sent a v2 in reply to this message
> > > for fixing the error.  I spent some time trying to install a ppc64
> > > toolchain for testing, but unfortunately with on luck.  So Stephen,
> > > I have to rely on linux-next to give it a test again.  Thanks.
> >=20
> > Cross compilers suitable for building kernels are available at
> > http://www.kernel.org/pub/tools/crosstool/ .
>=20
> Thanks for the link, Stephen.  I installed the compiler and verified
> that the v2 fixes the error.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__21_Jan_2013_16_53_24_+1100_jlPb4YmeQu38z+7S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ/NfUAAoJEECxmPOUX5FERuMP/jpePHUierAuYPEAS87YwBzE
h2SaA5G17KXnb8yULT0p7eRJE9rweujBjKvIBHHN+McWlo0o/0t0yB6pyp6D2iid
rzC5Hvr7axaxrTSdrtZuvT8oCsBux0uVqDvG+k0ihdjRrQteLB1qkGACWd6P5vI1
iwVywY9d88aInst9bMN2Hcme91wNhIshUmFaupvqMEIVGqXXtsadL6othw/+D/4Q
TVxC6CWzt3MBQCP7WfvmjBWTY+vNAgpH8T3kNhIeuZJ64c9yggafp5sf7yqUn0Ep
M+m8kmuXuxaP9kGF3VPw6NNo75UOU0Nzp9/OlCMoRgQghNF4IVFwX0Bcb4Ym2jiO
CJENO1OyhV7JfWr2v7eQ1e6heOzhHN5H09I9mTweDO+hTtf1KmKzRwduQCOtihS5
sNcFvwytgoJIemqUo4ND23aBLO7tMuZeM7BpcMLi4gxgoRm4z2Irw84CzPMm130i
OPhQamOhB+iRwHXiU0dhLd2A6dpCI+IZrQmTtPA+fm4kkxvhqBS2Y3kNUvuzXzLN
zrFTk4L8rMPPlI8IXictC4Y3mRZ4kJz/Nhf3QWfKLqEgN/QJ+7cDGbqipG3OrYGe
4cvAW2ABFoYUsW7TzL3jTTeTRJ78MmgLhpQDzZfwURmXy96ESDxmWS1VPh/Nu/gP
xFN9Lhsf23UW4CfgQC7W
=ILra
-----END PGP SIGNATURE-----

--Signature=_Mon__21_Jan_2013_16_53_24_+1100_jlPb4YmeQu38z+7S--
