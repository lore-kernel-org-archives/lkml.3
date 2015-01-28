Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760109AbbA1B2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:28:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41037 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759724AbbA1B2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:28:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.18 00/61] 3.18.5-stable review
Date: Tue, 27 Jan 2015 17:26:12 -0800
Message-Id: <20150128012636.936333725@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
User-Agent: quilt/0.63-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.18.5 release.
There are 61 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Jan 30 01:26:13 UTC 2015.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.18.5-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.18.5-rc1

Mathias Krause <minipli@googlemail.com>
    crypto: add missing crypto module aliases

Kees Cook <keescook@chromium.org>
    crypto: include crypto- module prefix in template

Kees Cook <keescook@chromium.org>
    crypto: prefix module autoloading with "crypto-"

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI / PM: Do not disable wakeup GPEs that have not been enabled

David Spinadel <david.spinadel@intel.com>
    iwlwifi: mvm: add a flag to enable match found notification

David Vrabel <david.vrabel@citrix.com>
    Revert "swiotlb-xen: pass dev_addr to swiotlb_tbl_unmap_single"

Dan Carpenter <dan.carpenter@oracle.com>
    ipvs: uninitialized data with IP_VS_IPV6

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: conntrack: fix race between confirmation and flush

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nfnetlink: relax strict multicast group check from netlink_bind

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: fix flush ruleset chain dependencies

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nfnetlink: validate nfnetlink header from batch

Michal Hocko <mhocko@suse.cz>
    mm: get rid of radix tree gfp mask for pagecache_get_page

Sasha Levin <sasha.levin@oracle.com>
    KEYS: close race between key lookup and freeing

Suman Tripathi <stripathi@apm.com>
    ahci_xgene: Fix the endianess issue in APM X-Gene SoC AHCI SATA controller driver.

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    sata_dwc_460ex: fix resource leak on error path

Bryan O'Donoghue <pure.logic@nexus-software.ie>
    x86/apic: Re-enable PCI_MSI support for non-SMP X86_32

Andy Lutomirski <luto@amacapital.net>
    x86, tls: Interpret an all-zero struct user_desc as "no segment"

Andy Lutomirski <luto@amacapital.net>
    x86, tls, ldt: Stop checking lm in LDT_empty

Nadav Amit <nadav.amit@gmail.com>
    KVM: x86: Fix of previously incomplete fix for CVE-2014-8480

Nadav Amit <namit@cs.technion.ac.il>
    KVM: x86: SYSENTER emulation is broken

Kees Cook <keescook@chromium.org>
    x86, boot: Skip relocs when load address unchanged

Alexandre Demers <alexandre.f.demers@gmail.com>
    x86/tsc: Change Fast TSC calibration failed from error to info

K. Y. Srinivasan <kys@microsoft.com>
    x86, hyperv: Mark the Hyper-V clocksource as being continuous

Tobias Jakobi <tjakobi@math.uni-bielefeld.de>
    clocksource: exynos_mct: Fix bitmask regression for exynos4_mct_write

Jan Beulich <JBeulich@suse.com>
    x86, irq: Properly tag virtualization entry in /proc/interrupts

Gavin Li <git@thegavinli.com>
    irqchip: atmel-aic-common: Prevent clobbering of priority when changing IRQ type

Al Viro <viro@zeniv.linux.org.uk>
    fix deadlock in cifs_ioctl_clone()

Andrew Lunn <andrew@lunn.ch>
    bus: mvebu-mbus: fix support of MBus window 13

Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    ARM: mvebu: completely disable hardware I/O coherency

Fabio Estevam <fabio.estevam@freescale.com>
    ARM: dts: imx25: Fix PWM "per" clocks

Sasha Levin <sasha.levin@oracle.com>
    time: adjtimex: Validate the ADJ_FREQUENCY values

Sasha Levin <sasha.levin@oracle.com>
    time: settimeofday: Validate the values of tv from user

Felipe Balbi <balbi@ti.com>
    irqchip: omap-intc: Fix legacy DMA regression

Joe Thornber <ejt@redhat.com>
    dm cache: fix problematic dual use of a single migration count variable

Joe Thornber <ejt@redhat.com>
    dm cache: share cache-metadata object across inactive and active DM tables

Hans Verkuil <hans.verkuil@cisco.com>
    vb2: fix vb2_thread_stop race conditions

Matthias Schwarzott <zzam@gentoo.org>
    cx23885: Split Hauppauge WinTV Starburst from HVR4400 card entry

Brian King <brking@linux.vnet.ibm.com>
    ipr: wait for aborted command responses

Alex Williamson <alex.williamson@redhat.com>
    PCI: Mark Atheros AR93xx to avoid bus reset

Alex Williamson <alex.williamson@redhat.com>
    PCI: Add flag for devices where we can't use bus reset

Yinghai Lu <yinghai@kernel.org>
    x86/PCI: Clip bridge windows to fit in upstream windows

Yinghai Lu <yinghai@kernel.org>
    PCI: Add pci_bus_clip_resource() to clip to fit upstream window

Yinghai Lu <yinghai@kernel.org>
    PCI: Add pci_claim_bridge_resource() to clip window if necessary

Yinghai Lu <yinghai@kernel.org>
    PCI: Pass bridge device, not bus, when updating bridge windows

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: use rv515_ring_start on r5xx

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: add si dpm quirk list

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: add a dpm quirk list

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Fix mutex->owner inspection race under DEBUG_MUTEXES

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Ban Haswell from using RCS flips

Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
    scripts/recordmcount.pl: There is no -m32 gcc option on Super-H anymore

Tejun Heo <tj@kernel.org>
    workqueue: fix subtle pool management issue which can stall whole worker_pool

Jason Lee Cragg <jcragg@gmail.com>
    ALSA: usb-audio: Add mic volume fix quirk for Logitech Webcam C210

David Jeffery <djeffery@redhat.com>
    libata: prevent HSM state change race between ISR and PIO

Dan Williams <dan.j.williams@intel.com>
    libata: allow sata_sil24 to opt-out of tag ordered submission

Roger Tseng <rogerable@realtek.com>
    mfd: rtsx_usb: Fix runtime PM deadlock

Felipe Balbi <balbi@ti.com>
    mfd: tps65218: Make INT1 our status_base register

Felipe Balbi <balbi@ti.com>
    mfd: tps65218: Make INT[12] and STATUS registers volatile

Jim Lin <jilin@nvidia.com>
    pinctrl: Fix two deadlocks

Stephen Boyd <sboyd@codeaurora.org>
    pinctrl: qcom: Don't iterate past end of function array

Oliver Hartkopp <socketcan@hartkopp.net>
    can: m_can: tag current CAN FD controllers as non-ISO

Oliver Hartkopp <socketcan@hartkopp.net>
    can: dev: fix crtlmode_supported check


-------------

Diffstat:

 Makefile                                       |   4 +-
 arch/arm/boot/dts/imx25.dtsi                   |   8 +-
 arch/arm/crypto/aes_glue.c                     |   4 +-
 arch/arm/crypto/sha1_glue.c                    |   2 +-
 arch/arm/crypto/sha1_neon_glue.c               |   2 +-
 arch/arm/crypto/sha512_neon_glue.c             |   4 +-
 arch/arm/mach-mvebu/coherency.c                |   7 +-
 arch/arm64/crypto/aes-ce-ccm-glue.c            |   2 +-
 arch/arm64/crypto/aes-glue.c                   |   8 +-
 arch/powerpc/crypto/sha1.c                     |   3 +-
 arch/s390/crypto/aes_s390.c                    |   2 +-
 arch/s390/crypto/des_s390.c                    |   4 +-
 arch/s390/crypto/ghash_s390.c                  |   2 +-
 arch/s390/crypto/sha1_s390.c                   |   2 +-
 arch/s390/crypto/sha256_s390.c                 |   4 +-
 arch/s390/crypto/sha512_s390.c                 |   4 +-
 arch/sparc/crypto/aes_glue.c                   |   2 +-
 arch/sparc/crypto/camellia_glue.c              |   2 +-
 arch/sparc/crypto/crc32c_glue.c                |   2 +-
 arch/sparc/crypto/des_glue.c                   |   2 +-
 arch/sparc/crypto/md5_glue.c                   |   2 +-
 arch/sparc/crypto/sha1_glue.c                  |   2 +-
 arch/sparc/crypto/sha256_glue.c                |   4 +-
 arch/sparc/crypto/sha512_glue.c                |   4 +-
 arch/x86/Kconfig                               |   6 +-
 arch/x86/boot/compressed/misc.c                |   9 ++-
 arch/x86/crypto/aes_glue.c                     |   4 +-
 arch/x86/crypto/aesni-intel_glue.c             |   2 +-
 arch/x86/crypto/blowfish_glue.c                |   4 +-
 arch/x86/crypto/camellia_aesni_avx2_glue.c     |   4 +-
 arch/x86/crypto/camellia_aesni_avx_glue.c      |   4 +-
 arch/x86/crypto/camellia_glue.c                |   4 +-
 arch/x86/crypto/cast5_avx_glue.c               |   2 +-
 arch/x86/crypto/cast6_avx_glue.c               |   2 +-
 arch/x86/crypto/crc32-pclmul_glue.c            |   4 +-
 arch/x86/crypto/crc32c-intel_glue.c            |   4 +-
 arch/x86/crypto/crct10dif-pclmul_glue.c        |   4 +-
 arch/x86/crypto/des3_ede_glue.c                |   8 +-
 arch/x86/crypto/fpu.c                          |   3 +
 arch/x86/crypto/ghash-clmulni-intel_glue.c     |   2 +-
 arch/x86/crypto/salsa20_glue.c                 |   4 +-
 arch/x86/crypto/serpent_avx2_glue.c            |   4 +-
 arch/x86/crypto/serpent_avx_glue.c             |   2 +-
 arch/x86/crypto/serpent_sse2_glue.c            |   2 +-
 arch/x86/crypto/sha-mb/sha1_mb.c               |   2 +-
 arch/x86/crypto/sha1_ssse3_glue.c              |   2 +-
 arch/x86/crypto/sha256_ssse3_glue.c            |   4 +-
 arch/x86/crypto/sha512_ssse3_glue.c            |   4 +-
 arch/x86/crypto/twofish_avx_glue.c             |   2 +-
 arch/x86/crypto/twofish_glue.c                 |   4 +-
 arch/x86/crypto/twofish_glue_3way.c            |   4 +-
 arch/x86/include/asm/desc.h                    |  20 +++--
 arch/x86/kernel/cpu/mshyperv.c                 |   1 +
 arch/x86/kernel/irq.c                          |   2 +-
 arch/x86/kernel/tls.c                          |  25 +++++-
 arch/x86/kernel/tsc.c                          |   2 +-
 arch/x86/kvm/emulate.c                         |  31 +++-----
 arch/x86/pci/i386.c                            |   2 +-
 crypto/842.c                                   |   1 +
 crypto/aes_generic.c                           |   3 +-
 crypto/algapi.c                                |   4 +-
 crypto/ansi_cprng.c                            |   3 +-
 crypto/anubis.c                                |   1 +
 crypto/api.c                                   |   4 +-
 crypto/arc4.c                                  |   1 +
 crypto/authenc.c                               |   1 +
 crypto/authencesn.c                            |   1 +
 crypto/blowfish_generic.c                      |   3 +-
 crypto/camellia_generic.c                      |   3 +-
 crypto/cast5_generic.c                         |   3 +-
 crypto/cast6_generic.c                         |   3 +-
 crypto/cbc.c                                   |   1 +
 crypto/ccm.c                                   |   5 +-
 crypto/chainiv.c                               |   1 +
 crypto/cmac.c                                  |   1 +
 crypto/crc32.c                                 |   1 +
 crypto/crc32c_generic.c                        |   3 +-
 crypto/crct10dif_generic.c                     |   3 +-
 crypto/cryptd.c                                |   1 +
 crypto/crypto_null.c                           |   6 +-
 crypto/ctr.c                                   |   3 +-
 crypto/cts.c                                   |   1 +
 crypto/deflate.c                               |   2 +-
 crypto/des_generic.c                           |   7 +-
 crypto/ecb.c                                   |   1 +
 crypto/eseqiv.c                                |   1 +
 crypto/fcrypt.c                                |   1 +
 crypto/gcm.c                                   |   7 +-
 crypto/ghash-generic.c                         |   3 +-
 crypto/hmac.c                                  |   1 +
 crypto/khazad.c                                |   1 +
 crypto/krng.c                                  |   3 +-
 crypto/lrw.c                                   |   1 +
 crypto/lz4.c                                   |   1 +
 crypto/lz4hc.c                                 |   1 +
 crypto/lzo.c                                   |   1 +
 crypto/mcryptd.c                               |   1 +
 crypto/md4.c                                   |   2 +-
 crypto/md5.c                                   |   1 +
 crypto/michael_mic.c                           |   1 +
 crypto/pcbc.c                                  |   1 +
 crypto/pcrypt.c                                |   1 +
 crypto/rmd128.c                                |   1 +
 crypto/rmd160.c                                |   1 +
 crypto/rmd256.c                                |   1 +
 crypto/rmd320.c                                |   1 +
 crypto/salsa20_generic.c                       |   3 +-
 crypto/seed.c                                  |   1 +
 crypto/seqiv.c                                 |   1 +
 crypto/serpent_generic.c                       |   5 +-
 crypto/sha1_generic.c                          |   3 +-
 crypto/sha256_generic.c                        |   6 +-
 crypto/sha512_generic.c                        |   6 +-
 crypto/tea.c                                   |   5 +-
 crypto/tgr192.c                                |   5 +-
 crypto/twofish_generic.c                       |   3 +-
 crypto/vmac.c                                  |   1 +
 crypto/wp512.c                                 |   5 +-
 crypto/xcbc.c                                  |   1 +
 crypto/xts.c                                   |   1 +
 crypto/zlib.c                                  |   1 +
 drivers/acpi/device_pm.c                       |  12 ++-
 drivers/ata/ahci_xgene.c                       |   2 +-
 drivers/ata/libata-core.c                      |   5 +-
 drivers/ata/libata-sff.c                       |  12 +++
 drivers/ata/sata_dwc_460ex.c                   |  26 +++----
 drivers/ata/sata_sil24.c                       |   2 +-
 drivers/bus/mvebu-mbus.c                       |  13 ++++
 drivers/clocksource/exynos_mct.c               |   4 +-
 drivers/crypto/padlock-aes.c                   |   2 +-
 drivers/crypto/padlock-sha.c                   |   8 +-
 drivers/crypto/qat/qat_common/adf_ctl_drv.c    |   3 +-
 drivers/crypto/ux500/cryp/cryp_core.c          |   4 +-
 drivers/crypto/ux500/hash/hash_core.c          |   8 +-
 drivers/gpu/drm/i915/i915_gem.c                |   2 +-
 drivers/gpu/drm/i915/intel_display.c           |   2 +-
 drivers/gpu/drm/radeon/radeon_asic.c           |  18 ++++-
 drivers/gpu/drm/radeon/radeon_pm.c             |  33 ++++++++
 drivers/gpu/drm/radeon/si_dpm.c                |  39 ++++++++++
 drivers/irqchip/irq-atmel-aic-common.c         |   4 +-
 drivers/irqchip/irq-omap-intc.c                |  26 +++++--
 drivers/md/dm-cache-metadata.c                 | 101 +++++++++++++++++++++++--
 drivers/md/dm-cache-target.c                   |  89 ++++++++++++----------
 drivers/media/pci/cx23885/cx23885-cards.c      |  23 ++++--
 drivers/media/pci/cx23885/cx23885-dvb.c        |  11 +++
 drivers/media/pci/cx23885/cx23885.h            |   1 +
 drivers/media/v4l2-core/videobuf2-core.c       |  19 +++--
 drivers/mfd/rtsx_usb.c                         |  12 ---
 drivers/mfd/tps65218.c                         |  12 +++
 drivers/net/can/dev.c                          |   8 +-
 drivers/net/can/m_can/m_can.c                  |   5 ++
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h |   2 +
 drivers/net/wireless/iwlwifi/mvm/scan.c        |   1 +
 drivers/pci/bus.c                              |  43 +++++++++++
 drivers/pci/pci.c                              |  40 +++++++++-
 drivers/pci/pci.h                              |   1 +
 drivers/pci/quirks.c                           |  14 ++++
 drivers/pci/setup-bus.c                        |  56 +++++++++++---
 drivers/pinctrl/core.c                         |   5 +-
 drivers/pinctrl/qcom/pinctrl-msm.c             |   4 +-
 drivers/s390/crypto/ap_bus.c                   |   3 +-
 drivers/scsi/ipr.c                             |  92 ++++++++++++++++++++++
 drivers/scsi/ipr.h                             |   1 +
 drivers/xen/swiotlb-xen.c                      |   2 +-
 fs/cifs/ioctl.c                                |  21 ++---
 include/acpi/acpi_bus.h                        |   1 +
 include/linux/crypto.h                         |  13 ++++
 include/linux/libata.h                         |   1 +
 include/linux/pagemap.h                        |  13 ++--
 include/linux/pci.h                            |   3 +
 include/linux/time.h                           |  13 ++++
 include/uapi/linux/can/netlink.h               |   1 +
 kernel/time/ntp.c                              |   7 ++
 kernel/time/time.c                             |   4 +
 kernel/workqueue.c                             |  25 ++----
 mm/filemap.c                                   |  29 +++----
 net/netfilter/ipvs/ip_vs_ftp.c                 |  10 +--
 net/netfilter/nf_conntrack_core.c              |  20 +++--
 net/netfilter/nf_tables_api.c                  |  14 ++--
 net/netfilter/nfnetlink.c                      |   5 +-
 scripts/recordmcount.pl                        |   1 -
 security/keys/gc.c                             |   4 +-
 sound/usb/mixer.c                              |   1 +
 183 files changed, 987 insertions(+), 380 deletions(-)


