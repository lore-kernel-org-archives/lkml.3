Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934926Ab3BTGeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 01:34:19 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:51960 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757364Ab3BTGeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 01:34:17 -0500
Date: Wed, 20 Feb 2013 17:34:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Jones <pjones@redhat.com>
Subject: linux-next: build warning after merge of the akpm tree
Message-Id: <20130220173414.fa4886355efd8f85d0d349f4@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__20_Feb_2013_17_34_14_+1100_9gfoARGTzytJ3OHH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__20_Feb_2013_17_34_14_+1100_9gfoARGTzytJ3OHH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (powerpc
ppc44x_defconfig) produced this warning:

block/partitions/efi.c: In function 'is_gpt_valid':
block/partitions/efi.c:324:3: warning: format '%lu' expects argument of typ=
e 'long unsigned int', but argument 3 has type 'unsigned int' [-Wformat]

Introduced by commit ef25bb0fa6e2 ("block/partitions/efi.c: ensure that
the GPT header is at least the size of the structure").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__20_Feb_2013_17_34_14_+1100_9gfoARGTzytJ3OHH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRJG5mAAoJEECxmPOUX5FE0b8P/iDLm8eO5ut4KeNAUKkyg9wu
9P7jRZAr2kJGCYmPhaV+0hkIUjkw8PcFK4YOZhaS5fjffOLAq52Ot+rpNhnsF2yS
6Ct0puW/0zjgVuMoIcUNaKjjCYh2VvSTefC3fYOqlghdTyReQVzc09E/S4qeXI66
4cGgstPuhR7Cgrwfpvi+5VJBwK0euO/PDa05o6nctdmWj/vS+j62vm4GrGlkuh7R
7S3ab0GCO4YoQ9WNgnMF617mbwm2cQBZA8fx/p67/zSKKG3ZY4tNyyPUSSBJGjVN
m8rEkYQabCDD2NaOsVU53i6r/ueB6aL8GA3Y+Yqu6R8iH2mX0tyuzkCde5zC8x73
IUcf4k5RFM4MIqe6KCAE4IXfAXaQT1Snloagh3AhO5oxlslPtXo5idklepJD/i0g
a7G5Ej3AqdN8DZM63IBM6f312NkcbKpUgeD/mOCD3uBVHzsZNQmFySzcAQ5ss44v
UM028npaJRPihW0M58yJ2GI2GPq7/XIbUJy32i3cpd2J6l5wHPadfW3KcFIYm5Cq
1J7p4ZmHC6bUbyNx4j+i5kyR00/BdUf2u9L30bqHdHZH7Bo1fUlWSxZrxhwWSIeX
y6nlSsE8dwCjI7wZcUM0BIsUDBKa7DLNGFTwIi6ICLiDYT/yo0Jiu5CUUywNPWxa
NFasxIFNO5xgndov8a2C
=84E1
-----END PGP SIGNATURE-----

--Signature=_Wed__20_Feb_2013_17_34_14_+1100_9gfoARGTzytJ3OHH--
