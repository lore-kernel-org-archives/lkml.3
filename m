Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbaLGUKR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 15:10:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39762 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbaLGUKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 15:10:10 -0500
Date: Sun, 7 Dec 2014 12:10:07 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.17.5
Message-ID: <20141207201007.GA12710@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.17.5 kernel.

No one should use it, use 3.17.6 instead.  I'm just including this here
so that everyone can see the changelog of what went into it.

The updated 3.17.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.17.y
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
31 --
 arch/arm/mach-mvebu/coherency.c                                       |   =
 2=20
 arch/arm/mm/proc-v7.S                                                 |   =
 2=20
 arch/arm/mm/proc-xscale.S                                             |   =
 4=20
 arch/mips/include/asm/mipsregs.h                                      |   =
 2=20
 arch/mips/include/asm/r4kcache.h                                      |   =
 4=20
 arch/mips/include/asm/uaccess.h                                       |   =
 7=20
 arch/mips/kernel/cpu-probe.c                                          |   =
33 ++-
 arch/mips/kernel/signal.c                                             |   =
 8=20
 arch/mips/lib/memcpy.S                                                |   =
 1=20
 arch/mips/loongson/common/Makefile                                    |   =
 3=20
 arch/mips/loongson/loongson-3/numa.c                                  |   =
 1=20
 arch/mips/mm/tlb-r4k.c                                                |   =
 4=20
 arch/mips/mm/tlbex.c                                                  |   =
10=20
 arch/mips/oprofile/backtrace.c                                        |   =
 2=20
 arch/mips/sgi-ip27/ip27-memory.c                                      |   =
 1=20
 arch/powerpc/kernel/vdso32/getcpu.S                                   |   =
 4=20
 arch/powerpc/platforms/powernv/opal-hmi.c                             |   =
 2=20
 arch/powerpc/platforms/powernv/pci-ioda.c                             |   =
 5=20
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
10=20
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
81 ++-----
 arch/x86/kernel/traps.c                                               |   =
71 +++++-
 arch/x86/mm/init_64.c                                                 |   =
11 -
 arch/x86/tools/calc_run_size.pl                                       |   =
11 -
 drivers/acpi/device_pm.c                                              |   =
 2=20
 drivers/acpi/ec.c                                                     |   =
 4=20
 drivers/clk/clk-divider.c                                             |   =
18 -
 drivers/clk/qcom/mmcc-apq8084.c                                       |   =
 2=20
 drivers/clk/rockchip/clk.c                                            |   =
 4=20
 drivers/clocksource/sun4i_timer.c                                     |   =
12 -
 drivers/dma/sun6i-dma.c                                               |   =
61 ++---
 drivers/gpu/drm/i915/i915_dma.c                                       |   =
10=20
 drivers/gpu/drm/i915/intel_display.c                                  |   =
 4=20
 drivers/gpu/drm/i915/intel_dp.c                                       |   =
12 +
 drivers/gpu/drm/i915/intel_pm.c                                       |   =
 5=20
 drivers/gpu/drm/radeon/dce3_1_afmt.c                                  |   =
 2=20
 drivers/gpu/drm/radeon/dce6_afmt.c                                    |   =
 2=20
 drivers/gpu/drm/radeon/evergreen_hdmi.c                               |   =
 2=20
 drivers/gpu/drm/radeon/r600_dpm.c                                     |   =
 2=20
 drivers/gpu/drm/radeon/radeon_connectors.c                            |   =
19 +
 drivers/gpu/drm/radeon/radeon_encoders.c                              |   =
 3=20
 drivers/gpu/drm/radeon/radeon_irq_kms.c                               |   =
10=20
 drivers/hwmon/g762.c                                                  |   =
 6=20
 drivers/iio/adc/men_z188_adc.c                                        |   =
 1=20
 drivers/infiniband/ulp/isert/ib_isert.c                               |   =
44 ++--
 drivers/infiniband/ulp/srpt/ib_srpt.c                                 |   =
 8=20
 drivers/input/joystick/xpad.c                                         |   =
16 +
 drivers/input/mouse/synaptics.c                                       |   =
 4=20
 drivers/irqchip/irq-atmel-aic-common.c                                |   =
 6=20
 drivers/net/bonding/bond_main.c                                       |   =
 4=20
 drivers/net/can/dev.c                                                 |   =
 2=20
 drivers/net/can/usb/esd_usb2.c                                        |   =
 1=20
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c                         |   =
12 -
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c                        |   =
28 +-
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
 drivers/net/wireless/brcm80211/brcmfmac/of.c                          |   =
 4=20
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c                        |   =
 2=20
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c                 |   =
 6=20
 drivers/net/wireless/iwlwifi/iwl-fw.h                                 |   =
 4=20
 drivers/net/wireless/iwlwifi/mvm/mac80211.c                           |   =
37 ++-
 drivers/net/wireless/iwlwifi/mvm/time-event.c                         |   =
 2=20
 drivers/net/wireless/iwlwifi/pcie/trans.c                             |   =
 3=20
 drivers/net/wireless/rt2x00/rt2x00queue.c                             |   =
50 +---
 drivers/of/address.c                                                  |   =
19 +
 drivers/of/fdt.c                                                      |   =
 2=20
 drivers/of/selftest.c                                                 |   =
 3=20
 drivers/pci/msi.c                                                     |   =
26 ++
 drivers/pci/probe.c                                                   |   =
28 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                                     |   =
 7=20
 drivers/scsi/scsi_devinfo.c                                           |   =
 1=20
 drivers/spi/spi-dw.c                                                  |   =
 6=20
 drivers/spi/spi-sirf.c                                                |   =
 4=20
 drivers/spi/spi.c                                                     |   =
 6=20
 drivers/staging/rtl8188eu/os_dep/usb_intf.c                           |   =
 1=20
 drivers/target/target_core_transport.c                                |   =
 2=20
 drivers/usb/core/quirks.c                                             |   =
 3=20
 drivers/usb/host/xhci-hub.c                                           |   =
 5=20
 drivers/usb/host/xhci-pci.c                                           |   =
 2=20
 drivers/usb/host/xhci-plat.c                                          |   =
10=20
 drivers/usb/host/xhci-ring.c                                          |   =
43 +---
 drivers/usb/host/xhci.c                                               |  1=
07 +++++-----
 drivers/usb/host/xhci.h                                               |   =
 2=20
 drivers/usb/serial/cp210x.c                                           |   =
 1=20
 drivers/usb/serial/ftdi_sio.c                                         |   =
33 +++
 drivers/usb/serial/ftdi_sio_ids.h                                     |   =
39 +++
 drivers/usb/serial/keyspan.c                                          |   =
97 +++++----
 drivers/usb/serial/ssu100.c                                           |   =
11 -
 drivers/usb/storage/unusual_uas.h                                     |   =
 7=20
 drivers/vhost/scsi.c                                                  |   =
24 ++
 fs/aio.c                                                              |   =
21 +
 fs/btrfs/ctree.c                                                      |   =
14 -
 fs/btrfs/locking.c                                                    |   =
24 +-
 fs/btrfs/locking.h                                                    |   =
 2=20
 fs/nfsd/nfs4callback.c                                                |   =
 8=20
 fs/nfsd/nfsd.h                                                        |   =
 9=20
 include/dt-bindings/clock/qcom,mmcc-apq8084.h                         |   =
 2=20
 include/linux/bitops.h                                                |   =
 7=20
 include/linux/clk-provider.h                                          |   =
 1=20
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
 net/ipv4/fib_rules.c                                                  |   =
 4=20
 net/ipv4/ping.c                                                       |   =
 2=20
 net/ipx/af_ipx.c                                                      |   =
 6=20
 net/mac80211/aes_ccm.c                                                |   =
 3=20
 net/netfilter/nf_conntrack_core.c                                     |   =
14 -
 sound/pci/hda/hda_intel.c                                             |   =
24 +-
 sound/pci/hda/hda_priv.h                                              |   =
 1=20
 sound/pci/hda/patch_realtek.c                                         |   =
 1=20
 sound/soc/codecs/cs42l51-i2c.c                                        |   =
 1=20
 sound/soc/codecs/cs42l51.c                                            |   =
 4=20
 sound/soc/codecs/cs42l51.h                                            |   =
 1=20
 sound/soc/codecs/rt5670.c                                             |   =
28 +-
 sound/soc/codecs/sgtl5000.c                                           |   =
 3=20
 sound/soc/codecs/sgtl5000.h                                           |   =
 2=20
 sound/soc/codecs/wm_adsp.c                                            |   =
 1=20
 sound/soc/rockchip/rockchip_i2s.c                                     |   =
 4=20
 sound/soc/samsung/snow.c                                              |   =
 1=20
 sound/soc/sh/fsi.c                                                    |   =
 3=20
 sound/soc/sh/rcar/core.c                                              |   =
 3=20
 sound/soc/soc-pcm.c                                                   |   =
72 +++++-
 sound/usb/quirks.c                                                    |   =
14 +
 143 files changed, 1007 insertions(+), 605 deletions(-)

Aaro Koskinen (2):
      MIPS: oprofile: Fix backtrace on 64-bit kernel
      MIPS: Loongson: Make platform serial setup always built-in.

Alex Deucher (4):
      drm/radeon: fix endian swapping in vbios fetch for tdp table
      drm/radeon: disable native backlight control on pre-r6xx asics (v2)
      drm/radeon: report disconnected for LVDS/eDP with PX if ddc fails
      drm/radeon: initialize sadb to NULL in the audio code

Alexey Khoroshilov (2):
      ieee802154: fix error handling in ieee802154fake_probe()
      can: esd_usb2: fix memory leak on disconnect

Andreas F=E4rber (1):
      ASoC: samsung: Add MODULE_DEVICE_TABLE for Snow

Andy Lutomirski (4):
      x86_64, traps: Fix the espfix64 #DF fixup and rewrite it in C
      x86_64, traps: Stop using IST for #SS
      x86_64, traps: Rework bad_iret
      uprobes, x86: Fix _TIF_UPROBE vs _TIF_NOTIFY_RESUME

Anton Blanchard (1):
      powerpc: 32 bit getcpu VDSO function uses 64 bit instructions

Arend van Spriel (1):
      brcmfmac: fix conversion of channel width 20MHZ_NOHT

Arnaud Ebalard (1):
      hwmon: (g762) fix call to devm_hwmon_device_register_with_groups()

Axel Lin (1):
      iio: adc: men_z188_adc: Add terminating entry for men_z188_ids

Bard Liao (1):
      ASoC: rt5670: correct the incorrect default values

Bart Van Assche (1):
      srp-target: Retry when QP creation fails with ENOMEM

Ben Sagal (1):
      Input: synaptics - adjust min/max on Thinkpad E540

Benjamin Herrenschmidt (6):
      PCI/MSI: Add device flag indicating that 64-bit MSIs don't work
      of/base: Fix PowerPC address parsing hack
      powerpc/pseries: Honor the generic "no_64bit_msi" flag
      sound/radeon: Move 64-bit MSI quirk from arch to driver
      gpu/radeon: Set flag to indicate broken 64-bit MSI
      powerpc/powernv: Honor the generic "no_64bit_msi" flag

Bjorn Helgaas (1):
      of/irq: Drop obsolete 'interrupts' vs 'interrupts-extended' text

Boris Brezillon (1):
      irqchip: atmel-aic: Fix irqdomain initialization

Charles Keepax (2):
      ASoC: wm_adsp: Avoid attempt to free buffers that might still be in u=
se
      spi: Fix mapping from vmalloc-ed buffer to scatter list

Chris Mason (1):
      btrfs: fix lockups from btrfs_clear_path_blocking

Chris Moore (1):
      IB/isert: Adjust CQ size to HW limits

Christian S=FCnkenberg (1):
      scsi: add Intel Multi-Flex to scsi scan blacklist

Christoph Hellwig (1):
      nfsd: correctly define v4.2 support attributes

Cristina Ciocan (1):
      iio: Fix IIO_EVENT_CODE_EXTRACT_DIR bit mask

Daniel Borkmann (1):
      ixgbe: fix use after free adapter->state test in ixgbe_remove/ixgbe_p=
robe

Daniel Vetter (2):
      drm/i915: drop WaSetupGtModeTdRowDispatch:snb
      drm/i915: Kick fbdev before vgacon

Dave Hansen (1):
      x86: Require exact match for 'noxsave' command line option

David S. Miller (1):
      sparc64: Fix constraints on swab helpers.

Dmitry Eremin-Solenikov (1):
      ARM: 8216/1: xscale: correct auxiliary register in suspend/resume

Dmitry Torokhov (1):
      brcmfmac: fix error handling of irq_of_parse_and_map

Fabio Estevam (1):
      ASoC: sgtl5000: Fix SMALL_POP bit definition

Gavin Shan (1):
      powerpc/powernv: Replace OPAL_DEASSERT_RESET with EEH_RESET_DEACTIVATE

Georgi Djakov (1):
      clk: qcom: Fix duplicate rbcpr clock name

Grant Likely (1):
      of/selftest: Fix off-by-one error in removal path

Greg Kroah-Hartman (2):
      Input: xpad - use proper endpoint type
      Linux 3.17.5

Gu Zheng (1):
      aio: fix uncorrent dirty pages accouting when truncating AIO ring buf=
fer

Hans de Goede (2):
      usb-quirks: Add reset-resume quirk for MS Wireless Laser Mouse 6000
      USB: uas: Add no-uas quirk for Hitachi usb-3 enclosures 4971:1012

Hui Wang (1):
      ALSA: hda - One more HP machine needs to change mute led quirk

James Cowgill (2):
      MIPS: IP27: Fix __node_distances undefined error
      MIPS: Loongson3: Fix __node_distances undefined error

James Hogan (1):
      clk-divider: Fix READ_ONLY when divider > 1

Jane Zhou (1):
      net/ping: handle protocol mismatching scenario

Jianqun (1):
      ASoC: rockchip-i2s: fix infinite loop in rockchip_snd_rxctrl

Jiri Bohac (1):
      ipx: fix locking regression in ipx_sendmsg and ipx_recvmsg

Johan Hovold (3):
      USB: ssu100: fix overrun-error reporting
      USB: keyspan: fix overrun-error reporting
      USB: keyspan: fix tty line-status reporting

Johannes Berg (1):
      brcmfmac: don't include linux/unaligned/access_ok.h

Jurgen Kramer (1):
      ALSA: usb-audio: Add ctrl message delay quirk for Marantz/Denon devic=
es

Kees Cook (2):
      x86, mm: Set NX across entire PMD at boot
      x86, kaslr: Handle Gold linker for finding bss/brk

Kevin Cernekee (1):
      of: Fix crash if an earlycon driver is not found

Kuninori Morimoto (2):
      ASoC: rsnd: remove unsupported PAUSE flag
      ASoC: fsi: remove unsupported PAUSE flag

Larry Finger (1):
      staging: r8188eu: Add new device ID for DLink GO-USB-N150

Laurent Dufour (1):
      powerpc/pseries: Fix endiannes issue in RTAS call from xmon

Leonid Yegoshin (1):
      MIPS: tlbex: Fix potential HTW race on TLBL/M/S handlers

Liad Kaufman (1):
      iwlwifi: pcie: fix prph dump length

Lu Baolu (2):
      usb: xhci: rework root port wake bits if controller isn't allowed to =
wakeup
      Revert "xhci: clear root port wake on bits if controller isn't wake-u=
p capable"

Luciano Coelho (1):
      iwlwifi: mvm: check TLV flag before trying to use hotspot firmware co=
mmands

Lv Zheng (1):
      ACPI / EC: Add support to disallow QR_EC to be issued before completi=
ng previous QR_EC

Mahesh Salgaonkar (1):
      powerpc/powernv: Fix the hmi event version check.

Markos Chandras (5):
      MIPS: lib: memcpy: Restore NOP on delay slot before returning to call=
er
      MIPS: tlb-r4k: Add missing HTW stop/start sequences
      MIPS: asm: uaccess: Add v1 register to clobber list on EVA
      MIPS: cpu-probe: Set the FTLB probability bit on supported cores
      MIPS: r4kcache: Add EVA case for protected_writeback_dcache_line

Martin Hauke (1):
      qmi_wwan: Add support for HP lt4112 LTE/HSPA+ Gobi 4G Modem

Mathias Krause (1):
      pptp: fix stack info leak in pptp_getname()

Mathias Nyman (2):
      USB: xhci: don't start a halted endpoint before its new dequeue is set
      USB: xhci: Reset a halted endpoint immediately when we encounter a st=
all.

Matti Gottlieb (1):
      iwlwifi: mvm: ROC - bug fixes around time events and locking

Maurizio Lombardi (1):
      bnx2fc: do not add shared skbs to the fcoe_rx_list

Maxime COQUELIN (1):
      bitops: Fix shift overflow in GENMASK macros

Maxime Ripard (2):
      clockevent: sun4i: Fix race condition in the probe code
      dmaengine: sun6i: Fix memcpy operation

Miaoqing Pan (1):
      ath9k: Fix RTC_DERIVED_CLK usage

Nicholas Bellinger (1):
      vhost-scsi: Take configfs group dependency during VHOST_SCSI_SET_ENDP=
OINT

Nikolay Aleksandrov (1):
      bonding: fix curr_active_slave/carrier with loadbalance arp monitoring

Or Gerlitz (3):
      net/mlx4_en: Add VXLAN ndo calls to the PF net device ops too
      net/mlx4_en: Advertize encapsulation offloads features only when VXLA=
N tunnel is set
      ib_isert: Add max_send_sge=3D2 minimum for control PDU responses

Panu Matilainen (1):
      ipv4: Fix incorrect error code when adding an unreachable route

Paolo Bonzini (1):
      x86: kvm: use alternatives for VMCALL vs. VMMCALL if kernel text is r=
ead-only

Paul Burton (1):
      MIPS: fix EVA & non-SMP non-FPU FP context signal handling

Preston Fick (1):
      USB: serial: cp210x: add IDs for CEL MeshConnect USB Stick

Qipan Li (1):
      spi: sirf: fix word width configuration

Rafael J. Wysocki (1):
      ACPI / PM: Ignore wakeup setting if the ACPI companion can't wake up

Roland Dreier (1):
      target: Don't call TFO->write_pending if data_length =3D=3D 0

Ronald Wahl (1):
      mac80211: Fix regression that triggers a kernel BUG with CCMP

Sagi Grimberg (1):
      iser-target: Handle DEVICE_REMOVAL event on network portal listener c=
orrectly

Stanislaw Gruszka (1):
      rt2x00: do not align payload on modern H/W

Takashi Iwai (2):
      ASoC: dpcm: Fix race between FE/BE updates and trigger
      ALSA: hda - Limit 40bit DMA for AMD HDMI controllers

Thomas K=F6rper (1):
      can: dev: avoid calling kfree_skb() from interrupt context

Thomas Petazzoni (3):
      ASoC: cs42l51: re-hook of_match_table pointer
      ARM: mvebu: add missing of_node_put() call in coherency.c
      ARM: 8222/1: mvebu: enable strex backoff delay

Thor Thayer (1):
      spi: dw: Fix dynamic speed change.

Trond Myklebust (1):
      nfsd: Fix slot wake up race in the nfsv4.1 callback code

Troy Clark (1):
      usb: serial: ftdi_sio: add PIDs for Matrix Orbital products

Ville Syrj=E4l=E4 (2):
      drm/i915: Ignore SURFLIVE and flip counter when the GPU gets reset
      drm/i915: Ignore long hpds on eDP ports

Vincent BENAYOUN (1):
      inetdevice: fixed signed integer overflow

Vlad Yasevich (1):
      ixgbe: Correctly disable VLAN filter in promiscuous mode

Vladimir Murzin (1):
      ARM: 8226/1: cacheflush: get rid of restarting block

Yinghai Lu (1):
      PCI: Support 64-bit bridge windows if we have 64-bit dma_addr_t

bill bonaparte (1):
      netfilter: conntrack: fix race in __nf_conntrack_confirm against get_=
next_corpse


--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUhLQZAAoJEDjbvchgkmk+XE4P/1m66fgILOhNvvUtuzYt7xFG
lQ5GcWYykmTXlYrNgXSv58F75h4o30XXTfZjJYMz1kHp1EW7+58ShWVW6rCCvCYb
WB6NLlW3WMpb3hPlIyG2AQCNhqq5rXOtNAt//3s4qrEjoc26ie+gKnSXqwjU2fpf
iGh3gA0uCvzrDbTTvekKR7bLo8IIw3SFGtQAG73q5U96rCo33tdeKA3fSsDIqEnu
CDh3qNq0OKdascIPSNfh0nVH3NTqhPIHGMM1+BjIQ6kqcqt6b/JqY82zKasoZ8Ua
j6h9AKidEChYYuayw4pFtLSI8r/FgzW0xJJGTKsQyrEmXFhWsc3BaXjLtFB/D0hR
QB6ztZ9RTzy1vs2Ks1jjNu1nTnpfkoS1Vkg4TqHszdprAuRW8hKkObItF5XCMzNA
C8VMZuZnOSDdhr/tDpseeBiD9OeA1tdwnjBrKP6EWLiyhIdahqvYDfsqZBBpxO73
X3at/WNe9QbhBaCC7CNpXf/zb3du3iWPQcnCsTQhlMc97NR79tduA6DhPw2w+3WN
L9/O94YweiXDiShvDi/rqrsTJxmhl61p2jmpMAwQBlJW0jCkXcbYtgZLGnHM7AIb
8vGXY8tA8IKEoQ+wHoyporbhdNNxLaMaTCbRfCEnmbl2VmOF8F370keJZsN3a7Mw
BZaH/JzDUi5IcjqUL9m9
=4Dvx
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
