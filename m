Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965884Ab3DQGub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 02:50:31 -0400
Received: from mail-da0-f49.google.com ([209.85.210.49]:42811 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965786Ab3DQGu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 02:50:27 -0400
Date: Tue, 16 Apr 2013 23:50:23 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.8.8
Message-ID: <20130417065023.GA13310@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.8.8 kernel.

All users of the 3.8 kernel series must upgrade.

The updated 3.8.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.8.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                                 |    2=20
 arch/arm/boot/dts/kirkwood-iomega_ix2_200.dts            |   14=20
 arch/arm/mach-imx/clk-imx35.c                            |    1=20
 arch/x86/include/asm/paravirt.h                          |    5=20
 arch/x86/include/asm/paravirt_types.h                    |    2=20
 arch/x86/include/asm/tlb.h                               |    2=20
 arch/x86/kernel/paravirt.c                               |   25 -
 arch/x86/lguest/boot.c                                   |    1=20
 arch/x86/mm/fault.c                                      |    6=20
 arch/x86/mm/pgtable.c                                    |    7=20
 arch/x86/xen/mmu.c                                       |    1=20
 drivers/dma/omap-dma.c                                   |   20=20
 drivers/gpio/gpiolib-of.c                                |    5=20
 drivers/gpu/drm/udl/udl_connector.c                      |    4=20
 drivers/net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c    |  369 +++++-----=
-----
 drivers/net/wireless/brcm80211/brcmsmac/phy/phytbl_lcn.c |   64 +-
 drivers/scsi/libsas/sas_expander.c                       |   12=20
 drivers/target/target_core_alua.c                        |    3=20
 drivers/tty/tty_ldisc.c                                  |   10=20
 fs/cifs/connect.c                                        |   16=20
 fs/gfs2/file.c                                           |    5=20
 fs/gfs2/rgrp.c                                           |    2=20
 fs/inode.c                                               |    2=20
 include/asm-generic/tlb.h                                |    7=20
 include/linux/ftrace.h                                   |    3=20
 ipc/msg.c                                                |    1=20
 kernel/sched/clock.c                                     |   26 +
 kernel/sys.c                                             |    3=20
 kernel/trace/ftrace.c                                    |   37 -
 kernel/trace/trace_stack.c                               |    2=20
 lib/kobject.c                                            |    9=20
 mm/memory.c                                              |    1=20
 sound/soc/codecs/wm5102.c                                |    2=20
 sound/soc/codecs/wm8903.c                                |    2=20
 sound/soc/soc-core.c                                     |    2=20
 sound/usb/mixer_quirks.c                                 |    4=20
 sound/usb/quirks.c                                       |    2=20
 37 files changed, 335 insertions(+), 344 deletions(-)

Alban Bedel (1):
      ASoC: wm8903: Fix the bypass to HP/LINEOUT when no DAC or ADC is runn=
ing

Boris Ostrovsky (1):
      x86, mm: Patch out arch_flush_lazy_mmu_mode() when running on bare me=
tal

Dave Airlie (1):
      udl: handle EDID failure properly.

Dave Hansen (1):
      x86-32: Fix possible incomplete TLB invalidate with PAE pagetables

Eldad Zack (1):
      ALSA: usb-audio: fix endianness bug in snd_nativeinstruments_*

Greg Kroah-Hartman (1):
      Linux 3.8.8

Haojian Zhuang (1):
      gpio: fix wrong checking condition for gpio range

Huacai Chen (1):
      PM / reboot: call syscore_shutdown() after disable_nonboot_cpus()

John W. Linville (1):
      Revert "brcmsmac: support 4313iPA"

Joonyoung Shim (1):
      ASoC: core: Fix to check return value of snd_soc_update_bits_locked()

Linus Torvalds (1):
      kobject: fix kset_find_obj() race with concurrent last kobject_put()

Lukasz Dorau (1):
      SCSI: libsas: fix handling vacant phy in sas_set_ex_phy()

Mark Brown (1):
      ASoC: wm5102: Correct lookup of arizona struct in SYSCLK event

Markus Pargmann (1):
      ARM: imx35 Bugfix admux clock

Namhyung Kim (2):
      tracing: Fix double free when function profile init failed
      tracing: Fix possible NULL pointer dereferences

Nicholas Bellinger (1):
      target: Fix incorrect fallthrough of ALUA Standby/Offline/Transition =
CDBs

Nigel Roberts (1):
      ARM: Kirkwood: Fix typo in the definition of ix2-200 rebuild LED

Peter Ujfalusi (1):
      dmaengine: omap-dma: Start DMA without delay for cyclic channels

Sachin Prabhu (1):
      cifs: Allow passwords which begin with a delimitor

Samu Kallio (1):
      x86, mm, paravirt: Fix vmalloc_fault oops during lazy MMU updates

Sebastian Andrzej Siewior (1):
      tty: don't deadlock while flushing workqueue

Stanislav Kinsbursky (1):
      ipc: set msg back to -EAGAIN if copy wasn't performed

Steven Rostedt (Red Hat) (1):
      ftrace: Move ftrace_filter_lseek out of CONFIG_DYNAMIC_FTRACE section

Steven Whitehouse (1):
      GFS2: Fix unlock of fcntl locks during withdrawn state

Suleiman Souhlal (1):
      vfs: Revert spurious fix to spinning prevention in prune_icache_sb

Thomas Gleixner (1):
      sched_clock: Prevent 64bit inatomicity on 32bit systems

Wei Yongjun (1):
      GFS2: return error if malloc failed in gfs2_rs_alloc()


--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJRbkYvAAoJEDjbvchgkmk+UU4P/29RkeRTXS/4HV4P/z+kxbpN
zZ29BWG4kCq2M6QRRRrfqRk9gPjByXArejiIAF3azwcx8C0sHDpihl325bJ7/KPL
VyHm6wIa07xaA0aSLcTFP7e9EqNkyUhhlubbqsoy0vxB26E8U7/Y58fHIFRqjy+a
f1IMIiz6te+YMPcqEkDeP4vvIhtvdudnryVPS8DjIIUmRxEhYj7Baql+rC94TLDe
qReIIhDl9bxTmsHgklIrdxaiRdNtFLlEEJjzCi04I9EBdZGFXgW0k2g7dHMCTERm
DgfBp1ENTpm7LMlFZdck2xZMQpAO33gaQxs6D5rS0XSbz8XLJ9WHYKAufrJBvU6C
Cjrxv1PVPZVxTN9Q2DwN3tCOQdshEBmgBUvSYBshSxs7EHRHZFAqIJt1nrVRLCX1
nzS8SNeWAS51VUJsCVxuk9dujaUt+X/SMjxYdMbUTRvnL0kdj+npgPuHf6dzriQr
Kx+G5BYyCOgIGwhDYDmmBzvkKTWHVxhUPhCAKxtAqCadC326Nk+z4SSV9C4xG5yJ
2Lhib5FwHvHS/emaVqLPSjF4TasuxYktcsZUV3+TGny/onC2lwUwV7/EBSiyII36
ba0/38GoRt5LBP1uvVLsdC/HLosbJjucA54+8fPr4BsPMXrEs5PqXFwn1IXgd6sT
kk0EV2jcz2cpUmnS5hF/
=+sxJ
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
