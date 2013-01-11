Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab3AKESj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 23:18:39 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:57286 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab3AKESi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 23:18:38 -0500
Date: Fri, 11 Jan 2013 15:18:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Romain Naour <romain.naour@openwide.fr>,
        Stephen Warren <swarren@nvidia.com>
Subject: linux-next: manual merge of the samsung tree with the arm-soc tree
Message-Id: <20130111151828.bd7069afb779f8d08900f165@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__11_Jan_2013_15_18_28_+1100_7MimW1b237+0z3vp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__11_Jan_2013_15_18_28_+1100_7MimW1b237+0z3vp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the samsung tree got a conflict in
arch/arm/plat-samsung/time.c between various commits from the arm-soc
tree and commit 0e4a0a6e970e ("ARM: SAMSUNG: Remove unused
plat-samsung/time.c") from the samsung tree.

The latter removes the file, so I did that.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__11_Jan_2013_15_18_28_+1100_7MimW1b237+0z3vp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ75KUAAoJEECxmPOUX5FEB18P/1//sJ4WTNGYNEJStQZf/r7G
Grb3EBAEcpsSIo83Hzjv8P9iSRSk/cN0lWkc1D0wJ5cHdL/ZIUxH34RYiQaqYZdn
0JdN7pl0leLQclWotrbY0d3p087OMTYAdhJ9DH9As7jhIrNtJLIGImSrA4zF7CD3
pxiVZSwF0caZezSSKntZZcF6ASvQxLZ/iok8L7H0rfs0PLCBJTihk2AFkEyrPdHa
UMfb/RpfaQivJ43KcAQLFyndDyH48ReKOHPTFf8RmzRVJKhSxy1sDjZa5p+E6z8a
wNx5BFdC+epKHeOAr/5rk4gdTzaGhYc1itFC5lXDRU2hvmc9ac7xMWHlj8dB3UIC
3R1Ht3fELoB3R6Vf/nd8IeWwcWITIwXsYBGvs3RkeQ+UQny4LetoJ15ubsi032u4
Yb589A9wvO7MUarfxF9jBUG8G9jF9VkdsrSFvYJcCDDMFJWoYcgD9Ls0DZAAYCjz
zMY8uBsS/n2G1Xf8GE3Vmrmvx9r3aDRQZ4+i0u+w3huzSEV4+7Mpt7bdrbWxTLc3
boM7LlIsTvnRRo5tz8V8eZdT2Yz3PFpWbXfm+ujTmJm0HM+1j818KA7Ip1t8+O+6
JRFToxSN5hT95Bg0Uf6JZZCy8UZdza3EU5jdMhSP0CbKy7k01Jorrjo8JHfa8GU4
sC1HV+Jk21ZKnvWLe76w
=IMD6
-----END PGP SIGNATURE-----

--Signature=_Fri__11_Jan_2013_15_18_28_+1100_7MimW1b237+0z3vp--
