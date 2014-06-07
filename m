Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758AbaFGBoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:44:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35936 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752527AbaFGBXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:36 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: torvalds@linux-foundation.org, Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>, akpm@linux-foundation.org
Date: Sat, 07 Jun 2014 02:26:28 +0100
Message-ID: <lsq.1402104388.385007124@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 00/92] 3.2.60-rc1 review
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.60 release.
There are 92 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon Jun 09 01:26:28 UTC 2014.
Anything received after that time might be too late.

A combined patch relative to 3.2.59 will be posted as an additional
response to this.  A shortlog and diffstat can be found below.

Ben.

-------------

AceLan Kao (3):
      HID: usbhid: quirk for Synaptics HD touchscreen
         [d8e2e7581d2521910398c4c80d7a3b78e84da7d5]
      HID: usbhid: quirk for Synaptics Large Touchccreen
         [8171a67d587a09e14a4949a81e070345fedcf410]
      HID: usbhid: quirk for Synaptics Quad HD touchscreen
         [12f508aede4bda5d20a2dd3ff3deb16ef47a97e9]

Alex Deucher (1):
      drm/radeon: handle non-VGA class pci devices with ATRM
         [d8ade3526b2aa0505132c404c05a38b73ea15490]

Alex Elder (1):
      libceph: only call kernel_sendpage() via helper
         [e36b13cceb46136d849aeee06b4907ad3570ba78]

Alex Hung (1):
      thinkpad-acpi: fix issuing duplicated key events for brightness up/down
         [ff413195e830541afeae469fc866ecd0319abd7e]

Alexander Duyck (1):
      skb: Add inline helper for getting the skb end offset  from head
         [ec47ea82477404631d49b8e568c71826c9b663ac]

Andreas Schwab (1):
      powerpc: Add vr save/restore functions
         [8fe9c93e7453e67b8bd09f263ec1bb0783c733fc]

Anthony Iliopoulos (1):
      x86, mm, hugetlb: Add missing TLB page invalidation for hugetlb_cow()
         [9844f5462392b53824e8b86726e7c33b5ecbb676]

Ben Hutchings (1):
      rtl8192cu: Fix unbalanced irq enable in error path of rtl92cu_hw_init()
         [3234f5b06fc3094176a86772cc64baf3decc98fc]

Chen Yucong (1):
      hwpoison, hugetlb: lock_page/unlock_page does not match for handling a free hugepage
         [b985194c8c0a130ed155b71662e39f7eaea4876f]

Christian König (1):
      drm/radeon: also try GART for CPU accessed buffers
         [544092596e8ac269f70e70961b5e9381909c9b1e]

Christoph Hellwig (1):
      posix_acl: handle NULL ACL in posix_acl_equiv_mode
         [50c6e282bdf5e8dabf8d7cf7b162545a55645fd9]

Chunwei Chen (1):
      libceph: fix corruption when using page_count 0 page in rbd
         [178eda29ca721842f2146378e73d43e0044c4166]

Daniele Forsi (2):
      USB: Nokia 5300 should be treated as unusual dev
         [6ed07d45d09bc2aa60e27b845543db9972e22a38]
      usb: storage: shuttle_usbat: fix discs being detected twice
         [df602c2d2358f02c6e49cffc5b49b9daa16db033]

David Gibson (2):
      rtnetlink: Only supply IFLA_VF_PORTS information when  RTEXT_FILTER_VF is set
         [c53864fd60227de025cb79e05493b13f69843971]
      rtnetlink: Warn when interface's information won't fit  in our packet
         [973462bbde79bb827824c73b59027a0aed5c9ca6]

Dmitry Petukhov (1):
      l2tp: take PMTU from tunnel UDP socket
         [f34c4a35d87949fbb0e0f31eba3c054e9f8199ba]

Eric Dumazet (2):
      ipv6: Limit mtu to 65575 bytes
         [30f78d8ebf7f514801e71b88a10c948275168518]
      net-gro: reset skb->truesize in napi_reuse_skb()
         [e33d0ba8047b049c9262fdb1fcafb93cb52ceceb]

Ezequiel Garcia (1):
      dma: mv_xor: Flush descriptors before activating a channel
         [5a9a55bf9157d3490b0c8c4c81d4708602c26e07]

Florian Westphal (2):
      net: core: don't account for udp header size when  computing seglen
         [6d39d589bb76ee8a1c6cde6822006ae0053decff]
      net: ipv4: ip_forward: fix inverted local_df test
         [ca6c5d4ad216d5942ae544bbf02503041bd802aa]

Guennadi Liakhovetski (2):
      [media] V4L2: fix VIDIOC_CREATE_BUFS in 64- / 32-bit compatibility mode
         [97d9d23dda6f37d90aefeec4ed619d52df525382]
      [media] V4L2: ov7670: fix a wrong index, potentially Oopsing the kernel from user-space
         [cfece5857ca51d1dcdb157017aba226f594e9dcf]

Hans de Goede (3):
      HID: add NO_INIT_REPORTS quirk for Synaptics Touch Pad V 103S
         [2f433083e854ec72c19dc9b0e1cebcc8e230fd75]
      Input: elantech - fix touchpad initialization on Gigabyte U2442
         [36189cc3cd57ab0f1cd75241f93fe01de928ac06]
      Input: synaptics - add min/max quirk for ThinkPad Edge E431
         [27a38856a948c3e8de30dc71647ff9e1778c99fc]

Horia Geanta (1):
      crypto: caam - add allocation failure handling in SPRINTFCAT macro
         [27c5fb7a84242b66bf1e0b2fe6bf40d19bcc5c04]

Ilia Mirkin (1):
      drm/nouveau/acpi: allow non-optimus setups to load vbios from acpi
         [a3d0b1218d351c6e6f3cea36abe22236a08cb246]

Ivan Vecera (1):
      tg3: update rx_jumbo_pending ring param only when jumbo  frames are enabled
         [ba67b510035141bd89b40bf65efa0a79834311ca]

J. Bruce Fields (2):
      nfsd4: remove lockowner when removing lock stateid
         [a1b8ff4c97b4375d21b6d6c45d75877303f61b3b]
      nfsd4: warn on finding lockowner without stateid's
         [27b11428b7de097c42f205beabb1764f4365443b]

Jason Wang (1):
      act_mirred: do not drop packets when fails to mirror it
         [16c0b164bd24d44db137693a36b428ba28970c62]

Jiri Bohac (1):
      timer: Prevent overflow in apply_slack
         [98a01e779f3c66b0b11cd7e64d531c0e41c95762]

Jiri Olsa (1):
      perf: Prevent false warning in perf_swevent_add
         [39af6b1678afa5880dda7e375cf3f9d395087f6d]

Johan Hedberg (1):
      Bluetooth: Fix redundant encryption request for reauthentication
         [09da1f3463eb81d59685df723b1c5950b7570340]

Josef Gajdusek (2):
      hwmon: (emc1403) Support full range of known chip revision numbers
         [3a18e1398fc2dc9c32bbdc50664da3a77959a8d1]
      hwmon: (emc1403) fix inverted store_hyst()
         [17c048fc4bd95efea208a1920f169547d8588f1f]

Kieran Clancy (2):
      ACPI / EC: Clear stale EC events on Samsung systems
         [ad332c8a45330d170bb38b95209de449b31cd1b4]
      ACPI / EC: Process rather than discard events in acpi_ec_clear
         [3eba563e280101209bad27d40bfc83ddf1489234]

Kinglong Mee (1):
      NFSD: Call ->set_acl with a NULL ACL structure if no entries
         [aa07c713ecfc0522916f3cd57ac628ea6127c0ec]

Larry Finger (1):
      rtlwifi: rtl8192cu: Fix too long disable of IRQs
         [a53268be0cb9763f11da4f6fe3fb924cbe3a7d4a]

Leon Ma (1):
      hrtimer: Prevent remote enqueue of leftmost timers
         [012a45e3f4af68e86d85cce060c6c2fed56498b2]

Li RongQing (1):
      ipv4: initialise the itag variable in __mkroute_input
         [fbdc0ad095c0a299e9abf5d8ac8f58374951149a]

Linus Torvalds (1):
      x86-64, modify_ldt: Make support for 16-bit segments a runtime option
         [fa81511bb0bbb2b1aace3695ce869da9762624ff]

Liu Yu (1):
      tcp_cubic: fix the range of delayed_ack
         [0cda345d1b2201dd15591b163e3c92bad5191745]

Marcel Apfelbaum (1):
      PCI: shpchp: Check bridge's secondary (not primary) bus speed
         [93fa9d32670f5592c8e56abc9928fc194e1e72fc]

Mathias Krause (1):
      filter: prevent nla extensions to peek beyond the end  of the message
         [05ab8f2647e4221cbdb3856dd7d32bd5407316b3]

Mikulas Patocka (1):
      tgafb: fix mode setting with fbset
         [624966589041deb32a2626ee2e176e8274581101]

Mohammed Habibulla (1):
      Bluetooth: Add support for Lite-on [04ca:3007]
         [1fb4e09a7e780b915dbd172592ae7e2a4c071065]

Naoya Horiguchi (1):
      mm/memory-failure.c: fix memory leak by race between poison and unpoison
         [3e030ecc0fc7de10fd0da10c1c19939872a31717]

NeilBrown (1):
      md: avoid possible spinning md thread at shutdown.
         [0f62fb220aa4ebabe8547d3a9ce4a16d3c045f21]

Oleg Nesterov (1):
      KVM: async_pf: mm->mm_users can not pin apf->mm
         [41c22f626254b9dc0376928cae009e73d1b6a49a]

Olof Johansson (1):
      i2c: s3c2410: resume race fix
         [ce78cc071f5f541480e381cc0241d37590041a9d]

Paul.Szabo@Sydney.Edu.Au (1):
      Negative (setpoint-dirty) in bdi_position_ratio()
         [ed84825b785ceb932af7dd5aa08614801721320b]

Peter Christensen (1):
      macvlan: Don't propagate IFF_ALLMULTI changes on down  interfaces.
         [bbeb0eadcf9fe74fb2b9b1a6fea82cd538b1e556]

Peter Zijlstra (1):
      perf: Limit perf_event_attr::sample_period to 63 bits
         [0819b2e30ccb93edf04876237b6205eef84ec8d2]

Radim Krčmář (2):
      kvm: free resources after canceling async_pf
         [28b441e24088081c1e213139d1303b451a34a4f4]
      kvm: remove .done from struct kvm_async_pf
         [98fda169290b3b28c0f2db2b8f02290c13da50ef]

Rik van Riel (1):
      mm/page-writeback.c: fix divide by zero in pos_ratio_polynom
         [d5c9fde3dae750889168807038243ff36431d276]

Romain Izard (1):
      trace: module: Maintain a valid user count
         [098507ae3ec2331476fb52e85d4040c1cc6d0ef4]

Salva Peiró (1):
      [media] media-device: fix infoleak in ioctl media_enum_entities()
         [e6a623460e5fc960ac3ee9f946d3106233fd28d8]

Sergey Popovich (1):
      ipv4: fib_semantics: increment fib_info_cnt after  fib_info allocation
         [aeefa1ecfc799b0ea2c4979617f14cecd5cccbfd]

Stanislaw Gruszka (1):
      rt2x00: fix beaconing on USB
         [8834d3608cc516f13e2e510f4057c263f3d2ce42]

Stephane Grosjean (2):
      can: peak_pci: Fix the way channels are linked together
         [29830406415c227a54af429d7b300aabd4754237]
      can: peak_pci: prevent use after free at netdev removal
         [0b5a958cf4df3a5cd578b861471e62138f55c85e]

Steven Rostedt (3):
      ftrace/module: Hardcode ftrace_module_init() call into load_module()
         [a949ae560a511fe4e3adf48fa44fefded93e5c2b]
      sched: Use CPUPRI_NR_PRIORITIES instead of MAX_RT_PRIO in cpupri check
         [6227cb00cc120f9a43ce8313bb0475ddabcb7d01]
      tracepoint: Do not waste memory on mods with no tracepoints
         [7dec935a3aa04412cba2cebe1524ae0d34a30c24]

Stuart Hayes (1):
      hrtimer: Prevent all reprogramming if hang detected
         [6c6c0d5a1c949d2e084706f9e5fb1fccc175b265]

Thomas Gleixner (6):
      futex-prevent-requeue-pi-on-same-futex.patch futex: Forbid uaddr == uaddr2 in futex_requeue(..., requeue_pi=1)
         [e9c243a5a6de0be8e584c604d353412584b592f8]
      futex: Add another early deadlock detection check
         [866293ee54227584ffcb4a42f69c1f365974ba7f]
      futex: Always cleanup owner tid in unlock_pi
         [13fbca4c6ecd96ec1a1cfa2e4f2ce191fe928a5e]
      futex: Make lookup_pi_state more robust
         [54a217887a7b658e2650c3feff22756ab80c7339]
      futex: Prevent attaching to kernel threads
         [f0d71b3dcb8332f7971b5f2363632573e6d9486a]
      futex: Validate atomic acquisition in futex_lock_pi_atomic()
         [b3eaa9fc5cd0a4d74b18f6b8dc617aeaf1873270]

Thomas Graf (1):
      netfilter: Can't fail and free after table replacement
         [c58dd2dd443c26d856a168db108a0cd11c285bf3]

Thomas Hellstrom (1):
      drm/vmwgfx: Make sure user-space can't DMA across buffer object boundaries v2
         [cbd75e97a525e3819c02dc18bc2d67aa544c9e45]

Thomas Richter (1):
      bonding: Remove debug_fs files when module init fails
         [db29868653394937037d71dc3545768302dda643]

Tomoki Sekiyama (1):
      drivers/tty/hvc: don't free hvc_console_setup after init
         [501fed45b7e8836ee9373f4d31e2d85e3db6103a]

Toshiaki Makita (1):
      bridge: Handle IFLA_ADDRESS correctly when creating  bridge device
         [30313a3d5794472c3548d7288e306a5492030370]

Trond Myklebust (2):
      NFSd: Move default initialisers from create_client() to alloc_client()
         [5694c93e6c4954fa9424c215f75eeb919bddad64]
      NFSd: call rpc_destroy_wait_queue() from free_client()
         [4cb57e3032d4e4bf5e97780e9907da7282b02b0c]

Tyler Stachecki (1):
      [SCSI] mpt2sas: Don't disable device twice at suspend.
         [af61e27c3f77c7623b5335590ae24b6a5c323e22]

Victor A. Santos (1):
      USB: Nokia 305 should be treated as unusual dev
         [f0ef5d41792a46a1085dead9dfb0bdb2c574638e]

Viresh Kumar (1):
      hrtimer: Set expiry time before switch_hrtimer_base()
         [84ea7fe37908254c3bd90910921f6e1045c1747a]

Vlad Yasevich (1):
      Revert "macvlan : fix checksums error when we are in  bridge mode"
         [f114890cdf84d753f6b41cd0cc44ba51d16313da]

Wenkai Du (1):
      i2c: designware: Mask all interrupts during i2c controller enable
         [47bb27e78867997040a228328f2a631c3c7f2c82]

Xiaoming Wang (1):
      net: ipv4: current group_info should be put after  using.
         [b04c46190219a4f845e46a459e3102137b7f6cac]

Xufeng Zhang (1):
      sctp: reset flowi4_oif parameter on route lookup
         [85350871317a5adb35519d9dc6fc9e80809d42ad]

 Documentation/input/elantech.txt            |   5 +-
 Makefile                                    |   4 +-
 arch/powerpc/lib/crtsavres.S                | 186 ++++++++++++++++++++++
 arch/x86/include/asm/hugetlb.h              |   1 +
 arch/x86/kernel/ldt.c                       |   4 +-
 arch/x86/vdso/vdso32-setup.c                |   8 +
 drivers/acpi/ec.c                           |  77 ++++++++-
 drivers/atm/ambassador.c                    |   2 +-
 drivers/atm/idt77252.c                      |   2 +-
 drivers/bluetooth/ath3k.c                   |   2 +
 drivers/bluetooth/btusb.c                   |   1 +
 drivers/crypto/caam/error.c                 |  10 +-
 drivers/dma/mv_xor.c                        |   8 +-
 drivers/gpu/drm/nouveau/nouveau_acpi.c      |   3 -
 drivers/gpu/drm/radeon/radeon_bios.c        |  14 ++
 drivers/gpu/drm/radeon/radeon_object.c      |  38 +++--
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c     |  22 +++
 drivers/hid/hid-ids.h                       |   7 +
 drivers/hid/usbhid/hid-quirks.c             |   5 +
 drivers/hwmon/emc1403.c                     |   4 +-
 drivers/i2c/busses/i2c-designware-core.c    |   3 +
 drivers/i2c/busses/i2c-s3c2410.c            |   2 +-
 drivers/input/mouse/elantech.c              |  26 ++-
 drivers/input/mouse/elantech.h              |   1 +
 drivers/input/mouse/synaptics.c             |   8 +
 drivers/md/md.c                             |   3 +-
 drivers/media/media-device.c                |   1 +
 drivers/media/video/ov7670.c                |   2 +-
 drivers/media/video/v4l2-compat-ioctl32.c   |  12 +-
 drivers/net/bonding/bond_main.c             |   1 +
 drivers/net/can/sja1000/peak_pci.c          |  31 ++--
 drivers/net/ethernet/broadcom/tg3.c         |   4 +-
 drivers/net/macvlan.c                       |   9 +-
 drivers/net/wimax/i2400m/usb-rx.c           |   2 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c     |  22 +--
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c |  17 +-
 drivers/pci/hotplug/shpchp_ctrl.c           |   4 +-
 drivers/platform/x86/thinkpad_acpi.c        |   2 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c        |   1 -
 drivers/staging/octeon/ethernet-tx.c        |   2 +-
 drivers/tty/hvc/hvc_console.c               |   2 +-
 drivers/usb/storage/shuttle_usbat.c         |   2 +-
 drivers/usb/storage/unusual_devs.h          |  14 ++
 drivers/video/tgafb.c                       |  15 +-
 fs/nfsd/nfs4acl.c                           |  17 +-
 fs/nfsd/nfs4state.c                         |  40 +++--
 fs/posix_acl.c                              |   6 +
 include/linux/ftrace.h                      |   2 +
 include/linux/kvm_host.h                    |   1 -
 include/linux/skbuff.h                      |  12 +-
 include/net/ip6_route.h                     |   5 +
 include/trace/events/module.h               |   2 +-
 kernel/events/core.c                        |  16 +-
 kernel/futex.c                              | 239 ++++++++++++++++++++++------
 kernel/hrtimer.c                            |  30 +++-
 kernel/module.c                             |   3 +
 kernel/sched_cpupri.c                       |   3 +-
 kernel/timer.c                              |   2 +-
 kernel/trace/ftrace.c                       |  27 +---
 kernel/tracepoint.c                         |   6 +
 mm/memory-failure.c                         |  17 +-
 mm/page-writeback.c                         |   4 +-
 net/bluetooth/hci_conn.c                    |   9 +-
 net/bridge/br_netlink.c                     |  15 ++
 net/bridge/netfilter/ebtables.c             |   5 +-
 net/ceph/messenger.c                        |  39 ++++-
 net/core/dev.c                              |   1 +
 net/core/filter.c                           |   6 +-
 net/core/rtnetlink.c                        |  33 ++--
 net/core/skbuff.c                           |  21 +--
 net/ipv4/fib_semantics.c                    |   2 +-
 net/ipv4/ip_forward.c                       |   4 +-
 net/ipv4/netfilter/arp_tables.c             |   6 +-
 net/ipv4/netfilter/ip_tables.c              |   6 +-
 net/ipv4/ping.c                             |  15 +-
 net/ipv4/route.c                            |   2 +-
 net/ipv4/tcp_cubic.c                        |   2 +-
 net/ipv6/netfilter/ip6_tables.c             |   6 +-
 net/ipv6/route.c                            |   5 +-
 net/l2tp/l2tp_ppp.c                         |   4 +-
 net/sched/act_mirred.c                      |  11 +-
 net/sctp/protocol.c                         |   7 +-
 scripts/mod/modpost.c                       |   8 +-
 virt/kvm/async_pf.c                         |  14 +-
 84 files changed, 962 insertions(+), 280 deletions(-)

-- 
Ben Hutchings
Knowledge is power.  France is bacon.

