Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478AbaGHTrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:47:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54034 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755646AbaGHTIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:38 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: torvalds@linux-foundation.org, Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>, akpm@linux-foundation.org
Date: Tue, 08 Jul 2014 20:01:49 +0100
Message-ID: <lsq.1404846109.699842714@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 000/125] 3.2.61-rc1 review
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.61 release.
There are 125 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Jul 10 19:01:49 UTC 2014.
Anything received after that time might be too late.

A combined patch relative to 3.2.60 will be posted as an additional
response to this.  A shortlog and diffstat can be found below.

Ben.

-------------

Alan Stern (2):
      USB: Avoid runtime suspend loops for HCDs that can't handle suspend/resume
         [8ef42ddd9a53b73e6fc3934278710c27f80f324f]
      USB: EHCI: avoid BIOS handover on the HASEE E200
         [b0a50e92bda3c4aeb8017d4e6c6e92146ebd5c9b]

Alex Deucher (3):
      drm/radeon/atom: fix dithering on certain panels
         [642528355c694f5ed68f6bff9ff520326a249f99]
      drm/radeon: fix typo in radeon_connector_is_dp12_capable()
         [af5d36539dfe043f1cf0f8b7334d6bb12cd14e75]
      drm/radeon: only apply hdmi bpc pll flags when encoder mode is hdmi
         [7d5ab3009a8ca777174f6f469277b3922d56fd4b]

Alex Smith (1):
      recordmcount/MIPS: Fix possible incorrect mcount_loc table entries in modules
         [91ad11d7cc6f4472ebf177a6252fbf0fd100d798]

Alexej Starschenko (1):
      USB: serial: option: add support for Novatel E371 PCIe card
         [8a61ba3a47ac39f660702aa66a172185dd605a86]

Andreas Schrägle (1):
      ahci: add PCI ID for Marvell 88SE91A0 SATA Controller
         [754a292fe6b08196cb135c03b404444e17de520a]

Andrey Ryabinin (2):
      ARM: 8051/1: put_user: fix possible data corruption in put_user
         [537094b64b229bf3ad146042f83e74cf6abe59df]
      mm: rmap: fix use-after-free in __put_anon_vma
         [624483f3ea82598ab0f62f1bdb9177f531ab1892]

Andy Lutomirski (2):
      auditsc: audit_krule mask accesses need bounds checking
         [a3c54931199565930d6d84f4c3456f6440aefd41]
      x86_32, entry: Do syscall exit work on badsys (CVE-2014-4508)
         [554086d85e71f30abe46fc014fea31929a7c6a8a]

Arik Nemtsov (1):
      mac80211: don't check netdev state for debugfs read/write
         [923eaf367206e01f22c97aee22300e332d071916]

Bart Van Assche (3):
      IB/srp: Fix a sporadic crash triggered by cable pulling
         [024ca90151f5e4296d30f72c13ff9a075e23c9ec]
      IB/umad: Fix error handling
         [8ec0a0e6b58218bdc1db91dd70ebfcd6ad8dd6cd]
      [SCSI] Stop accepting SCSI requests before removing a device
         [b485462aca7df4e32bcf7efb6f84a69e8b640243]

Ben Collins (1):
      [SCSI] megaraid: Use resource_size_t for PCI resources, not long
         [11f8a7b31f2140b0dc164bb484281235ffbe51d3]

Benjamin Herrenschmidt (1):
      powerpc/serial: Use saner flags when creating legacy ports
         [c4cad90f9e9dcb85afc5e75a02ae3522ed077296]

Benjamin Tissoires (1):
      Input: synaptics - fix resolution for manually provided min/max
         [d49cb7aeebb974713f9f7ab2991352d3050b095b]

Benny Halevy (1):
      nfsd4: use recall_lock for delegation hashing
         [931ee56c67573eb4e51c8a4e78598d965b8b059e]

Boris BREZILLON (1):
      rtc: rtc-at91rm9200: fix infinite wait for ACKUPD irq
         [2fe121e1f5aa3bf31b418a9790db6c400e922291]

Chris Mason (1):
      Btrfs: fix double free in find_lock_delalloc_range
         [7d78874273463a784759916fc3e0b4e2eb141c70]

Chris Wilson (1):
      drm/i915: Only copy back the modified fields to userspace from execbuffer
         [9aab8bff7aa3bee567213ad3c1fdfb217bb980a2]

Christian Borntraeger (1):
      s390/lowcore: reserve 96 bytes for IRB in lowcore
         [993072ee67aa179c48c85eb19869804e68887d86]

Christian König (1):
      drm/radeon: stop poisoning the GART TLB
         [0986c1a55ca64b44ee126a2f719a6e9f28cbe0ed]

Christoph Hellwig (1):
      nfsd: getattr for FATTR4_WORD0_FILES_AVAIL needs the statfs buffer
         [12337901d654415d9f764b5f5ba50052e9700f37]

Dan Carpenter (1):
      RDMA/cxgb4: Fix four byte info leak in c4iw_create_cq()
         [e24a72a3302a638d4c6e77f0b40c45cc61c3f089]

Daniel Vetter (1):
      drm/i915: s/DRM_ERROR/DRM_DEBUG in i915_gem_execbuffer.c
         [ff240199b6a3b0bec5ae9b6d26403dad38e8cb19]

David Henningsson (1):
      ALSA: hda - Add quirk for external mic on Lifebook U904
         [2041d56464a067461d7cc21734a0f024587ed2ff]

David Woodhouse (1):
      iommu/vt-d: Fix missing IOTLB flush in intel_iommu_unmap()
         [ea8ea460c9ace60bbb5ac6e5521d637d5c15293d]

Dennis Dalessandro (1):
      IB/ipath: Translate legacy diagpkt into newer extended diagpkt
         [7e6d3e5c70f13874fb06e6b67696ed90ce79bd48]

Emil Goode (1):
      ARM: imx: fix error handling in ipu device registration
         [d1d70e5dc2cfa9047bb935c41ba808ebb8135696]

Eric Dumazet (1):
      net: fix inet_getid() and ipv6_select_ident() bugs
         [39c36094d78c39e038c1e499b2364e13bce36f54]

Felipe Balbi (1):
      bluetooth: hci_ldisc: fix deadlock condition
         [da64c27d3c93ee9f89956b9de86c4127eb244494]

Gabor Juhos (1):
      watchdog: ath79_wdt: avoid spurious restarts on AR934x
         [23afeb613ec0e10aecfae7838a14d485db62ac52]

Geert Uytterhoeven (1):
      Documentation: Update stable address in Chinese and Japanese translations
         [98b0f811aade1b7c6e7806c86aa0befd5919d65f]

George McCollister (1):
      USB: ftdi_sio: add NovaTech OrionLXm product ID
         [d0839d757e6294921c31b1c4ca4f1dcc5df63bcd]

Greg Kroah-Hartman (1):
      lzo: properly check for overruns
         [206a81c18401c0cde6e579164f752c4b147324ce]

Guenter Roeck (1):
      powerpc: Fix 64 bit builds with binutils 2.24
         [7998eb3dc700aaf499f93f50b3d77da834ef9e1d]

Hans de Goede (4):
      Input: elantech - deal with clickpads reporting right button events
         [cd9e83e2754465856097f31c7ab933ce74c473f8]
      Input: elantech - don't set bit 1 of reg_10 when the no_hw_res quirk is set
         [fb4f8f568a9def02240ef9bf7aabd246dc63a081]
      Input: synaptics - T540p - unify with other LEN0034 models
         [6d396ede224dc596d92d7cab433713536e68916c]
      Input: synaptics - add min/max quirk for the ThinkPad W540
         [0b5fe736fe923f1f5e05413878d5990e92ffbdf5]

Huang Rui (1):
      usb: usbtest: fix unlink write error with pattern 1
         [e4d58f5dcb7d7be45df8def31881ebfae99c75da]

Hugh Dickins (2):
      mm: fix crashes from mbind() merging vmas
         [d05f0cdcbe6388723f1900c549b4850360545201]
      mm: fix sleeping function warning from __put_anon_vma
         [7f39dda9d86fb4f4f17af0de170decf125726f8c]

Hujianyang (2):
      UBIFS: Remove incorrect assertion in shrink_tnc()
         [72abc8f4b4e8574318189886de627a2bfe6cd0da]
      UBIFS: fix an mmap and fsync race condition
         [691a7c6f28ac90cccd0dbcf81348ea90b211bdd0]

J. Bruce Fields (1):
      nfsd4: fix FREE_STATEID lockowner leak
         [48385408b45523d9a432c66292d47ef43efcbb94]

James Bottomley (3):
      [SCSI] Fix spurious request sense in error handling
         [d555a2abf3481f81303d835046a5ec2c4fb3ca8e]
      [SCSI] dual scan thread bug fix
         [f2495e228fce9f9cec84367547813cbb0d6db15a]
      [SCSI] fix our current target reap infrastructure
         [e63ed0d7a98014fdfc2cfeb3f6dada313dcabb59]

Jan Kara (1):
      ext4: fix zeroing of page during writeback
         [eeece469dedadf3918bad50ad80f4616a0064e90]

Jeff Mahoney (1):
      reiserfs: call truncate_setsize under tailpack mutex
         [22e7478ddbcb670e33fab72d0bbe7c394c3a2c84]

Johan Hedberg (2):
      Bluetooth: Fix SSP acceptor just-works confirmation without MITM
         [ba15a58b179ed76a7e887177f2b06de12c58ec8f]
      Bluetooth: Fix check for connection encryption
         [e694788d73efe139b24f78b036deb97fe57fa8cb]

Johan Hovold (14):
      USB: cdc-acm: fix broken runtime suspend
         [140cb81ac8c625942a1d695875932c615767a526]
      USB: cdc-acm: fix potential urb leak and PM imbalance in write
         [183a45087d126d126e8dd1d9b2602fc129dff9ad]
      USB: cdc-acm: fix runtime PM for control messages
         [bae3f4c53585e9a170da9436e0f06919874bda9a]
      USB: cdc-acm: fix write and resume race
         [e144ed28bed10684f9aaec6325ed974d53f76110]
      USB: cdc-acm: fix write and suspend race
         [5a345c20c17d87099224a4be12e69e5bd7023dca]
      USB: io_ti: fix firmware download on big-endian machines (part 2)
         [c03890ff5e24a4bf59059f2d179f427559b7330a]
      USB: option: fix runtime PM handling
         [acf47d4f9c39b1cba467aa9442fc2efe0b1da741]
      USB: sierra: fix AA deadlock in open error path
         [353fe198602e8b4d1c7bdcceb8e60955087201b1]
      USB: sierra: fix remote wakeup
         [80cc0fcbdaeaf10d04ba27779a2d7ceb73d2717a]
      USB: sierra: fix urb and memory leak in resume error path
         [7fdd26a01eb7b6cb6855ff8f69ef4a720720dfcb]
      USB: sierra: fix urb and memory leak on disconnect
         [014333f77c0b71123d6ef7d31a9724e0699c9548]
      USB: usb_wwan: fix potential blocked I/O after resume
         [fb7ad4f93d9f0f7d49beda32f5e7becb94b29a4d]
      USB: usb_wwan: fix urb leak at shutdown
         [79eed03e77d481b55d85d1cfe5a1636a0d3897fd]
      USB: usb_wwan: fix write and suspend race
         [170fad9e22df0063eba0701adb966786d7a4ec5a]

Johannes Weiner (1):
      mm: vmscan: clear kswapd's special reclaim powers before exiting
         [71abdc15adf8c702a1dd535f8e30df50758848d2]

Jérôme Carretero (1):
      ahci: Add Device ID for HighPoint RocketRaid 642L
         [d251836508fb26cd1a22b41381739835ee23728d]

Kailang Yang (1):
      ALSA: hda/realtek - Add support of ALC891 codec
         [b6c5fbad16aa5026f508093a8d651c25e1cb6179]

Kees Cook (1):
      HID: core: fix validation of report id 0
         [1b15d2e5b8077670b1e6a33250a0d9577efff4a5]

Krzysztof Hałasa (1):
      mac80211: fix IBSS join by initializing last_scan_completed
         [c7d37a66e345df2fdf1aa7b2c9a6d3d53846ca5b]

Lai Jiangshan (1):
      idr: fix overflow bug during maximum ID calculation at maximum height
         [3afb69cb5572b3c8c898c00880803cf1a49852c4]

Lars-Peter Clausen (5):
      ALSA: control: Don't access controls outside of protected regions
         [fd9f26e4eca5d08a27d12c0933fceef76ed9663d]
      ALSA: control: Fix replacing user controls
         [82262a46627bebb0febcc26664746c25cef08563]
      ALSA: control: Handle numid overflow
         [ac902c112d90a89e59916f751c2745f4dbdbb4bd]
      ALSA: control: Make sure that id->index does not overflow
         [883a1d49f0d77d30012f114b2e19fc141beb3e8e]
      ALSA: control: Protect user controls against concurrent access
         [07f4d9d74a04aa7c72c5dae0ef97565f28f17b92]

Liu Hua (1):
      ARM: 8012/1: kdump: Avoid overflow when converting pfn to physaddr
         [8fad87bca7ac9737e413ba5f1656f1114a8c314d]

Lv Zheng (1):
      ACPI: Fix conflict between customized DSDT and DSDT local copy
         [73577d1df8e1f31f6b1a5eebcdbc334eb0330e47]

Marco Stornelli (1):
      reiserfs: drop vmtruncate
         [cfac4b47c664e207740880d6492938761c53d74b]

Markos Chandras (2):
      MIPS: MSC: Prevent out-of-bounds writes to MIPS SC ioremap'd region
         [ab6c15bc6620ebe220970cc040b29bcb2757f373]
      MIPS: asm: thread_info: Add _TIF_SECCOMP flag
         [137f7df8cead00688524c82360930845396b8a21]

Markus F.X.J. Oberhumer (2):
      lib/lzo: Rename lzo1x_decompress.c to lzo1x_decompress_safe.c
         [b6bec26cea948148a9420e7a0ac337f925de49e7]
      lib/lzo: Update LZO compression to current upstream version
         [8b975bd3f9089f8ee5d7bbfd798537b992bbc7e7]

Mathias Nyman (1):
      xhci: delete endpoints from bandwidth list before freeing whole device
         [5dc2808c4729bf080487e61b80ee04e0fdb12a37]

Matthew Dempsky (1):
      ptrace: fix fork event messages across pid namespaces
         [4e52365f279564cef0ddd41db5237f0471381093]

Maurizio Lombardi (1):
      ext4: fix wrong assert in ext4_mb_normalize_request()
         [b5b60778558cafad17bbcbf63e0310bd3c68eb17]

Michael Neuling (1):
      powerpc: Don't setup CPUs with bad status
         [59a53afe70fd530040bdc69581f03d880157f15a]

Michael S. Tsirkin (3):
      skbuff: add an api to orphan frags
         [a353e0ce0fd42d8859260666d1e9b10f2abd4698]
      skbuff: export skb_copy_ubufs
         [dcc0fb782b3a6e2abfeaaeb45dd88ed09596be0f]
      skbuff: skb_segment: orphan frags before copying
         [1fd819ecb90cc9b822cd84d3056ddba315d3340f]

Michal Schmidt (1):
      netlink: rate-limit leftover bytes warning and print  process name
         [bfc5184b69cf9eeb286137640351c650c27f118a]

Mike Marciniszyn (1):
      IB/qib: Fix port in pkey change event
         [911eccd284d13d78c92ec4f1f1092c03457d732a]

Mikulas Patocka (1):
      matroxfb: perform a dummy read of M_STATUS
         [972754cfaee94d6e25acf94a497bc0a864d91b7e]

Mimi Zohar (1):
      evm: prohibit userspace writing 'security.evm' HMAC value
         [2fb1c9a4f2dbc2f0bd2431c7fa64d0b5483864e4]

Minchan Kim (1):
      mm: revert 0def08e3 ("mm/mempolicy.c: check return code of check_range")
         [082708072a4250f5c4dbc62065e7af93f5e45646]

Naoya Horiguchi (1):
      hugetlb: fix copy_hugetlb_page_range() to handle migration/hwpoisoned entry
         [4a705fef986231a3e7a6b1a6d3c37025f021f49f]

NeilBrown (1):
      md: always set MD_RECOVERY_INTR when aborting a reshape or other "resync".
         [3991b31ea072b070081ca3bfa860a077eda67de5]

Nicholas Bellinger (3):
      iscsi-target: Reject mutual authentication with reflected CHAP_C
         [1d2b60a5545942b1376cb48c1d55843d71e3a08f]
      target: Explicitly clear ramdisk_mcp backend pages
         [4442dc8a92b8f9ad8ee9e7f8438f4c04c03a22dc]
      target: Fix left-over se_lun->lun_sep pointer OOPs
         [83ff42fcce070801a3aa1cd6a3269d7426271a8d]

Oleg Nesterov (1):
      tracing: Fix syscall_*regfunc() vs copy_process() race
         [4af4206be2bd1933cae20c2b6fb2058dbc887f7c]

Peter Zijlstra (1):
      perf: Fix race in removing an event
         [46ce0fe97a6be7532ce6126bb26ce89fed81528c]

Rafał Miłecki (1):
      b43: fix frequency reported on G-PHY with /new/ firmware
         [2fc68eb122c7ea6cd5be1fe7d6650c0beb2f4f40]

Ralf Baechle (1):
      MIPS: Cleanup flags in syscall flags handlers.
         [e7f3b48af7be9f8007a224663a5b91340626fed5]

Stanislaw Gruszka (1):
      rt2x00: disable TKIP on USB
         [8edcb0ba0d56f5914eef11eda6db8bfe74eb9ca8]

Tejun Heo (1):
      ptrace,x86: force IRET path after a ptrace_stop()
         [b9cd18de4db3c9ffa7e17b0dc0ca99ed5aa4d43a]

Thomas Gleixner (5):
      genirq: Sanitize spurious interrupt detection of threaded irqs
         [1e77d0a1ed7417d2a5a52a7b8d32aea1833faa6c]
      rtmutex: Detect changes in the pi lock chain
         [82084984383babe728e6e3c9a8e5c46278091315]
      rtmutex: Fix deadlock detector for real
         [397335f004f41e5fcf7a795e94eb3ab83411a17c]
      rtmutex: Handle deadlock detection smarter
         [3d5c9340d1949733eb37616abd15db36aef9a57c]
      rtmutex: Plug slow unlock race
         [27e35715df54cbc4f2d044f681802ae30479e7fb]

Tom Gundersen (1):
      net: tunnels - enable module autoloading
         [f98f89a0104454f35a62d681683c844f6dbf4043]

Wei Yang (2):
      mlx4_core: Stash PCI ID driver_data in mlx4_priv  structure
         [839f12434c7618d326b9d1ece5eca643e5e48d0a]
      net/mlx4_core: Preserve pci_dev_data after  __mlx4_remove_one()
         [befdf8978accecac2e0739e6b5075afc62db37fe]

Will Deacon (1):
      mm: highmem: don't treat PKMAP_ADDR(LAST_PKMAP) as a highmem address
         [498c2280212327858e521e9d21345d4cc2637f54]

Xiao Jin (2):
      USB: usb_wwan: fix race between write and resume
         [d9e93c08d8d985e5ef89436ebc9f4aad7e31559f]
      USB: usb_wwan: fix urb leak in write error path
         [db0904737947d509844e171c9863ecc5b4534005]

Xufeng Zhang (1):
      sctp: Fix sk_ack_backlog wrap-around problem
         [d3217b15a19a4779c39b212358a5c71d725822ee]

Yann Droneaud (1):
      RDMA/cxgb4: Add missing padding at end of struct c4iw_create_cq_resp
         [b6f04d3d21458818073a2f5af5339f958864bf71]

Zhaowei Yuan (1):
      drm: fix NULL pointer access by wrong ioctl
         [1539fb9bd405ee32282ea0a38404f9e008ac5b7a]

 Documentation/ja_JP/HOWTO                     |   2 +-
 Documentation/ja_JP/stable_kernel_rules.txt   |   6 +-
 Documentation/zh_CN/HOWTO                     |   2 +-
 Documentation/zh_CN/stable_kernel_rules.txt   |   2 +-
 Makefile                                      |   4 +-
 arch/arm/include/asm/uaccess.h                |   3 +-
 arch/arm/kernel/crash_dump.c                  |   2 +-
 arch/arm/plat-mxc/devices/platform-ipu-core.c |   2 +-
 arch/mips/include/asm/thread_info.h           |   2 +
 arch/mips/kernel/irq-msc01.c                  |   2 +-
 arch/mips/kernel/scall32-o32.S                |   2 +-
 arch/mips/kernel/scall64-64.S                 |   2 +-
 arch/mips/kernel/scall64-n32.S                |   2 +-
 arch/mips/kernel/scall64-o32.S                |   2 +-
 arch/powerpc/Makefile                         |   4 +-
 arch/powerpc/include/asm/ppc_asm.h            |   7 +-
 arch/powerpc/kernel/legacy_serial.c           |  15 +-
 arch/powerpc/kernel/setup-common.c            |   2 +-
 arch/s390/include/asm/lowcore.h               |  11 +-
 arch/x86/include/asm/ptrace.h                 |  16 ++
 arch/x86/kernel/entry_32.S                    |  10 +-
 drivers/acpi/bus.c                            |   7 +
 drivers/ata/ahci.c                            |   4 +
 drivers/bluetooth/hci_ldisc.c                 |  25 +-
 drivers/bluetooth/hci_uart.h                  |   2 +
 drivers/gpu/drm/drm_drv.c                     |   3 +-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c    | 102 ++++----
 drivers/gpu/drm/radeon/atombios_crtc.c        |  48 ++--
 drivers/gpu/drm/radeon/atombios_encoders.c    |   5 +-
 drivers/gpu/drm/radeon/radeon_connectors.c    |   2 +-
 drivers/gpu/drm/radeon/rs600.c                |   7 +-
 drivers/hid/hid-core.c                        |  12 +-
 drivers/infiniband/core/user_mad.c            |  49 ++--
 drivers/infiniband/hw/cxgb4/cq.c              |   3 +-
 drivers/infiniband/hw/cxgb4/user.h            |   1 +
 drivers/infiniband/hw/ipath/ipath_diag.c      |   4 +
 drivers/infiniband/hw/qib/qib_mad.c           |   2 +-
 drivers/infiniband/ulp/srp/ib_srp.c           |   6 +
 drivers/input/mouse/elantech.c                |  27 ++-
 drivers/input/mouse/synaptics.c               |  26 +-
 drivers/iommu/intel-iommu.c                   |  18 +-
 drivers/md/md.c                               |   4 +-
 drivers/net/ethernet/mellanox/mlx4/main.c     | 120 +++++----
 drivers/net/ethernet/mellanox/mlx4/mlx4.h     |   3 +
 drivers/net/wireless/b43/xmit.c               |  10 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c       |   2 +
 drivers/rtc/rtc-at91rm9200.c                  |  16 +-
 drivers/scsi/megaraid/megaraid_sas.h          |   1 -
 drivers/scsi/megaraid/megaraid_sas_base.c     |   5 +-
 drivers/scsi/scsi_error.c                     |   9 +
 drivers/scsi/scsi_lib.c                       |   7 +-
 drivers/scsi/scsi_scan.c                      | 112 +++++----
 drivers/scsi/scsi_sysfs.c                     |  31 ++-
 drivers/target/iscsi/iscsi_target_auth.c      |  10 +
 drivers/target/target_core_device.c           |   1 +
 drivers/target/target_core_rd.c               |   2 +-
 drivers/usb/class/cdc-acm.c                   |  96 +++++---
 drivers/usb/class/cdc-acm.h                   |   2 +-
 drivers/usb/core/driver.c                     |   9 +-
 drivers/usb/core/hub.c                        |  16 +-
 drivers/usb/host/pci-quirks.c                 |  19 +-
 drivers/usb/host/xhci-mem.c                   |  20 +-
 drivers/usb/misc/usbtest.c                    |  10 +
 drivers/usb/serial/ftdi_sio.c                 |   2 +
 drivers/usb/serial/ftdi_sio_ids.h             |   5 +
 drivers/usb/serial/io_ti.c                    |   2 +-
 drivers/usb/serial/io_usbvend.h               |   2 +-
 drivers/usb/serial/option.c                   |  14 +-
 drivers/usb/serial/sierra.c                   |  48 +++-
 drivers/usb/serial/usb_wwan.c                 |  85 ++++---
 drivers/video/matrox/matroxfb_base.h          |   2 +-
 drivers/watchdog/ath79_wdt.c                  |  10 +
 fs/btrfs/extent_io.c                          |   1 +
 fs/ext4/mballoc.c                             |   2 +-
 fs/ext4/page-io.c                             |  24 +-
 fs/nfsd/nfs4state.c                           |  22 +-
 fs/nfsd/nfs4xdr.c                             |   4 +-
 fs/reiserfs/file.c                            |   3 +-
 fs/reiserfs/inode.c                           |  21 +-
 fs/ubifs/file.c                               |   3 +-
 fs/ubifs/shrinker.c                           |   1 -
 include/linux/irqdesc.h                       |   4 +
 include/linux/lzo.h                           |  15 +-
 include/linux/ptrace.h                        |  35 +++
 include/linux/reiserfs_fs.h                   |   1 +
 include/linux/skbuff.h                        |  16 ++
 include/net/inetpeer.h                        |   9 +-
 include/scsi/scsi_device.h                    |   3 +-
 include/sound/core.h                          |   2 +
 include/trace/syscall.h                       |  15 ++
 kernel/auditsc.c                              |  25 +-
 kernel/events/core.c                          |  45 ++--
 kernel/fork.c                                 |  12 +-
 kernel/irq/manage.c                           |   4 +-
 kernel/irq/spurious.c                         | 106 +++++++-
 kernel/rtmutex-debug.h                        |   5 +
 kernel/rtmutex.c                              | 268 ++++++++++++++++++---
 kernel/rtmutex.h                              |   5 +
 lib/decompress_unlzo.c                        |   2 +-
 lib/idr.c                                     |   8 +-
 lib/lzo/Makefile                              |   2 +-
 lib/lzo/lzo1x_compress.c                      | 335 +++++++++++++++-----------
 lib/lzo/lzo1x_decompress.c                    | 255 --------------------
 lib/lzo/lzodefs.h                             |  38 ++-
 lib/nlattr.c                                  |   5 +-
 mm/highmem.c                                  |   2 +-
 mm/hugetlb.c                                  |  71 +++---
 mm/mempolicy.c                                |  57 +++--
 mm/rmap.c                                     |  11 +-
 mm/vmscan.c                                   |   3 +
 net/bluetooth/hci_conn.c                      |   2 +-
 net/bluetooth/hci_event.c                     |   7 +-
 net/core/skbuff.c                             |   5 +-
 net/ipv4/ipip.c                               |   1 +
 net/ipv6/ip6_output.c                         |  11 +-
 net/ipv6/ip6_tunnel.c                         |   1 +
 net/ipv6/sit.c                                |   1 +
 net/mac80211/debugfs_netdev.c                 |   6 +-
 net/mac80211/ibss.c                           |   1 +
 net/sctp/associola.c                          |   2 +-
 scripts/recordmcount.h                        |   4 +-
 security/integrity/evm/evm_main.c             |  12 +-
 sound/core/control.c                          |  78 +++---
 sound/core/init.c                             |   1 +
 sound/pci/hda/patch_realtek.c                 |  10 +
 125 files changed, 1696 insertions(+), 1014 deletions(-)

-- 
Ben Hutchings
Any smoothly functioning technology is indistinguishable from a rigged demo.

