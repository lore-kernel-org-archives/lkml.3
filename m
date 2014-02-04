Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933030AbaBDVBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:01:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56036 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932452AbaBDVBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:01:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [PATCH 3.10 000/104] 3.10.29-stable review
Date: Tue,  4 Feb 2014 13:01:03 -0800
Message-Id: <20140204210222.731641778@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.29 release.
There are 104 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Feb  6 21:02:03 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.29-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.29-rc1

Paul Mackerras <paulus@samba.org>
    powerpc: Make sure "cache" directory is removed when offlining cpu

Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
    powerpc: Fix the setup of CPU-to-Node mappings during CPU online

David Sterba <dsterba@suse.cz>
    btrfs: restrict snapshotting to own subvolumes

Wang Shilong <wangsl.fnst@cn.fujitsu.com>
    Btrfs: handle EAGAIN case properly in btrfs_drop_snapshot()

Andy Grover <agrover@redhat.com>
    target/iscsi: Fix network portal creation race

Asias He <asias.hejun@gmail.com>
    virtio-scsi: Fix hotcpu_notifier use-after-free with virtscsi_freeze

Vijaya Mohan Guvva <vmohan@brocade.com>
    SCSI: bfa: Chinook quad port 16G FC HBA claim issue

Thomas Pugliese <thomas.pugliese@gmail.com>
    usb: core: get config and string descriptors for unauthorized devices

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: pcie: fix interrupt coalescing for 7260 / 3160

Stephen Warren <swarren@nvidia.com>
    ALSA: hda/hdmi - allow PIN_OUT to be dynamically enabled

Anssi Hannula <anssi.hannula@iki.fi>
    ALSA: hda - hdmi: introduce patch_nvhdmi()

Mihai Caraman <mihai.caraman@freescale.com>
    KVM: PPC: e500: Fix bad address type in deliver_tlb_misss()

Andreas Schwab <schwab@linux-m68k.org>
    KVM: PPC: Book3S HV: use xics_wake_cpu only when defined

Helge Deller <deller@gmx.de>
    parisc: fix cache-flushing

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: pcie: enable oscillator for L1 exit

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    ip6tnl: fix double free of fb_tnl_dev on exit

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    Revert "ip6tnl: fix use after free of fb_tnl_dev"

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    sit: fix double free of fb_tunnel_dev on exit

Annie Li <annie.li@oracle.com>
    xen-netfront: fix resource leak in netfront

Holger Eitzenberger <holger@eitzenberger.org>
    net: Fix memory leak if TPROXY used with TCP early demux

Oliver Hartkopp <socketcan@hartkopp.net>
    fib_frontend: fix possible NULL pointer dereference

Duan Jiong <duanj.fnst@cn.fujitsu.com>
    ip_tunnel: clear IPCB in ip_tunnel_xmit() in case dst_link_failure() is called

Heiko Carstens <heiko.carstens@de.ibm.com>
    s390/bpf,jit: fix 32 bit divisions, use unsigned divide instructions

Eric Dumazet <edumazet@google.com>
    bpf: do not use reciprocal divide

Christoph Paasch <christoph.paasch@uclouvain.be>
    tcp: metrics: Avoid duplicate entries with the same destination-IP

Gerald Schaefer <gerald.schaefer@de.ibm.com>
    net: rds: fix per-cpu helper usage

Richard Weinberger <richard@nod.at>
    net,via-rhine: Fix tx_timeout handling

Hannes Frederic Sowa <hannes@stressinduktion.org>
    net: avoid reference counter overflows on fib_rules in multicast forwarding

Christian Engelmayer <cengelma@gmx.at>
    ieee802154: Fix memory leak in ieee802154_add_iface()

Neal Cardwell <ncardwell@google.com>
    inet_diag: fix inet_diag_dump_icsk() timewait socket state logic

Michal Schmidt <mschmidt@redhat.com>
    bnx2x: fix DMA unmapping of TSO split BDs

Takashi Iwai <tiwai@suse.de>
    hp_accel: Add a new PnP ID HPQ6007 for new HP laptops

Kent Overstreet <kmo@daterainc.com>
    bcache: Data corruption fix

Eric W. Biederman <ebiederm@xmission.com>
    vfs: Is mounted should be testing mnt_ns for NULL or error.

Theodore Ts'o <tytso@mit.edu>
    ext4: avoid clearing beyond i_blocks when truncating an inline data file

Tejun Heo <tj@kernel.org>
    libata: disable LPM for some WD SATA-I devices

Lior Amsalem <alior@marvell.com>
    ata: sata_mv: fix disk hotplug for Armada 370/XP SoCs

Simon Guinot <simon.guinot@sequanux.org>
    ata: sata_mv: introduce compatible string "marvell, armada-370-sata"

Peter Huewe <PeterHuewe@gmx.de>
    tpm/tpm_ppi: Do not compare strcmp(a,b) == -1

Peter Huewe <PeterHuewe@gmx.de>
    tpm/tpm_i2c_stm_st33: Check return code of get_burstcount

Adrien Vergé <adrienverge@gmail.com>
    ALSA: hda - Fix silent output on MacBook Air 1,1

Takashi Iwai <tiwai@suse.de>
    ALSA: Enable CONFIG_ZONE_DMA for smaller PCI DMA masks

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Don't create duplicated ctls for loopback paths

Takashi Iwai <tiwai@suse.de>
    ALSA: rme9652: fix a missing comma in channel_map_9636_ds[]

Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
    ASoC: wm5110: Extend SYSCLK patch file for rev D

Lars-Peter Clausen <lars@metafoo.de>
    ASoC: adau1701: Fix ADAU1701_SEROCTL_WORD_LEN_16 constant

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    mfd: max77686: Fix regmap resource leak on driver remove

Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
    perf kvm: Fix kvm report without guestmount.

Chen-Yu Tsai <wens@csie.org>
    pinctrl: sunxi: Honor GPIO output initial vaules

Stephen Warren <swarren@nvidia.com>
    rtc: max8907: weekday encoding fixes

Borislav Petkov <bp@alien8.de>
    rtc-cmos: Add an alarm disable quirk

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    parport: parport_pc: remove double PCI ID for NetMos

Heiko Carstens <heiko.carstens@de.ibm.com>
    s390/uapi: fix struct statfs64 definition

Heiko Carstens <heiko.carstens@de.ibm.com>
    KVM: s390: fix diagnose code extraction

Stephen Warren <swarren@nvidia.com>
    serial: 8250: enable UART_BUG_NOMSR for Tegra

Jonathan Woithe <jwoithe@just42.net>
    serial: 8250: Fix initialisation of Quatech cards with the AMCC PCI chip

Yegor Yefremov <yegorslists@googlemail.com>
    serial: add support for 200 v3 series Titan card

Phil Pokorny <ppokorny@penguincomputing.com>
    hwmon: (k10temp) Add support for Kaveri CPUs

Jean-Jacques Hiblot <jjhiblot@traphandler.com>
    ARM: at91: smc: bug fix in sam9_smc_cs_read()

Marek Roszko <mark.roszko@gmail.com>
    tty/serial: at91: Handle shutdown more safely

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: CARDqGetNextTBTT correct uLowNextTBTT

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: [BUG] BBvUpdatePreEDThreshold Always set sensitivity on bScanning

Larry Finger <Larry.Finger@lwfinger.net>
    staging: r8712u: Set device type to wlan

ZHAO Gang <gamerh2o@gmail.com>
    b43: fix the wrong assignment of status.freq in b43_rx()

Larry Finger <Larry.Finger@lwfinger.net>
    b43legacy: Fix unload oops if firmware is not available

Larry Finger <Larry.Finger@lwfinger.net>
    b43: Fix unload oops if firmware is not available

Larry Finger <Larry.Finger@lwfinger.net>
    b43: Fix lockdep splat

Eliad Peller <eliadx.peller@intel.com>
    iwlwifi: mvm: fix missing cleanup in .start() error path

Bing Zhao <bzhao@marvell.com>
    mwifiex: fix wrong 11ac bits setting in fw_cap_info

Amitkumar Karwar <akarwar@marvell.com>
    mwifiex: add missing endian conversion for fw_tsf

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8188ee: Fix typo in code

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: Add missing code to PWDB statics routine

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192cu: Fix some code in RF handling

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192cu: Update the power index registers

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192c: Add routines to save/restore power index registers

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: Increase the RX queue length for USB drivers

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192c: Add new definitions in the dm_common header

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: Set the link state

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: Redo register save locations

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192cu: Add new firmware

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192c: Prevent reconnect attempts if not connected

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: Update beacon statistics for USB driver

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192cu: Add new device ID

Peter Chen <peter.chen@freescale.com>
    usb: ehci: add freescale imx28 special write register method

Alan Stern <stern@rowland.harvard.edu>
    USB: fix race between hub_disconnect and recursively_mark_NOTATTACHED

Jack Pham <jackp@codeaurora.org>
    usb: xhci: Check for XHCI_PLAT in xhci_cleanup_msix()

Mikhail Zolotaryov <lebon@lebon.org.ua>
    USB: Nokia 502 is an unusual device

Colin Leitner <colin.leitner@googlemail.com>
    USB: ftdi_sio: added CS5 quirk for broken smartcard readers

Johan Hovold <jhovold@gmail.com>
    USB: cypress_m8: fix ring-indicator detection and reporting

Rahul Bedarkar <rahulbedarkar89@gmail.com>
    USB: serial: add support for iBall 3.5G connect usb modem

张君 <zjn77777@163.com>
    usb: option: add new zte 3g modem pids to option driver

Johan Hovold <jhovold@gmail.com>
    USB: pl2303: fix data corruption on termios updates

Marcelo Tosatti <mtosatti@redhat.com>
    KVM: x86: limit PIT timer frequency

Prarit Bhargava <prarit@redhat.com>
    x86: Add check for number of available vectors before CPU down

Dave Young <dyoung@redhat.com>
    x86/efi: Fix off-by-one bug in EFI Boot Services reservation

PaX Team <pageexec@freemail.hu>
    x86, x32: Correct invalid use of user timespec in the kernel

David Rientjes <rientjes@google.com>
    mm/mempolicy.c: fix mempolicy printing in numa_maps

David Ertman <davidx.m.ertman@intel.com>
    e1000e: fix compiler warnings

Aristeu Rozanski <aris@redhat.com>
    e752x_edac: Fix pci_dev usage count

Andrea Arcangeli <aarcange@redhat.com>
    mm: hugetlbfs: fix hugetlbfs optimization

Alexandre Courbot <acourbot@nvidia.com>
    lib/decompressors: fix "no limit" output buffer length

Ilia Mirkin <imirkin@alum.mit.edu>
    drm/nouveau/bios: fix offset calculation for BMPv1 bioses

NeilBrown <neilb@suse.de>
    md/raid5: fix long-standing problem with bitmap handling on write failure.

Andrew Jones <drjones@redhat.com>
    kvm: x86: fix apic_base enable check


-------------

Diffstat:

 Documentation/devicetree/bindings/ata/marvell.txt |   2 +-
 Makefile                                          |   4 +-
 arch/arm/mach-at91/sam9_smc.c                     |   2 +-
 arch/arm/net/bpf_jit_32.c                         |   6 +-
 arch/parisc/include/asm/cacheflush.h              |   2 -
 arch/parisc/include/asm/page.h                    |   3 +-
 arch/parisc/kernel/cache.c                        |  14 +++
 arch/powerpc/include/asm/topology.h               |  10 +-
 arch/powerpc/kernel/cacheinfo.c                   |   3 +
 arch/powerpc/kvm/book3s_hv.c                      |   7 +-
 arch/powerpc/kvm/e500_mmu.c                       |   2 +-
 arch/powerpc/mm/numa.c                            |  70 ++++++++++-
 arch/powerpc/net/bpf_jit_comp.c                   |   7 +-
 arch/s390/include/uapi/asm/statfs.h               |  10 +-
 arch/s390/kvm/diag.c                              |   2 +-
 arch/s390/net/bpf_jit_comp.c                      |  29 +++--
 arch/sparc/net/bpf_jit_comp.c                     |  17 ++-
 arch/x86/include/asm/irq.h                        |   1 +
 arch/x86/kernel/irq.c                             |  70 +++++++++++
 arch/x86/kernel/smpboot.c                         |   6 +
 arch/x86/kvm/i8254.c                              |  18 +++
 arch/x86/kvm/lapic.c                              |   5 +-
 arch/x86/kvm/x86.c                                |   3 +
 arch/x86/kvm/x86.h                                |   2 +
 arch/x86/net/bpf_jit_comp.c                       |  14 ++-
 arch/x86/platform/efi/efi.c                       |   2 +-
 drivers/ata/libata-core.c                         |  27 ++++
 drivers/ata/libata-scsi.c                         |  18 ++-
 drivers/ata/sata_mv.c                             |  25 ++++
 drivers/char/tpm/tpm_i2c_stm_st33.c               |   7 +-
 drivers/char/tpm/tpm_ppi.c                        |   8 +-
 drivers/edac/e752x_edac.c                         |   4 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/init.c   |   8 +-
 drivers/hwmon/k10temp.c                           |   1 +
 drivers/md/bcache/bset.c                          |  26 +++-
 drivers/md/raid5.c                                |   1 +
 drivers/mfd/max77686.c                            |   2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   |  13 +-
 drivers/net/ethernet/intel/e1000e/phy.c           |  10 +-
 drivers/net/ethernet/via/via-rhine.c              |   1 +
 drivers/net/wireless/b43/b43.h                    |   4 +-
 drivers/net/wireless/b43/main.c                   |  27 ++--
 drivers/net/wireless/b43/xmit.c                   |   4 +-
 drivers/net/wireless/b43legacy/main.c             |   1 +
 drivers/net/wireless/iwlwifi/iwl-7000.c           |   6 +
 drivers/net/wireless/iwlwifi/iwl-config.h         |   3 +
 drivers/net/wireless/iwlwifi/iwl-csr.h            |   5 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h           |   4 +
 drivers/net/wireless/iwlwifi/mvm/ops.c            |   1 +
 drivers/net/wireless/iwlwifi/pcie/rx.c            |   4 +
 drivers/net/wireless/iwlwifi/pcie/trans.c         |  19 ++-
 drivers/net/wireless/mwifiex/fw.h                 |   2 +-
 drivers/net/wireless/mwifiex/scan.c               |   4 +-
 drivers/net/wireless/rtlwifi/base.c               |   3 +-
 drivers/net/wireless/rtlwifi/core.c               |  11 ++
 drivers/net/wireless/rtlwifi/rtl8188ee/dm.c       |   2 +-
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c |  36 ++++++
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h |  14 +++
 drivers/net/wireless/rtlwifi/rtl8192cu/dm.c       |   9 ++
 drivers/net/wireless/rtlwifi/rtl8192cu/dm.h       |   3 +
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c       |  29 +++--
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c       |  17 ++-
 drivers/net/wireless/rtlwifi/stats.c              |  14 +++
 drivers/net/wireless/rtlwifi/usb.c                |   4 +-
 drivers/net/wireless/rtlwifi/wifi.h               |  33 ++---
 drivers/net/xen-netfront.c                        |  88 ++++---------
 drivers/parport/parport_pc.c                      |  10 +-
 drivers/pinctrl/pinctrl-sunxi.c                   |  13 +-
 drivers/platform/x86/hp_accel.c                   |   1 +
 drivers/rtc/rtc-cmos.c                            |  52 +++++++-
 drivers/rtc/rtc-max8907.c                         |  11 +-
 drivers/scsi/bfa/bfad.c                           |   6 +-
 drivers/scsi/virtio_scsi.c                        |  15 ++-
 drivers/staging/rtl8712/usb_intf.c                |   5 +
 drivers/staging/vt6656/baseband.c                 |   3 -
 drivers/staging/vt6656/card.c                     |   2 +-
 drivers/target/iscsi/iscsi_target.c               |  34 +++--
 drivers/tty/serial/8250/8250_core.c               |   4 +
 drivers/tty/serial/8250/8250_pci.c                |   8 +-
 drivers/tty/serial/atmel_serial.c                 |  20 +--
 drivers/usb/core/config.c                         |   7 --
 drivers/usb/core/hub.c                            |  54 +++-----
 drivers/usb/host/ehci.h                           |  18 ++-
 drivers/usb/host/xhci.c                           |   3 +
 drivers/usb/serial/cypress_m8.h                   |   2 +-
 drivers/usb/serial/ftdi_sio.c                     |  17 ++-
 drivers/usb/serial/option.c                       |  15 +++
 drivers/usb/serial/pl2303.c                       |  33 +++--
 drivers/usb/storage/unusual_devs.h                |   7 ++
 fs/btrfs/extent-tree.c                            |   2 +-
 fs/btrfs/ioctl.c                                  |   6 +
 fs/ext4/inline.c                                  |   8 +-
 fs/mount.h                                        |   2 +-
 include/linux/hugetlb.h                           |   6 +
 include/linux/libata.h                            |   2 +
 lib/decompress_inflate.c                          |   2 +-
 mm/hugetlb.c                                      |  17 +++
 mm/mempolicy.c                                    |   2 +-
 mm/swap.c                                         | 143 +++++++++++++---------
 net/compat.c                                      |   9 +-
 net/core/filter.c                                 |  30 +----
 net/ieee802154/nl-phy.c                           |   6 +-
 net/ipv4/fib_frontend.c                           |   2 +
 net/ipv4/inet_diag.c                              |   4 +-
 net/ipv4/ip_input.c                               |   2 +-
 net/ipv4/ip_tunnel.c                              |   1 +
 net/ipv4/ipmr.c                                   |   7 +-
 net/ipv4/tcp_metrics.c                            |  51 +++++---
 net/ipv6/ip6_input.c                              |   2 +-
 net/ipv6/ip6_tunnel.c                             |  12 ++
 net/ipv6/ip6mr.c                                  |   7 +-
 net/ipv6/sit.c                                    |  10 ++
 net/rds/ib_recv.c                                 |   7 +-
 sound/pci/Kconfig                                 |  12 ++
 sound/pci/hda/hda_generic.c                       |   6 +-
 sound/pci/hda/patch_hdmi.c                        | 100 +++++++++++----
 sound/pci/hda/patch_realtek.c                     |  19 ++-
 sound/pci/rme9652/rme9652.c                       |   2 +-
 sound/soc/codecs/adau1701.c                       |   2 +-
 sound/soc/codecs/wm5110.c                         |  48 ++++++++
 tools/perf/util/session.c                         |   7 +-
 121 files changed, 1216 insertions(+), 469 deletions(-)


