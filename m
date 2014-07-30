Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbaG3XB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 19:01:26 -0400
Received: from ozlabs.org ([103.22.144.67]:46665 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517AbaG3XBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 19:01:24 -0400
Date: Thu, 31 Jul 2014 09:01:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: URL change for mfd tree?
Message-ID: <20140731090116.01e54d15@canb.auug.org.au>
In-Reply-To: <20140730071254.GC9030@lee--X1>
References: <20140730092453.089e1094@canb.auug.org.au>
	<20140730071254.GC9030@lee--X1>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/bI7sOHZGvFumq.vHe1X0MkU"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/bI7sOHZGvFumq.vHe1X0MkU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Lee,

On Wed, 30 Jul 2014 08:12:54 +0100 Lee Jones <lee.jones@linaro.org> wrote:
>
> > I noticed commit 71e297b17bb6 ("MAINTAINERS: Update MFD repo location")
> > in the mfd-lj tree today.  In linux-next, I have the following mfd
> > trees:
> >=20
> > git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-fixes.git#master
> > git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-next.git#master
> > git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git#for-mfd-next
> >=20
> > Does your commit mean that I should remove the first two?
>=20
> Yes please.  They haven't been used for ~6 months and aren't likely to
> be used again.

I have removed them and renamed mfd-lj to mfd.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/bI7sOHZGvFumq.vHe1X0MkU
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT2XlCAAoJEMDTa8Ir7ZwVbYUP/1l+a/WRzEEx+dMf+QK4T4Qw
qV+euglEAGXSGB2xfU3YjLg/O3jMxWUwztSjXBuBBYnrJjdsWKLjrOdH87x+0VZc
PEXkSVv8Vr10qL9VJgKJ/wVGCsX37VHOobfuwtGyw7+nDTTG0qF/DO67Ga5NzoQf
7UKEukPgRXRZeGsXZZNxvZ5itLUkd96ASAcSnE+5b1rK4R1MNfFyHorNku1oegnW
6BxrBxEejnjTtgqd3P6Xh9sY21rwoGmytYb+mU8F6FWtNdoV8Fi4YWBBkFqmQKZS
dp3+vkYIbZpB2fD09rLx9VByJqbUGaTLoLhZuXZ36PHSO6rra+QSYf1bL2vqtnmq
L6jIdsP9kEgLZaAXjqs3dkh4qczQrFK88QZ8zaZqr0VBStNUHfJKrPo5xGDhhGgF
THNbSM5cVvnywyJ6+kID+XTgf7/VP1m7JUvub51Nh9Jfb2IavjBgwuW34zsblqXj
75op+zSt+TexV6b210PFpvV5KLT8oKn/V5bXHI/+hQaKklq3vZKB17ETPdHg3FOp
kPycE51kIEerVTCGQWchTZbAcnFTuWFYkzeDFiZioqvx2ZUA0IpMLWz3Llow9SF5
fM59zO3bGz0RW8JK2CrEisCuKjjXav0bgRquZlyPoydKKXyWy66MyWP9MaYIQS6W
Va8Z7n6AArtvnrZlziTb
=m5Rv
-----END PGP SIGNATURE-----

--Sig_/bI7sOHZGvFumq.vHe1X0MkU--
