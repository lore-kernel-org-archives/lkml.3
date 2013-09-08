Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759682Ab3IHDh2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:37:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55966 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751966Ab3IHDTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:19:25 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org
Date: Sun, 08 Sep 2013 03:52:00 +0100
Message-ID: <lsq.1378608720.401499712@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [000/121] 3.2.51-rc1 review
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.51 release.
There are 121 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Thanks to Guenter Roeck, I've been able to build-test this on a large
number of architectures and have included a number of build fixes.

Responses should be made by Tue Sep 10 11:00:00 UTC 2013.
Anything received after that time might be too late.

A combined patch relative to 3.2.50 will be posted as an additional
response to this.  A shortlog and diffstat can be found below.

Ben.

-------------

AceLan Kao (2):
      Bluetooth: Add support for Atheros [0cf3:3121]
         [1ebd0b21ab14efb75950079840eac29afea2a26e]
      Bluetooth: Add support for Atheros [0cf3:e003]
         [1d5b569ef85d013a775560a90050dc630614c045]

Alex Deucher (2):
      drm/radeon/atom: initialize more atom interpretor elements to 0
         [42a21826dc54583cdb79cc8477732e911ac9c376]
      drm/radeon: always program the MC on startup
         [6fab3febf6d949b0a12b1e4e73db38e4a177a79e]

Amit Shah (5):
      virtio: console: clean up port data immediately at time of unplug
         [ea3768b4386a8d1790f4cc9a35de4f55b92d6442]
      virtio: console: fix race in port_fops_open() and port unplug
         [671bdea2b9f210566610603ecbb6584c8a201c8c]
      virtio: console: fix race with port unplug and open/close
         [057b82be3ca3d066478e43b162fc082930a746c9]
      virtio: console: fix raising SIGIO after port unplug
         [92d3453815fbe74d539c86b60dab39ecdf01bb99]
      virtio: console: return -ENODEV on all read operations after unplug
         [96f97a83910cdb9d89d127c5ee523f8fc040a804]

Andreas Schwab (1):
      m68k: Truncate base in do_div()
         [ea077b1b96e073eac5c3c5590529e964767fc5f7]

Andrew Vagin (1):
      tracing: Fix fields of struct trace_iterator that are zeroed by mistake
         [ed5467da0e369e65b247b99eb6403cb79172bcda]

Arnd Bergmann (1):
      SCSI: nsp32: use mdelay instead of large udelay  constants
         [b497ceb964a80ebada3b9b3cea4261409039e25a]

Ben Hutchings (2):
      Revert "PM / Domains: Fix handling of wakeup devices during system resume"
         [not upstream; the change being reverted is correct for Linux 3.3+]
      ifb: Include <linux/sched.h>
         [not upstream; <linux/sched.h> seems to be included indirectly in
          all configurations now]

Benjamin Herrenschmidt (1):
      powerpc: Don't Oops when accessing /proc/powerpc/lparcfg without hypervisor
         [f5f6cbb61610b7bf9d9d96db9c3979d62a424bab]

Chen Gang (1):
      cifs: extend the buffer length enought for sprintf() using
         [057d6332b24a4497c55a761c83c823eed9e3f23b]

Chris Wilson (1):
      drm/i915: Invalidate TLBs for the rings after a reset
         [884020bf3d2a3787a1cc6df902e98e0eec60330b]

Cong Wang (2):
      [PARISC] include <linux/prefetch.h> in drivers/parisc/iommu-helpers.h
         [650275dbfb2f4c12bc91420ad5a99f955eabec98]
      sunrpc: remove the second argument of k[un]map_atomic()
         [b85417860172ff693dc115d7999805fc240cec1c]

Curt Brune (1):
      hwmon: (adt7470) Fix incorrect return code check
         [93d783bcca69bfacc8dc739d8a050498402587b5]

Dan Carpenter (6):
      ALSA: ak4xx-adda: info leak in ak4xxx_capture_source_info()
         [bd5fe738e388ceaa32e5171481e0d3ec59f0ccfe]
      Hostap: copying wrong data prism2_ioctl_giwaplist()
         [909bd5926d474e275599094acad986af79671ac9]
      NFSv4.1: integer overflow in decode_cb_sequence_args()
         [0439f31c35d1da0b28988b308ea455e38e6a350d]
      af_key: more info leaks in pfkey messages
         [ff862a4668dd6dba962b1d2d8bd344afa6375683]
      arcnet: cleanup sizeof parameter
         [087d273caf4f7d3f2159256f255f1f432bc84a5b]
      net_sched: info leak in atm_tc_dump_class()
         [8cb3b9c3642c0263d48f31d525bcee7170eedc20]

Daniel Vetter (1):
      drm/i915/lvds: ditch ->prepare special case
         [520c41cf2fa029d1e8b923ac2026f96664f17c4b]

Dave Kleikamp (1):
      jfs: fix readdir cookie incompatibility with NFSv4
         [44512449c0ab368889dd13ae0031fba74ee7e1d2]

David S. Miller (2):
      net_sched: Fix stack info leak in cbq_dump_wrr().
         [a0db856a95a29efb1c23db55c02d9f0ff4f0db48]
      sparc32: Add ucmpdi2.o to obj-y instead of lib-y.
         [74c7b28953d4eaa6a479c187aeafcfc0280da5e8]

David Vrabel (3):
      x86/xen: do not identity map UNUSABLE regions in the machine E820
         [3bc38cbceb85881a8eb789ee1aa56678038b1909]
      xen/events: initialize local per-cpu mask for all possible events
         [84ca7a8e45dafb49cd5ca90a343ba033e2885c17]
      xen/events: mask events when changing their VCPU binding
         [4704fe4f03a5ab27e3c36184af85d5000e0f8a48]

Dominik Dingel (1):
      KVM: s390: move kvm_guest_enter,exit closer to sie
         [2b29a9fdcb92bfc6b6f4c412d71505869de61a56]

Eldad Zack (1):
      ALSA: usb-audio: skip UAC2 EFFECT_UNIT
         [5dae5fd24071319bb67d3375217d5b0b6d16cb0b]

Emmanuel Grumbach (1):
      iwlwifi: add DELL SKU for 5150 HMC
         [a1923f1d4723e5757cefdd60f7c7ab30e472007a]

Eric Dumazet (1):
      usbnet: do not pretend to support SG/TSO
         [20f0170377264e8449b6987041f0bcc4d746d3ed]

Eugene Surovegin (1):
      powerpc/hvsi: Increase handshake timeout from 200ms to 400ms.
         [d220980b701d838560a70de691b53be007e99e78]

Geert Uytterhoeven (4):
      m32r: add memcpy() for CONFIG_KERNEL_GZIP=y
         [a8abbca6617e1caa2344d2d38d0a35f3e5928b79]
      m32r: consistently use "suffix-$(...)"
         [df12aef6a19bb2d69859a94936bda0e6ccaf3327]
      m32r: make memset() global for CONFIG_KERNEL_BZIP2=y
         [9a75c6e5240f7edc5955e8da5b94bde6f96070b3]
      m68k/atari: ARAnyM - Fix NatFeat module support
         [e8184e10f89736a23ea6eea8e24cd524c5c513d2]

H.J. Lu (1):
      x86, fpu: correct the asm constraints for fxsave, unbreak mxcsr.daz
         [eaa5a990191d204ba0f9d35dbe5505ec2cdd1460]

Hannes Frederic Sowa (1):
      ipv6: take rtnl_lock and mark mrt6 table as freed on  namespace cleanup
         [905a6f96a1b18e490a75f810d733ced93c39b0e5]

Helmut Schaa (1):
      ath9k_htc: Restore skb headroom when returning skb to mac80211
         [d2e9fc141e2aa21f4b35ee27072d84e9aa6e2ba0]

Imre Deak (1):
      drm/i915: ivb: fix edp voltage swing reg val
         [77fa4cbd5fa389e28419bbe8ac491b5fdd54840d]

Jacob Keller (1):
      ixgbe: Fix Tx Hang issue with lldpad on 82598EB
         [1eb9ac14c34a948bf1538bfb9034e8ab29099a64]

Jakob Bornecrantz (1):
      drm/vmwgfx: Split GMR2_REMAP commands if they are to large
         [6e4dcff3adbf25acb87e74500a58e3c07bdec40f]

Jan Kara (1):
      jbd2: Fix use after free after error in jbd2_journal_dirty_metadata()
         [91aa11fae1cf8c2fd67be0609692ea9741cdcc43]

Jeff Layton (1):
      cifs: don't instantiate new dentries in readdir for inodes that need to be revalidated immediately
         [757c4f6260febff982276818bb946df89c1105aa]

Jesper Nilsson (1):
      CRIS: Add _sdata to vmlinux.lds.S
         [473e162eea465e60578edb93341752e7f1c1dacc]

Jiri Olsa (1):
      perf: Fix event group context move
         [0231bb5336758426b44ccd798ccd3c5419c95d58]

Johan Hovold (5):
      USB: adutux: fix big-endian device-type reporting
         [d482b9d558602a9cacab063b1c8779f9b5214da7]
      USB: keyspan: fix null-deref at disconnect and release
         [ff8a43c10f1440f07a5faca0c1556921259f7f76]
      USB: mos7720: fix broken control requests
         [ef6c8c1d733e244f0499035be0dabe1f4ed98c6f]
      USB: mos7840: fix race in register handling
         [d8a083cc746664916d9d36ed9e4d08a29525f245]
      USB: ti_usb_3410_5052: fix big-endian firmware handling
         [e877dd2f2581628b7119df707d4cf03d940cff49]

Johannes Berg (2):
      iwlwifi: dvm: don't send BT_CONFIG on devices w/o Bluetooth
         [707aee401d2467baa785a697f40a6e2d9ee79ad5]
      mac80211: fix duplicate retransmission detection
         [6b0f32745dcfba01d7be33acd1b40306c7a914c6]

Joshua Zhu (1):
      perf tools: Add anonymous huge page recognition
         [d0528b5d71faf612014dd7672e44225c915344b2]

Jussi Kivilinna (2):
      ALSA: 6fire: fix DMA issues with URB transfer_buffer usage
         [ddb6b5a964371e8e52e696b2b258bda144c8bd3f]
      zd1201: do not use stack as URB transfer_buffer
         [1206ff4ff9d2ef7468a355328bc58ac6ebf5be44]

Kamal Mostafa (1):
      drm/i915: quirk no PCH_PWM_ENABLE for Dell XPS13 backlight
         [e85843bec6c2ea7c10ec61238396891cc2b753a9]

Kent Overstreet (1):
      block: Add bio_for_each_segment_all()
         [d74c6d514fe314b8bdab58b487b25992291577ec]

Lan Tianyu (1):
      ACPI / battery: Fix parsing _BIX return value
         [016d5baad04269e8559332df05f89bd95b52d6ad]

Linus Torvalds (1):
      vm: add no-mmu vm_iomap_memory() stub
         [3c0b9de6d37a481673e81001c57ca0e410c72346]

Martin Peschke (2):
      [SCSI] zfcp: fix lock imbalance by reworking request queue locking
         [d79ff142624e1be080ad8d09101f7004d79c36e1]
      [SCSI] zfcp: fix schedule-inside-lock in scsi_device list loops
         [924dd584b198a58aa7cb3efefd8a03326550ce8f]

Michal Kazior (1):
      nl80211: fix mgmt tx status and testmode reporting for netns
         [a0ec570f4f69c4cb700d743a915096c2c8f56a99]

Michal Simek (2):
      microblaze: Fix __futex_atomic_op macro register usage
         [8cf662ed3ef190fddc186bb5b1cd75eb3880d5a9]
      microblaze: Update microblaze defconfigs
         [d0e045401f268a8de6f87d65678214748b772680]

Michal Tesar (1):
      sysctl net: Keep tcp_syn_retries inside the boundary
         [651e92716aaae60fc41b9652f54cb6803896e0da]

Neil Horman (1):
      sctp: fully initialize sctp_outq in sctp_outq_init
         [c5c7774d7eb4397891edca9ebdf750ba90977a69]

Nicholas Bellinger (1):
      target: Fix trailing ASCII space usage in  INQUIRY vendor+model
         [ee60bddba5a5f23e39598195d944aa0eb2d455e5]

Nicolas Dichtel (1):
      af_key: initialize satype in key_notify_policy_flush()
         [85dfb745ee40232876663ae206cba35f24ab2a40]

Noguchi Kazutosi (1):
      Bluetooth: Add support for Foxconn/Hon Hai [0489:e04d]
         [0fc110f4e4f569e12c472f73f0af485e05631403]

Oleksij Rempel (1):
      ath9k_htc: do some initial hardware configuration
         [dc2a87f519a4d8cb376ab54f22b6b98a943b51ce]

Oliver Neukum (1):
      usb: add two quirky touchscreen
         [304ab4ab079a8ed03ce39f1d274964a532db036b]

Paul Bolle (1):
      sound: Fix make allmodconfig on MIPS correctly
         [a62ee234a572b4c98fe98cf5fb18e4e8b0f6e43d]

Paul Gortmaker (1):
      pci: frv architecture needs generic setup-bus infrastructure
         [cd0a2bfb77a3edeecd652081e0b1a163d3b0696b]

Paul Mackerras (1):
      powerpc: Work around gcc miscompilation of __pa() on 64-bit
         [bdbc29c19b2633b1d9c52638fb732bcde7a2031a]

Piotr Sarna (1):
      ext4: fix mount/remount error messages for incompatible mount options
         [6ae6514b33f941d3386da0dfbe2942766eab1577]

Radu Caragea (1):
      x86 get_unmapped_area: Access mmap_legacy_base through mm_struct member
         [41aacc1eea645c99edbe8fbcf78a97dc9b862adc]

Richard Kuo (1):
      Hexagon: misc compile warning/error cleanup due to missing headers
         [6bbbc30ce6b0ae428575c8af7c2a6c342c534e19]

Rick Farina (1):
      USB: serial: ftdi_sio: add more RT Systems ftdi devices
         [fed1f1ed90bce42ea010e2904cbc04e7b8304940]

Roland Dreier (1):
      [SCSI] sg: Fix user memory corruption when SG_IO is interrupted by a signal
         [35dc248383bbab0a7203fca4d722875bc81ef091]

Russ Anderson (1):
      drivers/base/memory.c: fix show_mem_removable() to handle missing sections
         [21ea9f5ace3a7317cc3ba1fbc749758021a83136]

Sam Ravnborg (2):
      sparc32: add ucmpdi2
         [de36e66d5fa52bc6e2dacd95c701a1762b5308a7]
      sparc32: support atomic64_t
         [aea1181b0bd0a09c54546399768f359d1e198e45]

Stanislaw Gruszka (5):
      iwl4965: fix rfkill set state regression
         [b2fcc0aee58a3435566dd6d8501a0b355552f28b]
      iwl4965: reset firmware after rfkill off
         [788f7a56fce1bcb2067b62b851a086fca48a0056]
      iwl4965: set power mode early
         [eca396d7a5bdcc1fd67b1b12f737c213ac78a6f4]
      iwlwifi: dvm: fix calling ieee80211_chswitch_done() with NULL
         [9186a1fd9ed190739423db84bc344d258ef3e3d7]
      rt2x00: fix stop queue
         [e2288b66fe7ff0288382b2af671b4da558b44472]

Stephen Boyd (1):
      perf/arm: Fix armpmu_map_hw_event()
         [b88a2595b6d8aedbd275c07dfa784657b4f757eb]

Sujith Manoharan (1):
      Bluetooth: ath3k: Add support for ID 0x13d3/0x3402
         [5b77a1f3d7b7360dc2b7c6d2188d39b9f8432907]

Sumit.Saxena@lsi.com (1):
      [SCSI] megaraid_sas: megaraid_sas driver init fails in kdump kernel
         [6431f5d7c6025f8b007af06ea090de308f7e6881]

Takashi Iwai (2):
      ALSA: opti9xx: Fix conflicting driver object name
         [fb615499f0ad28ed74201c1cdfddf9e64e205424]
      sound: Fix make allmodconfig on MIPS
         [d4702b189c6b951c1cb3260036ff998f719bfb62]

Tejun Heo (2):
      libata: make it clear that sata_inic162x is experimental
         [bb9696192826a7d9279caf872e95b41bc26c7eff]
      workqueue: cond_resched() after processing each work item
         [b22ce2785d97423846206cceec4efee0c4afd980]

Terry Suereth (1):
      libata: apply behavioral quirks to sil3826 PMP
         [8ffff94d20b7eb446e848e0046107d51b17a20a8]

Thomas Loo (1):
      Bluetooth: ath3k: Add support for Fujitsu Lifebook UH5x2 [04c5:1330]
         [84eb2ae1807dd1467bf6f500fc69ae61f1907b75]

Tomasz Moń (1):
      mwifiex: Add missing endian conversion.
         [83e612f632c3897be29ef02e0472f6d63e258378]

Torstein Hegge (1):
      ALSA: usb: Parse UAC2 extension unit like for UAC1
         [61ac51301e6c6d4ed977d7674ce2b8e713619a9b]

Torsten Schenk (2):
      ALSA: 6fire: make buffers DMA-able (midi)
         [4c2aee0032b70083dafebd733ed9c774633b2fa3]
      ALSA: 6fire: make buffers DMA-able (pcm)
         [5ece263f1d93fba8d992e67e3ab8a71acf674db9]

Trond Myklebust (1):
      SUNRPC: Fix memory corruption issue on 32-bit highmem systems
         [347e2233b7667e336d9f671f1a52dfa3f0416e2c]

Uwe Kleine-König (2):
      serial/mxs-auart: fix race condition in interrupt handler
         [d970d7fe65adff5efe75b4a73c4ffc9be57089f7]
      serial/mxs-auart: increase time to wait for transmitter to become idle
         [079a036f4283e2b0e5c26080b8c5112bc0cc1831]

Vyacheslav Dubeyko (2):
      nilfs2: fix issue with counting number of bio requests for BIO_EOPNOTSUPP error detection
         [4bf93b50fd04118ac7f33a3c2b8a0a1f9fa80bc9]
      nilfs2: remove double bio_put() in nilfs_end_bio_write() for BIO_EOPNOTSUPP error
         [2df37a19c686c2d7c4e9b4ce1505b5141e3e5552]

Wanpeng Li (1):
      mm/memory-hotplug: fix lowmem count overflow when offline pages
         [cea27eb2a202959783f81254c48c250ddd80e129]

Will Deacon (3):
      ARM: 7791/1: a.out: remove partial a.out support
         [acfdd4b1f7590d02e9bae3b73bdbbc4a31b05d38]
      ARM: 7809/1: perf: fix event validation for software group leaders
         [c95eb3184ea1a3a2551df57190c81da695e2144b]
      alpha: makefile: don't enforce small data model for  kernel builds
         [cd8d2331756751b6aeb855a3c9cb0a92fbd9c725]

Wladislav Wiebe (1):
      of: fdt: fix memory initialization for expanded DT
         [9e40127526e857fa3f29d51e83277204fbdfc6ba]

Xi Wang (1):
      slab: introduce kmalloc_array()
         [a8203725dfded5c1f79dca3368a4a273e24b59bb]

Yonghua Zheng (1):
      fs/proc/task_mmu.c: fix buffer overflow in add_page_map()
         [8c8296223f3abb142be8fc31711b18a704c0e7d8]

Yu-Chen Cho (1):
      Bluetooth: Add support for Mediatek Bluetooth device [0e8d:763f]
         [178c059e7640aa8e50213400c6f3dde00189d979]

Zhu Yanhai (1):
      sched: Fix the broken sched_rr_get_interval()
         [a59f4e079d19464eebb9b06513a1d4f55fdae5ba]

 Makefile                                           |  4 +-
 arch/alpha/Makefile                                |  2 +-
 arch/arm/Kconfig                                   |  1 -
 arch/arm/include/asm/a.out-core.h                  | 45 --------------
 arch/arm/include/asm/a.out.h                       | 34 -----------
 arch/arm/include/asm/processor.h                   |  4 --
 arch/arm/kernel/perf_event.c                       | 10 ++-
 arch/cris/kernel/vmlinux.lds.S                     |  1 +
 arch/hexagon/kernel/dma.c                          |  1 +
 arch/hexagon/kernel/ptrace.c                       |  1 +
 arch/hexagon/kernel/time.c                         |  1 +
 arch/hexagon/kernel/vdso.c                         |  1 +
 arch/m32r/boot/compressed/Makefile                 |  6 +-
 arch/m32r/boot/compressed/misc.c                   | 12 +++-
 arch/m68k/emu/natfeat.c                            | 23 +++++--
 arch/m68k/include/asm/div64.h                      |  9 +--
 arch/microblaze/configs/mmu_defconfig              | 49 ++++++++++-----
 arch/microblaze/configs/nommu_defconfig            | 71 +++++++++++++---------
 arch/microblaze/include/asm/futex.h                |  2 +-
 arch/powerpc/Kconfig                               |  1 +
 arch/powerpc/include/asm/page.h                    | 10 +++
 arch/powerpc/kernel/lparcfg.c                      | 23 +++----
 arch/s390/kvm/kvm-s390.c                           | 17 ++++--
 arch/sparc/Kconfig                                 |  1 +
 arch/sparc/include/asm/atomic_32.h                 |  2 +
 arch/sparc/lib/Makefile                            |  2 +-
 arch/x86/kernel/i387.c                             |  2 +-
 arch/x86/kernel/sys_x86_64.c                       |  2 +-
 arch/x86/mm/mmap.c                                 |  6 +-
 arch/x86/xen/setup.c                               | 22 +++++++
 drivers/acpi/battery.c                             |  2 +
 drivers/ata/Kconfig                                |  2 +-
 drivers/ata/libata-pmp.c                           | 12 ++--
 drivers/ata/sata_inic162x.c                        | 14 +++++
 drivers/base/memory.c                              |  2 +
 drivers/base/power/domain.c                        |  3 +-
 drivers/bluetooth/ath3k.c                          | 10 +++
 drivers/bluetooth/btusb.c                          |  8 +++
 drivers/char/virtio_console.c                      | 47 ++++++++------
 drivers/gpu/drm/i915/i915_drv.h                    |  1 +
 drivers/gpu/drm/i915/i915_reg.h                    |  5 +-
 drivers/gpu/drm/i915/intel_display.c               | 16 +++++
 drivers/gpu/drm/i915/intel_lvds.c                  | 11 +---
 drivers/gpu/drm/i915/intel_ringbuffer.c            | 12 ++++
 drivers/gpu/drm/radeon/atom.c                      |  5 ++
 drivers/gpu/drm/radeon/evergreen.c                 |  3 +-
 drivers/gpu/drm/radeon/ni.c                        |  3 +-
 drivers/gpu/drm/radeon/r600.c                      |  3 +-
 drivers/gpu/drm/radeon/rv770.c                     |  3 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c                | 58 ++++++++++++------
 drivers/hwmon/adt7470.c                            |  2 +-
 drivers/md/raid1.c                                 |  2 +-
 drivers/net/arcnet/arcnet.c                        |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_82598.c |  3 +-
 drivers/net/ifb.c                                  |  1 +
 drivers/net/usb/smsc75xx.c                         | 12 +---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |  1 +
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      | 10 +++
 drivers/net/wireless/hostap/hostap_ioctl.c         |  4 +-
 drivers/net/wireless/iwlegacy/iwl-core.c           |  1 +
 drivers/net/wireless/iwlegacy/iwl4965-base.c       | 18 +++---
 drivers/net/wireless/iwlwifi/iwl-agn.c             |  2 +-
 drivers/net/wireless/iwlwifi/iwl-core.c            |  5 +-
 drivers/net/wireless/iwlwifi/iwl-pci.c             |  1 +
 drivers/net/wireless/mwifiex/sdio.c                |  4 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c          | 18 +++---
 drivers/net/wireless/zd1201.c                      |  4 +-
 drivers/of/fdt.c                                   |  2 +
 drivers/parisc/iommu-helpers.h                     |  2 +
 drivers/pci/Makefile                               |  1 +
 drivers/s390/scsi/zfcp_erp.c                       | 29 ++++++---
 drivers/s390/scsi/zfcp_qdio.c                      |  8 +--
 drivers/scsi/megaraid/megaraid_sas_base.c          | 20 ++++--
 drivers/scsi/nsp32.c                               |  2 +-
 drivers/target/target_core_cdb.c                   | 11 ++--
 drivers/tty/hvc/hvsi_lib.c                         |  4 +-
 drivers/tty/serial/mxs-auart.c                     | 38 +++++++-----
 drivers/usb/core/quirks.c                          |  6 ++
 drivers/usb/misc/adutux.c                          |  2 +-
 drivers/usb/serial/ftdi_sio.c                      | 31 +++++++++-
 drivers/usb/serial/ftdi_sio_ids.h                  | 34 +++++++++--
 drivers/usb/serial/keyspan.c                       |  2 +-
 drivers/usb/serial/mos7720.c                       | 21 ++++---
 drivers/usb/serial/mos7840.c                       | 18 +++++-
 drivers/usb/serial/ti_usb_3410_5052.c              |  9 +--
 drivers/xen/events.c                               | 13 +++-
 fs/bio.c                                           | 32 ++++++----
 fs/cifs/cifsencrypt.c                              |  2 +-
 fs/cifs/cifsglob.h                                 |  1 +
 fs/cifs/readdir.c                                  |  8 +++
 fs/cifs/sess.c                                     |  6 +-
 fs/exofs/ore.c                                     |  2 +-
 fs/exofs/ore_raid.c                                |  2 +-
 fs/ext4/ext4_jbd2.c                                |  8 +--
 fs/ext4/super.c                                    | 17 +++++-
 fs/jfs/jfs_dtree.c                                 | 31 +++++++---
 fs/nfs/callback_xdr.c                              |  6 +-
 fs/nilfs2/segbuf.c                                 |  5 +-
 fs/proc/task_mmu.c                                 |  6 +-
 include/linux/bio.h                                | 17 +++++-
 include/linux/ftrace_event.h                       |  4 +-
 include/linux/mm_types.h                           |  1 +
 include/linux/slab.h                               | 17 +++++-
 include/linux/wait.h                               | 57 +++++++++++++++++
 kernel/events/core.c                               | 20 +++++-
 kernel/sched_fair.c                                |  2 +-
 kernel/trace/trace.c                               |  1 +
 kernel/workqueue.c                                 |  9 +++
 mm/bounce.c                                        |  2 +-
 mm/nommu.c                                         | 10 +++
 mm/page_alloc.c                                    |  4 ++
 net/ipv4/sysctl_net_ipv4.c                         |  6 +-
 net/ipv6/ip6mr.c                                   |  5 ++
 net/key/af_key.c                                   |  5 ++
 net/mac80211/rx.c                                  | 10 ++-
 net/sched/sch_atm.c                                |  1 +
 net/sched/sch_cbq.c                                |  1 +
 net/sctp/outqueue.c                                |  8 +--
 net/sunrpc/auth_gss/gss_krb5_wrap.c                |  4 +-
 net/sunrpc/socklib.c                               |  4 +-
 net/sunrpc/xdr.c                                   | 25 ++++----
 net/sunrpc/xprtrdma/rpc_rdma.c                     |  8 +--
 net/wireless/nl80211.c                             |  7 ++-
 sound/i2c/other/ak4xxx-adda.c                      |  2 +-
 sound/isa/opti9xx/opti92x-ad1848.c                 |  8 +--
 sound/oss/Kconfig                                  |  1 +
 sound/usb/6fire/comm.c                             | 38 ++++++++++--
 sound/usb/6fire/comm.h                             |  2 +-
 sound/usb/6fire/midi.c                             | 16 ++++-
 sound/usb/6fire/midi.h                             |  6 +-
 sound/usb/6fire/pcm.c                              | 41 ++++++++++++-
 sound/usb/6fire/pcm.h                              |  2 +-
 sound/usb/mixer.c                                  | 16 ++++-
 tools/perf/util/map.c                              |  3 +-
 134 files changed, 980 insertions(+), 437 deletions(-)

-- 
Ben Hutchings
I haven't lost my mind; it's backed up on tape somewhere.

