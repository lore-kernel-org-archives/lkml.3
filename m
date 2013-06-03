Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758974Ab3FCWMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:12:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12031 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757635Ab3FCWLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:11:54 -0400
X-Authority-Analysis: v=2.0 cv=H8VZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=eIhxMilvRf8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=bLFOEYoiK7IA:10 a=YB6zP3NbyGnIamDMeWcA:9 a=smrRgNUI3D6LpvSQ:21 a=hmkFEsz_7n1zaZ-M:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221016.243553628@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:10:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [00/65] 3.6.11.5-stable review
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the start of the stable review cycle for 3.6.11.5 release.
There are 65 patches in this series, which will be posted as responses
to this one. If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Jun  18:08:30.
Anything received after that time might be too late.

Aaro Koskinen (1):
      ARM: OMAP: RX-51: change probe order of touchscreen and panel SPI devices
         [e65f131a14726e5f1b880a528271a52428e5b3a5]

Amitkumar Karwar (1):
      mwifiex: fix memory leak issue when driver unload
         [f16fdc9d2dc1e5b270e9a08377587e831e0d36ac]

Anton Blanchard (2):
      powerpc/kexec: Fix kexec when using VMX optimised memcpy
         [79c66ce8f6448a3295a32efeac88c9debd7f7094]
      audit: Syscall rules are not applied to existing processes on non-x86
         [cdee3904b4ce7c03d1013ed6dd704b43ae7fc2e9]

Ben Hutchings (1):
      sfc: Fix naming of MTD partitions for FPGA bitfiles
         [89cc80a44b7c320e08599cb86f6aef0ead8986a1]

Benjamin LaHaise (1):
      ipmi: ipmi_devintf: compat_ioctl method fails to take ipmi_mutex
         [6368087e851e697679af059b4247aca33a69cef3]

Bing Zhao (1):
      mwifiex: clear is_suspended flag when interrupt is received early
         [48795424acff7215d5eac0b52793a2c1eb3a6283]

Bjørn Mork (1):
      net: vlan,ethtool: netdev_features_t is more than 32 bit
         [b29d3145183da4e07d4b570fa8acdd3ac4a5c572]

Bob Moore (1):
      ACPICA: Fix possible buffer overflow during a field unit read operation
         [61388f9e5d93053cf399a356414f31f9b4814c6d]

Chen Gang (2):
      drivers/char/ipmi: memcpy, need additional 2 bytes to avoid memory overflow
         [a5f2b3d6a738e7d4180012fe7b541172f8c8dcea]
      net: mac802154: comparision issue of type cast, finding by EXTRA_CFLAGS=-W
         [2c1bbbffa0b644fab4f91878cde0c2e8f52e2dcc]

Chris Metcalf (1):
      tile: support new Tilera hypervisor
         [c539914dcd9a68c63305e055b14115a6a19578a8]

Christopher Harvey (2):
      drm/mgag200: Fix framebuffer base address programming
         [9f1d036648c1c5ed81b0e98d7a06d55df972701e]
      drm/mgag200: Fix writes into MGA1064_PIX_CLK_CTL register
         [fb70a6690875315a3a1454e52fa339441ee7612b]

Cong Wang (1):
      xfrm6: release dev before returning error
         [84c4a9dfbf430861e7588d95ae3ff61535dca351]

Dan Carpenter (1):
      ASoC: wm8994: missing break in wm8994_aif3_hw_params()
         [4495e46fe18f198366961bb2b324a694ef8a9b44]

Daniel Borkmann (1):
      packet: tpacket_v3: do not trigger bug() on wrong header status
         [8da3056c04bfc5f69f840ab038a38389e2de8189]

Daniel Drake (1):
      mwifiex: fix setting of multicast filter
         [ccd384b10420ac81ba3fb9b0a7d18272c7173552]

Eric Dumazet (2):
      ipv6: do not clear pinet6 field
         [f77d602124d865c38705df7fa25c03de9c284ad2]
      tcp: force a dst refcount when prequeue packet
         [093162553c33e9479283e107b4431378271c735d]

Felix Fietkau (1):
      ath9k: fix key allocation error handling for powersave keys
         [4ef69d0394cba8caa9f75d3f2e53429bfb8b3045]

Frederic Weisbecker (1):
      math64: New div64_u64_rem helper
         [f792685006274a850e6cc0ea9ade275ccdfc90bc]

Gabriel de Perthuis (1):
      btrfs: don't stop searching after encountering the wrong item
         [03b71c6ca6286625d8f1ed44aabab9b5bf5dac10]

Gleb Natapov (1):
      KVM: VMX: fix halt emulation while emulating invalid guest sate
         [8d76c49e9ffeee839bc0b7a3278a23f99101263e]

Guenter Roeck (1):
      watchdog: Fix race condition in registration code
         [60403f7a4d9368d187f79cba5e4672d01df37574]

Helge Deller (1):
      parisc: make default cross compiler search more robust (v3)
         [6880b0150a7c25fd75c5ece80abc49ebf53c38c1]

Inderpal Singh (1):
      ARM: EXYNOS5: Fix kernel dump in AFTR idle mode
         [088584618836b159947bc4ab5011a5cf1f081a62]

Jaccon Bastiaansen (1):
      ARM: 7720/1: ARM v6/v7 cmpxchg64 shouldn't clear upper 32 bits of the old/new value
         [6eabb3301b1facee669d9938f7c5a0295c21d71d]

Jamal Hadi Salim (1):
      net_sched: act_ipt forward compat with xtables
         [0dcffd09641f3abb21ac5cabc61542ab289d1a3c]

James Bottomley (1):
      sd: fix array cache flushing bug causing performance problems
         [39c60a0948cc06139e2fbfe084f83cb7e7deae3b]

Jiri Pirko (1):
      macvlan: fix passthru mode race between dev removal and rx path
         [233c7df0821c4190e2d3f4be0f2ca0ab40a5ed8c]

Joern Engel (1):
      target: close target_put_sess_cmd() vs. core_tmr_abort_task() race
         [ccf5ae83a6cf3d9cfe9a7038bfe7cd38ab03d5e1]

John David Anglin (2):
      parisc: fix SMP races when updating PTE and TLB entries in entry.S
         [f0a18819e261afc5fdbd8c5c6f9943123c5461ba]
      parisc: only re-enable interrupts if we need to schedule or deliver signals when returning to userspace
         [c207a76bf155cb5cf24cf849c08f6555e9180594]

Josef Ahmad (1):
      i2c: designware: fix RX FIFO overrun
         [e6f34cea56f5b95498070eaa9f4aa3ba4a9e4f62]

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

Matthew Whitehead (1):
      3c509.c: call SET_NETDEV_DEV for all device types (ISA/ISAPnP/EISA)
         [3b54912f9cd167641b91d4a697bd742f70e534fe]

Michael S. Tsirkin (1):
      virtio_console: fix uapi header
         [6407d75afd08545f2252bb39806ffd3f10c7faac]

Mika Westerberg (1):
      i2c: designware: always clear interrupts before enabling them
         [2a2d95e9d6d29e726cc294b65391917ed2e32bf4]

Mike Frysinger (1):
      parisc: fix NATIVE set up in build
         [93782eba49e23c3f311a6b05a19ba15927ec4e8b]

Mike Snitzer (1):
      dm stripe: fix regression in stripe_width calculation
         [d793e684277124d55c5d2444007e224635821346]

Mikulas Patocka (1):
      dm bufio: avoid a possible __vmalloc deadlock
         [502624bdad3dba45dfaacaf36b7d83e39e74b2d2]

Niels Ole Salscheider (1):
      drm/radeon: Fix VRAM size calculation for VRAM >= 4GB
         [fc986034540102cd090237bf3f70262e1ae80d9c]

Oleg Nesterov (1):
      usermodehelper: check subprocess_info->path != NULL
         [264b83c07a84223f0efd0d1db9ccc66d6f88288f]

Patrick McHardy (1):
      net: use netdev_features_t in skb_needs_linearize()
         [6708c9e5cc9bfc7c9a00ce9c0fdd0b1d4952b3d1]

Philipp Reisner (1):
      drbd: fix for deadlock when using automatic split-brain-recovery
         [7c689e63a847316c1b2500f86891b0a574ce7e69]

Robert Jennings (1):
      powerpc: Bring all threads online prior to migration/hibernation
         [120496ac2d2d60aee68d3123a68169502a85f4b5]

Sergei Shtylyov (2):
      3c59x: fix PCI resource management
         [4b264a1676e70dc656ba53a8cac690f2d4b65f4e]
      3c59x: fix freeing nonexistent resource on driver unload
         [c81400be716aa4c76f6ebf339ba94358dbbf6da6]

Shlomo Pongratz (1):
      iscsi-target: Fix processing of OOO commands
         [3eccfdb01da58fbd0f789ae6ca61cee3769e26de]

Shuah Khan (1):
      hp_accel: Ignore the error from lis3lv02d_poweron() at resume
         [7783819920ca52fc582a2782f654fe6ed373f465]

Steven Rostedt (Red Hat) (1):
      tracing: Fix leaks of filter preds
         [60705c89460fdc7227f2d153b68b3f34814738a4]

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

Wang YanQing (1):
      ALSA: HDA: Fix Oops caused by dereference NULL pointer
         [2195b063f6609e4c6268f291683902f25eaf9aa6]

Wei Yongjun (3):
      hwmon: fix error return code in abituguru_probe()
         [ecacb0b17c08fae89f65468727f0e4b8e91da4e1]
      drivers/rtc/rtc-pcf2123.c: fix error return code in pcf2123_probe()
         [35623715818dfa720cccf99cd280dcbb4b78da23]
      dm snapshot: fix error return code in snapshot_ctr
         [09e8b813897a0f85bb401435d009228644c81214]

stephen hemminger (1):
      bridge: fix race with topology change timer
         [83401eb4990ff6af55aeed8f49681558544192e6]

----
 arch/arm/include/asm/cmpxchg.h               |    8 +-
 arch/arm/mach-exynos/include/mach/regs-pmu.h |    1 +
 arch/arm/mach-exynos/pmu.c                   |    5 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c |    4 +-
 arch/parisc/Makefile                         |   24 ++--
 arch/parisc/kernel/entry.S                   |  169 ++++++++++++++------------
 arch/powerpc/include/asm/rtas.h              |    2 +
 arch/powerpc/kernel/machine_kexec_64.c       |    4 +
 arch/powerpc/kernel/rtas.c                   |  113 +++++++++++++++++
 arch/powerpc/platforms/pseries/suspend.c     |   22 ++++
 arch/tile/Kconfig                            |   14 ++-
 arch/tile/include/hv/hypervisor.h            |   27 +++-
 arch/tile/kernel/head_32.S                   |    2 +-
 arch/tile/kernel/head_64.S                   |   12 +-
 arch/x86/kvm/vmx.c                           |    6 +
 arch/x86/xen/enlighten.c                     |   15 +++
 drivers/acpi/acpica/exfldio.c                |   14 ++-
 drivers/acpi/ec.c                            |    4 +-
 drivers/block/drbd/drbd_receiver.c           |    1 -
 drivers/char/ipmi/ipmi_bt_sm.c               |    4 +-
 drivers/char/ipmi/ipmi_devintf.c             |   14 ++-
 drivers/dma/pch_dma.c                        |    2 +-
 drivers/gpu/drm/mgag200/mgag200_mode.c       |   69 +++++++----
 drivers/gpu/drm/radeon/evergreen.c           |    4 +-
 drivers/gpu/drm/radeon/r300_cmdbuf.c         |    2 +-
 drivers/gpu/drm/radeon/radeon_ttm.c          |    2 +-
 drivers/gpu/drm/radeon/si.c                  |    4 +-
 drivers/hwmon/abituguru.c                    |   16 ++-
 drivers/i2c/busses/i2c-designware-core.c     |   14 ++-
 drivers/i2c/busses/i2c-designware-core.h     |    2 +
 drivers/md/dm-bufio.c                        |   26 +++-
 drivers/md/dm-snap.c                         |    1 +
 drivers/md/dm-stripe.c                       |   11 +-
 drivers/net/ethernet/3com/3c509.c            |    2 +
 drivers/net/ethernet/3com/3c59x.c            |   27 ++--
 drivers/net/ethernet/sfc/mcdi.c              |    2 +-
 drivers/net/ethernet/tile/tilegx.c           |    2 +-
 drivers/net/macvlan.c                        |    7 +-
 drivers/net/wireless/ath/ath9k/main.c        |    6 +-
 drivers/net/wireless/b43/dma.c               |   19 +++
 drivers/net/wireless/b43/dma.h               |    4 +-
 drivers/net/wireless/b43/main.c              |   43 +++----
 drivers/net/wireless/mwifiex/cfg80211.c      |    3 -
 drivers/net/wireless/mwifiex/cmdevt.c        |    1 +
 drivers/net/wireless/mwifiex/main.c          |    1 +
 drivers/net/wireless/mwifiex/sta_ioctl.c     |   21 +---
 drivers/platform/x86/hp_accel.c              |    3 +-
 drivers/rtc/rtc-pcf2123.c                    |    1 +
 drivers/scsi/sd.c                            |   20 +++
 drivers/scsi/sd.h                            |    1 +
 drivers/target/iscsi/iscsi_target_erl1.c     |    7 +-
 drivers/target/target_core_transport.c       |   11 +-
 drivers/watchdog/watchdog_dev.c              |    3 +-
 fs/btrfs/ioctl.c                             |   10 +-
 fs/ext4/mballoc.c                            |    6 +-
 include/linux/audit.h                        |    2 +-
 include/linux/if_cablemodem.h                |   12 +-
 include/linux/kref.h                         |   33 +++++
 include/linux/math64.h                       |   19 ++-
 include/linux/virtio_console.h               |    2 +-
 include/net/sock.h                           |   12 ++
 include/net/tcp.h                            |    1 +
 kernel/kmod.c                                |    5 +
 kernel/time/tick-sched.c                     |    2 +-
 kernel/timer.c                               |    2 +-
 kernel/trace/trace_events_filter.c           |    4 +
 lib/div64.c                                  |   19 ++-
 net/8021q/vlan_dev.c                         |    2 +-
 net/bridge/br_stp_timer.c                    |    2 +-
 net/core/dev.c                               |    2 +-
 net/core/ethtool.c                           |    2 +-
 net/core/sock.c                              |   12 --
 net/ipv6/tcp_ipv6.c                          |   12 ++
 net/ipv6/udp.c                               |   13 +-
 net/ipv6/udp_impl.h                          |    2 +
 net/ipv6/udplite.c                           |    2 +-
 net/ipv6/xfrm6_policy.c                      |    4 +-
 net/mac802154/mac802154.h                    |    2 +-
 net/packet/af_packet.c                       |   53 ++++----
 net/sched/act_ipt.c                          |   33 ++++-
 sound/pci/hda/hda_codec.c                    |    3 +
 sound/soc/codecs/wm8994.c                    |    1 +
 82 files changed, 761 insertions(+), 315 deletions(-)
