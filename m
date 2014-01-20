Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbaATPbP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 10:31:15 -0500
Received: from multi.imgtec.com ([194.200.65.239]:57312 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150AbaATPbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 10:31:12 -0500
Message-ID: <52DD413D.2050905@imgtec.com>
Date: Mon, 20 Jan 2014 15:31:09 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-metag <linux-metag@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James <james.hogan@imgtec.com>, Jiang Liu <liuj97@gmail.com>,
        Chen Gang <gang.chen.5i5j@gmail.com>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [GIT PULL] Metag architecture changes for v3.14
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="w5Pe5wrObtfHwvnQ7kA78MmbCdvIxcaG3"
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2014_01_20_15_31_10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--w5Pe5wrObtfHwvnQ7kA78MmbCdvIxcaG3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull the following changes since commit 6ce4eac1f600b34f2f7f58f9cd=
8f0503d79e42ae:

  Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)

which are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jhogan/metag.git tags/met=
ag-for-v3.14

for you to fetch changes up to e9a1d0165bbda4398d4a5d71736cf6390fb42c6f:

  metag/smp: Make boot_secondary() static (2014-01-06 09:59:22 +0000)

Thanks
James

----------------------------------------------------------------
Metag architecture changes for v3.14

- A few cleanups and minor bug fixes.
- Kill SMP single function call IPI.

----------------------------------------------------------------
Chen Gang (1):
      metag: topology: export 'cpu_core_map'

Geert Uytterhoeven (1):
      metag/smp: Make boot_secondary() static

James Hogan (2):
      metag: dma: remove dead code in dma_alloc_init()
      metag: smp: don't set irq regs in do_IPI()

Jiang Liu (1):
      smp, metag: kill SMP single function call interrupt

 arch/metag/include/asm/smp.h |  2 --
 arch/metag/kernel/dma.c      |  5 -----
 arch/metag/kernel/smp.c      | 15 ++++-----------
 arch/metag/kernel/topology.c |  1 +
 4 files changed, 5 insertions(+), 18 deletions(-)


--w5Pe5wrObtfHwvnQ7kA78MmbCdvIxcaG3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJS3UE9AAoJEKHZs+irPybfM0IP/A3y4Mkj4Q4bBdvJokpmaCvm
Zy0Tvyb4mZ9r+T7Nem6RJCIUQDJlaOz9Rg0ykzsXH8yZILnCzVXgup9TXRup748u
aNmW89gRbJUPCZXOq+bekp76jLbleQuVoPOW3WUXEkwm3HyqoFXWm9bbI6TeHdsp
XX4CjLAUMIKpvPn6TqMQ5/SAD2U0S8VnVh9jitYrTpR5FATubQNLI88YJwKQspGu
9X+y7G8JqeIW0HFVd6UPInSZEOJUSk1t1z5e5xHcK+BIvnyp9/ig1ECoxB2Kt5mH
K3WuQw8QX/mg160gg2gvtjb9J3HUiXEXIlRvTh5+QWe4iN76mNu9ZeLkc8enXDEx
Q2sqXUhqW8cCOXjVmzqlewAX9LpZTdn1zwVZPxJWcsdZHN65v/n/Ecz48LQjhzga
2i93xpZ1BnsSMS79PPMM/U3CGz2jar02ERnYxT9KPeuc4FRX6obWaI+UcRoNvN48
kVZppE+LsqSqI3kHRJBflcBi8AE8uAwCL4rdFyiBztOd7dZc3V8Y0MBEtim+qF/I
W8T0N5V8/3JT6uNIAi0yKhnEcbUUUDNBzgcCaJFTp4CZoNOtlr1qrw+GCxkvga4a
82drJNf/Ahtn4bGZfvsb2IMfjRTs8BxpEWfaZAyiqmEdkhX+i/7t9oTKVkOrKxmy
OQLIhhbp3RiO6VKSvBPa
=cx3O
-----END PGP SIGNATURE-----

--w5Pe5wrObtfHwvnQ7kA78MmbCdvIxcaG3--

