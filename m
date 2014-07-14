Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbaGNBGY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 21:06:24 -0400
Received: from ozlabs.org ([103.22.144.67]:59882 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbaGNBGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 21:06:15 -0400
Date: Mon, 14 Jul 2014 11:06:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Cooper <jason@lakedaemon.net>, <andrew@lunn.ch>,
        <gregory.clement@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>
Subject: linux-next: manual merge of the mvebu tree with Linus' tree
Message-ID: <20140714110605.045e5cf5@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/uWBeAOIUlHZX+cjcjBOSvYM"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/uWBeAOIUlHZX+cjcjBOSvYM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the mvebu tree got a conflict in
arch/arm/Kconfig between commit 19682f72f5db ("ARM: Remove
ARCH_HAS_CPUFREQ config option") from Linus' tree and commit
ba364fc752da ("ARM: Kirkwood: Remove mach-kirkwood") from the mvebu
tree.

I fixed it up (The latter just removed the whole ARCH_KIRKWOOD entry,
so I did that) and can carry the fix as necessary (no action is
required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/uWBeAOIUlHZX+cjcjBOSvYM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTwy0CAAoJEMDTa8Ir7ZwVSssP/0/4OAEr1AjkTGSJX5JmFfGO
cAQwQ/qeiQ41+nyv+XMAi3x4mjgDacbRwqlzzqYb0JIzxfgWLIYYWLCiJEAcMXDK
PaJU/7p7geHjTWoIjkI2ru5vlQtlEZvUpxxKUqKxYR0ielBuVTGArK+SRrZ8bmRs
4CbR6sz7KLVFe76W1Wp+yKS0NEaFMnzOdt9VoeB442ELrINWX7/TH/VVXn10+fQ6
CHHF4gfBOPZ3j5tHXBgY5sX9cqZnAKmKJPY+ceKqsBbxJE3DyNId38eUPsZL0mdm
0OK7+0hPRiF7QRAUBw8kiVzl6HGVkItrBThTXVkZPNzmQRPgEUU4/fVKTTcOb7Hs
JpqA02xlXeIGUu4RQhRm4Pw1jwNExHBuHxKbvfcyU0Ktqzg6PUAWxo5y5EoDh5mx
hJVd/DEpfGucYgMt5aANvbYaurV/JTnG9bWfVZs1wJXarJooD9DvWSuiDvKstmHR
d/4eUSfSPGB8AOLANtZyrH28gqSTDaBqyhSlDUGxRyscFK6gfM8QiMrAKjPM+fY5
NbHryPP/OWfQCrztSQvkS7sSnQpJOaJXsL5ZO6kwhvD0NTX9MxNGqoP1T0XqU+4L
IDEF1uMpLj+LNzszHWs8OP8WzBjQrJFCgzYtJH/4awaBQ7Bkm7ev+yAWcsPMI08D
96hy2f3dkXgzBI3i+bdm
=/spD
-----END PGP SIGNATURE-----

--Sig_/uWBeAOIUlHZX+cjcjBOSvYM--
