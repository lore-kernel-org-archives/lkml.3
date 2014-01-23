Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800AbaAWW6g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 17:58:36 -0500
Received: from ozlabs.org ([203.10.76.45]:41371 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755471AbaAWW6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 17:58:34 -0500
Date: Fri, 24 Jan 2014 09:58:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Subject: Re: [PATCH 59/73] drivers/gpio: delete non-required instances of
 include <linux/init.h>
Message-Id: <20140124095827.1ee8ddcfed8d1c8e0a6d3dbd@canb.auug.org.au>
In-Reply-To: <CACRpkdYk6cOO-JZbe887ihJaWE5JMjuXm3EVcZmE1jCeL2BODQ@mail.gmail.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
	<1390339396-3479-60-git-send-email-paul.gortmaker@windriver.com>
	<CACRpkdYk6cOO-JZbe887ihJaWE5JMjuXm3EVcZmE1jCeL2BODQ@mail.gmail.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__24_Jan_2014_09_58_27_+1100_MyHDoUzMbh4bFCu1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__24_Jan_2014_09_58_27_+1100_MyHDoUzMbh4bFCu1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Thu, 23 Jan 2014 09:12:43 +0100 Linus Walleij <linus.walleij@linaro.org>=
 wrote:
>
> On Tue, Jan 21, 2014 at 10:23 PM, Paul Gortmaker <paul.gortmaker@windrive=
r.com> wrote:
>=20
> > None of these files are actually using any __init type directives
> > and hence don't need to include <linux/init.h>.  Most are just a
> > left over from __devinit and __cpuinit removal, or simply due to
> > code getting copied from one driver to the next.
> >
> > Cc: Linus Walleij <linus.walleij@linaro.org>
> > Cc: Alexandre Courbot <gnurou@gmail.com>
> > Cc: linux-gpio@vger.kernel.org
> > Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
>=20
> Patch applied for v3.15.

Yet that patch is in linux-next today.  And just 2 days ago I mailed out th=
is request (as I do during each merge window):

"Please do not add any code intended for v3.15 to your linux-next included
trees until after v3.14-rc1 has been released."

I have no problem with that particular patch being sent to Linus during
this merge window (in fact Paul intends to send whatever is left of the
series at the end of the merge window), but it makes me wonder about the
other commits that you have added to the gpio tree (and the pinctrl tree)
today.  Are they intended for this merge window or v3.15?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__24_Jan_2014_09_58_27_+1100_MyHDoUzMbh4bFCu1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS4Z6YAAoJEMDTa8Ir7ZwVnwoQAIar8U4PphHfitTTxRtzE/xT
3ejq4VSIihtf+QPHqC8BV8835e4ukRzpJt/V4itPK9OZSQZpJDO0DBr7q+GUoWqC
phphQvVQYxQ7Zb2yzFKzD3vUeFim2q7bdDHKQhERDVTTp4CfrQXYxWKWJLAZAHe3
r0zYO3Uuc1qKo7yZWz7iSPGwfkdr2E/OWRshUqsmyYbbsIY7MtPaXad2wc4aGFpx
R+NLq1kwSbUgFDKoYwEk32eR78Uhfv/mSn6iHzGMUZPbzvhytNTMV4jE9Ub9xCGs
Te7wttFXblFJctDH3hCOzbwMHBq5AN0SoTZCpK54G4m459Ydt3rxCYAzIqtYUA7z
r16EDDwlv8Z2+SBLX3y7OB3TFcazWjJfRE91Q+GXI1BJeLUXd+nK557HL3T9QWei
CJyzKReRci+6xrK85y4SMQ8IzYam6QNnQmpm0fy42utaNg/zZRD1LTkyJFWfGDZm
0XhZeiaGb82PSLwOJWsCGHCv8G9uTYBYjXF75jQYlkIdbr62B6givKyaQmOdS5zL
eL6osM0U+yt25vOq107hI0NB428IEssF26GbPQBJP4HPYzguhn3AJsFTLmh+C/5F
QYCHtOO4IZ8z28ovikwZ6h9HgXRIP0gA1qoUOyYCdCBidUlRriN/NGW5nbJYsZ6K
KdkWhHOlUQ+TEB67XoE8
=8Ck+
-----END PGP SIGNATURE-----

--Signature=_Fri__24_Jan_2014_09_58_27_+1100_MyHDoUzMbh4bFCu1--
