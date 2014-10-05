Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694AbaJEKeM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 06:34:12 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:34146 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaJEKeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 06:34:10 -0400
Message-ID: <54311E8E.80906@gmail.com>
Date: Sun, 05 Oct 2014 18:33:50 +0800
From: Lennox Wu <lennox.wu@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: [GIT PULL] S+core : Patches for building allmodconfig and for removing
 useless
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="7gugEsW5pocJx7ePMBMdpuHVW6DBisvdw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7gugEsW5pocJx7ePMBMdpuHVW6DBisvdw
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Please pull these updates for S+core architecture.
Three of the patches are for building allmodconfig, and the others are
for removing useless flags. Thanks.


The following changes since commit 58586869599f6
bb38aeca71a847cd77bfea74808:

  Merge tag 'pm+acpi-3.17-final' of
git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
(2014-10-02 18:47:28 -0700)

are available in the git repository at:


  git://github.com/sctscore/linux-off.git tags/for-linus

for you to fetch changes up to 1742b630e43a6ccca67cf634704e8b76d128947f:

  score: Remove GENERIC_HAS_IOMAP (2014-10-05 04:38:08 +0800)

----------------------------------------------------------------
Chen Gang (3):
      arch: score: Export   'flush_icache_range'
      arch/score/include/asm/Kbuild: Add generic "serial.h"

Michael Opdenacker (1):
      score: remove deprecated IRQF_DISABLED

Richard Weinberger (1):
      score: Remove GENERIC_HAS_IOMAP

 arch/score/Kconfig             | 3 ---
 arch/score/include/asm/Kbuild  | 1 +
 arch/score/kernel/time.c       | 2 +-
 arch/score/lib/checksum_copy.c | 1 +
 arch/score/mm/cache.c          | 2 ++
 5 files changed, 5 insertions(+), 4 deletions(-)


--7gugEsW5pocJx7ePMBMdpuHVW6DBisvdw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJUMR6SAAoJEN984+whgMZcbXgQALr7Ad88XnJ0DdAYZSVY4y9g
VgTH7CTE/W9cm2YhJ0hC0zPBfQ5grzNaeDp8s90t6C6e9zpSiRD2fz3LOTHZ14+O
r/xqLV2AVAPoHu7LiIeS/CWW0P2VeFCz7iN3ysLqZI9ukT8DtjOj93F0dOxRPauC
NPNZFRDIe3XvMAfsA6av5WxtCbUkdKJ/jErDjAuZHbLylZTtk7p8unIVzYD1+vlp
ktdwgJh8x15ZDhFBQCwao/YMMq0zsD0GqIdq/KfO0TmsRyP38naBYS8dwG2FzkqK
DzFZRfZ3oO69nrK0APVnd7sd0FrKE4afDQKA8BE2RC413YHZ8MCOABmu6qY3ke52
Fe8402iy6A5stUz9HLsJrvmtSCpKOhGjvCe6MASrhFPhBv6QidttaVkKSPP2sEqt
tMJQ1OToiM0wI53gb7yZXTitCD4ri7E212iGMTRPTheIM+14muWjGqnYuvIlsj3q
0QFPUuzHQuFnHzWxyy88vzFfYHff6Pd5ekKJBEl/8QF578EM7YawGCF2zCLsc9Ly
FPLVJsL58ZCuCO0B41gD381ln3Z7tH2hTaAgWjSjaNrpDC3ikOuvGgp+DQ/+wU+b
tE9NfTluzwj9uxgpwBjmITosq8/D3RnJB7X6H/wLtQPjcsMGnBuuuNrEZnZCHftm
6yoO7FCkYrWpew+G+YbW
=R1/X
-----END PGP SIGNATURE-----

--7gugEsW5pocJx7ePMBMdpuHVW6DBisvdw--
