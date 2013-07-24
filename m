Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab3GXAVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 20:21:37 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46778 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab3GXAVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 20:21:36 -0400
Date: Wed, 24 Jul 2013 10:21:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Mark Brown <broonie@kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: status of various trees
Message-Id: <20130724102123.6d1156925959e56640c23468@canb.auug.org.au>
In-Reply-To: <CACxGe6tjrFG1aLc9Scmmuunjb9hTm5vyH6LqXiys8484YY=Zzw@mail.gmail.com>
References: <20130723095513.19b9638ab4a19157e9834dcf@canb.auug.org.au>
	<CACxGe6tjrFG1aLc9Scmmuunjb9hTm5vyH6LqXiys8484YY=Zzw@mail.gmail.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__24_Jul_2013_10_21_23_+1000_.dPdQWpNIUeEw98m"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__24_Jul_2013_10_21_23_+1000_.dPdQWpNIUeEw98m
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

On Tue, 23 Jul 2013 13:38:45 +0100 Grant Likely <grant.likely@secretlab.ca>=
 wrote:
>
> On Tue, Jul 23, 2013 at 12:55 AM, Stephen Rothwell <sfr@canb.auug.org.au>=
 wrote:
> >
> > Currently linux-next has the following gpio trees:
> >
> > gpio-current    git://git.secretlab.ca/git/linux-2.6#gpio/merge
> > gpio            git://git.secretlab.ca/git/linux-2.6#gpio/next
> > gpio-lw         git://git.kernel.org/pub/scm/linux/kernel/git/linusw/li=
nux-gpio.git#for-next
> >
> > Given commit a0062d4e3a0a ("MAINTAINERS: Remove Grant Likely") in the
> > devicetree-current tree today, should I remove the first two and rename
> > the third to be just "gpio"?  (And does Linus have an alternative
> > "current" tree?)
> >
> > I also have the irqdomain tree:
> >
> > irqdomain       git://git.secretlab.ca/git/linux-2.6.git#irqdomain/next
> >
> > Should I remove that?  And is there going to be an alternative?
> >
> > And for spi, I have:
> >
> > spi             git://git.secretlab.ca/git/linux-2.6#spi/next
> > spi-mb          git://git.kernel.org/pub/scm/linux/kernel/git/broonie/s=
pi.git#for-next
> >
> > again, should I remove the first and rename the second?
>=20
> Yes on all of the above. Thanks.

OK, I have done all that.  I also removed the irqdomain-current and
spi-current trees.

So the trees I have left that you are responsible for are:

devicetree-current	git://git.secretlab.ca/git/linux-2.6#devicetree/merge
devicetree		git://git.secretlab.ca/git/linux-2.6#devicetree/next
arm-dt			git://git.secretlab.ca/git/linux-2.6#devicetree/arm-next

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__24_Jul_2013_10_21_23_+1000_.dPdQWpNIUeEw98m
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR7x4HAAoJEECxmPOUX5FE5XcP/3K9+FhqjhuVVbCqtojCUJWl
0r5bSnQDzeU6CstEttGb5L1q8UGVxw6uxA/dyrqJhTXHN85FtqDt0JU8ETCM5Pxp
ktPIhlYhdiGRwWVCr9qxUqgxwhLmzPqxA58FKWLpVq72ibQYHMvn00oFzT2qTcQ7
uwQEeHj/eI3b+CxKsVxyvGag2bqXxNiJXoSBaaILEltAGanaWC1NMgu8mH3sXPuU
ds0sNZUZ+Yi4arC1LVZL5zN/7ad6KEwtNWA7R3x08fM4VaiPgYMQK1MUlZ4TkrkJ
pH4UXQAvLxD/uBpiAdhlX6d/G/UQBRbiNKxlvRCBeOM29s0Bbd1fcilIHnnu65qv
0rnqYVaXdYjYPYDlYJ/7COfumJibLJgOLzWNacyHd3I2KX0YqYbtvBPoaA5f6dDp
qorQha4jl6zaDkVSW5kVPa9Ogq0g2raBWCYnJJWkENJ51pSJfyhfxF4xH6FOhotj
/xt5quhdKWRanI8mFIt+xTcywx+xCb51gLhfT7ZRrwFYjqzf6WaL0AQZXNnDrxLn
cfnl9qctDWZeEOA8zJlhrUPdyM+pDAi1b+XAxbikLdErsXvjub8yKv8JExINCLuR
WdENrBqFkMS9a3qUKce3lbl37jtmzBwquJszrxXWyIuRgogFhupU1nqcXN7p4CJZ
i5v/9ZKbJpMltzh4pOd3
=IF66
-----END PGP SIGNATURE-----

--Signature=_Wed__24_Jul_2013_10_21_23_+1000_.dPdQWpNIUeEw98m--
