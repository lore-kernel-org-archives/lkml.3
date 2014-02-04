Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933658AbaBDVLK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:11:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56994 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932434AbaBDVLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:11:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [PATCH 3.13 000/140] 3.13.2-stable review
Date: Tue,  4 Feb 2014 13:09:47 -0800
Message-Id: <20140204211036.967663852@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.13.2 release.
There are 140 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Feb  6 21:10:18 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.13.2-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.13.2-rc1

Paul Mackerras <paulus@samba.org>
    powerpc: Make sure "cache" directory is removed when offlining cpu

Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
    powerpc: Fix the setup of CPU-to-Node mappings during CPU online

David Sterba <dsterba@suse.cz>
    btrfs: restrict snapshotting to own subvolumes

Chris Mason <clm@fb.com>
    Btrfs: setup inode location during btrfs_init_inode_locked

Wang Shilong <wangsl.fnst@cn.fujitsu.com>
    Btrfs: handle EAGAIN case properly in btrfs_drop_snapshot()

Andy Grover <agrover@redhat.com>
    target/iscsi: Fix network portal creation race

Nicholas Bellinger <nab@linux-iscsi.org>
    iscsi-target: Pre-allocate more tags to avoid ack starvation

Asias He <asias.hejun@gmail.com>
    virtio-scsi: Fix hotcpu_notifier use-after-free with virtscsi_freeze

Dan Carpenter <dan.carpenter@oracle.com>
    SCSI: qla4xxx: overflow in qla4xxx_set_chap_entry()

Vijaya Mohan Guvva <vmohan@brocade.com>
    SCSI: bfa: Chinook quad port 16G FC HBA claim issue

Thomas Pugliese <thomas.pugliese@gmail.com>
    usb: core: get config and string descriptors for unauthorized devices

Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
    hpfs: remember free space

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Don't set indep_hp flag for old AD codecs

Mihai Caraman <mihai.caraman@freescale.com>
    KVM: PPC: e500: Fix bad address type in deliver_tlb_misss()

Andreas Schwab <schwab@linux-m68k.org>
    KVM: PPC: Book3S HV: use xics_wake_cpu only when defined

Helge Deller <deller@gmx.de>
    parisc: fix cache-flushing

Helge Deller <deller@gmx.de>
    parisc/sti_console: prefer Linux fonts over built-in ROM fonts

Mikulas Patocka <mpatocka@redhat.com>
    alpha: fix broken network checksum

Dong Aisheng <b29396@freescale.com>
    mmc: sdhci-esdhc-imx: fix access hardirq-unsafe lock in atomic context

Aisheng Dong <b29396@freescale.com>
    mmc: sdhci: fix lockdep error in tuning routine

David Cohen <david.a.cohen@linux.intel.com>
    mmc: sdhci-pci: add broken HS200 quirk for Intel Merrifield

David Cohen <david.a.cohen@linux.intel.com>
    mmc: sdhci: add quirk for broken HS200 support

Duan Jiong <duanj.fnst@cn.fujitsu.com>
    net: gre: use icmp_hdr() to get inner ip header

Annie Li <annie.li@oracle.com>
    xen-netfront: fix resource leak in netfront

Holger Eitzenberger <holger@eitzenberger.org>
    net: Fix memory leak if TPROXY used with TCP early demux

Oliver Hartkopp <socketcan@hartkopp.net>
    fib_frontend: fix possible NULL pointer dereference

Or Gerlitz <ogerlitz@mellanox.com>
    net/vxlan: Share RX skb de-marking and checksum checks with ovs

Duan Jiong <duanj.fnst@cn.fujitsu.com>
    ip_tunnel: clear IPCB in ip_tunnel_xmit() in case dst_link_failure() is called

Anton Blanchard <anton@samba.org>
    drivers/tty: ehv_bytechan fails to build as a module

Shane Huang <shane.huang@amd.com>
    i2c: piix4: Add support for AMD ML and CZ SMBus changes

Gregory CLEMENT <gregory.clement@free-electrons.com>
    i2c: mv64xxx: Document the newly introduced Armada XP A0 compatible

Gregory CLEMENT <gregory.clement@free-electrons.com>
    i2c: mv64xxx: Fix bus hang on A0 version of the Armada XP SoCs

Gregory CLEMENT <gregory.clement@free-electrons.com>
    ARM: mvebu: Add quirk for i2c for the OpenBlocks AX3-4 board

Gregory CLEMENT <gregory.clement@free-electrons.com>
    ARM: mvebu: Add support to get the ID and the revision of a SoC

Takashi Iwai <tiwai@suse.de>
    hp_accel: Add a new PnP ID HPQ6007 for new HP laptops

Minchan Kim <minchan@kernel.org>
    zram: fix race between reset and flushing pending work

Kent Overstreet <kmo@daterainc.com>
    bcache: Data corruption fix

Eric W. Biederman <ebiederm@xmission.com>
    vfs: Is mounted should be testing mnt_ns for NULL or error.

Eric W. Biederman <ebiederm@xmission.com>
    vfs: Remove second variable named error in __dentry_path

Theodore Ts'o <tytso@mit.edu>
    ext4: avoid clearing beyond i_blocks when truncating an inline data file

Tejun Heo <tj@kernel.org>
    libata: disable LPM for some WD SATA-I devices

Simon Guinot <simon.guinot@sequanux.org>
    ARM: mvebu: update the SATA compatible string for Armada 370/XP

Lior Amsalem <alior@marvell.com>
    ata: sata_mv: fix disk hotplug for Armada 370/XP SoCs

Simon Guinot <simon.guinot@sequanux.org>
    ata: sata_mv: introduce compatible string "marvell, armada-370-sata"

Roberto Sassu <roberto.sassu@polito.it>
    ima: change the default hash algorithm to SHA1 in ima_eventdigest_ng_init()

Peter Huewe <PeterHuewe@gmx.de>
    tpm/tpm_ppi: Do not compare strcmp(a,b) == -1

Peter Huewe <PeterHuewe@gmx.de>
    tpm/tpm_i2c_stm_st33: Check return code of get_burstcount

Stephen Warren <swarren@nvidia.com>
    ALSA: hda/hdmi - allow PIN_OUT to be dynamically enabled

Hui Wang <hui.wang@canonical.com>
    ALSA: hda - add headset mic detect quirks for another Dell laptop

Adrien Vergé <adrienverge@gmail.com>
    ALSA: hda - Fix silent output on MacBook Air 1,1

Dan Carpenter <dan.carpenter@oracle.com>
    ALSA: bits vs bytes bug in snd_card_create()

Hui Wang <hui.wang@canonical.com>
    ALSA: hda - add headset mic detect quirks for some Dell machines

Hui Wang <hui.wang@canonical.com>
    ALSA: hda - automute via amp instead of pinctl on some AIO models

Takashi Iwai <tiwai@suse.de>
    ALSA: Enable CONFIG_ZONE_DMA for smaller PCI DMA masks

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Don't create duplicated ctls for loopback paths

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Correct AD1986A 3stack pin configs

Takashi Iwai <tiwai@suse.de>
    ALSA: rme9652: fix a missing comma in channel_map_9636_ds[]

Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
    ASoC: wm5110: Extend SYSCLK patch file for rev D

Markus Pargmann <mpa@pengutronix.de>
    ASoC: tlv320aic32x4: Fix regmap range_min

Markus Pargmann <mpa@pengutronix.de>
    ASoC: codec: tlv320aic32x4: Fix regmap range config

Lars-Peter Clausen <lars@metafoo.de>
    ASoC: adau1701: Fix ADAU1701_SEROCTL_WORD_LEN_16 constant

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    mfd: max77686: Fix regmap resource leak on driver remove

Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
    perf kvm: Fix kvm report without guestmount.

Chen-Yu Tsai <wens@csie.org>
    pinctrl: sunxi: Honor GPIO output initial vaules

Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>
    misc: mic: bug fix for interrupt acknowledgement in MSI/INTx case.

Stephen Warren <swarren@nvidia.com>
    rtc: max8907: weekday encoding fixes

Borislav Petkov <bp@alien8.de>
    rtc-cmos: Add an alarm disable quirk

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    parport: parport_pc: remove double PCI ID for NetMos

Heiko Carstens <heiko.carstens@de.ibm.com>
    s390/uapi: fix struct statfs64 definition

Dominik Dingel <dingel@linux.vnet.ibm.com>
    KVM: s390: ioeventfd: ignore leftmost bits

Heiko Carstens <heiko.carstens@de.ibm.com>
    KVM: s390: fix diagnose code extraction

Thomas Huth <thuth@linux.vnet.ibm.com>
    KVM: s390: Always store status during SIGP STOP_AND_STORE_STATUS

Heiko Carstens <heiko.carstens@de.ibm.com>
    s390/compat: fix PSW32_USER_BITS definition

Stephen Warren <swarren@nvidia.com>
    serial: 8250: enable UART_BUG_NOMSR for Tegra

Jonathan Woithe <jwoithe@just42.net>
    serial: 8250: Fix initialisation of Quatech cards with the AMCC PCI chip

Yegor Yefremov <yegorslists@googlemail.com>
    serial: add support for 200 v3 series Titan card

Aaro Koskinen <aaro.koskinen@nsn.com>
    uio: fix devm_request_irq usage

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    xhci: Set scatter-gather limit to avoid failed block writes.

Ben Hutchings <ben@decadent.org.uk>
    xhci: Avoid infinite loop when sg urb requires too many trbs

Phil Pokorny <ppokorny@penguincomputing.com>
    hwmon: (k10temp) Add support for Kaveri CPUs

Jean-Jacques Hiblot <jjhiblot@traphandler.com>
    ARM: at91: smc: bug fix in sam9_smc_cs_read()

Ludovic Desroches <ludovic.desroches@atmel.com>
    ARM: at91: at91sam9g45: set default mmc pinctrl-names

Marek Roszko <mark.roszko@gmail.com>
    tty/serial: at91: disable uart timer at start of shutdown

Mark Deneen <mdeneen@gmail.com>
    tty/serial: at91: reset rx_ring when port is shutdown

Marek Roszko <mark.roszko@gmail.com>
    tty/serial: at91: fix race condition in atmel_serial_remove

Marek Roszko <mark.roszko@gmail.com>
    tty/serial: at91: Handle shutdown more safely

Tomas Winkler <tomas.winkler@intel.com>
    mei: use hbm idle state to prevent spurious resets

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: CARDqGetNextTBTT correct uLowNextTBTT

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: [BUG] BBvUpdatePreEDThreshold Always set sensitivity on bScanning

Larry Finger <Larry.Finger@lwfinger.net>
    staging: r8712u: Set device type to wlan

Amir Shehata <amir.shehata@intel.com>
    staging/lustre/ptlrpc: Fix a crash when dereferencing NULL pointer

Sujith Manoharan <c_manoha@qca.qualcomm.com>
    ath9k: Disable cross-band FCC

Sujith Manoharan <c_manoha@qca.qualcomm.com>
    ath9k: Use correct channel for RX packets

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

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: pcie: enable oscillator for L1 exit

Bing Zhao <bzhao@marvell.com>
    mwifiex: fix wrong 11ac bits setting in fw_cap_info

Amitkumar Karwar <akarwar@marvell.com>
    mwifiex: add missing endian conversion for fw_tsf

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8188ee: Fix typo in code

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192c: Update dynamic gain calculations

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

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: dwc3: fix the glue drivers using the nop phy

Bjørn Mork <bjorn@mork.no>
    usb: cdc-wdm: resp_count can be 0 even if WDM_READ is set

Bjørn Mork <bjorn@mork.no>
    usb: cdc-wdm: avoid hanging on zero length reads

Peter Chen <peter.chen@freescale.com>
    usb: chipidea: udc: using MultO at TD as real mult value for ISO-TX

Peter Chen <peter.chen@freescale.com>
    usb: chipidea: need to mask INT_STATUS when write otgsc

Peter Chen <peter.chen@freescale.com>
    usb: chipidea: imx: set CI_HDRC_IMX28_WRITE_FIX for imx28

Peter Chen <peter.chen@freescale.com>
    usb: chipidea: add freescale imx28 special write register method

Paolo Bonzini <pbonzini@redhat.com>
    x86, kvm: correctly access the KVM_CPUID_FEATURES leaf at 0x40000101

Paolo Bonzini <pbonzini@redhat.com>
    x86, kvm: cache the base of the KVM cpuid leaves

Marcelo Tosatti <mtosatti@redhat.com>
    KVM: x86: limit PIT timer frequency

Prarit Bhargava <prarit@redhat.com>
    x86: Add check for number of available vectors before CPU down

Dave Young <dyoung@redhat.com>
    x86/efi: Fix off-by-one bug in EFI Boot Services reservation

Ben Hutchings <ben@decadent.org.uk>
    xen/pci: Fix build on non-x86

PaX Team <pageexec@freemail.hu>
    x86, x32: Correct invalid use of user timespec in the kernel

David Rientjes <rientjes@google.com>
    mm/mempolicy.c: fix mempolicy printing in numa_maps

Aristeu Rozanski <aris@redhat.com>
    e752x_edac: Fix pci_dev usage count


-------------

Diffstat:

 Documentation/devicetree/bindings/ata/marvell.txt  |   2 +-
 .../devicetree/bindings/i2c/i2c-mv64xxx.txt        |   6 +-
 Documentation/i2c/busses/i2c-piix4                 |   2 +-
 Makefile                                           |   4 +-
 arch/alpha/lib/csum_partial_copy.c                 |   9 +-
 arch/arm/boot/dts/armada-370-xp.dtsi               |   2 +-
 arch/arm/boot/dts/at91sam9g45.dtsi                 |   2 +
 arch/arm/mach-at91/sam9_smc.c                      |   2 +-
 arch/arm/mach-mvebu/Makefile                       |   2 +-
 arch/arm/mach-mvebu/armada-370-xp.c                |  32 ++
 arch/arm/mach-mvebu/mvebu-soc-id.c                 | 119 ++++++++
 arch/arm/mach-mvebu/mvebu-soc-id.h                 |  32 ++
 arch/parisc/include/asm/cacheflush.h               |   2 -
 arch/parisc/include/asm/page.h                     |   3 +-
 arch/parisc/kernel/cache.c                         |  14 +
 arch/powerpc/include/asm/topology.h                |  10 +-
 arch/powerpc/kernel/cacheinfo.c                    |   3 +
 arch/powerpc/kvm/book3s_hv.c                       |   7 +-
 arch/powerpc/kvm/e500_mmu.c                        |   2 +-
 arch/powerpc/mm/numa.c                             |  70 ++++-
 arch/s390/include/asm/compat.h                     |   3 +-
 arch/s390/include/uapi/asm/statfs.h                |  10 +-
 arch/s390/kvm/diag.c                               |   4 +-
 arch/s390/kvm/kvm-s390.c                           |  25 +-
 arch/s390/kvm/kvm-s390.h                           |   4 +-
 arch/s390/kvm/sigp.c                               |  15 +-
 arch/x86/include/asm/irq.h                         |   1 +
 arch/x86/include/asm/kvm_para.h                    |  33 +--
 arch/x86/kernel/irq.c                              |  70 +++++
 arch/x86/kernel/kvm.c                              |  32 ++
 arch/x86/kernel/smpboot.c                          |   6 +
 arch/x86/kvm/i8254.c                               |  18 ++
 arch/x86/kvm/lapic.c                               |   3 -
 arch/x86/kvm/x86.c                                 |   3 +
 arch/x86/kvm/x86.h                                 |   2 +
 arch/x86/platform/efi/efi.c                        |   2 +-
 drivers/ata/libata-core.c                          |  27 ++
 drivers/ata/libata-scsi.c                          |  18 +-
 drivers/ata/sata_mv.c                              |  25 ++
 drivers/char/tpm/tpm_i2c_stm_st33.c                |   7 +-
 drivers/char/tpm/tpm_ppi.c                         |   8 +-
 drivers/edac/e752x_edac.c                          |   4 +-
 drivers/hwmon/k10temp.c                            |   1 +
 drivers/i2c/busses/Kconfig                         |   1 +
 drivers/i2c/busses/i2c-mv64xxx.c                   |   5 +
 drivers/i2c/busses/i2c-piix4.c                     |  28 +-
 drivers/md/bcache/bset.c                           |  26 +-
 drivers/mfd/max77686.c                             |   2 +-
 drivers/misc/mei/hbm.c                             |  19 ++
 drivers/misc/mei/hbm.h                             |   1 +
 drivers/misc/mei/init.c                            |  12 +-
 drivers/misc/mei/interrupt.c                       |  25 +-
 drivers/misc/mic/host/mic_device.h                 |   3 +
 drivers/misc/mic/host/mic_main.c                   |   2 +-
 drivers/misc/mic/host/mic_virtio.c                 |   2 +-
 drivers/misc/mic/host/mic_x100.c                   |  36 ++-
 drivers/mmc/host/sdhci-esdhc-imx.c                 |  12 +-
 drivers/mmc/host/sdhci-pci.c                       |   1 +
 drivers/mmc/host/sdhci.c                           |  23 +-
 drivers/net/vxlan.c                                |  20 +-
 drivers/net/wireless/ath/ath9k/hw.c                |   7 -
 drivers/net/wireless/ath/ath9k/recv.c              |  25 +-
 drivers/net/wireless/b43/b43.h                     |   4 +-
 drivers/net/wireless/b43/main.c                    |  27 +-
 drivers/net/wireless/b43/xmit.c                    |   4 +-
 drivers/net/wireless/b43legacy/main.c              |   1 +
 drivers/net/wireless/iwlwifi/iwl-prph.h            |   4 +
 drivers/net/wireless/iwlwifi/mvm/ops.c             |   1 +
 drivers/net/wireless/iwlwifi/pcie/trans.c          |  22 ++
 drivers/net/wireless/mwifiex/fw.h                  |   2 +-
 drivers/net/wireless/mwifiex/scan.c                |   4 +-
 drivers/net/wireless/rtlwifi/base.c                |   3 +-
 drivers/net/wireless/rtlwifi/core.c                |  11 +
 drivers/net/wireless/rtlwifi/rtl8188ee/dm.c        |   2 +-
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c  | 327 +++++++++++++++------
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.h  |  14 +
 drivers/net/wireless/rtlwifi/rtl8192cu/dm.c        |   9 +
 drivers/net/wireless/rtlwifi/rtl8192cu/dm.h        |   3 +
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c        |  29 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c        |  17 +-
 drivers/net/wireless/rtlwifi/stats.c               |  14 +
 drivers/net/wireless/rtlwifi/usb.c                 |   4 +-
 drivers/net/wireless/rtlwifi/wifi.h                |  33 ++-
 drivers/net/xen-netfront.c                         |  88 ++----
 drivers/parport/parport_pc.c                       |  10 +-
 drivers/pinctrl/pinctrl-sunxi.c                    |  13 +-
 drivers/platform/x86/hp_accel.c                    |   1 +
 drivers/rtc/rtc-cmos.c                             |  52 +++-
 drivers/rtc/rtc-max8907.c                          |  11 +-
 drivers/scsi/bfa/bfad.c                            |   6 +-
 drivers/scsi/qla4xxx/ql4_os.c                      |  11 +-
 drivers/scsi/virtio_scsi.c                         |  15 +-
 drivers/staging/lustre/lustre/ptlrpc/niobuf.c      |   6 +-
 drivers/staging/rtl8712/usb_intf.c                 |   5 +
 drivers/staging/vt6656/baseband.c                  |   3 -
 drivers/staging/vt6656/card.c                      |   2 +-
 drivers/staging/zram/zram_drv.c                    |   4 +-
 drivers/target/iscsi/iscsi_target.c                |  34 ++-
 drivers/target/iscsi/iscsi_target_nego.c           |   2 +-
 drivers/tty/Kconfig                                |   2 +-
 drivers/tty/serial/8250/8250_core.c                |   4 +
 drivers/tty/serial/8250/8250_pci.c                 |   8 +-
 drivers/tty/serial/atmel_serial.c                  |  45 +--
 drivers/uio/uio.c                                  |   2 +-
 drivers/usb/chipidea/ci.h                          |  26 +-
 drivers/usb/chipidea/ci_hdrc_imx.c                 |  32 +-
 drivers/usb/chipidea/core.c                        |   2 +
 drivers/usb/chipidea/host.c                        |   1 +
 drivers/usb/chipidea/otg.h                         |   6 +-
 drivers/usb/chipidea/udc.c                         |  19 +-
 drivers/usb/class/cdc-wdm.c                        |  70 +++--
 drivers/usb/core/config.c                          |   7 -
 drivers/usb/core/hub.c                             |  53 +---
 drivers/usb/dwc3/dwc3-exynos.c                     |   1 +
 drivers/usb/dwc3/dwc3-pci.c                        |   1 +
 drivers/usb/host/ehci.h                            |  18 +-
 drivers/usb/host/xhci-ring.c                       |   2 +-
 drivers/usb/host/xhci.c                            |   7 +-
 drivers/usb/host/xhci.h                            |   2 +-
 drivers/usb/serial/cypress_m8.h                    |   2 +-
 drivers/usb/serial/ftdi_sio.c                      |  17 +-
 drivers/usb/serial/option.c                        |  15 +
 drivers/usb/serial/pl2303.c                        |  34 ++-
 drivers/usb/storage/unusual_devs.h                 |   7 +
 drivers/video/console/sticore.c                    |   2 +-
 drivers/xen/pci.c                                  |   2 +
 fs/btrfs/extent-tree.c                             |   2 +-
 fs/btrfs/inode.c                                   |  18 +-
 fs/btrfs/ioctl.c                                   |   6 +
 fs/dcache.c                                        |   1 -
 fs/ext4/inline.c                                   |   8 +-
 fs/hpfs/alloc.c                                    |  66 ++++-
 fs/hpfs/hpfs_fn.h                                  |   2 +-
 fs/hpfs/super.c                                    |  29 +-
 fs/mount.h                                         |   2 +-
 include/linux/libata.h                             |   2 +
 include/linux/mmc/sdhci.h                          |   2 +
 include/linux/usb/chipidea.h                       |   1 +
 lib/fonts/Kconfig                                  |   6 +-
 mm/mempolicy.c                                     |   2 +-
 net/compat.c                                       |   9 +-
 net/ipv4/fib_frontend.c                            |   2 +
 net/ipv4/ip_gre.c                                  |   2 +-
 net/ipv4/ip_input.c                                |   2 +-
 net/ipv4/ip_tunnel.c                               |   1 +
 net/ipv6/ip6_input.c                               |   2 +-
 security/integrity/ima/ima_template_lib.c          |   2 +-
 sound/core/init.c                                  |   4 +-
 sound/pci/Kconfig                                  |  12 +
 sound/pci/hda/hda_generic.c                        |   6 +-
 sound/pci/hda/patch_analog.c                       |  22 +-
 sound/pci/hda/patch_hdmi.c                         |  40 ++-
 sound/pci/hda/patch_realtek.c                      |  51 +++-
 sound/pci/rme9652/rme9652.c                        |   2 +-
 sound/soc/codecs/adau1701.c                        |   2 +-
 sound/soc/codecs/tlv320aic32x4.c                   |   4 +-
 sound/soc/codecs/wm5110.c                          |  48 +++
 tools/perf/util/session.c                          |   7 +-
 158 files changed, 1819 insertions(+), 627 deletions(-)


