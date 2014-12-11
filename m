Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934248AbaLKJBB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 04:01:01 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:33507 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934214AbaLKJA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 04:00:58 -0500
Message-ID: <54895D46.5010106@suse.cz>
Date: Thu, 11 Dec 2014 10:00:54 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
CC: lwn@lwn.net
Subject: Linux 3.12.35
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 3.12.35 kernel.

All users of the 3.12 kernel series must upgrade.

The updated 3.12.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.12.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

----------------------------------------------------------------
Aaro Koskinen (2):
      MIPS: oprofile: Fix backtrace on 64-bit kernel
      MIPS: Loongson: Make platform serial setup always built-in.

Alex Deucher (1):
      drm/radeon: fix endian swapping in vbios fetch for tdp table

Alexander Gordeev (1):
      PCI/MSI: Return msix_capability_init() failure if populate_msi_sysfs() fails

Alexey Khoroshilov (1):
      can: esd_usb2: fix memory leak on disconnect

Andy Lutomirski (4):
      x86_64, traps: Fix the espfix64 #DF fixup and rewrite it in C
      x86_64, traps: Stop using IST for #SS
      x86_64, traps: Rework bad_iret
      uprobes, x86: Fix _TIF_UPROBE vs _TIF_NOTIFY_RESUME

Bart Van Assche (1):
      srp-target: Retry when QP creation fails with ENOMEM

Ben Sagal (1):
      Input: synaptics - adjust min/max on Thinkpad E540

Benjamin Herrenschmidt (5):
      PCI/MSI: Add device flag indicating that 64-bit MSIs don't work
      of/base: Fix PowerPC address parsing hack
      powerpc/pseries: Honor the generic "no_64bit_msi" flag
      gpu/radeon: Set flag to indicate broken 64-bit MSI
      powerpc/powernv: Honor the generic "no_64bit_msi" flag

Benjamin Tissoires (1):
      Input: synaptics - fix resolution for manually provided min/max

Charles Keepax (1):
      ASoC: wm_adsp: Avoid attempt to free buffers that might still be in use

Chris Moore (1):
      IB/isert: Adjust CQ size to HW limits

Christian Sünkenberg (1):
      scsi: add Intel Multi-Flex to scsi scan blacklist

Christoph Hellwig (1):
      nfsd: correctly define v4.2 support attributes

Cong Wang (1):
      batman: fix a bogus warning from batadv_is_on_batman_iface()

Cristina Ciocan (1):
      iio: Fix IIO_EVENT_CODE_EXTRACT_DIR bit mask

Dave Hansen (1):
      x86: Require exact match for 'noxsave' command line option

Dmitry Eremin-Solenikov (1):
      ARM: 8216/1: xscale: correct auxiliary register in suspend/resume

Fabio Estevam (1):
      ASoC: sgtl5000: Fix SMALL_POP bit definition

Greg Kroah-Hartman (1):
      Input: xpad - use proper endpoint type

Gu Zheng (1):
      aio: fix uncorrent dirty pages accouting when truncating AIO ring buffer

Hans de Goede (8):
      Input: serio - add firmware_id sysfs attribute
      Input: i8042 - add firmware_id support
      Input: Add INPUT_PROP_TOPBUTTONPAD device property
      Input: synaptics - report INPUT_PROP_TOPBUTTONPAD property
      Input: synaptics - add a matches_pnp_id helper function
      Input: synaptics - change min/max quirk table to pnp-id matching
      Input: synaptics - add min/max quirk for pnp-id LEN2002 (Edge E531)
      usb-quirks: Add reset-resume quirk for MS Wireless Laser Mouse 6000

Jane Zhou (1):
      net/ping: handle protocol mismatching scenario

Jeff Layton (1):
      locks: eliminate BUG() call when there's an unexpected lock on file close

Jiri Slaby (1):
      Linux 3.12.35

Johan Hovold (3):
      USB: ssu100: fix overrun-error reporting
      USB: keyspan: fix overrun-error reporting
      USB: keyspan: fix tty line-status reporting

Jurgen Kramer (1):
      ALSA: usb-audio: Add ctrl message delay quirk for Marantz/Denon devices

Kees Cook (1):
      x86, mm: Set NX across entire PMD at boot

Kuninori Morimoto (2):
      ASoC: rsnd: remove unsupported PAUSE flag
      ASoC: fsi: remove unsupported PAUSE flag

Larry Finger (1):
      staging: r8188eu: Add new device ID for DLink GO-USB-N150

Laurent Dufour (1):
      powerpc/pseries: Fix endiannes issue in RTAS call from xmon

Lu Baolu (1):
      usb: xhci: rework root port wake bits if controller isn't allowed to wakeup

Mathias Nyman (1):
      USB: xhci: don't start a halted endpoint before its new dequeue is set

Maurizio Lombardi (1):
      bnx2fc: do not add shared skbs to the fcoe_rx_list

Maxime Ripard (1):
      clockevent: sun4i: Fix race condition in the probe code

Miaoqing Pan (1):
      ath9k: Fix RTC_DERIVED_CLK usage

Nicholas Bellinger (1):
      vhost-scsi: Take configfs group dependency during VHOST_SCSI_SET_ENDPOINT

Or Gerlitz (1):
      ib_isert: Add max_send_sge=2 minimum for control PDU responses

Preston Fick (1):
      USB: serial: cp210x: add IDs for CEL MeshConnect USB Stick

Roland Dreier (1):
      target: Don't call TFO->write_pending if data_length == 0

Sagi Grimberg (1):
      iser-target: Handle DEVICE_REMOVAL event on network portal listener correctly

Stanislaw Gruszka (1):
      rt2x00: do not align payload on modern H/W

Takashi Iwai (2):
      Input: synaptics - add min/max quirk for Lenovo T440s
      ASoC: dpcm: Fix race between FE/BE updates and trigger

Thomas Körper (1):
      can: dev: avoid calling kfree_skb() from interrupt context

Thomas Petazzoni (1):
      ARM: 8222/1: mvebu: enable strex backoff delay

Thor Thayer (1):
      spi: dw: Fix dynamic speed change.

Trond Myklebust (1):
      nfsd: Fix slot wake up race in the nfsv4.1 callback code

Troy Clark (1):
      usb: serial: ftdi_sio: add PIDs for Matrix Orbital products

Vladimir Murzin (1):
      ARM: 8226/1: cacheflush: get rid of restarting block

 Makefile                                    |   2 +-
 arch/arm/include/asm/thread_info.h          |  11 -
 arch/arm/kernel/traps.c                     |  31 +--
 arch/arm/mm/proc-v7.S                       |   2 -
 arch/arm/mm/proc-xscale.S                   |   4 +-
 arch/mips/loongson/common/Makefile          |   3 +-
 arch/mips/oprofile/backtrace.c              |   2 +-
 arch/powerpc/platforms/powernv/pci-ioda.c   |   3 +-
 arch/powerpc/platforms/powernv/pci.c        |   4 +-
 arch/powerpc/platforms/pseries/msi.c        |   2 +-
 arch/powerpc/xmon/xmon.c                    |   6 +-
 arch/x86/include/asm/page_32_types.h        |   1 -
 arch/x86/include/asm/page_64_types.h        |  11 +-
 arch/x86/include/asm/thread_info.h          |   2 +-
 arch/x86/kernel/cpu/common.c                |   2 +
 arch/x86/kernel/dumpstack_64.c              |   1 -
 arch/x86/kernel/entry_64.S                  |  81 ++-----
 arch/x86/kernel/traps.c                     |  71 ++++--
 arch/x86/mm/init_64.c                       |  11 +-
 drivers/clocksource/sun4i_timer.c           |  10 +-
 drivers/gpu/drm/radeon/r600_dpm.c           |   2 +-
 drivers/gpu/drm/radeon/radeon_irq_kms.c     |  10 +
 drivers/infiniband/ulp/isert/ib_isert.c     |  44 ++--
 drivers/infiniband/ulp/srpt/ib_srpt.c       |   8 +
 drivers/input/joystick/xpad.c               |  16 +-
 drivers/input/mouse/synaptics.c             | 212 ++++++++----------
 drivers/input/serio/i8042-x86ia64io.h       |  15 ++
 drivers/input/serio/i8042.c                 |   6 +
 drivers/input/serio/serio.c                 |  13 ++
 drivers/net/can/dev.c                       |   2 +-
 drivers/net/can/usb/esd_usb2.c              |   1 +
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |  13 ++
 drivers/net/wireless/ath/ath9k/hw.c         |  13 --
 drivers/net/wireless/rt2x00/rt2x00queue.c   |  50 +----
 drivers/of/address.c                        |  19 +-
 drivers/pci/msi.c                           |  37 ++-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c           |   7 +
 drivers/scsi/scsi_devinfo.c                 |   1 +
 drivers/spi/spi-dw.c                        |   6 +-
 drivers/staging/rtl8188eu/os_dep/usb_intf.c |   1 +
 drivers/target/target_core_transport.c      |   2 +-
 drivers/usb/core/quirks.c                   |   3 +
 drivers/usb/host/xhci-pci.c                 |   2 +-
 drivers/usb/host/xhci-plat.c                |  10 +-
 drivers/usb/host/xhci-ring.c                |   3 +-
 drivers/usb/host/xhci.c                     |  42 +++-
 drivers/usb/host/xhci.h                     |   2 +-
 drivers/usb/serial/cp210x.c                 |   1 +
 drivers/usb/serial/ftdi_sio.c               |  33 +++
 drivers/usb/serial/ftdi_sio_ids.h           |  39 +++-
 drivers/usb/serial/keyspan.c                |  97 ++++----
 drivers/usb/serial/ssu100.c                 |  11 +-
 drivers/vhost/scsi.c                        |  24 ++
 fs/aio.c                                    |  21 +-
 fs/locks.c                                  |  24 +-
 fs/nfsd/nfs4callback.c                      |   8 +-
 fs/nfsd/nfsd.h                              |   9 +-
 include/linux/iio/events.h                  |   2 +-
 include/linux/pci.h                         |   1 +
 include/linux/serio.h                       |   1 +
 include/sound/soc-dpcm.h                    |   2 +
 include/uapi/linux/input.h                  |   1 +
 kernel/events/uprobes.c                     |   1 -
 net/batman-adv/hard-interface.c             |   2 +-
 net/ipv4/ping.c                             |   2 +
 sound/soc/codecs/sgtl5000.c                 |   3 +-
 sound/soc/codecs/sgtl5000.h                 |   2 +-
 sound/soc/codecs/wm_adsp.c                  |   1 +
 sound/soc/sh/fsi.c                          |   3 +-
 sound/soc/sh/rcar/core.c                    |   3 +-
 sound/soc/soc-pcm.c                         |  72 ++++--
 sound/usb/quirks.c                          |  14 ++
 72 files changed, 732 insertions(+), 445 deletions(-)


thanks,
-- 
js
