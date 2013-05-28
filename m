Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768Ab3E1EPG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 00:15:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52472 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758760Ab3E1Dyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:40 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org
Date: Tue, 28 May 2013 04:49:52 +0100
Message-ID: <lsq.1369712992.755341692@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [00/94] 3.2.46-rc1 review
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.46 release.
There are 94 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu May 30 12:00:00 UTC 2013.
Anything received after that time might be too late.

A combined patch relative to 3.2.45 will be posted as an additional
response to this.  A shortlog and diffstat can be found below.

Ben.

-------------

Alan Cox (1):
      [media] mantis: fix silly crash case
         [e1d45ae10aea8e8a403e5d96bf5902ee670007ff]

Alan Stern (2):
      USB: UHCI: fix for suspend of virtual HP controller
         [997ff893603c6455da4c5e26ba1d0f81adfecdfc]
      USB: xHCI: override bogus bulk wMaxPacketSize values
         [e4f47e3675e6f1f40906b785b934ce963e9f2eb3]

Alexandre Bounine (1):
      rapidio/tsi721: fix bug in MSI interrupt handling
         [1ccc819da6fda9bee10ab8b72e9adbb5ad3e4959]

Amitkumar Karwar (1):
      mwifiex: fix memory leak issue when driver unload
         [f16fdc9d2dc1e5b270e9a08377587e831e0d36ac]

Andrew Gomella (1):
      USB: ftdi_sio: Add support for Newport CONEX motor drivers
         [7138143972b7c293267c783fc99a194f0ceff7f2]

Aneesh Kumar K.V (1):
      mm/THP: use pmd_populate() to update the pmd with pgtable_t pointer
         [7c3425123ddfdc5f48e7913ff59d908789712b18]

Bastian Triller (1):
      ACPI / video: Add "Asus UL30A" to ACPI video detect blacklist
         [c8f6d8351ba8c89d5cd4c562552ec7ec29274e31]

Ben Hutchings (3):
      Revert "drm/i915: Fix detection of base of stolen memory"
         [not upstream; fix is not needed in 3.2 and was backported wrongly]
      perf: net_dropmonitor: Fix symbol-relative addresses
         [5a1e99dd2028e00998d42029be86835d8ef4a46e]
      perf: net_dropmonitor: Fix trace parameter order
         [140c3c6a2bcd2c31e2f7f5a8d59689724776c8e5]

Benjamin Herrenschmidt (1):
      net/eth/ibmveth: Fixup retrieval of MAC address
         [13f85203e1060da83d9ec1c1c5a63343eaab8de4]

Benjamin LaHaise (1):
      ipmi: ipmi_devintf: compat_ioctl method fails to take ipmi_mutex
         [6368087e851e697679af059b4247aca33a69cef3]

Bing Zhao (1):
      mwifiex: clear is_suspended flag when interrupt is received early
         [48795424acff7215d5eac0b52793a2c1eb3a6283]

Bob Moore (1):
      ACPICA: Fix possible buffer overflow during a field unit read operation
         [61388f9e5d93053cf399a356414f31f9b4814c6d]

Brian Behlendorf (1):
      drivers/block/brd.c: fix brd_lookup_page() race
         [dfd20b2b174d3a9b258ea3b7a35ead33576587b1]

Brian King (1):
      powerpc/pseries: Fix partition migration hang in stop_topology_update
         [444080d13d05dc38d07dd3bf751d38bce7ab7c72]

Chen Gang (1):
      drivers/char/ipmi: memcpy, need additional 2 bytes to avoid memory overflow
         [a5f2b3d6a738e7d4180012fe7b541172f8c8dcea]

Cliff Wickman (1):
      mm/pagewalk.c: walk_page_range should avoid VM_PFNMAP areas
         [a9ff785e4437c83d2179161e012f5bdfbd6381f0]

Cong Wang (1):
      xfrm6: release dev before returning error
         [84c4a9dfbf430861e7588d95ae3ff61535dca351]

Dan Carpenter (2):
      ASoC: wm8994: missing break in wm8994_aif3_hw_params()
         [4495e46fe18f198366961bb2b324a694ef8a9b44]
      USB: cxacru: potential underflow in cxacru_cm_get_array()
         [2a0ebf80aa95cc758d4725f74a7016e992606a39]

Dan Williams (1):
      USB: option: add device IDs for Dell 5804 (Novatel E371) WWAN card
         [49c6e370dd6400b84897c4100095089b5c13a061]

Daniel Borkmann (1):
      packet: tpacket_v3: do not trigger bug() on wrong  header status
         [8da3056c04bfc5f69f840ab038a38389e2de8189]

Daniel Drake (1):
      mwifiex: fix setting of multicast filter
         [ccd384b10420ac81ba3fb9b0a7d18272c7173552]

David Jeffery (1):
      autofs - remove autofs dentry mount check
         [ce8a5dbdf9e709bdaf4618d7ef8cceb91e8adc69]

Eric Dumazet (2):
      ipv6: do not clear pinet6 field
         [f77d602124d865c38705df7fa25c03de9c284ad2]
      tcp: force a dst refcount when prequeue packet
         [093162553c33e9479283e107b4431378271c735d]

Felix Fietkau (1):
      ath9k: fix key allocation error handling for powersave keys
         [4ef69d0394cba8caa9f75d3f2e53429bfb8b3045]

Gabriel de Perthuis (1):
      btrfs: don't stop searching after encountering the wrong item
         [03b71c6ca6286625d8f1ed44aabab9b5bf5dac10]

Gleb Natapov (1):
      KVM: VMX: fix halt emulation while emulating invalid guest sate
         [8d76c49e9ffeee839bc0b7a3278a23f99101263e]

Gregory CLEMENT (1):
      ARM: plat-orion: Fix num_resources and id for ge10 and ge11
         [2b8b2797142c7951e635c6eec5d1705ee9bc45c5]

Hans Schillstrom (1):
      ipvs: ip_vs_sip_fill_param() BUG: bad check of return value
         [f7a1dd6e3ad59f0cfd51da29dfdbfd54122c5916]

Hans-Christian Egtvedt (1):
      avr32: fix relocation check for signed 18-bit offset
         [e68c636d88db3fda74e664ecb1a213ae0d50a7d8]

Hema Prathaban (1):
      staging: vt6656: use free_netdev instead of kfree
         [0a438d5b381e2bdfd5e02d653bf46fcc878356e3]

Ian Abbott (1):
      staging: comedi: prevent auto-unconfig of manually configured devices
         [7d3135af399e92cf4c9bbc5f86b6c140aab3b88c]

Imre Deak (1):
      wait: fix false timeouts when using wait_event_timeout()
         [4c663cfc523a88d97a8309b04a089c27dc57fd7e]

J. Bruce Fields (1):
      nfsd4: don't allow owner override on 4.1 CLAIM_FH opens
         [9f415eb25574db4b73a9a712a4438e41dc284922]

Jamal Hadi Salim (1):
      net_sched: act_ipt forward compat with xtables
         [0dcffd09641f3abb21ac5cabc61542ab289d1a3c]

Jeff Layton (2):
      cifs: only set ops for inodes in I_NEW state
         [c2b93e0699723700f886ce17bb65ffd771195a6d]
      sunrpc: clarify comments on rpc_make_runnable
         [506026c3ec270e18402f0c9d33fee37482c23861]

Jiri Kosina (1):
      random: fix accounting race condition with lockless irq entropy_count update
         [10b3a32d292c21ea5b3ad5ca5975e88bb20b8d68]

Jiri Pirko (1):
      macvlan: fix passthru mode race between dev removal  and rx path
         [233c7df0821c4190e2d3f4be0f2ca0ab40a5ed8c]

Johan Hovold (1):
      mmc: at91/avr32/atmel-mci: fix DMA-channel leak on module unload
         [91cf54feecf815bec0b6a8d6d9dbd0e219f2f2cc]

Joseph Qi (1):
      ocfs2: goto out_unlock if ocfs2_get_clusters_nocache() failed in ocfs2_fiemap()
         [b4ca2b4b577c3530e34dcfaafccb2cc680ce95d1]

Josh Boyer (1):
      if_cablemodem.h: Add parenthesis around ioctl macros
         [4f924b2aa4d3cb30f07e57d6b608838edcbc0d88]

Kees Cook (1):
      drm/radeon: check incoming cliprects pointer
         [fefaedcfb82d2e57c2320acf60604ab03b750cc0]

Konrad Rzeszutek Wilk (1):
      xen/vcpu/pvhvm: Fix vcpu hotplugging hanging.
         [7f1fc268c47491fd5e63548f6415fc8604e13003]

Lachlan McIlroy (1):
      ext4: limit group search loop for non-extent files
         [e6155736ad76b2070652745f9e54cdea3f0d8567]

Lan Tianyu (1):
      ACPI / EC: Restart transaction even when the IBF flag set
         [28fe5c825f8e15744d04c7c1b8df197950923ecd]

Lars-Peter Clausen (1):
      mfd: adp5520: Restore mode bits on resume
         [c6cc25fda58da8685ecef3f179adc7b99c8253b2]

Leonid Yegoshin (1):
      mm compaction: fix of improper cache flush in migration code
         [c2cc499c5bcf9040a738f49e8051b42078205748]

Li Fei (1):
      x86: Eliminate irq_mis_count counted in arch_irq_stat
         [f7b0e1055574ce06ab53391263b4e205bf38daf3]

Libin (1):
      sched/debug: Fix sd->*_idx limit range avoiding overflow
         [fd9b86d37a600488dbd80fe60cca46b822bff1cd]

Martin Michlmayr (1):
      Kirkwood: Enable PCIe port 1 on QNAP TS-11x/TS-21x
         [99e11334dcb846f9b76fb808196c7f47aa83abb3]

Matt Fleming (1):
      x86, efivars: firmware bug workarounds should be in platform code
         [a6e4d5a03e9e3587e88aba687d8f225f4f04c792]

Matthew Whitehead (1):
      3c509.c: call SET_NETDEV_DEV for all device types  (ISA/ISAPnP/EISA)
         [3b54912f9cd167641b91d4a697bd742f70e534fe]

Michael S. Tsirkin (1):
      virtio_console: fix uapi header
         [6407d75afd08545f2252bb39806ffd3f10c7faac]

Mika Westerberg (1):
      i2c: designware: always clear interrupts before enabling them
         [2a2d95e9d6d29e726cc294b65391917ed2e32bf4]

Mikulas Patocka (1):
      dm bufio: avoid a possible __vmalloc deadlock
         [502624bdad3dba45dfaacaf36b7d83e39e74b2d2]

Namhyung Kim (1):
      sched/debug: Limit sd->*_idx range on sysctl
         [201c373e8e4823700d3160d5c28e1ab18fd1193e]

Nithin Sujir (1):
      tg3: Skip powering down function 0 on certain serdes devices
         [44f3b503c16425c8e9db4bbaa2fc9cd0c9d0ba91]

OGAWA Hirofumi (1):
      fat: fix possible overflow for fat_clusters
         [7b92d03c3239f43e5b86c9cc9630f026d36ee995]

Oleg Nesterov (1):
      usermodehelper: check subprocess_info->path != NULL
         [264b83c07a84223f0efd0d1db9ccc66d6f88288f]

Oliver Neukum (1):
      USB: reset resume quirk needed by a hub
         [bac6b03275184c912ad0818c9a0a736847804dca]

Philip Rakity (1):
      mmc: core: Fix bit width test failing on old eMMC cards
         [836dc2fe89c968c10cada87e0dfae6626f8f9da3]

Philipp Reisner (1):
      drbd: fix for deadlock when using automatic split-brain-recovery
         [7c689e63a847316c1b2500f86891b0a574ce7e69]

Richard Weinberger (3):
      um: Serve io_remap_pfn_range()
         [4d94d6d030adfdea4837694d293ec6918d133ab2]
      x86,efi: Check max_size only if it is non-zero.
         [7791c8423f1f7f4dad94e753bae67461d5b80be8]
      x86,efi: Implement efi_no_storage_paranoia parameter
         [8c58bf3eec3b8fc8162fe557e9361891c20758f2]

Robert Jennings (1):
      powerpc: Bring all threads online prior to migration/hibernation
         [120496ac2d2d60aee68d3123a68169502a85f4b5]

Ryusuke Konishi (1):
      nilfs2: fix issue of nilfs_set_page_dirty() for page at EOF boundary
         [136e8770cd5d1fe38b3c613100dd6dc4db6d4fa6]

Sarah Sharp (1):
      xhci: Don't warn on empty ring for suspended devices.
         [a83d6755814e4614ba77e15d82796af0f695c6b8]

Schemmel Hans-Christoph (1):
      USB: Blacklisted Cinterion's PLxx WWAN Interface
         [8ff10bdb14a52e3f25d4ce09e0582a8684c1a6db]

Sergei Shtylyov (2):
      3c59x: fix PCI resource management
         [4b264a1676e70dc656ba53a8cac690f2d4b65f4e]
      3c59x: fix freeing nonexistent resource on driver  unload
         [c81400be716aa4c76f6ebf339ba94358dbbf6da6]

Sergey Vlasov (1):
      efi: Export efi_query_variable_store() for efivars.ko
         [3668011d4ad556224f7c012c1e870a6eaa0e59da]

Shlomo Pongratz (1):
      iscsi-target: Fix processing of OOO commands
         [3eccfdb01da58fbd0f789ae6ca61cee3769e26de]

Shuah Khan (1):
      hp_accel: Ignore the error from lis3lv02d_poweron() at resume
         [7783819920ca52fc582a2782f654fe6ed373f465]

Stephen Hemminger (1):
      bridge: fix race with topology change timer
         [83401eb4990ff6af55aeed8f49681558544192e6]

Steven Rostedt (1):
      tracing: Fix leaks of filter preds
         [60705c89460fdc7227f2d153b68b3f34814738a4]

Teppo Kotilainen (1):
      usb: option: Add Telewell TW-LTE 4G
         [73c042df6e1bc50544842a04b777b36bbe3630e6]

Terry Barnaby (1):
      mmc: atmel-mci: pio hang on block errors
         [bdbc5d0c60f3e9de3eeccf1c1a18bdc11dca62cc]

Thomas Gleixner (1):
      tick: Cleanup NOHZ per cpu data on cpu down
         [4b0c0f294f60abcdd20994a8341a95c8ac5eeb96]

Thommy Jakobsson (1):
      B43: Handle DMA RX descriptor underrun
         [73b82bf0bfbf58e6ff328d3726934370585f6e78]

Tirupathi Reddy (1):
      timer: Don't reinitialize the cpu base lock during CPU_UP_PREPARE
         [42a5cf46cd56f46267d2a9fcf2655f4078cd3042]

Tomoya MORINAGA (1):
      pch_dma: Use GFP_ATOMIC because called from interrupt context
         [5c1ef59168c485318e40ba485c1eba57d81d0faa]

Trond Myklebust (1):
      SUNRPC: Prevent an rpc_task wakeup race
         [a3c3cac5d31879cd9ae2de7874dc6544ca704aec]

Wang YanQing (2):
      ALSA: HDA: Fix Oops caused by dereference NULL pointer
         [2195b063f6609e4c6268f291683902f25eaf9aa6]
      TTY: Fix tty miss restart after we turn off flow-control
         [dab73b4eb9ef924a2b90dab84e539076d82b256f]

Wei Yongjun (3):
      dm snapshot: fix error return code in snapshot_ctr
         [09e8b813897a0f85bb401435d009228644c81214]
      drivers/rtc/rtc-pcf2123.c: fix error return code in pcf2123_probe()
         [35623715818dfa720cccf99cd280dcbb4b78da23]
      hwmon: fix error return code in abituguru_probe()
         [ecacb0b17c08fae89f65468727f0e4b8e91da4e1]

Xiao Guangrong (1):
      mm: mmu_notifier: re-fix freed page still mapped in secondary MMU
         [d34883d4e35c0a994e91dd847a82b4c9e0c31d83]

 Documentation/kernel-parameters.txt          |    6 ++
 Makefile                                     |    4 +-
 arch/arm/configs/at91sam9g45_defconfig       |    1 -
 arch/arm/mach-kirkwood/ts219-setup.c         |    2 +-
 arch/arm/plat-orion/common.c                 |   12 +--
 arch/avr32/configs/favr-32_defconfig         |    1 -
 arch/avr32/configs/merisc_defconfig          |    1 -
 arch/avr32/kernel/module.c                   |    2 +-
 arch/powerpc/include/asm/rtas.h              |    2 +
 arch/powerpc/kernel/rtas.c                   |  118 +++++++++++++++++++++++++-
 arch/powerpc/platforms/pseries/suspend.c     |   28 +++++-
 arch/um/include/asm/pgtable.h                |    2 +
 arch/x86/kernel/irq.c                        |    4 -
 arch/x86/kvm/vmx.c                           |    6 ++
 arch/x86/platform/efi/efi.c                  |   43 ++++++++++
 arch/x86/xen/enlighten.c                     |   15 ++++
 drivers/acpi/acpica/exfldio.c                |   14 ++-
 drivers/acpi/ec.c                            |    4 +-
 drivers/acpi/video_detect.c                  |    8 ++
 drivers/block/brd.c                          |    4 +-
 drivers/block/drbd/drbd_receiver.c           |    1 -
 drivers/char/ipmi/ipmi_bt_sm.c               |    4 +-
 drivers/char/ipmi/ipmi_devintf.c             |   14 ++-
 drivers/char/random.c                        |   24 ++++--
 drivers/dma/pch_dma.c                        |    2 +-
 drivers/firmware/efivars.c                   |   18 +---
 drivers/gpu/drm/i915/i915_dma.c              |   81 +++++++++---------
 drivers/gpu/drm/i915/i915_drv.h              |    1 -
 drivers/gpu/drm/radeon/r300_cmdbuf.c         |    2 +-
 drivers/hwmon/abituguru.c                    |   16 ++--
 drivers/i2c/busses/i2c-designware-core.c     |    3 +-
 drivers/md/dm-bufio.c                        |   26 +++++-
 drivers/md/dm-snap.c                         |    1 +
 drivers/media/dvb/mantis/mantis_dvb.c        |    6 +-
 drivers/mfd/adp5520.c                        |    8 +-
 drivers/mmc/core/mmc.c                       |    2 +-
 drivers/mmc/host/Kconfig                     |   10 ---
 drivers/mmc/host/atmel-mci.c                 |   16 ++--
 drivers/net/ethernet/3com/3c509.c            |    2 +
 drivers/net/ethernet/3com/3c59x.c            |   27 +++---
 drivers/net/ethernet/broadcom/tg3.c          |   32 +++++--
 drivers/net/ethernet/ibm/ibmveth.c           |   23 +++--
 drivers/net/macvlan.c                        |    7 +-
 drivers/net/wireless/ath/ath9k/main.c        |    6 +-
 drivers/net/wireless/b43/dma.c               |   19 +++++
 drivers/net/wireless/b43/dma.h               |    4 +-
 drivers/net/wireless/b43/main.c              |   43 ++++------
 drivers/net/wireless/mwifiex/cfg80211.c      |    3 -
 drivers/net/wireless/mwifiex/cmdevt.c        |    1 +
 drivers/net/wireless/mwifiex/main.c          |    1 +
 drivers/net/wireless/mwifiex/sta_ioctl.c     |   21 ++---
 drivers/platform/x86/hp_accel.c              |    3 +-
 drivers/rapidio/devices/tsi721.c             |   11 +++
 drivers/rtc/rtc-pcf2123.c                    |    1 +
 drivers/staging/comedi/comedi_fops.c         |    3 +
 drivers/staging/vt6656/hostap.c              |    2 +-
 drivers/target/iscsi/iscsi_target_erl1.c     |    7 +-
 drivers/tty/n_tty.c                          |    8 ++
 drivers/usb/atm/cxacru.c                     |    3 +-
 drivers/usb/core/quirks.c                    |    3 +
 drivers/usb/host/uhci-hub.c                  |    3 +-
 drivers/usb/host/xhci-mem.c                  |   17 ++--
 drivers/usb/host/xhci-ring.c                 |   23 +++--
 drivers/usb/serial/ftdi_sio.c                |    2 +
 drivers/usb/serial/ftdi_sio_ids.h            |    2 +
 drivers/usb/serial/option.c                  |   13 ++-
 fs/autofs4/expire.c                          |    9 --
 fs/btrfs/ioctl.c                             |   10 +--
 fs/cifs/inode.c                              |    3 +-
 fs/ext4/mballoc.c                            |    6 +-
 fs/fat/inode.c                               |   15 +++-
 fs/nfsd/nfs4proc.c                           |   15 +++-
 fs/nilfs2/inode.c                            |   27 +++++-
 fs/ocfs2/extent_map.c                        |    2 +-
 include/linux/efi.h                          |   11 ++-
 include/linux/if_cablemodem.h                |   12 +--
 include/linux/rculist.h                      |   17 ++++
 include/linux/virtio_console.h               |    2 +-
 include/linux/wait.h                         |   16 ++--
 include/net/sock.h                           |   12 +++
 include/net/tcp.h                            |    1 +
 kernel/kmod.c                                |    5 ++
 kernel/sched.c                               |   35 +++++---
 kernel/time/tick-sched.c                     |    2 +-
 kernel/timer.c                               |    2 +-
 kernel/trace/trace_events_filter.c           |    4 +
 mm/huge_memory.c                             |    7 +-
 mm/migrate.c                                 |    2 +-
 mm/mmu_notifier.c                            |   80 ++++++++---------
 mm/pagewalk.c                                |   70 +++++++--------
 net/bridge/br_stp_timer.c                    |    2 +-
 net/core/sock.c                              |   12 ---
 net/ipv6/tcp_ipv6.c                          |   12 +++
 net/ipv6/udp.c                               |   13 ++-
 net/ipv6/udp_impl.h                          |    2 +
 net/ipv6/udplite.c                           |    2 +-
 net/ipv6/xfrm6_policy.c                      |    4 +-
 net/netfilter/ipvs/ip_vs_pe_sip.c            |    6 +-
 net/packet/af_packet.c                       |   54 +++++-------
 net/sched/act_ipt.c                          |   33 ++++++-
 net/sunrpc/sched.c                           |   13 ++-
 sound/pci/hda/hda_codec.c                    |    3 +
 sound/soc/codecs/wm8994.c                    |    1 +
 tools/perf/scripts/python/net_dropmonitor.py |    8 +-
 104 files changed, 906 insertions(+), 426 deletions(-)

-- 
Ben Hutchings
If at first you don't succeed, you're doing about average.

