Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab3CLDXK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 23:23:10 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48021 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246Ab3CLDXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 23:23:09 -0400
Date: Tue, 12 Mar 2013 14:22:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>
Subject: linux-next: manual merge of the signal tree with the mips tree
Message-Id: <20130312142259.d9a49c81cc5c3d3f03b3403f@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__12_Mar_2013_14_22_59_+1100_9LHqC7V/srKuWJoX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__12_Mar_2013_14_22_59_+1100_9LHqC7V/srKuWJoX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the signal tree got a conflict in
arch/mips/kernel/linux32.c between commit 63981a409608 ("MIPS: compat:
Return same error ENOSYS as native for invalid operation") from the mips
tree and commit 56e41d3c5aa8 ("merge compat sys_ipc instances") from the
signal tree.

The latter removed the code fixed by the former, so I did that and can
carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__12_Mar_2013_14_22_59_+1100_9LHqC7V/srKuWJoX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRPp+TAAoJEECxmPOUX5FEiAgP+wU/6h05MbzTiLBWMSTz/GOg
RmU/1cP4PT70tsq6ZJHQ6BjipJhqCZwUKmatgheeM1VKETbpdFOmEqdNiTqnUGxm
Bthe2JoPrJIdJg/xRzXdyi9EVElIlkqajOzW6WKwI7Nz3zWcUFe3GE6JYcasWC1B
zWzM124O/NzJFRWoBiUPcLoD3EvV1PUVdb7H73FIdaIUPhqOC/hSIN38+JcxWAL4
2Vo/jAQk6b0RkKv2CTsWEmLDEHxspfbvEArBeZAW0+JRl2nj+UYPZ+FLLjVi9m5S
Oyf34layJ0IIADSMNu2bB63IJlf3Yy2UTrdDnXUBSHaB+YNvVVhSJZnHoMHf98Xd
3JAM0/wjQanu/nWyim9OUQ/zBm5hiy4LnIu0mVnrg6PA/5RU08XVhp6m34wNurkh
96u/h2OBcXpxnP3CF5aYGmzZaoTWpRuS4LU5j+uWNHRmiWqxPXqCcz2DN7TFUlUF
APbyUHmJ5B/NXaPFd5TU2OFV1JS4E2m65g9bg+mSnC1U6pJWT8onRt/GY4/tz1S3
/88gxG/H5j9BCDVOKiCuoxPiGEH5f7VnPZC2eSf2SNZkp6yZEUOwDQ5QL55Axbzp
9pk8eC9RUjRiHiWt00UUj74RmBc5VuaLnVq/Vf9mEHQEf/wMyygOQNcZHOJXobX0
QtFzqStdeJ1MvFAjAn15
=soBy
-----END PGP SIGNATURE-----

--Signature=_Tue__12_Mar_2013_14_22_59_+1100_9LHqC7V/srKuWJoX--
