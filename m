Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751089AbaLOCau (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 21:30:50 -0500
Received: from ozlabs.org ([103.22.144.67]:49041 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804AbaLOCam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 21:30:42 -0500
Date: Mon, 15 Dec 2014 13:30:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the tip tree with the pm tree
Message-ID: <20141215133020.3de254a5@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/+qAL1XUsYPYAiO0TSiwQzwk"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/+qAL1XUsYPYAiO0TSiwQzwk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/x86/kernel/apic/io_apic.c between commit 16394fd03114 ("x86 / PM:
Replace CONFIG_PM_RUNTIME in io_apic.c") from the pm tree and various
commits from the tip tree.

I fixed it up (the tip tree seems to have made extensive changes to
this file and there are no longer any references to CONFIG_PM_RUNTIME,
so I used the tip tree version) and can carry the fix as necessary (no
action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/+qAL1XUsYPYAiO0TSiwQzwk
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUjkfDAAoJEMDTa8Ir7ZwV0aYQAI5NyQYBvdsfVOO7TnBQxWg3
SonW6U8aHDvVq6oNRt0UQ5ewXaPxY2wht0qvkK/ZbDyqaxaRK1Gbyp0tLppjjNfj
/EZVnr+nT0yuMbqYGfYapk3f4G2FxmMTKDA0N9JNZa/6tvyBwmWjCFwN0lS1iJzP
w0zThL/Bahgimkwf3ghRiKuo7wdLtzL1/e5ZCG2/ovfx8QsUXrKmfiFcw8CLTY+Z
E5CLzIhUBGygWPm/s3SjU/jAtDHfhHTVsgkAjuGDaM/OQjvWdRvZvXRv07nCYqhs
MASxQP5uOFAtRRS+232hNsxOlF8CwhAlJCTdtX4OhiWKqw7ofeWbOLW+AuoW84oH
TuakxDS/WGZVgSSgsbDxqUNkxUHp4+u6bx1PYZIUVhonRsMMfb9PKnh31gmnL5vX
Y8tl81J+huK4D+DPmpGdOYfp9UKt6Jerw6vzk5SrzG42mom4uWnKDZq1UhVt7KuQ
LEPe2igieRerffeosn+v+/tVqPFE7Xg7UI7dyaKDEFH+J2cdBNLeYtNiiSvGklAu
1GbhPtHH6qJfM+xtuC1yCFtXG4UmmFAAlen354Qn+CB5CSIXAVKRKWbUdaNLhP2j
Su6FiCXKtNCCyOZMjSuwr6XD9EcLuEVJF3JgbL5clhACUoEJ8xcSoXJN5ev8Li+S
SQXxZY5sBZLdmcI1EkGT
=n4b5
-----END PGP SIGNATURE-----

--Sig_/+qAL1XUsYPYAiO0TSiwQzwk--
