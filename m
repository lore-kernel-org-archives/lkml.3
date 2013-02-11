Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab3BKB72 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 20:59:28 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:55669 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab3BKB7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 20:59:14 -0500
Date: Mon, 11 Feb 2013 12:59:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: linux-next: manual merge of the acpi tree with the pm tree
Message-Id: <20130211125912.2543dcc111b7b67dca8b2e05@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__11_Feb_2013_12_59_12_+1100_675JensdqlJR4qNW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__11_Feb_2013_12_59_12_+1100_675JensdqlJR4qNW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Len,

Today's linux-next merge of the acpi tree got a conflict in
arch/x86/kernel/process.c between commit 43720bd60143 ("PM / tracing:
remove deprecated power trace API") from the pm tree and commit
69fb3676df33 ("x86 idle: remove mwait_idle() and "idle=3Dmwait" cmdline
param") from the acpi tree.

I fixed it up (the latter removed the function modified by the former, so
I did that) and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__11_Feb_2013_12_59_12_+1100_675JensdqlJR4qNW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRGFBwAAoJEECxmPOUX5FE+MoP/3c8QsqAjMg0Hz/HB2sJwkCU
8QygFqJ5bqyjCWL5LgCShOz4n1OWzYqcHHFrY45qjWKfyq1g1fD3Fgrd2l7goVRt
bYP/FCV/1qVDd1RkekEhDE2FovU4a1pIjHppd5n/8G5BBb7Fqep2oV+DnFheIbW4
YpbB1IjbheyIVDWhkCa5huEQlU0HMfsj16q9QqZPNHtelu/lTd4Sik/JHIqSya77
XEUdYKZXHoMfdDcJJG0GhTjlN7MJarke55KZlIXUMCY6oFBfp9hj6GFFon/o3Ab8
ZGWhN9M/deUb2CxZP0CEK8A8xSqbqMDyycFD5C2VrBAtzwpyOkmX9aSRZ8uED+NW
qxZ8QidQCFktsjDG/A5HeD7v2JZyRWr6UiYH4m6s3lU0efWbtseFm6t7W6IE9tJ9
L2te4JYlz54J80WuAm8LAA7637m1ZyAPCxu0VpIK4nNxZDjUS2Tjs/LD1siKAZbi
/bwCi9SGU8VlXgMEQBWYsrKrN3Nk7kCG31+LpQldv6qfcXcKPasYfOwDbIbJ5foE
O9GHqbwopp2+Gxmy22hXarXEYZqLViiU1LXQ9Un/Wvk3W0JGi/pRqq7rDI2LQmxu
2hBYUtR63q6OxB8UN9ZhhNAEgbwopd5q3rhdVeuRb14mtR1OlkMvY+gem5Bg6CoJ
JBm7t45myUv4+vGz7UXU
=fGjD
-----END PGP SIGNATURE-----

--Signature=_Mon__11_Feb_2013_12_59_12_+1100_675JensdqlJR4qNW--
