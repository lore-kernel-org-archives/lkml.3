Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbaBTTbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 14:31:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41888 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214AbaBTTbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 14:31:22 -0500
Date: Thu, 20 Feb 2014 11:32:49 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.13.4
Message-ID: <20140220193249.GA9315@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.13.4 kernel.

All users of the 3.13 kernel series must upgrade.

The updated 3.13.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.13.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                      |    2=20
 arch/arm/mach-imx/clk-imx6q.c                 |    3=20
 arch/arm/mach-imx/clk-imx6sl.c                |    3=20
 arch/arm/mach-imx/pm-imx6q.c                  |    2=20
 arch/arm64/include/asm/atomic.h               |   29 +++++--
 arch/arm64/include/asm/cacheflush.h           |    1=20
 arch/arm64/include/asm/cmpxchg.h              |    9 +-
 arch/arm64/include/asm/futex.h                |    6 +
 arch/arm64/kernel/kuser32.S                   |    6 +
 arch/arm64/kernel/vdso.c                      |    4 -
 arch/arm64/kernel/vdso/Makefile               |    2=20
 arch/arm64/kernel/vdso/gettimeofday.S         |    7 +
 arch/arm64/lib/bitops.S                       |    3=20
 arch/arm64/mm/mmu.c                           |   12 ++-
 arch/s390/crypto/aes_s390.c                   |   65 ++++++++++++-----
 arch/s390/crypto/des_s390.c                   |   95 ++++++++++++++++-----=
-----
 arch/x86/kernel/cpu/intel.c                   |    2=20
 drivers/irqchip/irq-armada-370-xp.c           |    4 -
 drivers/md/bcache/bcache.h                    |    4 -
 drivers/md/bcache/btree.c                     |    2=20
 drivers/media/dvb-frontends/cx24117.c         |    2=20
 drivers/media/usb/dvb-usb-v2/af9035.c         |    2=20
 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h |    2=20
 drivers/media/usb/dvb-usb-v2/mxl111sf.c       |    2=20
 drivers/media/v4l2-core/videobuf-dma-contig.c |   12 +--
 drivers/media/v4l2-core/videobuf-dma-sg.c     |   10 +-
 drivers/media/v4l2-core/videobuf-vmalloc.c    |   10 +-
 drivers/pinctrl/core.c                        |    2=20
 drivers/pinctrl/pinctrl-at91.c                |   10 +-
 drivers/pinctrl/pinctrl-imx1-core.c           |   10 +-
 drivers/pinctrl/vt8500/pinctrl-wmt.c          |   15 +++-
 drivers/regulator/core.c                      |    9 ++
 fs/btrfs/inode.c                              |    2=20
 fs/buffer.c                                   |    6 +
 fs/nfs/nfs4client.c                           |    2=20
 fs/nfs/nfs4proc.c                             |    8 +-
 fs/nfs/nfs4session.c                          |   25 +++++-
 fs/nfs/nfs4session.h                          |    2=20
 include/linux/nfs_xdr.h                       |    2=20
 kernel/irq/Kconfig                            |    1=20
 lib/Makefile                                  |    1=20
 mm/page-writeback.c                           |    5 -
 mm/swapfile.c                                 |   11 ++-
 security/selinux/ss/services.c                |    4 +
 sound/pci/hda/patch_analog.c                  |   27 +++++++
 sound/pci/hda/patch_realtek.c                 |    9 ++
 sound/usb/Kconfig                             |    1=20
 47 files changed, 317 insertions(+), 136 deletions(-)

Andi Shyti (1):
      cx24117: use a valid dev pointer for dev_err printout

Antti Palosaari (1):
      af9035: add ID [2040:f900] Hauppauge WinTV-MiniStick 2

Catalin Marinas (1):
      arm64: Invalidate the TLB when replacing pmd entries during boot

Chris Ruehl (2):
      pinctrl: imx27: fix wrong offset to ICONFB
      pinctrl: imx27: fix offset calculation in imx_read_2bit

Darrick J. Wong (1):
      bcache: fix BUG_ON due to integer overflow with GC_SECTORS_USED

Dave Jones (2):
      mxl111sf: Fix unintentional garbage stack read
      mxl111sf: Fix compile when CONFIG_DVB_USB_MXL111SF is unset

Greg Kroah-Hartman (1):
      Linux 3.13.4

Hans Verkuil (1):
      Revert "[media] videobuf_vm_{open,close} race fixes"

Harald Freudenberger (3):
      crypto: s390 - fix concurrency issue in aes-ctr mode
      crypto: s390 - fix des and des3_ede cbc concurrency issue
      crypto: s390 - fix des and des3_ede ctr concurrency issue

Josef Bacik (1):
      Btrfs: disable snapshot aware defrag for now

KOSAKI Motohiro (2):
      mm: __set_page_dirty_nobuffers() uses spin_lock_irqsave() instead of =
spin_lock_irq()
      mm: __set_page_dirty uses spin_lock_irqsave instead of spin_lock_irq

Lior Amsalem (2):
      irqchip: armada-370-xp: fix IPI race condition
      irqchip: armada-370-xp: fix MSI race condition

Mark Brown (1):
      regulator: core: Correct default return value for full constraints

Mel Gorman (1):
      x86: mm: change tlb_flushall_shift for IvyBridge

Nathan Lynch (2):
      arm64: vdso: update wtm fields for CLOCK_MONOTONIC_COARSE
      arm64: vdso: fix coarse clock handling

Nicolas Ferre (1):
      pinctrl: at91: use locked variant of irq_set_handler

Nitin A Kamble (1):
      genirq: Generic irq chip requires IRQ_DOMAIN

Peter Oberparleiter (1):
      x86, hweight: Fix BUG when booting with CONFIG_GCOV_PROFILE_ALL=3Dy

Philipp Zabel (1):
      ARM: imx6: Initialize low-power mode early again

Stanislaw Gruszka (1):
      pinctrl: protect pinctrl_list add

Stephen Smalley (1):
      SELinux: Fix kernel BUG on empty security contexts.

Takashi Iwai (5):
      ALSA: usb-audio: Add missing kconfig dependecy
      ALSA: hda - Fix missing VREF setup for Mac Pro 1,1
      ALSA: hda - Fix silent output on Toshiba Satellite L40
      ALSA: hda - Add missing mixer widget for AD1983
      ALSA: hda - Improve loopback path lookups for AD1983

Tony Prisk (1):
      pinctrl: vt8500: Change devicetree data parsing

Trond Myklebust (2):
      NFSv4.1: nfs4_destroy_session must call rpc_destroy_waitqueue
      NFSv4: Fix memory corruption in nfs4_proc_open_confirm

Vinayak Kale (1):
      arm64: add DSB after icache flush in __flush_icache_all()

Weijie Yang (1):
      mm/swap: fix race on swap_info reuse between swapoff and swapon

Will Deacon (2):
      arm64: atomics: fix use of acquire + release for full barrier semanti=
cs
      arm64: vdso: prevent ld from aligning PT_LOAD segments to 64k


--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIbBAEBAgAGBQJTBlhhAAoJEDjbvchgkmk+WcoP+LCj+vic8fhzjZsNcFR6Rm8a
HkiRPNgpQPsk1vwrMPWupfbFZRXWoU9A5H/B+ChENEwb9wCT8R+YZYQxxavg2jZe
IhqkJwvPR5o47EFHqxXsZhwRqBm9dZpoNOEhda6bFVVy7cfW5g1NhUVEraoGXI7w
cPQcve9lKmVws6ogZUMCo+dLz5HlQl2fZkYxawZHs3Ep2ikcV+lQL8lyePkFpK0Z
HXWlRlq12DnrT5RAFJXxCbAgQF2Mi/NHnXT5P2zQoJA8x8Po9RLyRy5HxVuCvmAI
Q4Wy8z+ydOL3b+hDmOD5SK6hNWgDetBP8vM1HholT78f0E8VtAnvEthyL4i2ginL
IinqXyZ014Cxi6maa9Xnq4pCL2Bar/v/btDyVgX8ePhMVmla/PNk4bpDE5DfpAzt
FQlfDHN/Q5LqJohJ0KSbUHyqcxZq22CS8fQhjG38isvj7D/ybQCmm8s43ArZCU5/
a6fP9CgExhDFuNt3Cn2pB/lnzLXuh5b0RkOXQYNGL5Gc5OrN44jrFbj5wBqQrDC5
uxx+SLqBA/h+PxCNU6x/CZ2gSmb3bQMMN+MNenMSDPfwEvGCZcC0cNlPTwqH/38w
sSc84iY0xdXc7A9ZJ+oLmQUqIxnW5bj/hUUJ+nuuyrFZJb6e+B4GXnSx2/VgEoGP
2fpptMlYZZG86pSs9Qo=
=MKCb
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
