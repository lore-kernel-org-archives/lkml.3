Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938AbaBFT7a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 14:59:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48711 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbaBFT71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 14:59:27 -0500
Date: Thu, 6 Feb 2014 12:00:36 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.12.10
Message-ID: <20140206200036.GA2121@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.12.10 kernel.

All users of the 3.12 kernel series must upgrade.

The updated 3.12.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.12.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/ata/marvell.txt     |    2=20
 Documentation/devicetree/bindings/i2c/i2c-mv64xxx.txt |    6=20
 Documentation/i2c/busses/i2c-piix4                    |    2=20
 Makefile                                              |    2=20
 arch/alpha/lib/csum_partial_copy.c                    |    9 -
 arch/arm/boot/dts/armada-370-xp.dtsi                  |    2=20
 arch/arm/boot/dts/at91sam9g45.dtsi                    |    2=20
 arch/arm/mach-at91/sam9_smc.c                         |    2=20
 arch/arm/mach-mvebu/Makefile                          |    2=20
 arch/arm/mach-mvebu/armada-370-xp.c                   |   32 ++++
 arch/arm/mach-mvebu/mvebu-soc-id.c                    |  119 ++++++++++++++
 arch/arm/mach-mvebu/mvebu-soc-id.h                    |   32 ++++
 arch/arm/net/bpf_jit_32.c                             |    6=20
 arch/parisc/include/asm/cacheflush.h                  |    2=20
 arch/parisc/include/asm/page.h                        |    3=20
 arch/parisc/kernel/cache.c                            |   14 +
 arch/powerpc/include/asm/topology.h                   |   10 +
 arch/powerpc/kernel/cacheinfo.c                       |    3=20
 arch/powerpc/kvm/book3s_hv.c                          |    7=20
 arch/powerpc/kvm/e500_mmu.c                           |    2=20
 arch/powerpc/mm/numa.c                                |   70 ++++++++
 arch/powerpc/net/bpf_jit_comp.c                       |    7=20
 arch/s390/include/uapi/asm/statfs.h                   |   10 -
 arch/s390/kvm/diag.c                                  |    4=20
 arch/s390/net/bpf_jit_comp.c                          |   29 ++-
 arch/sparc/net/bpf_jit_comp.c                         |   17 +-
 arch/x86/include/asm/kvm_para.h                       |   33 +---
 arch/x86/include/uapi/asm/msr-index.h                 |    1=20
 arch/x86/kernel/cpu/amd.c                             |   10 +
 arch/x86/kernel/kvm.c                                 |   32 ++++
 arch/x86/kvm/i8254.c                                  |   18 ++
 arch/x86/kvm/lapic.c                                  |    5=20
 arch/x86/kvm/x86.c                                    |    3=20
 arch/x86/kvm/x86.h                                    |    2=20
 arch/x86/net/bpf_jit_comp.c                           |   14 +
 arch/x86/platform/efi/efi.c                           |    2=20
 drivers/ata/libata-core.c                             |   27 +++
 drivers/ata/libata-scsi.c                             |   18 +-
 drivers/ata/sata_mv.c                                 |   25 +++
 drivers/char/tpm/tpm_i2c_stm_st33.c                   |    7=20
 drivers/char/tpm/tpm_ppi.c                            |    8 -
 drivers/edac/e752x_edac.c                             |    4=20
 drivers/gpu/drm/nouveau/core/subdev/bios/init.c       |    8 -
 drivers/hwmon/k10temp.c                               |    1=20
 drivers/i2c/busses/Kconfig                            |    1=20
 drivers/i2c/busses/i2c-mv64xxx.c                      |    5=20
 drivers/i2c/busses/i2c-piix4.c                        |   28 ++-
 drivers/md/bcache/bset.c                              |   26 ++-
 drivers/md/raid5.c                                    |    1=20
 drivers/mfd/max77686.c                                |    2=20
 drivers/misc/mei/hbm.c                                |   19 ++
 drivers/misc/mei/hbm.h                                |    1=20
 drivers/misc/mei/init.c                               |   12 +
 drivers/misc/mei/interrupt.c                          |   25 +--
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c       |   13 +
 drivers/net/ethernet/intel/e1000e/phy.c               |   10 -
 drivers/net/ethernet/via/via-rhine.c                  |    1=20
 drivers/net/usb/usbnet.c                              |    2=20
 drivers/net/vxlan.c                                   |   20 +-
 drivers/net/wireless/ath/ath9k/hw.c                   |    7=20
 drivers/net/wireless/ath/ath9k/recv.c                 |   25 +--
 drivers/net/wireless/b43/b43.h                        |    4=20
 drivers/net/wireless/b43/main.c                       |   27 ++-
 drivers/net/wireless/b43/xmit.c                       |    4=20
 drivers/net/wireless/b43legacy/main.c                 |    1=20
 drivers/net/wireless/iwlwifi/iwl-prph.h               |    4=20
 drivers/net/wireless/iwlwifi/mvm/ops.c                |    1=20
 drivers/net/wireless/iwlwifi/pcie/trans.c             |   22 ++
 drivers/net/wireless/mwifiex/fw.h                     |    2=20
 drivers/net/wireless/mwifiex/scan.c                   |    4=20
 drivers/net/wireless/rtlwifi/base.c                   |    3=20
 drivers/net/wireless/rtlwifi/core.c                   |   11 +
 drivers/net/wireless/rtlwifi/rtl8188ee/dm.c           |    2=20
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c     |   36 ++++
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h     |   14 +
 drivers/net/wireless/rtlwifi/rtl8192cu/dm.c           |    9 +
 drivers/net/wireless/rtlwifi/rtl8192cu/dm.h           |    3=20
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c           |   29 ++-
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c           |   17 +-
 drivers/net/wireless/rtlwifi/stats.c                  |   14 +
 drivers/net/wireless/rtlwifi/usb.c                    |    4=20
 drivers/net/wireless/rtlwifi/wifi.h                   |   33 ++--
 drivers/net/xen-netfront.c                            |   88 +++--------
 drivers/parport/parport_pc.c                          |   10 -
 drivers/pinctrl/pinctrl-sunxi.c                       |   13 -
 drivers/platform/x86/hp_accel.c                       |    1=20
 drivers/rtc/rtc-max8907.c                             |   11 -
 drivers/scsi/bfa/bfad.c                               |    6=20
 drivers/scsi/virtio_scsi.c                            |   15 +
 drivers/staging/lustre/lustre/ptlrpc/niobuf.c         |    6=20
 drivers/staging/rtl8712/usb_intf.c                    |    5=20
 drivers/staging/vt6656/baseband.c                     |    3=20
 drivers/staging/vt6656/card.c                         |    2=20
 drivers/staging/zram/zram_drv.c                       |    4=20
 drivers/target/iscsi/iscsi_target.c                   |   34 ++--
 drivers/target/iscsi/iscsi_target_nego.c              |    2=20
 drivers/tty/serial/8250/8250_core.c                   |    4=20
 drivers/tty/serial/8250/8250_pci.c                    |    8 -
 drivers/tty/serial/atmel_serial.c                     |   45 +++--
 drivers/usb/chipidea/ci.h                             |   26 +++
 drivers/usb/chipidea/ci_hdrc_imx.c                    |   32 +++-
 drivers/usb/chipidea/core.c                           |    2=20
 drivers/usb/chipidea/host.c                           |    1=20
 drivers/usb/chipidea/otg.h                            |    6=20
 drivers/usb/chipidea/udc.c                            |   19 ++
 drivers/usb/core/config.c                             |    7=20
 drivers/usb/core/hub.c                                |   54 ++----
 drivers/usb/host/ehci.h                               |   18 ++
 drivers/usb/host/xhci-ring.c                          |    2=20
 drivers/usb/host/xhci.c                               |    7=20
 drivers/usb/host/xhci.h                               |    2=20
 drivers/usb/serial/cypress_m8.h                       |    2=20
 drivers/usb/serial/ftdi_sio.c                         |   17 +-
 drivers/usb/serial/option.c                           |   15 +
 drivers/usb/serial/pl2303.c                           |   34 +++-
 drivers/usb/storage/unusual_devs.h                    |    7=20
 fs/btrfs/extent-tree.c                                |    2=20
 fs/btrfs/ioctl.c                                      |    6=20
 fs/dcache.c                                           |    1=20
 fs/ext4/inline.c                                      |    8 -
 fs/hpfs/alloc.c                                       |   66 ++++++++
 fs/hpfs/hpfs_fn.h                                     |    2=20
 fs/hpfs/super.c                                       |   29 ++-
 fs/mount.h                                            |    2=20
 include/linux/hugetlb.h                               |    6=20
 include/linux/libata.h                                |    2=20
 include/linux/usb/chipidea.h                          |    1=20
 mm/hugetlb.c                                          |   17 ++
 mm/mempolicy.c                                        |    2=20
 mm/swap.c                                             |  143 ++++++++++---=
-----
 net/compat.c                                          |    9 -
 net/core/filter.c                                     |   30 ---
 net/ieee802154/nl-phy.c                               |    6=20
 net/ipv4/fib_frontend.c                               |    2=20
 net/ipv4/inet_diag.c                                  |    4=20
 net/ipv4/ip_gre.c                                     |    2=20
 net/ipv4/ip_input.c                                   |    2=20
 net/ipv4/ip_tunnel.c                                  |    1=20
 net/ipv4/ipmr.c                                       |    7=20
 net/ipv4/tcp_metrics.c                                |   51 ++++--
 net/ipv6/ip6_input.c                                  |    2=20
 net/ipv6/ip6mr.c                                      |    7=20
 net/rds/ib_recv.c                                     |    7=20
 sound/core/init.c                                     |    4=20
 sound/pci/Kconfig                                     |   12 +
 sound/pci/hda/hda_generic.c                           |    6=20
 sound/pci/hda/patch_analog.c                          |   22 +-
 sound/pci/hda/patch_hdmi.c                            |  100 +++++++++---
 sound/pci/hda/patch_realtek.c                         |   19 ++
 sound/pci/rme9652/rme9652.c                           |    2=20
 sound/soc/codecs/adau1701.c                           |    2=20
 sound/soc/codecs/wm5110.c                             |   48 ++++++
 tools/perf/util/session.c                             |    7=20
 153 files changed, 1608 insertions(+), 595 deletions(-)

Adrien Verg=C3=A9 (1):
      ALSA: hda - Fix silent output on MacBook Air 1,1

Alan Stern (1):
      USB: fix race between hub_disconnect and recursively_mark_NOTATTACHED

Amir Shehata (1):
      staging/lustre/ptlrpc: Fix a crash when dereferencing NULL pointer

Amitkumar Karwar (1):
      mwifiex: add missing endian conversion for fw_tsf

Andrea Arcangeli (1):
      mm: hugetlbfs: fix hugetlbfs optimization

Andreas Schwab (1):
      KVM: PPC: Book3S HV: use xics_wake_cpu only when defined

Andrew Jones (1):
      kvm: x86: fix apic_base enable check

Andy Grover (1):
      target/iscsi: Fix network portal creation race

Annie Li (1):
      xen-netfront: fix resource leak in netfront

Anssi Hannula (1):
      ALSA: hda - hdmi: introduce patch_nvhdmi()

Aristeu Rozanski (1):
      e752x_edac: Fix pci_dev usage count

Asias He (1):
      virtio-scsi: Fix hotcpu_notifier use-after-free with virtscsi_freeze

Ben Hutchings (1):
      xhci: Avoid infinite loop when sg urb requires too many trbs

Bing Zhao (1):
      mwifiex: fix wrong 11ac bits setting in fw_cap_info

Bj=C3=B8rn Mork (1):
      net: usbnet: fix SG initialisation

Borislav Petkov (1):
      x86, cpu, amd: Add workaround for family 16h, erratum 793

Charles Keepax (1):
      ASoC: wm5110: Extend SYSCLK patch file for rev D

Chen-Yu Tsai (1):
      pinctrl: sunxi: Honor GPIO output initial vaules

Christian Engelmayer (1):
      ieee802154: Fix memory leak in ieee802154_add_iface()

Christoph Paasch (1):
      tcp: metrics: Avoid duplicate entries with the same destination-IP

Colin Leitner (1):
      USB: ftdi_sio: added CS5 quirk for broken smartcard readers

Dan Carpenter (1):
      ALSA: bits vs bytes bug in snd_card_create()

Dave Young (1):
      x86/efi: Fix off-by-one bug in EFI Boot Services reservation

David Ertman (1):
      e1000e: fix compiler warnings

David Rientjes (1):
      mm/mempolicy.c: fix mempolicy printing in numa_maps

David Sterba (1):
      btrfs: restrict snapshotting to own subvolumes

Dominik Dingel (1):
      KVM: s390: ioeventfd: ignore leftmost bits

Dongsheng Yang (1):
      perf kvm: Fix kvm report without guestmount.

Duan Jiong (2):
      ip_tunnel: clear IPCB in ip_tunnel_xmit() in case dst_link_failure() =
is called
      net: gre: use icmp_hdr() to get inner ip header

Eliad Peller (1):
      iwlwifi: mvm: fix missing cleanup in .start() error path

Emmanuel Grumbach (1):
      iwlwifi: pcie: enable oscillator for L1 exit

Eric Dumazet (1):
      bpf: do not use reciprocal divide

Eric W. Biederman (2):
      vfs: Remove second variable named error in __dentry_path
      vfs: Is mounted should be testing mnt_ns for NULL or error.

Gerald Schaefer (1):
      net: rds: fix per-cpu helper usage

Greg Kroah-Hartman (1):
      Linux 3.12.10

Gregory CLEMENT (4):
      ARM: mvebu: Add support to get the ID and the revision of a SoC
      ARM: mvebu: Add quirk for i2c for the OpenBlocks AX3-4 board
      i2c: mv64xxx: Fix bus hang on A0 version of the Armada XP SoCs
      i2c: mv64xxx: Document the newly introduced Armada XP A0 compatible

Hannes Frederic Sowa (1):
      net: avoid reference counter overflows on fib_rules in multicast forw=
arding

Heiko Carstens (3):
      KVM: s390: fix diagnose code extraction
      s390/uapi: fix struct statfs64 definition
      s390/bpf,jit: fix 32 bit divisions, use unsigned divide instructions

Helge Deller (1):
      parisc: fix cache-flushing

Holger Eitzenberger (1):
      net: Fix memory leak if TPROXY used with TCP early demux

Ilia Mirkin (1):
      drm/nouveau/bios: fix offset calculation for BMPv1 bioses

Jack Pham (1):
      usb: xhci: Check for XHCI_PLAT in xhci_cleanup_msix()

Jean-Jacques Hiblot (1):
      ARM: at91: smc: bug fix in sam9_smc_cs_read()

Johan Hovold (2):
      USB: pl2303: fix data corruption on termios updates
      USB: cypress_m8: fix ring-indicator detection and reporting

Jonathan Woithe (1):
      serial: 8250: Fix initialisation of Quatech cards with the AMCC PCI c=
hip

Kent Overstreet (1):
      bcache: Data corruption fix

Krzysztof Kozlowski (1):
      mfd: max77686: Fix regmap resource leak on driver remove

Larry Finger (17):
      rtlwifi: rtl8192cu: Add new device ID
      rtlwifi: Update beacon statistics for USB driver
      rtlwifi: rtl8192c: Prevent reconnect attempts if not connected
      rtlwifi: rtl8192cu: Add new firmware
      rtlwifi: Redo register save locations
      rtlwifi: Set the link state
      rtlwifi: rtl8192c: Add new definitions in the dm_common header
      rtlwifi: Increase the RX queue length for USB drivers
      rtlwifi: rtl8192c: Add routines to save/restore power index registers
      rtlwifi: rtl8192cu: Update the power index registers
      rtlwifi: rtl8192cu: Fix some code in RF handling
      rtlwifi: Add missing code to PWDB statics routine
      rtlwifi: rtl8188ee: Fix typo in code
      b43: Fix lockdep splat
      b43: Fix unload oops if firmware is not available
      b43legacy: Fix unload oops if firmware is not available
      staging: r8712u: Set device type to wlan

Lars-Peter Clausen (1):
      ASoC: adau1701: Fix ADAU1701_SEROCTL_WORD_LEN_16 constant

Lior Amsalem (1):
      ata: sata_mv: fix disk hotplug for Armada 370/XP SoCs

Ludovic Desroches (1):
      ARM: at91: at91sam9g45: set default mmc pinctrl-names

Malcolm Priestley (2):
      staging: vt6656: [BUG] BBvUpdatePreEDThreshold Always set sensitivity=
 on bScanning
      staging: vt6656: CARDqGetNextTBTT correct uLowNextTBTT

Marcelo Tosatti (1):
      KVM: x86: limit PIT timer frequency

Marek Roszko (3):
      tty/serial: at91: Handle shutdown more safely
      tty/serial: at91: fix race condition in atmel_serial_remove
      tty/serial: at91: disable uart timer at start of shutdown

Mark Deneen (1):
      tty/serial: at91: reset rx_ring when port is shutdown

Michal Schmidt (1):
      bnx2x: fix DMA unmapping of TSO split BDs

Mihai Caraman (1):
      KVM: PPC: e500: Fix bad address type in deliver_tlb_misss()

Mikhail Zolotaryov (1):
      USB: Nokia 502 is an unusual device

Mikulas Patocka (2):
      alpha: fix broken network checksum
      hpfs: remember free space

Minchan Kim (1):
      zram: fix race between reset and flushing pending work

Neal Cardwell (1):
      inet_diag: fix inet_diag_dump_icsk() timewait socket state logic

NeilBrown (1):
      md/raid5: fix long-standing problem with bitmap handling on write fai=
lure.

Nicholas Bellinger (1):
      iscsi-target: Pre-allocate more tags to avoid ack starvation

Oliver Hartkopp (1):
      fib_frontend: fix possible NULL pointer dereference

Or Gerlitz (1):
      net/vxlan: Share RX skb de-marking and checksum checks with ovs

PaX Team (1):
      x86, x32: Correct invalid use of user timespec in the kernel

Paolo Bonzini (2):
      x86, kvm: cache the base of the KVM cpuid leaves
      x86, kvm: correctly access the KVM_CPUID_FEATURES leaf at 0x40000101

Paul Mackerras (1):
      powerpc: Make sure "cache" directory is removed when offlining cpu

Peter Chen (5):
      usb: chipidea: add freescale imx28 special write register method
      usb: chipidea: imx: set CI_HDRC_IMX28_WRITE_FIX for imx28
      usb: chipidea: need to mask INT_STATUS when write otgsc
      usb: chipidea: udc: using MultO at TD as real mult value for ISO-TX
      usb: ehci: add freescale imx28 special write register method

Peter Huewe (2):
      tpm/tpm_i2c_stm_st33: Check return code of get_burstcount
      tpm/tpm_ppi: Do not compare strcmp(a,b) =3D=3D -1

Phil Pokorny (1):
      hwmon: (k10temp) Add support for Kaveri CPUs

Rahul Bedarkar (1):
      USB: serial: add support for iBall 3.5G connect usb modem

Richard Weinberger (1):
      net,via-rhine: Fix tx_timeout handling

Sarah Sharp (1):
      xhci: Set scatter-gather limit to avoid failed block writes.

Sebastian Andrzej Siewior (1):
      parport: parport_pc: remove double PCI ID for NetMos

Shane Huang (1):
      i2c: piix4: Add support for AMD ML and CZ SMBus changes

Simon Guinot (2):
      ata: sata_mv: introduce compatible string "marvell, armada-370-sata"
      ARM: mvebu: update the SATA compatible string for Armada 370/XP

Srivatsa S. Bhat (1):
      powerpc: Fix the setup of CPU-to-Node mappings during CPU online

Stephen Warren (3):
      serial: 8250: enable UART_BUG_NOMSR for Tegra
      rtc: max8907: weekday encoding fixes
      ALSA: hda/hdmi - allow PIN_OUT to be dynamically enabled

Sujith Manoharan (2):
      ath9k: Use correct channel for RX packets
      ath9k: Disable cross-band FCC

Takashi Iwai (6):
      ALSA: rme9652: fix a missing comma in channel_map_9636_ds[]
      ALSA: hda - Correct AD1986A 3stack pin configs
      ALSA: hda - Don't create duplicated ctls for loopback paths
      ALSA: Enable CONFIG_ZONE_DMA for smaller PCI DMA masks
      hp_accel: Add a new PnP ID HPQ6007 for new HP laptops
      ALSA: hda - Don't set indep_hp flag for old AD codecs

Tejun Heo (1):
      libata: disable LPM for some WD SATA-I devices

Theodore Ts'o (1):
      ext4: avoid clearing beyond i_blocks when truncating an inline data f=
ile

Thomas Pugliese (1):
      usb: core: get config and string descriptors for unauthorized devices

Tomas Winkler (1):
      mei: use hbm idle state to prevent spurious resets

Vijaya Mohan Guvva (1):
      SCSI: bfa: Chinook quad port 16G FC HBA claim issue

Wang Shilong (1):
      Btrfs: handle EAGAIN case properly in btrfs_drop_snapshot()

Yegor Yefremov (1):
      serial: add support for 200 v3 series Titan card

ZHAO Gang (1):
      b43: fix the wrong assignment of status.freq in b43_rx()

=E5=BC=A0=E5=90=9B (1):
      usb: option: add new zte 3g modem pids to option driver


--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS8+nkAAoJEDjbvchgkmk+Xc8QAMJjscHFDr8EZulETlK7CWaz
/egYx+IveTApQjMMIDr3S7nfkFKo1fDGSJVVRo/Ik+j25GuijFNJiEsebWBOvFgb
Ufvdgz8JYsQVkiEmJ6fXYPCPFKf9Txh+JDoN+RTB3prlbyJCpZ0EsyFS3TqGDHbg
M4dGHjRQMhH8Ic7P3IsbYldmN7QawisyG6S+9kQXupre/fr48iwqmUEVNcdwXbOy
ppkmJ9U9NmLto444zSRiKN6NeeslSf09JZtbuZx+gp59zDqBrtreWxxtyRUSgslB
9ZCe6huNF3AJR6+cz9sddDUd3napd6WjWFH2P8YYyxt3V3Pv2UnYoIECwa/eokgv
nCagb2Xo8fQi7SUK1wItK6ZrUh20hxPuNK90jbVUDZHXcp2fcRgCe5G/HV2DhVAD
N6ivSS8fAZM1Zvo+xU/noUaelpatLTOglg6bkDkdvTa+bO13lD5aYViPP1WLc0S/
LY1BJTyLDhKS14abnX8yYSrU8HaFPuCoBHKGK88swAypmEdZM8oaoSWFzsb/TY89
8I+z7iFuJ3AzaCnZUFTZIfmIDkNQ4Yw7L5HLVuP5dg8A2WXNZWtbopy0oj3BgAbE
igknOpqgJcyivS2U6KzuQ7uLoJDFHN9FiWbSGxXHnIIaNh0ptewGQZo4/U+lEUzE
fYypCpP5dVvmE/7E1grA
=i1l5
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
