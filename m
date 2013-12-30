Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab3L3AOl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 19:14:41 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43646 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557Ab3L3AOj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 19:14:39 -0500
MIME-Version: 1.0
Date: Sun, 29 Dec 2013 16:14:38 -0800
X-Google-Sender-Auth: DoL5tScUglQ6t9rZZYtvy__KihE
Message-ID: <CA+55aFy+C5wH-7r_0hqo1YEaL2KUHBu2Z0i1OUNfXaw2Tbs-1w@mail.gmail.com>
Subject: Linux 3.13-rc6
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As expected, things have been quiet over the holiday week. So various
small random updates: drivers (infiniband, gpu, cpufreq, libata,
block), some small filesystem fixes (ext4/jbd2), and a few ARM SoC
things. Tiny x86, percpu and cgroup fixes.

Nothing you'd normally even notice, just 81 fairly small commits.

              Linus

---

Al Viro (1):
      ext4: fix del_timer() misuse for ->s_err_report

Alex Deucher (4):
      drm/radeon/dce6: set correct number of audio pins
      drm/radeon/dpm: disable ss on Cayman
      drm/radeon: check for 0 count in speaker allocation and SAD code
      drm/radeon: fix asic gfx values for scrapper asics

Andrey Vagin (1):
      block: fix memory leaks on unplugging block device

Ard Biesheuvel (1):
      auxvec.h: account for AT_HWCAP2 in AT_VECTOR_SIZE_BASE

Ben Dooks (1):
      ARM: shmobile: r8a7790: fix shdi resource sizes

Chad Hanson (1):
      selinux: fix broken peer recv check

Chris Wilson (3):
      drm/i915: Prevent double unref following alloc failure during execbuffer
      drm/i915: Fix erroneous dereference of batch_obj inside reset_status
      drm/i915: Use the correct GMCH_CTRL register for Sandybridge+

Dmitry Monakhov (1):
      jbd2: rename obsoleted msg JBD->JBD2

Eryu Guan (1):
      ext4: check for overlapping extents in ext4_valid_extent_entries()

Jacob Pan (1):
      powercap / RAPL: add support for ValleyView Soc

Jan Beulich (1):
      x86/efi: Don't select EFI from certain special ACPI drivers

Jan Kara (4):
      ext2: Fix oops in ext2_get_block() called from ext2_quota_write()
      ext4: Do not reserve clusters when fs doesn't support extents
      jbd2: revise KERN_EMERG error messages
      ext4: fix deadlock when writing in ENOSPC conditions

Jason Baron (1):
      cpufreq: Use CONFIG_CPU_FREQ_DEFAULT_* to set initial policy for
setpolicy drivers

Junho Ryu (1):
      ext4: fix use-after-free in ext4_mb_new_blocks

Kent Overstreet (4):
      bcache: Use uninterruptible sleep in writeback
      bcache: Fix dirty_data accounting
      bcache: bugfix for race between moving_gc and bucket_invalidate
      bcache: New writeback PD controller

Kuninori Morimoto (1):
      ARM: shmobile: bockw: fixup DMA mask

Laurent Pinchart (1):
      ARM: shmobile: armadillo: Add PWM backlight power supply

Len Brown (1):
      x86 idle: Repair large-server 50-watt idle-power regression

Li Zefan (1):
      cgroup: don't recycle cgroup id until all csses' have been destroyed

Linus Torvalds (1):
      Linux 3.13-rc6

Linus Walleij (1):
      ARM: pxa: fix USB gadget driver compilation regression

Luiz Capitulino (1):
      virtio_balloon: update_balloon_size(): update correct field

Marc Carino (1):
      libata: implement ATA_HORKAGE_NO_NCQ_TRIM and apply it to Micro M500 SSDs

Marek Vasut (1):
      ahci: imx: Explicitly clear IMX6Q_GPR13_SATA_MPLL_CLK_EN

Masami Ichikawa (1):
      PM / sleep: Fix memory leak in pm_vt_switch_unregister().

Matias Bjorling (4):
      null_blk: mem garbage on NUMA systems during init
      null_blk: documentation
      null_blk: refactor init and init errors code paths
      null_blk: warning on ignored submit_queues param

Matias Bjørling (3):
      null_blk: corrections to documentation
      null_blk: set use_per_node_hctx param to false
      null_blk: support submit_queues on use_per_node_hctx

Michele Baldessari (1):
      libata: add ATA_HORKAGE_BROKEN_FPDMA_AA quirk for Seagate
Momentus SpinPoint M8

Ming Lei (1):
      scripts/link-vmlinux.sh: only filter kernel symbols for arm

Nicholas Swenson (5):
      bcache: Fix for can_attach_cache()
      bcache: Fix heap_peek() macro
      bcache: fix for gc crashing when no sectors are used
      bcache: bugfix - moving_gc now moves only correct buckets
      bcache: fix for gc and writeback race

Oleg Nesterov (1):
      selinux: selinux_setprocattr()->ptrace_parent() needs rcu_read_lock()

Paul Bolle (1):
      ahci: bail out on ICH6 before using AHCI BAR

Paul Drews (1):
      ACPI: Add BayTrail SoC GPIO and LPSS ACPI IDs

Paulo Zanoni (2):
      drm/i915: change CRTC assertion on LCPLL disable
      drm/i915: get a PC8 reference when enabling the power well

Rajendra Nayak (1):
      ARM: DRA7: hwmod: Fix boot crash with DEBUG_LL

Randy Dunlap (1):
      gpu: fix qxl missing crc32_le

Rashika (1):
      RDMA/cxgb4: Make _c4iw_write_mem_dma() static

Rashika Kheria (1):
      drivers: block: Mark the functions as static in skd_main.c

Robin H. Johnson (1):
      libata: disable a disk via libata.force params

Roland Dreier (1):
      IB/uverbs: New macro to set pointers to NULL if length is 0 in
INIT_UDATA()

Stefan Priebe (1):
      bcache: kthread don't set writeback task to INTERUPTIBLE

Steve Wise (1):
      RDMA/iwcm: Don't touch cm_id after deref in rem_ref

Suman Anna (1):
      ARM: OMAP2+: hwmod_data: fix missing OMAP_INTC_START in irq data

Tejun Heo (3):
      percpu: fix spurious sparse warnings from DEFINE_PER_CPU()
      cgroup: fix cgroup_create() error handling path
      libata, freezer: avoid block device removal while system is frozen

Theodore Ts'o (3):
      ext4: call ext4_error_inode() if jbd2_journal_dirty_metadata() fails
      jbd2: don't BUG but return ENOSPC if a handle runs out of space
      ext4: add explicit casts when masking cluster sizes

Thomas Hellstrom (1):
      drm/ttm: Fix swapin regression

Tony Lindgren (1):
      ARM: OMAP2+: Fix LCD panel backlight regression for LDP legacy booting

Viresh Kumar (1):
      cpufreq: remove sysfs files for CPUs which failed to come back
after resume

Wei Yongjun (1):
      bcache: fix sparse non static symbol warning

Yann Droneaud (7):
      IB/core: const'ify inbuf in struct ib_udata
      IB/uverbs: Check reserved field in extended command header
      IB/uverbs: Check comp_mask in destroy_flow
      IB/uverbs: Check reserved fields in create_flow
      IB/uverbs: Set error code when fail to consume all flow_spec items
      IB/uverbs: Check input length in flow steering uverbs
      IB/uverbs: Check access to userspace response buffer in extended command
