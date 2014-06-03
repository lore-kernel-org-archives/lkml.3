Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbaFCWwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 18:52:39 -0400
Received: from ozlabs.org ([103.22.144.67]:50577 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbaFCWwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 18:52:37 -0400
Date: Wed, 4 Jun 2014 08:52:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Ball <chris@printf.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: linux-next: build failure after merge of the mmc tree
Message-ID: <20140604085222.50916c65@canb.auug.org.au>
In-Reply-To: <20140602151141.084d3350@canb.auug.org.au>
References: <20140526140735.3f405672@canb.auug.org.au>
	<20140602151141.084d3350@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/d3JI4zejjJlRn7qAVv=NBjK"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/d3JI4zejjJlRn7qAVv=NBjK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Chris,

On Mon, 2 Jun 2014 15:11:41 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> On Mon, 26 May 2014 14:07:35 +1000 Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
> >
> > After merging the mmc tree, today's linux-next build (arm
> > multi_v7_defconfig) failed like this:
> >=20
> > drivers/mmc/host/sdhci-s3c.c: In function 'sdhci_s3c_notify_change':
> > drivers/mmc/host/sdhci-s3c.c:402:25: error: 'struct sdhci_host' has no =
member named 'card_tasklet'
> >=20
> > Caused by commit 3560db8e247a ("mmc: sdhci: push card_tasklet into
> > threaded irq handler").  This is the second left over one I found.
> > Please check for any more (grep is your friend).
> >=20
> > I have used the mmc tree from next-20140522 again for today.
>=20
> This is back again.  I have no idea why I didn't get this failure on
> Friday. Please, guys, go through your tree and fix this problem once
> and for all.  Grep is your friend.
>=20
> I have used the mmc tree from next-20140522 again for today.

Just wondering if you are even receiving my email?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/d3JI4zejjJlRn7qAVv=NBjK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTjlGyAAoJEMDTa8Ir7ZwVMvsP/jXuztg12MEVu+EUt0wXAPwE
4x9U0KJloIUy6ZXvM5THVfsV0l0xN5L9a+U40EDNzyUCwADCWi3L3KpRVAdeL09z
PMazm1S7zdTotX+P2isZuMjOgoEfLc40oBE+irEpt7580/hzfgUm7RMeMaKIjzxW
vTivjgBH5yS8JdD9Ll5RfL++UmMutJ/bgirp5oFGlWwGQGkWJG/24rYcQRgr7ooJ
x7Lk60zQQK3jQeQp2PMOiJuMSJQu9iPCn2kV2cD1fKMUlxwf9xXGnKZINYjHGFZ8
kSn+ie3MktQZMxp5ufZd5Tql0qpbRucmVHqljyx0/LfwJlLZ+ynA+XVo9CTvTPzB
I466fXLVfe+4M5yZiOMVeK6NWerIYDlS50I2VVSEEaI0nsdqEw9OWw3/3ungpOHM
OJfOj6MmmoTrFOkSHhmVdDUAhIAOA974Zq7mCP/Jv38lQQDGhXWaSgiAyvfGowdG
nyjHpK4lZm7cB9bQh3xTpGDZTKdiNpXaId6UfiWkhER1aXSdNoHklGjJr4ytlZLA
dww0ZoDTpQq1X9NL9X+0ACN5+6QK9ohwRMYG5QdA7jj7TtqvamSgEYdY00rE276B
cPKlKjT0XGmOw9laPS7oXl8WYUnF7/gRIVPk9tsPUPT+Fi6vMWkWjQK5wbgI6j/0
j9yO0FDaVLBozAr0JHZf
=Ltvv
-----END PGP SIGNATURE-----

--Sig_/d3JI4zejjJlRn7qAVv=NBjK--
