Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669AbaHHCTv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 22:19:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50084 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101AbaHHCTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 22:19:49 -0400
Date: Thu, 7 Aug 2014 19:19:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.102
Message-ID: <20140808021949.GA31832@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.102 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.4.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/x86/x86_64/mm.txt         |    2=20
 Makefile                                |    2=20
 arch/arm/mm/idmap.c                     |    7 +
 arch/x86/Kconfig                        |   25 +++
 arch/x86/include/asm/espfix.h           |   16 ++
 arch/x86/include/asm/irqflags.h         |    2=20
 arch/x86/include/asm/pgtable_64_types.h |    2=20
 arch/x86/include/asm/setup.h            |    2=20
 arch/x86/kernel/Makefile                |    1=20
 arch/x86/kernel/entry_32.S              |   12 +
 arch/x86/kernel/entry_64.S              |   80 ++++++++++--
 arch/x86/kernel/espfix_64.c             |  208 +++++++++++++++++++++++++++=
+++++
 arch/x86/kernel/ldt.c                   |   10 -
 arch/x86/kernel/paravirt_patch_64.c     |    2=20
 arch/x86/kernel/smpboot.c               |    7 +
 arch/x86/mm/dump_pagetables.c           |   39 ++++--
 arch/x86/vdso/vdso32-setup.c            |    8 -
 crypto/af_alg.c                         |    2=20
 drivers/scsi/scsi_lib.c                 |    8 +
 include/linux/printk.h                  |    6=20
 include/linux/skbuff.h                  |   17 --
 init/main.c                             |    4=20
 kernel/printk.c                         |    2=20
 kernel/sched/core.c                     |    2=20
 kernel/sched/rt.c                       |    2=20
 kernel/time/clockevents.c               |   10 -
 lib/btree.c                             |    1=20
 mm/mlock.c                              |    2=20
 mm/page_alloc.c                         |   16 +-
 mm/rmap.c                               |   14 +-
 net/ipv4/ip_forward.c                   |   68 ----------
 net/ipv6/addrconf.c                     |   14 +-
 net/ipv6/ip6_output.c                   |   13 --
 net/l2tp/l2tp_ppp.c                     |    4=20
 34 files changed, 446 insertions(+), 164 deletions(-)

Andy Lutomirski (1):
      x86_64/entry/xen: Do not invoke espfix64 on Xen

Boris Ostrovsky (1):
      x86/espfix/xen: Fix allocation of pages for paravirt page tables

David Rientjes (1):
      mm, thp: do not allow thp faults to avoid cpuset restrictions

Gao feng (1):
      ipv6: reallocate addrconf router for ipv6 address when lo device up

Greg Kroah-Hartman (2):
      Revert: "net: ip, ipv6: handle gso skbs in forwarding path"
      Linux 3.4.102

H. Peter Anvin (6):
      Revert "x86-64, modify_ldt: Make support for 16-bit segments a runtim=
e option"
      x86-64, espfix: Don't leak bits 31:16 of %esp returning to 16-bit sta=
ck
      x86, espfix: Move espfix definitions into a separate header file
      x86, espfix: Fix broken header guard
      x86, espfix: Make espfix64 a Kconfig option, fix UML
      x86, espfix: Make it possible to disable 16-bit support

James Bottomley (1):
      scsi: handle flush errors properly

Jan Kara (1):
      timer: Fix lock inversion between hrtimer_bases.lock and scheduler lo=
cks

John Stultz (1):
      printk: rename printk_sched to printk_deferred

Konstantin Khlebnikov (1):
      ARM: 8115/1: LPAE: reduce damage caused by idmap to virtual memory la=
yout

Milan Broz (1):
      crypto: af_alg - properly label AF_ALG socket

Minfei Huang (1):
      lib/btree.c: fix leak of whole btree nodes

Sasha Levin (1):
      net/l2tp: don't fall back on UDP [get|set]sockopt

Vlastimil Babka (1):
      mm: try_to_unmap_cluster() should lock_page() before mlocking


--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT5DPFAAoJEDjbvchgkmk+jJIP/2fVSM/2+I5S++qBnvYcIkNH
/64dGsa+de/V59taTeeiM+AMfbA16dULCwXGJKbgsXXb7gka+ccHw6D/2BnT3yAO
2Ddj/ZXPGMoeg2CzHmMegcS/TbH2E1pStvt5lCms0PWt4WRGzCkMREtA8arfSTmm
nboWXyA6qmf9ALiWttZtkYbvNXI7/ihcqUlZYYd1RVS44VLL07QdwFGl8EcvMTVS
rdS29CpVZFx3eE1YouiZ6YqbArPFUOk5D6pWeasBJiIMSou60ktyrCVJ0lNNeyzo
2EqamZPhxWg6ppOQYc+t41vbiBdjYdgvK1kHj55pGUPaZUNpyvGGoWL9TVgfs3T4
chc8V2vZjqeYcQ1bTQMfICkFWUeDZluRXLZbBudTCTyHps3wncT6CGjx3S05F+8R
at1yZK/zZN9qWDqiC2VLysy4tw7tlEJweyCP3GxXobPYO9QR04XuDN49SM1RyZRz
IvRU0MwGIMiJOZ+d9Fa/VRPwZz4rL1C1eT54m+0szTx5N+ru81pl9zrWA8Ji4hSv
QnAUf6vFokXcLgYMSVRlt+M/DXx5RXCRgJAwbCMASZjKnWdfy+Y9JlhWIBdljMVO
RvLunDDSuvCkbXCxB2G+GP94UImJ8kkqLBWrLCXEnITURcuZ1KM9GwoF+nEhIgvo
BzSAqVs7cgbpSOppxkzB
=Frq5
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
