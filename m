Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbaJ1DgE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:36:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44251 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbaJ1DgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:36:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.17 000/146] 3.17.2-stable review
Date: Tue, 28 Oct 2014 11:32:22 +0800
Message-Id: <20141028033343.441992423@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.17.2 release.
There are 146 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Oct 30 03:32:38 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.17.2-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.17.2-rc1

David S. Miller <davem@davemloft.net>
    sparc64: Implement __get_user_pages_fast().

David S. Miller <davem@davemloft.net>
    sparc64: Fix register corruption in top-most kernel stack frame during boot.

Dave Kleikamp <dave.kleikamp@oracle.com>
    sparc64: Increase size of boot string to 1024 bytes

David S. Miller <davem@davemloft.net>
    sparc64: Kill unnecessary tables and increase MAX_BANKS.

bob picco <bpicco@meloft.net>
    sparc64: sparse irq

David S. Miller <davem@davemloft.net>
    sparc64: Adjust vmalloc region size based upon available virtual address bits.

David S. Miller <davem@davemloft.net>
    sparc64: Increase MAX_PHYS_ADDRESS_BITS to 53.

David S. Miller <davem@davemloft.net>
    sparc64: Use kernel page tables for vmemmap.

David S. Miller <davem@davemloft.net>
    sparc64: Fix physical memory management regressions with large max_phys_bits.

David S. Miller <davem@davemloft.net>
    sparc64: Adjust KTSB assembler to support larger physical addresses.

David S. Miller <davem@davemloft.net>
    sparc64: Define VA hole at run time, rather than at compile time.

David S. Miller <davem@davemloft.net>
    sparc64: Switch to 4-level page tables.

bob picco <bpicco@meloft.net>
    sparc64: T5 PMU

Allen Pais <allen.pais@oracle.com>
    sparc64: cpu hardware caps support for sparc M6 and M7

Allen Pais <allen.pais@oracle.com>
    sparc64: support M6 and M7 for building CPU distribution map

Allen Pais <allen.pais@oracle.com>
    sparc64: correctly recognise M6 and M7 cpu type

David S. Miller <davem@davemloft.net>
    sparc64: Fix hibernation code refrence to PAGE_OFFSET.

David S. Miller <davem@davemloft.net>
    sparc64: Do not define thread fpregs save area as zero-length array.

David S. Miller <davem@davemloft.net>
    sparc64: Fix FPU register corruption with AES crypto offload.

David S. Miller <davem@davemloft.net>
    sparc64: Fix lockdep warnings on reboot on Ultra-5

David S. Miller <davem@davemloft.net>
    sparc64: Fix reversed start/end in flush_tlb_kernel_range()

Andreas Larsson <andreas@gaisler.com>
    sparc: Let memset return the address argument

Sowmini Varadhan <sowmini.varadhan@oracle.com>
    sparc64: Move request_irq() from ldc_bind() to ldc_alloc()

bob picco <bpicco@meloft.net>
    sparc64: find_node adjustment

David S. Miller <davem@davemloft.net>
    sparc64: Fix corrupted thread fault code.

bob picco <bpicco@meloft.net>
    sparc64: sun4v TLB error power off events

Daniel Hellstrom <daniel@gaisler.com>
    sparc32: dma_alloc_coherent must honour gfp flags

Dmitry Kasatkin <d.kasatkin@samsung.com>
    ima: pass 'opened' flag to identify newly created files

Dmitry Kasatkin <d.kasatkin@samsung.com>
    ima: provide flag to identify new empty files

Dmitry Kasatkin <d.kasatkin@samsung.com>
    ima: fix fallback to use new_sync_read()

Gavin Shan <gwshan@linux.vnet.ibm.com>
    powerpc/eeh: Clear frozen device state in time

Alexey Kardashevskiy <aik@ozlabs.ru>
    powerpc/iommu/ddw: Fix endianness

Li Zhong <zhong@linux.vnet.ibm.com>
    powerpc: Only set numa node information for present cpus at boottime

Li Zhong <zhong@linux.vnet.ibm.com>
    powerpc: Fix warning reported by verify_cpu_node_mapping()

Catalin Marinas <catalin.marinas@arm.com>
    futex: Ensure get_futex_key_refs() always implies a barrier

Konstantin Khlebnikov <k.khlebnikov@samsung.com>
    mm/balloon_compaction: redesign ballooned pages management

Daniel Glöckner <daniel-gl@gmx.net>
    rtc-cmos: fix wakeup from S5 without CONFIG_PM_SLEEP

Sasha Levin <sasha.levin@oracle.com>
    kernel: add support for gcc 5

Weijie Yang <weijie.yang@samsung.com>
    mm/cma: fix cma bitmap aligned mask computing

Yann Droneaud <ydroneaud@opteya.com>
    fanotify: enable close-on-exec on events' fd when requested in fanotify_init()

Junxiao Bi <junxiao.bi@oracle.com>
    mm: clear __GFP_FS when PF_MEMALLOC_NOIO is set

Jukka Rissanen <jukka.rissanen@linux.intel.com>
    Bluetooth: 6lowpan: Route packets that are not meant to peer via correct device

Jukka Rissanen <jukka.rissanen@linux.intel.com>
    Bluetooth: 6lowpan: Set the peer IPv6 address correctly

Jukka Rissanen <jukka.rissanen@linux.intel.com>
    Bluetooth: 6lowpan: Increase the connection timeout value

Johan Hedberg <johan.hedberg@intel.com>
    Bluetooth: Fix setting correct security level when initiating SMP

Champion Chen <champion_chen@realsil.com.cn>
    Bluetooth: Fix issue with USB suspend in btusb driver

Johan Hedberg <johan.hedberg@intel.com>
    Bluetooth: Fix incorrect LE CoC PDU length restriction based on HCI MTU

Loic Poulain <loic.poulain@intel.com>
    Bluetooth: Fix HCI H5 corrupted ack value

Felix Fietkau <nbd@openwrt.org>
    Revert "ath9k_hw: reduce ANI firstep range for older chips"

Stanislaw Gruszka <sgruszka@redhat.com>
    rt2800: correct BBP1_TX_POWER_CTRL mask

Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
    PCI: Generate uppercase hex for modalias interface class

Douglas Lehr <dllehr@us.ibm.com>
    PCI: Increase IBM ipr SAS Crocodile BARs to at least system page size

Yinghai Lu <yinghai@kernel.org>
    PCI: Add missing MEM_64 mask in pci_assign_unassigned_bridge_resources()

Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    PCI: mvebu: Fix uninitialized variable in mvebu_get_tgt_attr()

Eric Sandeen <sandeen@sandeen.net>
    xfs: fix agno increment in xfs_inumbers() loop

Dave Chinner <dchinner@redhat.com>
    xfs: ensure WB_SYNC_ALL writeback handles partial pages correctly

Alex Williamson <alex.williamson@redhat.com>
    vfio-pci: Fix remove path locking

Jan Kara <jack@suse.cz>
    udf: Fix loading of special inodes

Chao Yu <chao2.yu@samsung.com>
    ecryptfs: avoid to access NULL pointer when write metadata in xattr

Fabio Estevam <fabio.estevam@freescale.com>
    ARM: dts: imx28-evk: Let i2c0 run at 100kHz

klightspeed@killerwolves.net <klightspeed@killerwolves.net>
    ARM: mvebu: Netgear RN102: Use Hardware BCH ECC

Arnaud Ebalard <arno@natisbad.org>
    ARM: mvebu: Netgear RN2120: Use Hardware BCH ECC

Arnaud Ebalard <arno@natisbad.org>
    ARM: mvebu: Netgear RN104: Use Hardware BCH ECC

Andrew Lunn <andrew@lunn.ch>
    ARM: Kirkwood: Fix DT based DSA.

Ludovic Desroches <ludovic.desroches@atmel.com>
    ARM: at91/PMC: don't forget to write PMC_PCDR register to disable clocks

Andreas Henriksson <andreas.henriksson@endian.se>
    ARM: at91: fix at91sam9263ek DT mmc pinmuxing settings

David Dueck <davidcdueck@googlemail.com>
    ARM: at91/dt: Fix typo regarding can0_clk

Andy Gross <agross@codeaurora.org>
    clk: qcom: Add IPQ8064 PLL required for USB

David Henningsson <david.henningsson@canonical.com>
    ALSA: hda - Add missing terminating entry to SND_HDA_PIN_QUIRK macro

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix inverted LED gpio setup for Lenovo Ideapad

Anssi Hannula <anssi.hannula@iki.fi>
    ALSA: hda - hdmi: Fix missing ELD change event on plug/unplug

Vlad Catoi <vladcatoi@gmail.com>
    ALSA: usb-audio: Add support for Steinberg UR22 USB interface

Harsha Priya <harshapriya.n@intel.com>
    ALSA: ALC283 codec - Avoid pop noise on headphones during suspend/resume

Takashi Iwai <tiwai@suse.de>
    ALSA: emu10k1: Fix deadlock in synth voice lookup

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: bebob: Fix failure to detect source of clock for Terratec Phase 88

Anatol Pomozov <anatol.pomozov@gmail.com>
    ALSA: pcm: use the same dma mmap codepath both for arm and arm64

Victor Kamensky <victor.kamensky@linaro.org>
    arm64: compat: fix compat types affecting struct compat_elf_prpsinfo

Catalin Marinas <catalin.marinas@arm.com>
    arm64: Fix compilation error on UP builds

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    spi: dw-mid: terminate ongoing transfers at exit

Oren Givon <oren.givon@intel.com>
    iwlwifi: Add missing PCI IDs for the 7260 series

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: mvm: disable BT Co-running by default

Trond Myklebust <trond.myklebust@primarydata.com>
    NFSv4.1/pnfs: replace broken pnfs_put_lseg_async

Trond Myklebust <trond.myklebust@primarydata.com>
    NFS: Fix a bogus warning in nfs_generic_pgio

Trond Myklebust <trond.myklebust@primarydata.com>
    NFS: Fix an uninitialised pointer Oops in the writeback error path

J. Bruce Fields <bfields@redhat.com>
    nfsd4: reserve adequate space for LOCK op

Andy Adamson <andros@netapp.com>
    NFSv4.1: Fix an NFSv4.1 state renewal regression

Trond Myklebust <trond.myklebust@primarydata.com>
    NFSv4: fix open/lock state recovery error handling

Trond Myklebust <trond.myklebust@primarydata.com>
    NFSv4: Fix lock recovery when CREATE_SESSION/SETCLIENTID_CONFIRM fails

Fabian Frederick <fabf@skynet.be>
    nfs: fix duplicate proc entries

Frans Klaver <frans.klaver@xsens.com>
    tty: omap-serial: fix division by zero

Willy Tarreau <w@1wt.eu>
    lzo: check for length overrun in variable length encoding.

Willy Tarreau <w@1wt.eu>
    Revert "lzo: properly check for overruns"

Willy Tarreau <w@1wt.eu>
    Documentation: lzo: document part of the encoding

Olga Kornievskaia <kolga@netapp.com>
    Fixing lease renewal

Geert Uytterhoeven <geert@linux-m68k.org>
    m68k: Disable/restore interrupts in hwreg_present()/hwreg_write()

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: bus: fix possible boundaries violation

K. Y. Srinivasan <kys@microsoft.com>
    Drivers: hv: vmbus: Cleanup hv_post_message()

K. Y. Srinivasan <kys@microsoft.com>
    Drivers: hv: vmbus: Fix a bug in vmbus_open()

K. Y. Srinivasan <kys@microsoft.com>
    Drivers: hv: vmbus: Cleanup vmbus_establish_gpadl()

K. Y. Srinivasan <kys@microsoft.com>
    Drivers: hv: vmbus: Cleanup vmbus_close_internal()

K. Y. Srinivasan <kys@microsoft.com>
    Drivers: hv: vmbus: Cleanup vmbus_teardown_gpadl()

K. Y. Srinivasan <kys@microsoft.com>
    Drivers: hv: vmbus: Cleanup vmbus_post_msg()

K. Y. Srinivasan <kys@microsoft.com>
    Drivers: hv: util: Properly pack the data for file copy functionality

Will Deacon <will.deacon@arm.com>
    arm64: debug: don't re-enable debug exceptions on return from el1_dbg

Kees Cook <keescook@chromium.org>
    firmware_class: make sure fw requests contain a name

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    dmaengine: pl330: Fix NULL pointer dereference on driver unbind

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    dmaengine: pl330: Fix NULL pointer dereference on probe failure

Xuelin Shi <xuelin.shi@freescale.com>
    dmaengine: fix xor sources continuation

Joe Lawrence <joe.lawrence@stratus.com>
    qla2xxx: Fix shost use-after-free on device removal

Arun Easi <arun.easi@qlogic.com>
    qla2xxx: Use correct offset to req-q-out for reserve calculation

Himanshu Madhani <himanshu.madhani@qlogic.com>
    qla2xxx: fix kernel NULL pointer access

Steffen Trumtrar <s.trumtrar@pengutronix.de>
    regulator: ltc3589: fix broken voltage transitions

Chris J Arges <chris.j.arges@canonical.com>
    mptfusion: enable no_write_same for vmware scsi disks

Mike Christie <michaelc@cs.wisc.edu>
    be2iscsi: check ip buffer before copying

Xiubo Li <Li.Xiubo@freescale.com>
    regmap: fix possible ZERO_SIZE_PTR pointer dereferencing error.

Pankaj Dubey <pankaj.dubey@samsung.com>
    regmap: fix NULL pointer dereference in _regmap_write/read

Xiubo Li <Li.Xiubo@freescale.com>
    regmap: debugfs: fix possbile NULL pointer dereference

Borislav Petkov <bp@suse.de>
    mpc85xx_edac: Make L2 interrupt shared too

Benjamin Tissoires <benjamin.tissoires@redhat.com>
    HID: rmi: check sanity of the incoming report

Benjamin Tissoires <benjamin.tissoires@redhat.com>
    HID: wacom: fix timeout on probe for some wacoms

Ping Cheng <pinglinux@gmail.com>
    HID: wacom - remove report_id from wacom_get_report interface

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    spi: dw-mid: check that DMA was inited before exit

Addy Ke <addy.ke@rock-chips.com>
    spi/rockchip: fix bug that cause the failure to read data in DMA mode

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    spi: dw-mid: respect 8 bit mode

Bryan O'Donoghue <pure.logic@nexus-software.ie>
    x86/intel/quark: Switch off CR4.PGE so TLB flush uses CR3 instead

Andy Lutomirski <luto@amacapital.net>
    x86,kvm,vmx: Preserve CR4 across VM entry

David Matlack <dmatlack@google.com>
    kvm: don't take vcpu mutex for obviously invalid vcpu ioctls

Christian Borntraeger <borntraeger@de.ibm.com>
    KVM: s390: unintended fallthrough for external call

Paolo Bonzini <pbonzini@redhat.com>
    KVM: do not bias the generation number in kvm_current_mmio_generation

David Matlack <dmatlack@google.com>
    kvm: fix potentially corrupt mmio cache

David Matlack <dmatlack@google.com>
    kvm: x86: fix stale mmio cache bug

Josef Ahmad <josef.ahmad@intel.com>
    pci_ids: Add support for Intel Quark ILB

Andy Lutomirski <luto@amacapital.net>
    fs: Add a missing permission check to do_umount

Chris Mason <clm@fb.com>
    Revert "Btrfs: race free update of commit root for ro snapshots"

Sage Weil <sage@redhat.com>
    Btrfs: fix race in WAIT_SYNC ioctl

Qu Wenruo <quwenruo@cn.fujitsu.com>
    btrfs: Fix the wrong condition judgment about subset extent map

Josef Bacik <jbacik@fb.com>
    Btrfs: fix build_backref_tree issue with multiple shared blocks

Josef Bacik <jbacik@fb.com>
    Btrfs: cleanup error handling in build_backref_tree

Josef Bacik <jbacik@fb.com>
    Btrfs: try not to ENOSPC on log replay

Josef Bacik <jbacik@fb.com>
    Btrfs: don't do async reclaim during log replay

Qu Wenruo <quwenruo@cn.fujitsu.com>
    btrfs: Fix and enhance merge_extent_mapping() to insert best fitted extent map

Liu Bo <bo.li.liu@oracle.com>
    Btrfs: fix up bounds checking in lseek

Filipe Manana <fdmanana@suse.com>
    Btrfs: add missing compression property remove in btrfs_ioctl_setflags

Qu Wenruo <quwenruo@cn.fujitsu.com>
    btrfs: Fix a deadlock in btrfs_dev_replace_finishing()

Mark Fasheh <mfasheh@suse.de>
    btrfs: don't go readonly on existing qgroup items

David Sterba <dsterba@suse.cz>
    btrfs: wake up transaction thread from SYNC_FS ioctl


-------------

Diffstat:

 Documentation/lzo.txt                          | 164 ++++++++
 Documentation/virtual/kvm/mmu.txt              |  14 +
 Makefile                                       |   4 +-
 arch/arm/boot/dts/Makefile                     |   4 +-
 arch/arm/boot/dts/armada-370-netgear-rn102.dts |   4 +
 arch/arm/boot/dts/armada-370-netgear-rn104.dts |   4 +
 arch/arm/boot/dts/armada-xp-netgear-rn2120.dts |   4 +
 arch/arm/boot/dts/at91sam9263.dtsi             |   2 +
 arch/arm/boot/dts/imx28-evk.dts                |   1 -
 arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts |  16 +-
 arch/arm/boot/dts/kirkwood-rd88f6281-a.dts     |  43 ++
 arch/arm/boot/dts/kirkwood-rd88f6281-a0.dts    |  26 --
 arch/arm/boot/dts/kirkwood-rd88f6281-a1.dts    |  31 --
 arch/arm/boot/dts/kirkwood-rd88f6281-z0.dts    |  35 ++
 arch/arm/boot/dts/kirkwood-rd88f6281.dtsi      |  27 +-
 arch/arm/boot/dts/kirkwood.dtsi                |   4 +-
 arch/arm/boot/dts/sama5d3_can.dtsi             |   2 +-
 arch/arm/mach-at91/clock.c                     |   1 +
 arch/arm64/include/asm/compat.h                |   4 +-
 arch/arm64/include/asm/irq_work.h              |  11 +
 arch/arm64/kernel/entry.S                      |   1 -
 arch/m68k/mm/hwtest.c                          |   6 +
 arch/powerpc/kernel/eeh_pe.c                   |  21 +-
 arch/powerpc/kernel/smp.c                      |  10 +-
 arch/powerpc/mm/numa.c                         |   5 +-
 arch/powerpc/platforms/pseries/iommu.c         |  51 ++-
 arch/s390/kvm/interrupt.c                      |   1 +
 arch/sparc/Kconfig                             |   1 +
 arch/sparc/include/asm/hypervisor.h            |  11 +
 arch/sparc/include/asm/irq_64.h                |   7 +-
 arch/sparc/include/asm/ldc.h                   |   5 +-
 arch/sparc/include/asm/oplib_64.h              |   3 +-
 arch/sparc/include/asm/page_64.h               |  33 +-
 arch/sparc/include/asm/pgalloc_64.h            |  28 +-
 arch/sparc/include/asm/pgtable_64.h            | 100 +++--
 arch/sparc/include/asm/setup.h                 |   2 +
 arch/sparc/include/asm/spitfire.h              |   2 +
 arch/sparc/include/asm/thread_info_64.h        |   4 +-
 arch/sparc/include/asm/tsb.h                   |  87 ++--
 arch/sparc/include/asm/visasm.h                |   8 +
 arch/sparc/kernel/cpu.c                        |  12 +
 arch/sparc/kernel/cpumap.c                     |   2 +
 arch/sparc/kernel/ds.c                         |   4 +-
 arch/sparc/kernel/dtlb_prot.S                  |   6 +-
 arch/sparc/kernel/entry.h                      |   3 -
 arch/sparc/kernel/head_64.S                    |  52 +--
 arch/sparc/kernel/hvapi.c                      |   1 +
 arch/sparc/kernel/hvcalls.S                    |  16 +
 arch/sparc/kernel/hvtramp.S                    |   1 -
 arch/sparc/kernel/ioport.c                     |   5 +-
 arch/sparc/kernel/irq_64.c                     | 507 ++++++++++++++--------
 arch/sparc/kernel/ktlb.S                       | 125 +-----
 arch/sparc/kernel/ldc.c                        |  41 +-
 arch/sparc/kernel/pcr.c                        |  47 ++-
 arch/sparc/kernel/perf_event.c                 |   3 +-
 arch/sparc/kernel/setup_64.c                   |  36 +-
 arch/sparc/kernel/smp_64.c                     |   7 +
 arch/sparc/kernel/sun4v_tlb_miss.S             |  35 +-
 arch/sparc/kernel/trampoline_64.S              |  12 +-
 arch/sparc/kernel/traps_64.c                   |  15 +-
 arch/sparc/kernel/tsb.S                        |   6 +-
 arch/sparc/kernel/viohs.c                      |   4 +-
 arch/sparc/kernel/vmlinux.lds.S                |  10 +-
 arch/sparc/lib/NG4memcpy.S                     |  14 +-
 arch/sparc/lib/memset.S                        |  18 +-
 arch/sparc/mm/fault_64.c                       |   3 +
 arch/sparc/mm/gup.c                            |  30 ++
 arch/sparc/mm/init_64.c                        | 554 +++++++++++++------------
 arch/sparc/mm/init_64.h                        |  18 -
 arch/sparc/power/hibernate_asm.S               |   4 +-
 arch/sparc/prom/bootstr_64.c                   |   5 +-
 arch/sparc/prom/cif.S                          |   5 +-
 arch/sparc/prom/init_64.c                      |   6 +-
 arch/sparc/prom/p1275.c                        |   9 +-
 arch/x86/include/asm/kvm_host.h                |   1 +
 arch/x86/kernel/cpu/intel.c                    |  15 +
 arch/x86/kvm/mmu.c                             |  29 +-
 arch/x86/kvm/vmx.c                             |  16 +-
 arch/x86/kvm/x86.h                             |  20 +-
 crypto/async_tx/async_xor.c                    |   3 +-
 drivers/base/firmware_class.c                  |   3 +
 drivers/base/regmap/regmap-debugfs.c           |   8 +-
 drivers/base/regmap/regmap.c                   |   7 +-
 drivers/bluetooth/btusb.c                      |   9 +
 drivers/bluetooth/hci_h5.c                     |   2 +-
 drivers/clk/qcom/gcc-ipq806x.c                 |  31 +-
 drivers/dma/pl330.c                            |  12 +-
 drivers/edac/mpc85xx_edac.c                    |   2 +-
 drivers/hid/hid-rmi.c                          |  44 +-
 drivers/hid/wacom_sys.c                        |  26 +-
 drivers/hv/channel.c                           |  49 ++-
 drivers/hv/connection.c                        |  17 +-
 drivers/hv/hv.c                                |  27 +-
 drivers/hv/hyperv_vmbus.h                      |   4 +
 drivers/message/fusion/mptspi.c                |   5 +
 drivers/misc/mei/bus.c                         |   2 +-
 drivers/net/wireless/ath/ath9k/ar5008_phy.c    |   4 +-
 drivers/net/wireless/iwlwifi/mvm/constants.h   |   2 +-
 drivers/net/wireless/iwlwifi/pcie/drv.c        |   4 +
 drivers/net/wireless/rt2x00/rt2800.h           |   2 +-
 drivers/pci/host/pci-mvebu.c                   |   6 +-
 drivers/pci/pci-sysfs.c                        |   2 +-
 drivers/pci/quirks.c                           |  20 +
 drivers/pci/setup-bus.c                        |   2 +-
 drivers/regulator/ltc3589.c                    |   1 +
 drivers/rtc/rtc-cmos.c                         |   5 +-
 drivers/scsi/be2iscsi/be_mgmt.c                |  13 +-
 drivers/scsi/qla2xxx/qla_os.c                  |   6 +-
 drivers/scsi/qla2xxx/qla_target.c              |   5 +-
 drivers/spi/spi-dw-mid.c                       |  10 +-
 drivers/spi/spi-rockchip.c                     |  15 +-
 drivers/tty/serial/omap-serial.c               |  12 +-
 drivers/vfio/pci/vfio_pci.c                    | 136 +++---
 drivers/virtio/virtio_balloon.c                |  15 +-
 fs/btrfs/dev-replace.c                         |   3 +-
 fs/btrfs/extent-tree.c                         |   8 +-
 fs/btrfs/file.c                                |  25 +-
 fs/btrfs/inode.c                               | 118 +++---
 fs/btrfs/ioctl.c                               |  42 ++
 fs/btrfs/qgroup.c                              |  10 +-
 fs/btrfs/relocation.c                          |  93 +++--
 fs/btrfs/transaction.c                         |  12 +-
 fs/ecryptfs/inode.c                            |   2 +-
 fs/namei.c                                     |   2 +-
 fs/namespace.c                                 |   2 +
 fs/nfs/client.c                                |   2 +-
 fs/nfs/filelayout/filelayout.c                 |   2 +-
 fs/nfs/nfs4proc.c                              |   2 +-
 fs/nfs/nfs4renewd.c                            |  12 +-
 fs/nfs/nfs4state.c                             |  18 +-
 fs/nfs/pagelist.c                              |  10 +-
 fs/nfs/pnfs.c                                  |  33 +-
 fs/nfs/pnfs.h                                  |   6 +-
 fs/nfsd/nfs4xdr.c                              |   8 +
 fs/nfsd/vfs.c                                  |   2 +-
 fs/notify/fanotify/fanotify_user.c             |   2 +-
 fs/udf/inode.c                                 |  14 +-
 fs/udf/super.c                                 |  10 +-
 fs/udf/udfdecl.h                               |  13 +-
 fs/xfs/xfs_aops.c                              |  16 +-
 fs/xfs/xfs_itable.c                            |   3 +-
 include/linux/balloon_compaction.h             |  97 ++---
 include/linux/compiler-gcc5.h                  |  66 +++
 include/linux/ima.h                            |   4 +-
 include/linux/migrate.h                        |  11 +-
 include/linux/mm.h                             |  19 +
 include/linux/pci_ids.h                        |   1 +
 include/linux/sched.h                          |   6 +-
 include/uapi/linux/hyperv.h                    |   2 +-
 kernel/futex.c                                 |   2 +
 lib/lzo/lzo1x_decompress_safe.c                | 103 +++--
 mm/balloon_compaction.c                        |  26 +-
 mm/cma.c                                       |   4 +-
 mm/compaction.c                                |   2 +-
 mm/migrate.c                                   |  16 +-
 net/bluetooth/6lowpan.c                        |  80 +++-
 net/bluetooth/l2cap_core.c                     |   6 +-
 net/bluetooth/smp.c                            |   5 +-
 security/integrity/ima/ima.h                   |   4 +-
 security/integrity/ima/ima_appraise.c          |   9 +-
 security/integrity/ima/ima_crypto.c            |   8 +-
 security/integrity/ima/ima_main.c              |  28 +-
 security/integrity/integrity.h                 |   1 +
 sound/core/pcm_native.c                        |   2 +-
 sound/firewire/bebob/bebob_terratec.c          |   4 +-
 sound/pci/emu10k1/emu10k1_callback.c           |   6 +-
 sound/pci/hda/hda_local.h                      |   4 +-
 sound/pci/hda/patch_hdmi.c                     |  15 +-
 sound/pci/hda/patch_realtek.c                  |   7 +-
 sound/usb/quirks-table.h                       |  30 ++
 virt/kvm/kvm_main.c                            |  34 +-
 171 files changed, 2566 insertions(+), 1501 deletions(-)


