Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594Ab3BBDi1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 22:38:27 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:46904 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757429Ab3BBDiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 22:38:25 -0500
Date: Sat, 2 Feb 2013 14:38:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Roese <sr@denx.de>
Subject: linux-next: build warnings after merge of the l2-mtd tree
Message-Id: <20130202143817.a2d9246dcb11cfa08128f588@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__2_Feb_2013_14_38_17_+1100_Z+o/S98PAn/ilVn3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__2_Feb_2013_14_38_17_+1100_Z+o/S98PAn/ilVn3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Artem,

After merging the l2-mtd tree, today's linux-next build (x86_64
allmodconfig) produced these warnings:

In file included from drivers/mtd/chips/cfi_cmdset_0002.c:36:0:
include/linux/of_platform.h:107:13: warning: 'struct of_device_id' declared=
 inside parameter list [enabled by default]
include/linux/of_platform.h:107:13: warning: its scope is only this definit=
ion or declaration, which is probably not what you want [enabled by default]
include/linux/of_platform.h:107:13: warning: 'struct device_node' declared =
inside parameter list [enabled by default]
drivers/mtd/chips/cfi_cmdset_0002.c: In function 'cfi_cmdset_0002':
drivers/mtd/chips/cfi_cmdset_0002.c:504:22: warning: unused variable 'np' [=
-Wunused-variable]
drivers/mtd/chips/cfi_cmdset_0002.c: At top level:
drivers/mtd/chips/cfi_cmdset_0002.c:2279:12: warning: 'cfi_ppb_lock' define=
d but not used [-Wunused-function]
drivers/mtd/chips/cfi_cmdset_0002.c:2285:12: warning: 'cfi_ppb_unlock' defi=
ned but not used [-Wunused-function]
drivers/mtd/chips/cfi_cmdset_0002.c:2382:12: warning: 'cfi_ppb_is_locked' d=
efined but not used [-Wunused-function]

Introduced by commit c3a02f171365 ("mtd: cfi_cmdset_0002: Support
Persistent Protection Bits (PPB) locking").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sat__2_Feb_2013_14_38_17_+1100_Z+o/S98PAn/ilVn3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRDIopAAoJEECxmPOUX5FEEbwP/1mT/UMVhAf3oZ3ypakI94Y9
7pVx9IEdub+3l+VXMVTkvGYXg4c/U3xrGTn/zaGYDB1VqKeq4kFJEyovJbDBJPLs
w+Z31DcCN3sY+szXGzeusk7n8or5pcWfFNa0oAT8kaBiEZUjVUlGNoSeeumzxq9N
uvgKwBkrxAa/gqNpwSTjXborn0N2AKmJX+njN2UKKhUBB2gY5kTMH0LsgYztALqE
aOoZjOJDX9R6QVlHPVkCO0DE2XpwLVUDJHt4PsAybmwuX8ZVWCNqPz9Qtjl7MKrt
kgApBRmMF6xsZAAOit50HohOhGqom1ISrqlbCxKLpEiiMQM4w0JlVPpwQVbQvKM4
ADMA7GN2HpF7ksxsjIe7dybr8YL0uTicDY+cTdoqaUZ6hqACdZFdk0siUWM9S5Nz
1UeGK6M1ZfC9EzMFH7gOr83aZxvBdoNOxyPXeCM0wjB7pa33s8eErzep5dmsd5kW
gE7CuISyZBcN/WgYMQsWeZHuu4U0vaJVfhrHw6ij2cK8H/9hQDF1p0qbXbSR1V98
jzGrDpsSHjCJlMSfj2XW7gyEPdA38/d/dgyIJxV5RjskQnYiEoobhAx1rwHjspfD
wHjEf4ffGoM2zRlxcrgfgjhqC3E0PdNMa+cQ5UPKs27q0kEv6D7a0XuFtce8ukjD
21p9Qdno3VPngR+OhOvh
=ScwY
-----END PGP SIGNATURE-----

--Signature=_Sat__2_Feb_2013_14_38_17_+1100_Z+o/S98PAn/ilVn3--
