Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbaBRDJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 22:09:35 -0500
Received: from ozlabs.org ([203.10.76.45]:41286 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317AbaBRDJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 22:09:28 -0500
Date: Tue, 18 Feb 2014 14:09:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chen Gang <gang.chen.5i5j@gmail.com>,
        Hans-Christian Egtvedt <hegtvedt@cisco.com>,
        Tim Chen <tim.c.chen@linux.intel.com>
Subject: linux-next: manual merge of the tip tree with Linus' tree
Message-Id: <20140218140920.e79e5cff80dad8ecee400538@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__18_Feb_2014_14_09_20_+1100_mBaQ69lePelfi52T"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__18_Feb_2014_14_09_20_+1100_mBaQ69lePelfi52T
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/avr32/include/asm/Kbuild between commit d7668f9d448a ("avr32: add
generic vga.h to Kbuild") from the  tree and commit b119fa61d440
("locking/mcs: Order the header files in Kbuild of each architecture in
alphabetical order") from the tip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/avr32/include/asm/Kbuild
index c7c64a63c29f,8b398ff96974..000000000000
--- a/arch/avr32/include/asm/Kbuild
+++ b/arch/avr32/include/asm/Kbuild
@@@ -1,22 -1,22 +1,23 @@@
 =20
- generic-y	+=3D clkdev.h
- generic-y       +=3D cputime.h
- generic-y       +=3D delay.h
- generic-y       +=3D device.h
- generic-y       +=3D div64.h
- generic-y       +=3D emergency-restart.h
- generic-y	+=3D exec.h
- generic-y       +=3D futex.h
- generic-y	+=3D preempt.h
- generic-y       +=3D irq_regs.h
- generic-y	+=3D param.h
- generic-y       +=3D local.h
- generic-y       +=3D local64.h
- generic-y       +=3D percpu.h
- generic-y       +=3D scatterlist.h
- generic-y       +=3D sections.h
- generic-y       +=3D topology.h
- generic-y	+=3D trace_clock.h
+ generic-y +=3D clkdev.h
+ generic-y +=3D cputime.h
+ generic-y +=3D delay.h
+ generic-y +=3D device.h
+ generic-y +=3D div64.h
+ generic-y +=3D emergency-restart.h
+ generic-y +=3D exec.h
+ generic-y +=3D futex.h
+ generic-y +=3D hash.h
+ generic-y +=3D irq_regs.h
+ generic-y +=3D local.h
+ generic-y +=3D local64.h
+ generic-y +=3D mcs_spinlock.h
+ generic-y +=3D param.h
+ generic-y +=3D percpu.h
+ generic-y +=3D preempt.h
+ generic-y +=3D scatterlist.h
+ generic-y +=3D sections.h
+ generic-y +=3D topology.h
+ generic-y +=3D trace_clock.h
 +generic-y +=3D vga.h
- generic-y       +=3D xor.h
- generic-y	+=3D hash.h
+ generic-y +=3D xor.h

--Signature=_Tue__18_Feb_2014_14_09_20_+1100_mBaQ69lePelfi52T
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTAs7lAAoJEMDTa8Ir7ZwVE9UP/jgMxFUsfRI4VNt7w4n/ihOn
Ij0mu/vbhqzoKmHDbu6YEnQo1HhwZdYop5P85MM8gOTXgfHefeMknHiVkacZziKx
XhToZKdaSO9QMouN0K+JPnz6Cq5KkCna60n5w7j8lo0Recxf2xeqzuQoNPdfENzw
oXCiqhVLOOfbcWpbEuQpY/hzfNzHY1DHdDPIWu61Z0yyZaudP3pIpnJOMoe22WAL
yHHW8ZZh6KbNsaIOTfUZrLpEmVBsU0DOt2egU3JMMhFiOBSxyCuPQmrG1aP08MQ4
rD7wi2r80MAo/s4bcan2FIx4OmRnUbuq44QY6XpIpyed1+f4GO7uvwVYVyfu2Bp5
1lHx/PBbp44ELGvyW0BwfwQcozefP8fuztgQiRqN2dcGtn4v5xsA2qz3F8txCiaq
onBulwJbnSE4OXfBlb9FFM46ehj9C2sP+0dz6d3Oo0sxUsaQD9tNQy8+51X/kvHx
TvL9FtRA1C/LNbSXf2R/H1pyhF9krn13dztk9w+wRQXlRp316O0R7JDkmK0CRBgm
ejQDSyF+WSQY3l6aQVe3tgBUVOxkDfFPJPqD6oMp8eUm8u18eznwYD4wxuJoLh3J
3Ct+kR3oBUbNVnhyO99K/FO/YTzxlOz24UYBWBR7VvsfO5qJ+em8SDp6UOjkIWPB
wHef+CyJj9KMtxJtVCEb
=MMPM
-----END PGP SIGNATURE-----

--Signature=_Tue__18_Feb_2014_14_09_20_+1100_mBaQ69lePelfi52T--
