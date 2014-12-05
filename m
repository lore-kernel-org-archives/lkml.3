Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220AbaLELFJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 06:05:09 -0500
Received: from ozlabs.org ([103.22.144.67]:42788 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbaLELFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 06:05:07 -0500
Date: Fri, 5 Dec 2014 22:04:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuahkh@osg.samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tim Bird <tim.bird@sonymobile.com>,
        David Drysdale <drysdale@google.com>
Subject: linux-next: manual merge of the akpm-current tree with the
 kselftest-fixes tree
Message-ID: <20141205220456.60b39852@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/_E.dyJ9=l16KdloO6onlIMS"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/_E.dyJ9=l16KdloO6onlIMS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
tools/testing/selftests/Makefile between commit 3ce51050fadd
("selftest: size: Add size test for Linux kernel") from the
kselftest-fixes tree and commit 4126d336d7c3 ("syscalls: add selftest
for execveat(2)") from the akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc tools/testing/selftests/Makefile
index fa91aefc8d19,c14893b501a9..000000000000
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@@ -15,7 -15,7 +15,8 @@@ TARGETS +=3D use
  TARGETS +=3D sysctl
  TARGETS +=3D firmware
  TARGETS +=3D ftrace
+ TARGETS +=3D exec
 +TARGETS +=3D size
 =20
  TARGETS_HOTPLUG =3D cpu-hotplug
  TARGETS_HOTPLUG +=3D memory-hotplug

--Sig_/_E.dyJ9=l16KdloO6onlIMS
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUgZFgAAoJEMDTa8Ir7ZwVD4wP/jcANq3cuUGPgsXrPBuui6AR
w0xoZAsObRyJCLxm17o8pRSCXkPclXnEEbHEGt99IgskKSPkIp9Qwcaaci/ySOCU
XR6Rpv4nUdBqDMns4znvH4kd9vrf9D/7s22OWl3LaNa5q+5VneEsiOxDcrezLuCJ
Cm/xvIV6NPxedUBrZ6E4mx2nGb6CFtWdi/6xVHu5wQxViYa4IOGUEng3qEEhvj3i
4TDxSucQ4xzombgtuztq8HOVxirakdIfxvyPTdZ5qPbS8lio6iqx5ZEZN14AoMDq
Jaf6ATAAWo7nPOY2BzX7PQRTpsBb71WSt0d5ZIyBtOgKwmhIiH1qxlE+upJ/4k05
1fndUfSxHlrOGiigZwUNZfMQKsuZ9IUepJ7Exc05Kb3Ej8e5kgd8oQrm3f3YoA9a
Np6FQ7titgYsI1Ge5rZ9fuXbWnZOzB/iXy7eUatOsesrrpsvyri1Ex+zw5eZHBKT
NylJA9Vuda/fbdZM1n0nwbd/Fgq8A/2t7Xt2/BbqU8ZZDV/O8ne8z5qHd7iL7Tej
cXZMdTkvk6t1hOxrfMYGCTrC2GzlUkEuHgzPDJrj2kmWqo2bwnsaCtMjeEM+J5bI
m/kfiCpx85nkIkd4LMsMovtkuD6nLnFvwHIlrfUx+18cRY0YixGDPWmfN6GjuXgl
5C1sV4k5fsg4omt7iPVN
=CLAb
-----END PGP SIGNATURE-----

--Sig_/_E.dyJ9=l16KdloO6onlIMS--
