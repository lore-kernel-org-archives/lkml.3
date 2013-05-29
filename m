Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934845Ab3E2DfO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 23:35:14 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36772 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932280Ab3E2DfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 23:35:12 -0400
Date: Wed, 29 May 2013 13:34:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the xen-arm tree
Message-Id: <20130529133459.fb060dcd20cb00049bed55cd@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__29_May_2013_13_34_59_+1000_LdZ9BN/mVqYZMTWX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__29_May_2013_13_34_59_+1000_LdZ9BN/mVqYZMTWX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stefano,

After merging the xen-arm tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

kernel/sched/cputime.c:8:26: fatal error: asm/paravirt.h: No such file or d=
irectory
 #include <asm/paravirt.h>
                          ^

Caused by commit d31d069a9f68 ("kernel: missing include in cputime.c").
Only three architectures have that file (x86, arm and ia64).

I have used the xen-arm tree from next-20130528 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__29_May_2013_13_34_59_+1000_LdZ9BN/mVqYZMTWX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRpXdnAAoJEECxmPOUX5FEAcEP/14lBH1E8VBk2P05aCDp6Leu
FxBWAW74DX0a99epqyopyy7I2dXhPMTT/4PlDA9uNycYmI57eFlmY9s1Iny2N4Cs
j7tlfBewAttSOTIIciuFM3O8pPgeXNj/c5roghri6UKmLh9oGSmlUFCwXJNo1CMy
OygpKWlQ805CcZ2ut8ln8J8D52C3bQV5S11+Et0ka3frGftkcEQISzP9XN4iP0sP
AXDEiTdihJt6YbdSNms+cE3OGpibA4rPuaTeLadg/cn0pQYMOv6+ACBNtSKsyxAn
tMJ6y3QOhoyWO/ftCkRUgW23YT5HwIu7sZW6uF+XzuBhdd0vbWncHC6DTAFoW+Z3
KNNuEq9odm2i12adFRZvy4BvjX4Gz5MnriFhDKjYnYk2pNCXb7w5ByyEkja+UpOB
rX3lT/6XMlNUdqjfDHRZ3EfQYdcuMFo+DHcvWZEMUsutHZ2SpfO4wPnogQWPVYQP
LQS3OK6/0zAA+s6hrubezwpsZhkWJl9ky2Pw5dQIcY4caS0gnTJFr8RXcqxoNwyO
lXEuY5fMi7rdKR5r5bg4ry/voEUyeCQGQDbafDMxLIKpThxZO0iowRDGAGzJrALU
Q9BpIF8x9qxFhdID/efhLhZUeF7tPKJ3FwJ5hGKEQSFqxzrOFPUC9vMM6KUmZ0iw
yU9QnoJKorDaPMEOQNux
=Yv5C
-----END PGP SIGNATURE-----

--Signature=_Wed__29_May_2013_13_34_59_+1000_LdZ9BN/mVqYZMTWX--
