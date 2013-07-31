Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759975Ab3GaNaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:30:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46864 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752723Ab3GaN0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:26:07 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org
Date: Wed, 31 Jul 2013 15:23:09 +0200
Message-ID: <lsq.1375276989.251749228@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [00/84] 3.2.50-rc1 review
X-SA-Exim-Connect-IP: 151.216.67.181
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.50 release.
There are 84 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Aug 02 17:00:00 UTC 2013.
Anything received after that time might be too late.

A combined patch relative to 3.2.49 will be posted as an additional
response to this.  A shortlog and diffstat can be found below.

Ben.

-------------

Aaro Koskinen (1):
      ARM: OMAP: RX-51: change probe order of touchscreen and panel SPI devices
         [e65f131a14726e5f1b880a528271a52428e5b3a5]

Aaron Plattner (1):
      ALSA: hda - Add new GPU codec ID to snd-hda
         [d52392b1a80458c0510810789c7db4a39b88022a]

Alex Deucher (1):
      drm/radeon: improve dac adjust heuristics for legacy pdac
         [03ed8cf9b28d886c64c7e705c7bb1a365fd8fb95]

Alexandr "Sky" Ivanov (1):
      USB: option: add D-Link DWM-152/C1 and DWM-156/C1
         [ca24763588844b14f019ffc45c7df6d9e8f932c5]

Amerigo Wang (1):
      ipv6,mcast: always hold idev->lock before mca_lock
         [8965779d2c0e6ab246c82a405236b1fb2adae6b2,
          b7b1bfce0bb68bd8f6e62a28295922785cc63781]

Andi Kleen (1):
      [SCSI] Fix incorrect memset in bnx2fc_parse_fcp_rsp
         [16da05b1158d1bcb31656e636a8736a663b1cf1f]

Anton Blanchard (1):
      powerpc/modules: Module CRC relocation fix causes perf issues
         [0e0ed6406e61434d3f38fb58aa8464ec4722b77e]

Barry Grussling (1):
      usb: cp210x support SEL C662 Vendor/Device
         [b579fa52f6be0b4157ca9cc5e94d44a2c89a7e95]

Bjørn Mork (1):
      usb: option: add TP-LINK MA260
         [94190301ffa059c2d127b3a67ec5d161d5c62681]

Bob Picco (1):
      sparc64 address-congruence property
         [771a37ff4d80b80db3b0df3e7696f14b298c67b7]

Changli Gao (1):
      net: Swap ver and type in pppoe_hdr
         [b1a5a34bd0b8767ea689e68f8ea513e9710b671e]

Chih-Chung Chang (1):
      ASoC: max98088 - fix element type of the register cache.
         [cb6f66a2d278e57a6c9d8fb59bd9ebd8ab3965c2]

Dan Carpenter (1):
      fanotify: info leak in copy_event_to_user()
         [de1e0c40aceb9d5bff09c3a3b97b2f1b178af53f]

Dan Williams (1):
      usb: serial: option: add Olivetti Olicard 200
         [4cf76df06ecc852633ed927d91e01c83c33bc331]

Daniil Bolsun (1):
      USB: option: append Petatel NP10T device to GSM modems list
         [c38e83b6cc2adf80e3f091fd92cfbeacc9748347]

Dave Jones (1):
      x25: Fix broken locking in ioctl error paths.
         [4ccb93ce7439b63c31bc7597bfffd13567fa483d]

Dave Kleikamp (2):
      sparc: tsb must be flushed before tlb
         [23a01138efe216f8084cfaa74b0b90dd4b097441]
      sunvnet: vnet_port_remove must call unregister_netdev
         [aabb9875d02559ab9b928cd6f259a5cc4c21a589]

David Jeffery (1):
      lockd: protect nlm_blocked access in nlmsvc_retry_blocked
         [1c327d962fc420aea046c16215a552710bde8231]

Dingtianhong (3):
      dummy: fix oops when loading the dummy failed
         [2c8a01894a12665d8059fad8f0a293c98a264121]
      ifb: fix oops when loading the ifb failed
         [f2966cd5691058b8674a20766525bedeaea9cbcf]
      ifb: fix rcu_sched self-detected stalls
         [440d57bc5ff55ec1efb3efc9cbe9420b4bbdfefa]

Eldad Zack (1):
      ALSA: usb-audio: 6fire: return correct XRUN indication
         [be2f93a4c4981b3646b6f98f477154411b8516cb]

Enrico Mioso (3):
      usb: serial: option.c: remove ONDA MT825UP product ID fromdriver
         [878c69aae986ae97084458c0183a8c0a059865b1]
      usb: serial: option: Add ONYX 3G device support
         [63b5df963f52ccbab6fabedf05b7ac6b465789a4]
      usb: serial: option: blacklist ONDA MT689DC QMI interface
         [3d1a69e726406ab662ab88fa30a3a05ed404334d]

Eric Dumazet (3):
      ipv6: ip6_sk_dst_check() must not assume ipv6 dst
         [a963a37d384d71ad43b3e9e79d68d42fbe0901f3]
      neighbour: fix a race in neigh_destroy()
         [c9ab4d85de222f3390c67aedc9c18a50e767531e]
      vlan: fix a race in egress prio management
         [3e3aac497513c669e1c62c71e1d552ea85c1d974]

Ewan D. Milne (1):
      [SCSI] sd: fix crash when UA received on DIF enabled device
         [085b513f97d8d799d28491239be4b451bcd8c2c5]

Fabio Estevam (2):
      ASoC: sglt5000: Fix SGTL5000_PLL_FRAC_DIV_MASK
         [5c78dfe87ea04b501ee000a7f03b9432ac9d008c]
      ASoC: sglt5000: Fix the default value of CHIP_SSS_CTRL
         [016fcab8ff46fca29375d484226ec91932aa4a07]

Felipe Balbi (1):
      usb: dwc3: gadget: don't prevent gadget from being probed if we fail
         [cdcedd6981194e511cc206887db661d016069d68]

Gao feng (1):
      ipv6: don't call addrconf_dst_alloc again when enable  lo
         [a881ae1f625c599b460cc8f8a7fcb1c438f699ad]

George Cherian (1):
      usb: host: xhci: Enable XHCI_SPURIOUS_SUCCESS for all controllers with xhci 1.0
         [07f3cb7c28bf3f4dd80bfb136cf45810c46ac474]

Hannes Frederic Sowa (2):
      ipv6: call udp_push_pending_frames when uncorking a  socket with AF_INET pending data
         [8822b64a0fa64a5dd1dfcf837c5b0be83f8c05d1]
      ipv6: ip6_append_data_mtu did not care about pmtudisc  and frag_size
         [75a493e60ac4bbe2e977e7129d6d8cbb0dd236be]

Harshula Jayasuriya (1):
      nfsd: nfsd_open: when dentry_open returns an error do not propagate as struct file
         [e4daf1ffbe6cc3b12aab4d604e627829e93e9914]

Huang Rui (1):
      usb: dwc3: fix wrong bit mask in dwc3_event_type
         [1974d494dea05ea227cb42f5e918828801e237aa]

Ian Abbott (2):
      staging: comedi: COMEDI_CANCEL ioctl should wake up read/write
         [69acbaac303e8cb948801a9ddd0ac24e86cc4a1b]
      staging: comedi: fix a race between do_cmd_ioctl() and read/write
         [4b18f08be01a7b3c7b6df497137b6e3cb28adaa3]

Jan Beulich (1):
      xen/io/ring.h: new macro to detect whether there are too many requests on the ring
         [8d9256906a97c24e97e016482b9be06ea2532b05]

Jason Wang (1):
      macvtap: correctly linearize skb when zerocopy is used
         [61d46bf979d5cd7c164709a80ad5676a35494aae]

Jeff Skirvin (1):
      [SCSI] isci: Fix a race condition in the SSP task management path
         [96f15f29038e58e1b0a96483e2b369ff446becf1]

Johan Hovold (2):
      USB: mos7840: fix memory leak in open
         [5f8a2e68b679b41cc8e9b642f2f5aa45dd678641]
      USB: ti_usb_3410_5052: fix dynamic-id matching
         [1fad56424f5ad3ce4973505a357212b2e2282b3f]

Josef Bacik (2):
      Btrfs: fix lock leak when resuming snapshot deletion
         [fec386ac1428f9c0e672df952cbca5cebd4e4e2f]
      Btrfs: re-add root to dead root list if we stop dropping it
         [d29a9f629e009c9b90e5859bce581070fd6247fc]

Jóhann B . Guðmundsson (1):
      USB: misc: Add Manhattan Hi-Speed USB DVI Converter to sisusbvga
         [58fc90db8261b571c026bb8bf23aad48a7233118]

Konrad Rzeszutek Wilk (1):
      xen/blkback: Check for insane amounts of request on the ring (v6).
         [8e3f8755545cc4a7f4da8e9ef76d6d32e0dca576]

Lan Tianyu (1):
      ACPI / video: ignore BIOS initial backlight value for Fujitsu E753
         [9657a565a476d517451c10b0bcc106e300785aff]

Linus Lüssing (1):
      bridge: fix switched interval for MLD Query types
         [32de868cbc6bee010d2cee95b5071b25ecbec8c3]

Luiz Angelo Daros de Luca (1):
      usb: serial: cp210x: Add USB ID for Netgear Switches embedded serial adapter
         [90625070c4253377025878c4e82feed8b35c7116]

Mark Kettenis (1):
      drm/radeon: fix combios tables on older cards
         [cef1d00cd56f600121ad121875655ad410a001b8]

Mathias Krause (1):
      af_key: fix info leaks in notify messages
         [a5cc68f3d63306d0d288f31edfc2ae6ef8ecd887]

Michael S . Tsirkin (2):
      virtio: support unlocked queue poll
         [cc229884d3f77ec3b1240e467e0236c3e0647c0c]
      virtio_net: fix race in RX VQ processing
         [cbdadbbf0c790f79350a8f36029208944c5487d0]

Michael S. Tsirkin (1):
      macvtap: fix recovery from gup errors
         [4c7ab054ab4f5d63625508ed6f8a607184cae7c2]

Neil Horman (2):
      atl1e: fix dma mapping warnings
         [352900b583b2852152a1e05ea0e8b579292e731e]
      atl1e: unmap partially mapped skb on dma error and  free skb
         [584ec4355355ffac43571b02a314d43eb2f7fcbf]

Oleksij Rempel (1):
      xhci: fix null pointer dereference on ring_doorbell_for_active_rings
         [d66eaf9f89502971fddcb0de550b01fa6f409d83]

Olivier DANET (1):
      sparc32: vm_area_struct access for old Sun SPARCs.
         [961246b4ed8da3bcf4ee1eb9147f341013553e3c]

Ondrej Zary (1):
      drm/radeon: Another card with wrong primary dac adj
         [f7929f34fa0e0bb6736a2484fdc07d77a1653081]

Ren Bigcren (1):
      USB: storage: Add MicroVault Flash Drive to unusual_devs
         [e7a6121f4929c17215f0cdca3726f4bf3e4e9529]

Sami Rahman (1):
      USB: cp210x: add MMB and PI ZigBee USB Device Support
         [7681156982026ebf7eafd7301eb0374d7648d068]

Sarah Sharp (1):
      xhci: Avoid NULL pointer deref when host dies.
         [203a86613fb3bf2767335659513fa98563a3eb71]

Sasha Levin (1):
      9p: fix off by one causing access violations and  memory corruption
         [110ecd69a9feea82a152bbf9b12aba57e6396883]

Saurav Kashyap (1):
      [SCSI] qla2xxx: Properly set the tagging for commands.
         [c3ccb1d7cf4c4549151876dd37c0944a682fd9e1]

Sergei Shtylyov (1):
      sh_eth: fix unhandled RFE interrupt
         [ca8c35852138ee0585eaffe6b9f10a5261ea7771]

Steven Rostedt (1):
      tracing: Use current_uid() for critical time tracing
         [f17a5194859a82afe4164e938b92035b86c55794]

Takashi Iwai (8):
      ALSA: 6fire: Fix unlocked snd_pcm_stop() call
         [5b9ab3f7324a1b94a5a5a76d44cf92dfeb3b5e80]
      ALSA: asihpi: Fix unlocked snd_pcm_stop() call
         [60478295d6876619f8f47f6d1a5c25eaade69ee3]
      ALSA: atiixp: Fix unlocked snd_pcm_stop() call
         [cc7282b8d5abbd48c81d1465925d464d9e3eaa8f]
      ALSA: pxa2xx: Fix unlocked snd_pcm_stop() call
         [46f6c1aaf790be9ea3c8ddfc8f235a5f677d08e2]
      ALSA: ua101: Fix unlocked snd_pcm_stop() call
         [9538aa46c2427d6782aa10036c4da4c541605e0e]
      ALSA: usx2y: Fix unlocked snd_pcm_stop() call
         [5be1efb4c2ed79c3d7c0cbcbecae768377666e84]
      ASoC: s6000: Fix unlocked snd_pcm_stop() call
         [61be2b9a18ec70f3cbe3deef7a5f77869c71b5ae]
      staging: line6: Fix unlocked snd_pcm_stop() call
         [86f0b5b86d142b9323432fef078a6cf0fb5dda74]

Theodore Ts'o (1):
      ext4: don't allow ext4_free_blocks() to fail due to ENOMEM
         [e7676a704ee0a1ef71a6b23760b5a8f6896cb1a1]

Toshi Kani (1):
      ACPI / memhotplug: Fix a stale pointer in error path
         [d19f503e22316a84c39bc19445e0e4fdd49b3532]

Wei Yongjun (1):
      l2tp: add missing .owner to struct pppox_proto
         [e1558a93b61962710733dc8c11a2bc765607f1cd]

William Gulland (1):
      usb: Clear both buffers when clearing a control transfer TT buffer.
         [2c7b871b9102c497ba8f972aa5d38532f05b654d]

Youquan Song (1):
      ata: Fix DVD not dectected at some platform with Wellsburg PCH
         [eac27f04a71e1f39f196f7e520d16dcefc955d77]

 Makefile                                        |   4 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c    |   4 +-
 arch/powerpc/include/asm/module.h               |   5 +-
 arch/powerpc/kernel/vmlinux.lds.S               |   3 -
 arch/sparc/kernel/asm-offsets.c                 |   2 +
 arch/sparc/mm/hypersparc.S                      |   8 +-
 arch/sparc/mm/init_64.c                         |   9 +-
 arch/sparc/mm/swift.S                           |   8 +-
 arch/sparc/mm/tlb.c                             |   2 +-
 arch/sparc/mm/tsunami.S                         |   6 +-
 arch/sparc/mm/viking.S                          |  10 +-
 drivers/acpi/acpi_memhotplug.c                  |   1 +
 drivers/acpi/video.c                            |   8 ++
 drivers/ata/ata_piix.c                          |   2 +-
 drivers/block/xen-blkback/blkback.c             |  13 +-
 drivers/block/xen-blkback/common.h              |   2 +
 drivers/block/xen-blkback/xenbus.c              |   2 +
 drivers/gpu/drm/radeon/radeon_combios.c         | 159 ++++++++----------------
 drivers/net/dummy.c                             |   4 +
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c |  50 +++++++-
 drivers/net/ethernet/renesas/sh_eth.c           |  17 +--
 drivers/net/ethernet/renesas/sh_eth.h           |   2 +-
 drivers/net/ethernet/sun/sunvnet.c              |   2 +
 drivers/net/ifb.c                               |   8 +-
 drivers/net/macvtap.c                           |  14 ++-
 drivers/net/virtio_net.c                        |   5 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c                 |   2 +-
 drivers/scsi/isci/task.c                        |   9 +-
 drivers/scsi/qla2xxx/qla_iocb.c                 |  11 +-
 drivers/scsi/sd.c                               |  22 ++--
 drivers/staging/comedi/comedi_fops.c            |  32 +++--
 drivers/staging/line6/pcm.c                     |   5 +-
 drivers/usb/core/hub.c                          |   9 ++
 drivers/usb/dwc3/core.h                         |   4 +-
 drivers/usb/dwc3/gadget.c                       |   1 +
 drivers/usb/host/xhci-pci.c                     |   1 -
 drivers/usb/host/xhci-ring.c                    |   2 +-
 drivers/usb/host/xhci.c                         |  13 +-
 drivers/usb/misc/sisusbvga/sisusb.c             |   1 +
 drivers/usb/serial/cp210x.c                     |   4 +
 drivers/usb/serial/mos7840.c                    |  26 ++--
 drivers/usb/serial/option.c                     |  23 ++--
 drivers/usb/serial/ti_usb_3410_5052.c           |   2 +-
 drivers/usb/storage/unusual_devs.h              |   7 ++
 drivers/virtio/virtio_ring.c                    |  59 +++++++--
 fs/btrfs/extent-tree.c                          |  13 ++
 fs/ext4/mballoc.c                               |  11 +-
 fs/lockd/svclock.c                              |   4 +
 fs/nfsd/vfs.c                                   |   5 +-
 fs/notify/fanotify/fanotify_user.c              |   1 +
 include/linux/if_pppox.h                        |   4 +-
 include/linux/virtio.h                          |   4 +
 include/net/addrconf.h                          |   3 +
 include/net/udp.h                               |   1 +
 include/xen/interface/io/ring.h                 |   5 +
 kernel/trace/trace.c                            |  10 +-
 net/8021q/vlan_dev.c                            |   7 ++
 net/9p/trans_common.c                           |  10 +-
 net/bridge/br_multicast.c                       |   5 +-
 net/core/neighbour.c                            |  12 +-
 net/ipv4/udp.c                                  |   3 +-
 net/ipv6/addrconf.c                             |  31 +++--
 net/ipv6/ip6_output.c                           |  24 ++--
 net/ipv6/mcast.c                                |  18 +--
 net/ipv6/udp.c                                  |   7 +-
 net/key/af_key.c                                |   2 +
 net/l2tp/l2tp_ppp.c                             |   3 +-
 net/x25/af_x25.c                                |  15 +--
 sound/arm/pxa2xx-pcm-lib.c                      |   2 +
 sound/pci/asihpi/asihpi.c                       |   3 +
 sound/pci/atiixp.c                              |   2 +
 sound/pci/atiixp_modem.c                        |   2 +
 sound/pci/hda/patch_hdmi.c                      |   4 +
 sound/soc/codecs/max98088.c                     |   2 +-
 sound/soc/codecs/sgtl5000.c                     |   2 +-
 sound/soc/codecs/sgtl5000.h                     |   2 +-
 sound/soc/s6000/s6000-pcm.c                     |   2 +
 sound/usb/6fire/pcm.c                           |  14 ++-
 sound/usb/misc/ua101.c                          |  14 ++-
 sound/usb/usx2y/usbusx2yaudio.c                 |   4 +
 80 files changed, 546 insertions(+), 288 deletions(-)

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus

