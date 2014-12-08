Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbaLHALA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 19:11:00 -0500
Received: from mail-qg0-f51.google.com ([209.85.192.51]:39263 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbaLHAK7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 19:10:59 -0500
MIME-Version: 1.0
Date: Sun, 7 Dec 2014 16:10:58 -0800
X-Google-Sender-Auth: OG8TPpQreHv7DkuXujqCn1ZMwiA
Message-ID: <CA+55aFwK3XtS32iJna-2uXZUfZQNUGC0Z4FmEFHK4JXB_kyojA@mail.gmail.com>
Subject: Linux 3.18 released
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's been a quiet week, and the patch from rc7 is tiny, so 3.18 is out.

I'd love to say that we've figured out the problem that plagues 3.17
for a couple of people, but we haven't. At the same time, there's
absolutely no point in having everybody else twiddling their thumbs
when a couple of people are actively trying to bisect an older issue,
so holding up the release just didn't make sense. Especially since
that would just have then held things up entirely over the holiday
break.

So the merge window for 3.19 is open, and DaveJ will hopefully get his
bisection done (or at least narrow things down sufficiently that we
have that "Ahaa" moment) over the next week. But in solidarity with
Dave (and to make my life easier too ;) let's try to avoid introducing
any _new_ nasty issues, ok?

                   Linus

---

Aaron Lu (1):
      ACPI / video: update condition to check if device is in _DOD list

Abhilash Kesavan (1):
      watchdog: s3c2410_wdt: Fix the mask bit offset for Exynos7

Al Viro (1):
      fat: fix oops on corrupted vfat fs

Alexander Kochetkov (2):
      i2c: omap: fix NACK and Arbitration Lost irq handling
      i2c: omap: fix i207 errata handling

Andrew Jackson (1):
      i2c: designware: prevent early stop on TX FIFO empty

Andrew Morton (2):
      mm/vmpressure.c: fix race in vmpressure_work_fn()
      drivers/input/evdev.c: don't kfree() a vmalloc address

Andrey Utkin (1):
      [media] Update MAINTAINERS for solo6x10

Andy Lutomirski (1):
      context_tracking: Restore previous state in schedule_user

Ben Skeggs (1):
      drm/nouveau/fifo/g84-: ack non-stall interrupt before handling it

Borislav Petkov (1):
      x86, microcode: Limit the microcode reloading to 64-bit for now

Chris Clayton (1):
      x86: Use $(OBJDUMP) instead of plain objdump

Christian König (1):
      drm/radeon: sync all BOs involved in a CS v2

Daniel Forrest (1):
      mm: fix anon_vma_clone() error treatment

Daniel Vetter (2):
      drm/i915: More cautious with pch fifo underruns
      drm/i915: Unlock panel even when LVDS is disabled

Darrick J. Wong (2):
      jbd2: fix regression where we fail to initialize checksum seed
when loading
      block: fix regression where bio_integrity_process uses wrong
bio_vec iterator

Dave Airlie (1):
      nouveau: move the hotplug ignore to correct place.

David Howells (3):
      KEYS: Fix the size of the key description passed to/from userspace
      KEYS: Simplify KEYRING_SEARCH_{NO,DO}_STATE_CHECK flags
      KEYS: request_key() should reget expired keys rather than give EKEYEXPIRED

David Härdeman (1):
      [media] rc-core: fix toggle handling in the rc6 decoder

Devin Ryles (1):
      AHCI: Add DeviceIDs for Sunrise Point-LP SATA controller

Dmitry Torokhov (1):
      sata_fsl: fix error handling of irq_of_parse_and_map

Grygorii Strashko (1):
      i2c: davinci: generate STP always when NACK is received

Hans Verkuil (1):
      [media] cx23885: use sg = sg_next(sg) instead of sg++

Hariprasad Shenai (1):
      cxgb4: Fill in supported link mode for SFP modules

Huacai Chen (1):
      stmmac: platform: Move plat_dat checking earlier

Hugh Dickins (1):
      mm: fix swapoff hang after page migration and fork

Ian Campbell (1):
      of/fdt: memblock_reserve /memreserve/ regions in the case of
partial overlap

Ilia Mirkin (1):
      drm/nouveau/gf116: remove copy1 engine

Kailang Yang (1):
      ALSA: hda/realtek - Add headset Mic support for new Dell machine

Krzysztof Hałasa (1):
      [media] solo6x10: fix a race in IRQ handler

Linus Torvalds (1):
      Linux 3.18

Maarten Lankhorst (1):
      drm/nouveau: prevent stale fence->channel pointers, and protect with rcu

Manfred Spraul (1):
      ipc/sem.c: fully initialize sem_array before making it visible

Masahiro Yamada (1):
      uapi: fix to export linux/vm_sockets.h

Mauro Carvalho Chehab (1):
      MAINTAINERS: Update mchehab's addresses

Michal Simek (1):
      lib/genalloc.c: export devm_gen_pool_create() for modules

Michel Dänzer (1):
      drm/radeon: Ignore RADEON_GEM_GTT_WC on 32-bit x86

Mitsuhiro Kimura (2):
      sh_eth: Fix skb alloc size and alignment adjust rule.
      sh_eth: Fix sleeping function called from invalid context

Nicolas Dichtel (1):
      rtnetlink: release net refcnt on error in do_setlink()

Paul Mackerras (1):
      slab: fix nodeid bounds check for non-contiguous node IDs

Petr Mladek (1):
      drm/radeon: kernel panic in
drm_calc_vbltimestamp_from_scanoutpos with 3.18.0-rc6

Rafael Aquini (1):
      mm: do not overwrite reserved pages counter at show_mem()

Sakari Ailus (1):
      [media] smiapp: Only some selection targets are settable

Sebastian Ott (1):
      s390: fix machine check handling

Seth Forshee (1):
      xen-netfront: Remove BUGs on paged skb data which crosses a page boundary

Tejun Heo (1):
      ahci: disable MSI on SAMSUNG 0xa800 SSD

Thierry Reding (1):
      PCI: tegra: Use physical range for I/O mapping

Thomas Graf (1):
      bond: Check length of IFLA_BOND_ARP_IP_TARGET attributes

Vishnu Motghare (1):
      i2c: cadence: Set the hardware time-out register to maximum value

Weijie Yang (1):
      mm: frontswap: invalidate expired data on a dup-store failure

sensoray-dev (1):
      [media] s2255drv: fix payload size for JPG, MJPEG
