Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbaLGTtl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 14:49:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39658 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbaLGTth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 14:49:37 -0500
Date: Sun, 7 Dec 2014 11:49:34 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.14.26
Message-ID: <20141207194934.GA10195@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.14.26 kernel.

All users of the 3.14 kernel series must upgrade.

The updated 3.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.14.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/interrupt-controller/interrupts.txt |   =
 4=20
 Makefile                                                              |   =
 2=20
 arch/arm/include/asm/thread_info.h                                    |   =
11 -
 arch/arm/kernel/traps.c                                               |   =
31 ---
 arch/arm/mm/proc-v7.S                                                 |   =
 2=20
 arch/arm/mm/proc-xscale.S                                             |   =
 4=20
 arch/mips/loongson/common/Makefile                                    |   =
 3=20
 arch/mips/oprofile/backtrace.c                                        |   =
 2=20
 arch/powerpc/platforms/powernv/pci-ioda.c                             |   =
 3=20
 arch/powerpc/platforms/powernv/pci.c                                  |   =
 4=20
 arch/powerpc/platforms/pseries/msi.c                                  |   =
 2=20
 arch/powerpc/xmon/xmon.c                                              |   =
 6=20
 arch/sparc/include/uapi/asm/swab.h                                    |   =
12 -
 arch/x86/include/asm/cpufeature.h                                     |   =
 1=20
 arch/x86/include/asm/kvm_para.h                                       |   =
10 -
 arch/x86/include/asm/page_32_types.h                                  |   =
 1=20
 arch/x86/include/asm/page_64_types.h                                  |   =
11 -
 arch/x86/include/asm/thread_info.h                                    |   =
 2=20
 arch/x86/include/asm/traps.h                                          |   =
 1=20
 arch/x86/kernel/cpu/amd.c                                             |   =
 7=20
 arch/x86/kernel/cpu/common.c                                          |   =
 2=20
 arch/x86/kernel/dumpstack_64.c                                        |   =
 1=20
 arch/x86/kernel/entry_64.S                                            |   =
81 ++------
 arch/x86/kernel/traps.c                                               |   =
71 +++++--
 arch/x86/mm/init_64.c                                                 |   =
11 +
 arch/x86/tools/calc_run_size.pl                                       |   =
11 +
 drivers/clocksource/sun4i_timer.c                                     |   =
12 -
 drivers/gpu/drm/radeon/r600_dpm.c                                     |   =
 2=20
 drivers/gpu/drm/radeon/radeon_irq_kms.c                               |   =
10 +
 drivers/infiniband/ulp/isert/ib_isert.c                               |   =
51 +++--
 drivers/infiniband/ulp/srpt/ib_srpt.c                                 |   =
 8=20
 drivers/input/joystick/xpad.c                                         |   =
16 +
 drivers/input/mouse/synaptics.c                                       |   =
 4=20
 drivers/net/bonding/bond_main.c                                       |   =
 4=20
 drivers/net/can/dev.c                                                 |   =
 2=20
 drivers/net/can/usb/esd_usb2.c                                        |   =
 1=20
 drivers/net/ieee802154/fakehard.c                                     |   =
13 -
 drivers/net/ppp/pptp.c                                                |   =
 4=20
 drivers/net/usb/qmi_wwan.c                                            |   =
 1=20
 drivers/net/wireless/ath/ath9k/ar9003_phy.c                           |   =
13 +
 drivers/net/wireless/ath/ath9k/hw.c                                   |   =
13 -
 drivers/net/wireless/rt2x00/rt2x00queue.c                             |   =
50 +----
 drivers/of/address.c                                                  |   =
19 +
 drivers/pci/msi.c                                                     |   =
26 ++
 drivers/pci/probe.c                                                   |   =
29 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                                     |   =
 7=20
 drivers/scsi/scsi_devinfo.c                                           |   =
 1=20
 drivers/spi/spi-dw.c                                                  |   =
 6=20
 drivers/staging/rtl8188eu/os_dep/usb_intf.c                           |   =
 1=20
 drivers/target/target_core_transport.c                                |   =
 2=20
 drivers/usb/core/quirks.c                                             |   =
 3=20
 drivers/usb/host/xhci-pci.c                                           |   =
 2=20
 drivers/usb/host/xhci-plat.c                                          |   =
10 -
 drivers/usb/host/xhci-ring.c                                          |   =
 3=20
 drivers/usb/host/xhci.c                                               |   =
42 ++++
 drivers/usb/host/xhci.h                                               |   =
 2=20
 drivers/usb/serial/cp210x.c                                           |   =
 1=20
 drivers/usb/serial/ftdi_sio.c                                         |   =
33 +++
 drivers/usb/serial/ftdi_sio_ids.h                                     |   =
39 +++-
 drivers/usb/serial/keyspan.c                                          |   =
97 ++++++----
 drivers/usb/serial/ssu100.c                                           |   =
11 -
 drivers/vhost/scsi.c                                                  |   =
24 ++
 fs/aio.c                                                              |   =
21 +-
 fs/locks.c                                                            |   =
24 +-
 fs/nfs/pagelist.c                                                     |   =
 2=20
 fs/nfsd/nfs4callback.c                                                |   =
 8=20
 fs/nfsd/nfscache.c                                                    |   =
17 -
 fs/nfsd/nfsd.h                                                        |   =
 9=20
 include/linux/bitops.h                                                |   =
 7=20
 include/linux/iio/events.h                                            |   =
 2=20
 include/linux/inetdevice.h                                            |   =
 2=20
 include/linux/pci.h                                                   |   =
 1=20
 include/sound/soc-dpcm.h                                              |   =
 2=20
 kernel/events/uprobes.c                                               |   =
 1=20
 net/batman-adv/hard-interface.c                                       |   =
 2=20
 net/ipv4/fib_rules.c                                                  |   =
 4=20
 net/ipv4/ping.c                                                       |   =
 2=20
 net/ipx/af_ipx.c                                                      |   =
 6=20
 sound/soc/codecs/sgtl5000.c                                           |   =
 3=20
 sound/soc/codecs/sgtl5000.h                                           |   =
 2=20
 sound/soc/codecs/wm_adsp.c                                            |   =
 1=20
 sound/soc/sh/fsi.c                                                    |   =
 3=20
 sound/soc/sh/rcar/core.c                                              |   =
 3=20
 sound/soc/soc-pcm.c                                                   |   =
72 +++++--
 sound/usb/quirks.c                                                    |   =
14 +
 85 files changed, 689 insertions(+), 377 deletions(-)

Aaro Koskinen (2):
      MIPS: oprofile: Fix backtrace on 64-bit kernel
      MIPS: Loongson: Make platform serial setup always built-in.

Alex Deucher (1):
      drm/radeon: fix endian swapping in vbios fetch for tdp table

Alexey Khoroshilov (2):
      ieee802154: fix error handling in ieee802154fake_probe()
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

Bjorn Helgaas (1):
      of/irq: Drop obsolete 'interrupts' vs 'interrupts-extended' text

Charles Keepax (1):
      ASoC: wm_adsp: Avoid attempt to free buffers that might still be in u=
se

Chris Moore (1):
      IB/isert: Adjust CQ size to HW limits

Christian S=FCnkenberg (1):
      scsi: add Intel Multi-Flex to scsi scan blacklist

Christoph Hellwig (1):
      nfsd: correctly define v4.2 support attributes

Cong Wang (1):
      batman: fix a bogus warning from batadv_is_on_batman_iface()

Cristina Ciocan (1):
      iio: Fix IIO_EVENT_CODE_EXTRACT_DIR bit mask

Dave Hansen (1):
      x86: Require exact match for 'noxsave' command line option

David Jeffery (1):
      nfs: Don't busy-wait on SIGKILL in __nfs_iocounter_wait

David S. Miller (1):
      sparc64: Fix constraints on swab helpers.

Dmitry Eremin-Solenikov (1):
      ARM: 8216/1: xscale: correct auxiliary register in suspend/resume

Fabio Estevam (1):
      ASoC: sgtl5000: Fix SMALL_POP bit definition

Greg Kroah-Hartman (2):
      Input: xpad - use proper endpoint type
      Linux 3.14.26

Gu Zheng (1):
      aio: fix uncorrent dirty pages accouting when truncating AIO ring buf=
fer

Hans de Goede (1):
      usb-quirks: Add reset-resume quirk for MS Wireless Laser Mouse 6000

Jane Zhou (1):
      net/ping: handle protocol mismatching scenario

Jeff Layton (2):
      nfsd: don't halt scanning the DRC LRU list when there's an RC_INPROG =
entry
      locks: eliminate BUG() call when there's an unexpected lock on file c=
lose

Jiri Bohac (1):
      ipx: fix locking regression in ipx_sendmsg and ipx_recvmsg

Johan Hovold (3):
      USB: ssu100: fix overrun-error reporting
      USB: keyspan: fix overrun-error reporting
      USB: keyspan: fix tty line-status reporting

Jurgen Kramer (1):
      ALSA: usb-audio: Add ctrl message delay quirk for Marantz/Denon devic=
es

Kees Cook (2):
      x86, mm: Set NX across entire PMD at boot
      x86, kaslr: Handle Gold linker for finding bss/brk

Kuninori Morimoto (2):
      ASoC: rsnd: remove unsupported PAUSE flag
      ASoC: fsi: remove unsupported PAUSE flag

Larry Finger (1):
      staging: r8188eu: Add new device ID for DLink GO-USB-N150

Laurent Dufour (1):
      powerpc/pseries: Fix endiannes issue in RTAS call from xmon

Lu Baolu (1):
      usb: xhci: rework root port wake bits if controller isn't allowed to =
wakeup

Martin Hauke (1):
      qmi_wwan: Add support for HP lt4112 LTE/HSPA+ Gobi 4G Modem

Mathias Krause (1):
      pptp: fix stack info leak in pptp_getname()

Mathias Nyman (1):
      USB: xhci: don't start a halted endpoint before its new dequeue is set

Maurizio Lombardi (1):
      bnx2fc: do not add shared skbs to the fcoe_rx_list

Maxime COQUELIN (1):
      bitops: Fix shift overflow in GENMASK macros

Maxime Ripard (1):
      clockevent: sun4i: Fix race condition in the probe code

Miaoqing Pan (1):
      ath9k: Fix RTC_DERIVED_CLK usage

Nicholas Bellinger (2):
      iser-target: Disable TX completion interrupt coalescing
      vhost-scsi: Take configfs group dependency during VHOST_SCSI_SET_ENDP=
OINT

Nikolay Aleksandrov (1):
      bonding: fix curr_active_slave/carrier with loadbalance arp monitoring

Or Gerlitz (1):
      ib_isert: Add max_send_sge=3D2 minimum for control PDU responses

Panu Matilainen (1):
      ipv4: Fix incorrect error code when adding an unreachable route

Paolo Bonzini (1):
      x86: kvm: use alternatives for VMCALL vs. VMMCALL if kernel text is r=
ead-only

Preston Fick (1):
      USB: serial: cp210x: add IDs for CEL MeshConnect USB Stick

Roland Dreier (1):
      target: Don't call TFO->write_pending if data_length =3D=3D 0

Sagi Grimberg (2):
      iser-target: Handle DEVICE_REMOVAL event on network portal listener c=
orrectly
      Target/iser: Fix a wrong dereference in case discovery session is ove=
r iser

Stanislaw Gruszka (1):
      rt2x00: do not align payload on modern H/W

Takashi Iwai (1):
      ASoC: dpcm: Fix race between FE/BE updates and trigger

Thomas K=F6rper (1):
      can: dev: avoid calling kfree_skb() from interrupt context

Thomas Petazzoni (1):
      ARM: 8222/1: mvebu: enable strex backoff delay

Thor Thayer (1):
      spi: dw: Fix dynamic speed change.

Trond Myklebust (1):
      nfsd: Fix slot wake up race in the nfsv4.1 callback code

Troy Clark (1):
      usb: serial: ftdi_sio: add PIDs for Matrix Orbital products

Vincent BENAYOUN (1):
      inetdevice: fixed signed integer overflow

Vladimir Murzin (1):
      ARM: 8226/1: cacheflush: get rid of restarting block

Yinghai Lu (1):
      PCI: Support 64-bit bridge windows if we have 64-bit dma_addr_t


--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUhK9NAAoJEDjbvchgkmk+70oP/2K+sOiZo3hAYTXV9Z73I6Ot
dH5y6Z66TZxLUNaVQCRJgxSZPVsr2S01v5q53+b6m+kV7dpGrmt6DlWOWvXSJfZC
0jSIOlD0ffiSYIMTo3YFhTEHRibcEO2YKvVvO/KsImUF7gDoBwm0TlwnJa1Zlw6s
5rRZq1BfqXrqOu59ZqreZJSp+gXL0/hcOULKThiJrkVdwluhymk2taz7g2+AvGtv
TFbrIF0NbvlwQf1RXB9sw/L7aH6qA8Lfnxx5U191Fws3TocGzwa6WT5dD+g5CkGw
cm/Y7xbVhMpaRzGL5hkbHuSLQsYyTdRDhbay5Ake+yzzwDOxH0jW4YRsJYmhxvVb
mExyvmuLqFUZnUR61ruwL57tKZE/qdI/v+YxX5uD/FdeXhHoZGOaZQdweIGED6aR
u5V1eiJgFlMyjqGqL13NSuLWkCvidw6C+9yzIeKaEOi0ULjc1bYLMGc/XW9kAbdY
t9PWvugMN4X5pvYEuu22o1fYgj7LOLg0l2+H72ibtFkDvD+Qgg4wIOg5fvAr+2QT
drA6KCjnwW8DlO9TqEqoEXbbVWq/OUO4/XEde58LHyv4aRKBhdE78tTL6f6CxWHq
j+SYnVheLp8bNNA5q4XmZPunqgKbas96SbekHFBhcSxg6Bu3pF5RW91eS46Qybw3
jr99rGSOhGAeRvGZ63Oa
=hiKP
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--
