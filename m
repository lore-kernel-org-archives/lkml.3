Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649Ab3HMP63 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 11:58:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4969 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758457Ab3HMP6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:58:25 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=eIhxMilvRf8A:10 a=4NfZCxiLN3QA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=GnT3LFsvGa8A:10 a=a_RxaNBUchYvjmN8jIEA:9 a=4N01o73a8FBKWY66:21 a=4ZqVUA9gzVOY-WKr:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155654.069291373@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:56:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [00/88] 3.6.11.7-rc1-stable review
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Note, this will be the last release that I maintain for the 3.6 stable tree.

This is the start of the stable review cycle for 3.6.11.7-rc1 release.
There are 88 patches in this series, which will be posted as responses
to this one. If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Aug 16, 2013.
Anything received after that time might be too late.

Aaron Lu (1):
      libata-acpi: add back ACPI based hotplug functionality
         [44521527be36172864e6e7a6fba4b66e9aa48e40]

Al Viro (1):
      ext3,ext4: don't mess with dir_file->f_pos in htree_dirblock_to_tree()
         [64cb927371cd2ec43758d8a094a003d27bc3d0dc]

Alex Deucher (1):
      drm/radeon: prevent crash in the ring space allocation
         [fd5d93a0015ce1a7db881382022b2fcdfdc61760]

Anders Hammarquist (1):
      USB: serial: ti_usb_3410_5052: new device id for Abbot strip port cable
         [35a2fbc941accd0e9f1bfadd669311786118d874]

Anderson Lizardo (1):
      Bluetooth: Fix crash in l2cap_build_cmd() with small MTU
         [300b962e5244a1ea010df7e88595faa0085b461d]

Andy Lutomirski (2):
      net: Unbreak compat_sys_{send,recv}msg
         [a7526eb5d06b0084ef12d7b168d008fcf516caab]
      net: Block MSG_CMSG_COMPAT in send(m)msg and recv(m)msg
         [1be374a0518a288147c6a7398792583200a67261]

Artem Bityutskiy (2):
      UBIFS: fix a horrid bug
         [605c912bb843c024b1ed173dc427cd5c08e5d54d]
      UBIFS: prepare to fix a horrid bug
         [33f1a63ae84dfd9ad298cf275b8f1887043ced36]

Axel Lin (1):
      drivers/rtc/rtc-rv3029c2.c: fix disabling AIE irq
         [29ecd78c0fd6ee05f2c6b07b23823a6ae43c13ff]

Bart Van Assche (1):
      timer: Fix jiffies wrap behavior of round_jiffies_common()
         [9e04d3804d3ac97d8c03a41d78d0f0674b5d01e1]

Bartlomiej Zolnierkiewicz (1):
      drivers/dma/pl330.c: fix locking in pl330_free_chan_resources()
         [da331ba8e9c5de72a27e50f71105395bba6eebe0]

Ben Hutchings (2):
      genirq: Fix can_request_irq() for IRQs without an action
         [2779db8d37d4b542d9ca2575f5f178dbeaca6c86]
      sd: Fix parsing of 'temporary ' cache mode prefix
         [2ee3e26c673e75c05ef8b914f54fadee3d7b9c88]

Chris Metcalf (1):
      tilepro: work around module link error with gcc 4.7
         [3cb3f839d306443f3d1e79b0bde1a2ad2c12b555]

Christian Lamparter (1):
      carl9170: fix frame drop and WARN due to minstrel_ht change
         [5f34608fa2acbfef5a06d0072a978c9943c28a2d]

Clemens Ladisch (1):
      ALSA: usb-audio: work around Android accessory firmware bug
         [342cda29343a6272c630f94ed56810a76740251b]

Daniel Borkmann (2):
      packet: packet_getname_spkt: make sure string is always 0-terminated
         [2dc85bf323515e59e15dfa858d1472bb25cad0fe]
      net: sctp: fix NULL pointer dereference in socket destruction
         [1abd165ed757db1afdefaac0a4bc8a70f97d258c]

Eric Dumazet (5):
      net: force a reload of first item in hlist_nulls_for_each_entry_rcu
         [c87a124a5d5e8cf8e21c4363c3372bcaf53ea190]
      ip_tunnel: fix kernel panic with icmp_dest_unreach
         [a622260254ee481747cceaaa8609985b29a31565]
      tcp: xps: fix reordering issues
         [547669d483e5783d722772af1483fa474da7caf9]
      ipv6: fix possible crashes in ip6_cork_release()
         [284041ef21fdf2e0d216ab6b787bc9072b4eb58a]
      tcp: fix tcp_md5_hash_skb_data()
         [54d27fcb338bd9c42d1dfc5a39e18f6f9d373c2e]

Federico Vaga (1):
      net/core/sock.c: add missing VSOCK string in af_family_*_key_strings
         [456db6a4d495f40777da6f1f32f62f13026f52db]

Ferruh Yigit (1):
      Input: cyttsp - fix memcpy size param
         [d2983cdb480157f637df07723f28aaa657b1080d]

Gao feng (1):
      ipv6: assign rt6_info to inet6_ifaddr in init_loopback
         [534c877928a16ae5f9776436a497109639bf67dc]

George Cherian (1):
      usb: host: xhci-plat: release mem region while removing module
         [5388a3a5faba8dfa69e5f06c3a415d373c1a4316]

Giuseppe CAVALLARO (1):
      net: phy: fix a bug when verify the EEE support
         [9a9c56cb34e65000d1f0a4b7553399bfcf7c5a52]

Greg Kroah-Hartman (1):
      MAINTAINERS: add stable_kernel_rules.txt to stable maintainer information
         [7b175c46720f8e6b92801bb634c93d1016f80c62]

Guillaume Nault (2):
      l2tp: Fix sendmsg() return value
         [a6f79d0f26704214b5b702bbac525cb72997f984]
      l2tp: Fix PPP header erasure and memory leak
         [55b92b7a11690bc377b5d373872a6b650ae88e64]

Herbert Xu (1):
      crypto: algboss - Hold ref count on larval
         [939e17799619e31331d2433041196529515a86a6]

J. Bruce Fields (1):
      nfsd4: fix decoding of compounds across page boundaries
         [247500820ebd02ad87525db5d9b199e5b66f6636]

Jan Kara (2):
      ext4: fix overflow when counting used blocks on 32-bit architectures
         [8af8eecc1331dbf5e8c662022272cf667e213da5]
      ext4: fix data offset overflow in ext4_xattr_fiemap() on 32-bit archs
         [a60697f411eb365fb09e639e6f183fe33d1eb796]

Jason Wang (1):
      drivers: hv: switch to use mb() instead of smp_mb()
         [35848f68b07df3f917cb13fc3c134718669f569b]

Jerome Glisse (1):
      drm/radeon: update lockup tracking when scheduling in empty ring
         [8444d5c69549aa0f0b574cc608742d4669e1cc01]

Jiang Liu (1):
      PCI: Fix refcount issue in pci_create_root_bus() error recovery path
         [343df771e671d821478dd3ef525a0610b808dbf8]

Jiri Pirko (2):
      team: move add to port list before port enablement
         [72df935d985c1575ed44ad2c8c653b28147993fa]
      team: check return value of team_get_port_by_index_rcu() for NULL
         [76c455decbbad31de21c727edb184a963f42b40b]

Joachim Eastwood (1):
      pcmcia: at91_cf: fix gpio_get_value in at91_cf_get_status
         [e39506b466edcda2a7e9d0174d7987ae654137b7]

Jonathan Salwan (1):
      drivers/cdrom/cdrom.c: use kzalloc() for failing hardware
         [542db01579fbb7ea7d1f7bb9ddcef1559df660b2]

Junxiao Bi (1):
      ocfs2: xattr: fix inlined xattr reflink
         [ef962df057aaafd714f5c22ba3de1be459571fdf]

Jörn Engel (1):
      target/iscsi: don't corrupt bh_count in iscsit_stop_time2retain_timer()
         [574780fd5e6ec52bd43e0bdb777a19e4c4c6aa9c]

Kees Cook (3):
      crypto: sanitize argument for format string
         [1c8fca1d92e14859159a82b8a380d220139b7344]
      block: do not pass disk names as format strings
         [ffc8b30866879ed9ba62bd0a86fecdbd51cd3d19]
      charger-manager: Ensure event is not used as format string
         [3594f4c0d7bc51e3a7e6d73c44e368ae079e42f3]

Lai Jiangshan (1):
      clk: remove notifier from list before freeing it
         [72b5322f11ff0abf6a52b3007486656578d2c982]

Larry Finger (1):
      rtlwifi: rtl8192cu: Fix duplicate if test
         [10d0b9030a3f86e1e26c710c7580524d7787d688]

Laszlo Ersek (1):
      xen/time: remove blocked time accounting from xen "clockchip"
         [0b0c002c340e78173789f8afaa508070d838cf3d]

Li Zefan (1):
      cgroup: fix umount vs cgroup_event_remove() race
         [1c8158eeae0f37d0eee9f1fbe68080df6a408df2]

Lv Zheng (1):
      ACPICA: Do not use extended sleep registers unless HW-reduced bit is set
         [7cec7048fe22e3e92389da2cd67098f6c4284e7f]

Mathias Nyman (1):
      xhci: check for failed dma pool allocation
         [025f880cb2e4d7218d0422d4b07bea1a68959c38]

Michal Kubecek (1):
      ipv4: fix redirect handling for TCP packets
         [f96ef988cc603487c03a6de07807b06cbe641829]

Mikulas Patocka (1):
      hpfs: better test for errors
         [3ebacb05044f82c5f0bb456a894eb9dc57d0ed90]

Nandita Dukkipati (1):
      tcp: bug fix in proportional rate reduction.
         [35f079ebbc860dcd1cca70890c9c8d59c1145525]

Neil Horman (2):
      iommu/vt-d: add quirk for broken interrupt remapping on 55XX chipsets
         [03bbcb2e7e292838bb0244f5a7816d194c911d62]
      sctp: fully initialize sctp_outq in sctp_outq_init
         [c5c7774d7eb4397891edca9ebdf750ba90977a69]

Nikolay Martynov (1):
      iwlwifi: dvm: fix chain noise calibration
         [b28b6dfe580ab1ab8bf08b908fd69e299b877103]

Oleg Nesterov (1):
      hw_breakpoint: Use cpu_possible_mask in {reserve,release}_bp_slot()
         [c790b0ad23f427c7522ffed264706238c57c007e]

Paul Clements (1):
      nbd: correct disconnect behavior
         [c378f70adbc1bbecd9e6db145019f14b2f688c7c]

Paul Moore (1):
      netlabel: improve domain mapping validation
         [6b21e1b77d1a3d58ebfd513264c885695e8a0ba5]

Peter Zijlstra (2):
      perf: Fix mmap() accounting hole
         [9bb5d40cd93c9dd4be74834b1dcb1ba03629716b]
      perf: Fix perf mmap bugs
         [26cb63ad11e04047a64309362674bcbbd6a6f246]

Randy Dunlap (1):
      x86: fix build error and kconfig for ia32_emulation and binfmt
         [d1603990ea626668c78527376d9ec084d634202d]

Roland Dreier (1):
      tcm_qla2xxx: Fix residual for underrun commands that fail
         [b5aff3d2747bea08b386edd070941a45611ffe51]

Shane Huang (1):
      ahci: remove pmp link online check in FBS EH
         [912b9ac683b112615d5605686f1dc086402ce9f7]

Simon Baatz (2):
      ARM: 7772/1: Fix missing flush_kernel_dcache_page() for noMMU
         [63384fd0b1509acf522a8a8fcede09087eedb7df]
      ARM: 7755/1: handle user space mapped pages in flush_kernel_dcache_page
         [1bc39742aab09248169ef9d3727c9def3528b3f3]

Stephane Eranian (1):
      perf: Disable monitoring on setuid processes for regular users
         [2976b10f05bd7f6dab9f9e7524451ddfed656a89]

Steve French (2):
      Handle big endianness in NTLM (ntlmv2) authentication
         [fdf96a907c1fbb93c633e2b7ede3b8df26d6a4c0]
      use sensible file nlink values if unprovided
         [6658b9f70ebca5fc0795b1d6d733996af1e2caa7]

Sujith Manoharan (1):
      ath9k_htc: Handle IDLE state transition properly
         [075163bbb0f51174359947e1bce84f5edb23f21e]

Takashi Iwai (1):
      ALSA: usb-audio: Fix invalid volume resolution for Logitech HD Webcam c310
         [36691e1be6ec551eef4a5225f126a281f8c051c2]

Theodore Ts'o (3):
      ext4: don't allow ext4_free_blocks() to fail due to ENOMEM
         [e7676a704ee0a1ef71a6b23760b5a8f6896cb1a1]
      jbd2: fix theoretical race in jbd2__journal_restart
         [39c04153fda8c32e85b51c96eb5511a326ad7609]
      jbd2: move superblock checksum calculation to jbd2_write_superblock()
         [fe52d17cdd343ac43c85cf72940a58865b9d3bfb]

Tyler Hicks (1):
      libceph: Fix NULL pointer dereference in auth client code
         [2cb33cac622afde897aa02d3dcd9fbba8bae839e]

UCHINO Satoshi (1):
      usb: gadget: f_mass_storage: add missing memory barrier for thread_wakeup_needed
         [d68c277b501889b3a50c179d1c3d704db7947b83]

Wanpeng Li (1):
      mm/memory-hotplug: fix lowmem count overflow when offline pages
         [cea27eb2a202959783f81254c48c250ddd80e129]

Wei Yongjun (1):
      gianfar: add missing iounmap() on error in gianfar_ptp_probe()
         [e5f5e380e0f3bb11f04ca5bc66a551e58e0ad26e]

Yoshihiro Shimoda (1):
      net: sh_eth: fix incorrect RX length error if R8A7740
         [dd019897358b815f7828dab90b51d51df4d3658d]

Zefan Li (2):
      dlci: validate the net device in dlci_del()
         [578a1310f2592ba90c5674bca21c1dbd1adf3f0a]
      dlci: acquire rtnl_lock before calling __dev_get_by_name()
         [11eb2645cbf38a08ae491bf6c602eea900ec0bb5]

Zhang Yi (1):
      futex: Take hugepages into account when generating futex_key
         [13d60f4b6ab5b702dc8d2ee20999f98a93728aec]

Zhanghaoyu (A) (1):
      KVM: x86: remove vcpu's CPL check in host-invoked XCR set
         [764bcbc5a6d7a2f3e75c9f0e4caa984e2926e346]

stephen hemminger (1):
      8139cp: reset BQL when ring tx ring cleared
         [98962baad72fd6d393bf39dbb7c2076532c363c6]

----
 MAINTAINERS                                   |    1 +
 arch/arm/include/asm/cacheflush.h             |    4 +-
 arch/arm/mm/flush.c                           |   33 ++++
 arch/arm/mm/nommu.c                           |    6 +
 arch/tile/lib/exports.c                       |    2 +
 arch/x86/Kconfig                              |    1 +
 arch/x86/include/asm/irq_remapping.h          |    2 +
 arch/x86/kernel/early-quirks.c                |   20 +++
 arch/x86/kvm/x86.c                            |    5 +-
 arch/x86/xen/time.c                           |   17 +-
 block/genhd.c                                 |    2 +-
 crypto/algapi.c                               |    3 +-
 crypto/algboss.c                              |   15 +-
 crypto/api.c                                  |    6 -
 crypto/internal.h                             |    6 +
 drivers/acpi/acpica/hwxfsleep.c               |    8 +-
 drivers/ata/libahci.c                         |    3 +-
 drivers/ata/libata-acpi.c                     |   35 +++-
 drivers/ata/libata-core.c                     |    2 +
 drivers/ata/libata.h                          |    2 +
 drivers/block/nbd.c                           |    9 +-
 drivers/cdrom/cdrom.c                         |    2 +-
 drivers/clk/clk.c                             |    1 +
 drivers/dma/pl330.c                           |    4 +-
 drivers/gpu/drm/radeon/radeon_ring.c          |   10 ++
 drivers/hv/ring_buffer.c                      |    2 +-
 drivers/hv/vmbus_drv.c                        |    2 +-
 drivers/input/touchscreen/cyttsp_core.c       |    2 +-
 drivers/iommu/intel_irq_remapping.c           |   10 ++
 drivers/iommu/irq_remapping.c                 |    6 +
 drivers/iommu/irq_remapping.h                 |    1 +
 drivers/net/ethernet/freescale/gianfar_ptp.c  |    1 +
 drivers/net/ethernet/realtek/8139cp.c         |    1 +
 drivers/net/ethernet/renesas/sh_eth.c         |   15 +-
 drivers/net/phy/phy.c                         |    2 +-
 drivers/net/team/team.c                       |    2 +-
 drivers/net/team/team_mode_roundrobin.c       |    2 +
 drivers/net/wan/dlci.c                        |   26 ++-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    2 +-
 drivers/net/wireless/ath/carl9170/tx.c        |   69 +++-----
 drivers/net/wireless/iwlwifi/dvm/rxon.c       |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c   |    2 +-
 drivers/pci/probe.c                           |    8 +-
 drivers/pcmcia/at91_cf.c                      |    4 +-
 drivers/power/charger-manager.c               |    2 +-
 drivers/rtc/rtc-rv3029c2.c                    |    2 +-
 drivers/scsi/osd/osd_uld.c                    |    2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c            |    6 +-
 drivers/scsi/sd.c                             |    2 +-
 drivers/target/iscsi/iscsi_target_erl0.c      |    4 +-
 drivers/usb/gadget/f_mass_storage.c           |    2 +
 drivers/usb/host/xhci-mem.c                   |    4 +
 drivers/usb/host/xhci-plat.c                  |    1 +
 drivers/usb/serial/ti_usb_3410_5052.c         |    3 +-
 drivers/usb/serial/ti_usb_3410_5052.h         |    4 +-
 fs/cifs/cifs_unicode.h                        |    8 +-
 fs/cifs/cifsencrypt.c                         |    6 +-
 fs/cifs/inode.c                               |    5 +
 fs/exec.c                                     |   16 +-
 fs/ext3/namei.c                               |    7 +-
 fs/ext4/extents.c                             |    4 +-
 fs/ext4/inode.c                               |    4 +-
 fs/ext4/mballoc.c                             |   11 +-
 fs/ext4/namei.c                               |    7 +-
 fs/hpfs/map.c                                 |    3 +-
 fs/hpfs/super.c                               |    8 +-
 fs/jbd2/journal.c                             |    3 +-
 fs/jbd2/transaction.c                         |    2 +-
 fs/nfsd/nfs4xdr.c                             |    2 +-
 fs/ocfs2/xattr.c                              |   10 ++
 fs/ubifs/dir.c                                |   54 ++++--
 include/linux/hugetlb.h                       |   16 ++
 include/linux/nbd.h                           |    1 +
 include/linux/perf_event.h                    |    3 +-
 include/linux/rculist_nulls.h                 |    7 +-
 include/linux/socket.h                        |    3 +
 kernel/cgroup.c                               |   25 ++-
 kernel/events/core.c                          |  233 +++++++++++++++++--------
 kernel/events/hw_breakpoint.c                 |    4 +-
 kernel/events/internal.h                      |    4 +
 kernel/futex.c                                |    3 +-
 kernel/irq/manage.c                           |    6 +-
 kernel/timer.c                                |    8 +-
 mm/hugetlb.c                                  |   17 ++
 mm/page_alloc.c                               |    4 +
 net/bluetooth/l2cap_core.c                    |    3 +
 net/ceph/auth_none.c                          |    6 +
 net/compat.c                                  |   13 +-
 net/core/sock.c                               |    6 +-
 net/ipv4/ip_gre.c                             |    2 +-
 net/ipv4/ipip.c                               |    2 +-
 net/ipv4/route.c                              |    7 +-
 net/ipv4/tcp.c                                |    7 +-
 net/ipv4/tcp_input.c                          |   23 +--
 net/ipv4/tcp_output.c                         |   10 +-
 net/ipv6/addrconf.c                           |    4 +-
 net/ipv6/ip6_output.c                         |    2 +-
 net/l2tp/l2tp_ppp.c                           |    6 +-
 net/netlabel/netlabel_domainhash.c            |   69 ++++++++
 net/packet/af_packet.c                        |    5 +-
 net/sctp/outqueue.c                           |    6 +-
 net/sctp/socket.c                             |    6 +
 net/socket.c                                  |   61 +++++--
 sound/usb/card.c                              |   22 ++-
 sound/usb/mixer.c                             |    1 +
 105 files changed, 818 insertions(+), 317 deletions(-)
