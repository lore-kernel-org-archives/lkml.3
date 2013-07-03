Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537Ab3GCAJR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 20:09:17 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33803 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218Ab3GCAJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 20:09:16 -0400
Date: Wed, 3 Jul 2013 10:09:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] DMA-mapping updates for v3.11
Message-Id: <20130703100903.81ab08c6db864c20498b558d@canb.auug.org.au>
In-Reply-To: <1372754108-21075-1-git-send-email-m.szyprowski@samsung.com>
References: <1372754108-21075-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__3_Jul_2013_10_09_03_+1000_4/v9=Nw1a8ax/Tr5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__3_Jul_2013_10_09_03_+1000_4/v9=Nw1a8ax/Tr5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Marek,

On Tue, 02 Jul 2013 10:35:08 +0200 Marek Szyprowski <m.szyprowski@samsung.c=
om> wrote:
>
> I would like to ask You for pulling some fixes for ARM dma-mapping subsys=
tem
> for v3.11.
>=20
>=20
> The following changes since commit 8bb495e3f02401ee6f76d1b1d77f3ac9f079e3=
76:
>=20
>   Linux 3.10 (2013-06-30 15:13:29 -0700)
>=20
> are available in the git repository at:
>=20
>   git://git.linaro.org/people/mszyprowski/linux-dma-mapping.git for-v3.11
>=20
> for you to fetch changes up to 1e3d09b223f349a5f6cc14d62b4df66c0798d762:
>=20
>   ARM: dma: Drop __GFP_COMP for iommu dma memory allocations (2013-07-02 =
10:30:59 +0200)

This was rebased yesterday onto v3.10 for some reason (one commit was
dropped in the rebase).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__3_Jul_2013_10_09_03_+1000_4/v9=Nw1a8ax/Tr5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR02umAAoJEECxmPOUX5FECKMP/2OXxKXLrbDOnY7+iOY/YjhD
3hNtGZ3x7fdznz/rVC6Hz04FCus5BPjGSsJ0bJAmhpaieaeda1TxixhU1hZBzeeU
dJSInhoQYsibW0sHGbAbi294Zwr6h1akn/ntepU30CEdR9zSFb79nCqFFWBJIuld
QYPhZlLRfeRIfD7HQmOGQ5UXb5MBjN22xL8zIrnq24yt08aY/DIXzde97KTFUTrE
Cgw9mErETRz9jtRZrLCl4VjYaJw7FYe8HSa0ljZlhc2C8jfcUogvN5qq6DzslHRK
SnJTQwCYGl9EdUKdllOAgxcXnB3lbRTMJM3s5TayP7hKlE9MZVOIhJKVMb8vtJL4
b081rvk4ZjsinJquTRID8oBOATMwOTNBfddPlR5LuKsGax1Vhx6pJCe2Jm8/8uLo
vEQrrkpT96NZ+0bFaOyo2Do5K1G0mcmO3uvj+uAjdkdXCCTX3qH50nOdcekMBHKW
YzQDV7bfNYF4buf5YdMMt+c07vclHWC/x0VmU4Uc6xxnpWMxfIW1VG3NAn8eELCY
eSuMiktMnWyQ6eeBI65QoDKk373gDM7NigH6/uPGeU5Wp/Ivd6mlY4bgYBuznuuZ
L5gIymnM82w+k241JDxXej9ES7bh/9mUNyTfygcyuXj7DhqH5bqHWm+Qn0J7mMup
paj7ZRR6vVIqYhVANeYl
=NUU8
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Jul_2013_10_09_03_+1000_4/v9=Nw1a8ax/Tr5--
