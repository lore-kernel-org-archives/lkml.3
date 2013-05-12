Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab3ELBAM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 21:00:12 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:33437 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab3ELBAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 21:00:10 -0400
MIME-Version: 1.0
Date: Sat, 11 May 2013 18:00:09 -0700
X-Google-Sender-Auth: wV6C1Y8x4vTazRSxHBPHeTgfLEA
Message-ID: <CA+55aFwfK661zATyUpjkXJo1av51nmMweYdPJE7Le7S2KS3xwg@mail.gmail.com>
Subject: Linux 3-10-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So this is the biggest -rc1 in the last several years (perhaps ever)
at least as far as counting commits go, even if not necessarily in
actual lines (I didn't check the statistics on that).

Which was unexpected, because while linux-next was fairly big, it
wasn't exceptionally so. I'm sure Stephen Rothwell will talk about the
statistics of commits that weren't in -next, we'll see if that was the
reason..

Anyway, despite the large number of commits, hopefully it's all
boringly straigthforward. Sure.

Now, even normally, there's no way to list all the changes, much less
so when it's an unusually large -rc1. But I can do my "merge shortlog"
again, and it's worth mentioning (again) that the name attributed to
the merge is *not* necessarily the author of any of the code, it's
literally just the person who emailed me the pull request. So you can
see this as an approximation of "first-level maintainership" or
something, although even that is somewhat misleading since some of
these things are really done by groups and then there's one person who
end up sending me the end result.

But it's somewhat readable, and gives you a reasonable idea of what is
going on. A better idea can be gotten by looking at git directly,
especially since the merge commits often do contain a better
description of what happened. Not that all submaintainers necessarily
always send me that, but most of the merges actually do have
human-readable background information.

It's possible that I missed something. This really was a busier merge
window than usual. Holler if so,

                    Linus

---
  Al Viro: (7)
        VFS updates
        compat cleanup
        second round of VFS updates
        single_open() leak fixes
        more vfs updates
        more vfs fixes
        stray syscall bits

  Alasdair Kergon: (1)
        device-mapper updates

  Alex Elder: (1)
        Ceph changes

  Alex Williamson: (1)
        vfio updates

  Andrew Morton: (5)
        first batch of fixes
        second batch of fixes
        third batch of fixes
        IPC cleanup and scalability patches
        more incoming

  Anton Vorontsov: (2)
        battery updates
        pstore update

  Arnd Bergmann: (5)
        ARM SoC platform updates (part 2)
        ARM SoC platform updates (part 3)
        ARM SoC device tree updates (part 2)
        ARM SoC late cleanups
        late ARM Exynos multiplatform changes

  Ben Myers: (2)
        xfs update
        xfs update (#2)

  Benjamin Herrenschmidt: (2)
        powerpc update
        powerpc updates

  Bjorn Helgaas: (2)
        PCI updates
        PCI updates

  Borislav Petkov: (1)
        two small EDAC fixes

  Bruce Fields: (1)
        nfsd fixes

  Bryan Wu: (1)
        LED subsystem updates

  Catalin Marinas: (2)
        arm64 update
        arm64 update

  Chris Ball: (1)
        MMC update

  Chris Mason: (1)
        btrfs update

  Chris Metcalf: (2)
        tile arch changes
        tile update

  Chris Zankel: (1)
        xtensa updates

  Dave Airlie: (1)
        drm updates

  David Kleikamp: (1)
        jfs fixes

  David Miller: (5)
        networking updates
        sparc updates
        networking fixes
        networking fixes
        networking update

  David Teigland: (1)
        dlm update

  David Woodhouse: (2)
        MTD update
        misc fixes

  Dmitry Torokhov: (1)
        input updates

  Eric Paris: (1)
        audit changes

  Geert Uytterhoeven: (1)
        m68k update

  Gleb Natapov: (2)
        kvm updates
        kvm fixes

  Grant Likely: (2)
        GPIO changes
        removal of GENERIC_GPIO

  Greg Kroah-Hartman: (5)
        char/misc driver update
        driver core update
        staging driver tree update
        tty/serial driver update
        USB patches

  Greg Ungerer: (1)
        m68knommu updates

  Guenter Roeck: (1)
        hwmon update

  Helge Deller: (1)
        parisc updates

  Herbert Xu: (1)
        crypto update

  Ingo Molnar: (18)
        locking changes
        RCU updates
        perf updates
        scheduler changes
        SMP/hotplug changes
        core timer updates
        extable dmesg fixlet
        x86 cleanups
        x86 cpuid changes
        x86 debug update
        perparatory x86 kasrl changes
        x86 mm changes
        x86 paravirt update
        x86 platform changes
        x86 RAS changes
        scheduler fixes
        perf fixes
        'full dynticks' support

  J Bruce Fields: (1)
        nfsd changes

  Jaegeuk Kim: (1)
        f2fs updates

  James "Jej B" Bottomley: (2)
        first round of SCSI updates
        second SCSI update

  James Hogan: (1)
        arch/metag update

  James Morris: (1)
        security subsystem update

  Jan Kara: (1)
        ext3/jbd fixes

  Jean Delvare: (1)
        hwmon update

  Jeff Garzik: (1)
        libata update

  Jens Axboe: (2)
        block core updates
        block driver updates

  Jiri Kosina: (4)
        trivial tree updates
        HID updates
        fixup for trivial branch
        HID fixes

  Joerg Roedel: (1)
        IOMMU updates

  Konrad Rzeszutek Wilk: (2)
        Xen updates
        Xen bug-fixes

  Len Brown: (1)
        idle update

  Linus Walleij: (2)
        pinctrl update
        pinctrl fixes

  Mark Brown: (3)
        regmap updates
        regulator updates
        spi updates

  Martin Schwidefsky: (2)
        s390 update
        more s390 updates

  Matthew Garrett: (1)
        x86 platform drivers

  Matthew Wilcox: (1)
        NVMe driver update

  Mauro Carvalho Chehab: (3)
        media update
        edac fixes
        omap3isp clk support

  Michael Tsirkin: (2)
        vhost cleanups and fixes
        more vhost fixes

  Michael Turquette: (1)
        clock framework update

  Michal Marek: (3)
        kbuild changes
        kconfig updates
        misc kbuild updates

  Michal Simek: (1)
        microblaze updates

  Michel Lespinasse: (1)
        rwsem optimizations

  Miklos Szeredi: (1)
        fuse updates

  my IPC branch: (1)
        ipc fixes and cleanups

  NeilBrown: (1)
        md fixes

  Nicholas Bellinger: (1)
        SCSI target update

  Ohad Ben-Cohen: (2)
        rpmsg changes
        remoteproc update

  Olof Johansson: (10)
        ARM SoC non-critical fixes
        ARM SoC cleanup
        ARM SoC device-tree updates
        ARM SoC platform updates
        ARM SoC multiplatform updates
        ARM SoC driver changes
        ARM SoC pinctrl changes for Renesas
        ARM platform specific firmware interfaces
        ARM SoC board specific changes (part 1)
        ARM SoC fixes and straggler patches

  Pekka Enberg: (1)
        slab changes

  Peter Anvin: (2)
        x86/efi changes
        x86 fixes

  Rafael J Wysocki: (1)
        power management and ACPI updates

  Rafael Wysocki: (1)
        ACPICA fixes

  Ralf Baechle: (1)
        MIPS updates

  Richard Kuo: (2)
        Hexagon fixes
        Hexagon fixes

  Roland Dreier: (1)
        InfiniBand/RDMA changes

  Russell King: (1)
        ARM updates

  Rusty Russell: (2)
        virtio & lguest updates
        mudule updates

  Samuel Ortiz: (1)
        MFD update

  Sarah Sharp: (1)
        ReportingBugs rewrite

  Stefan Richter: (1)
        firewure updates

  Stefano Stabellini: (1)
        ARM Xen SMP updates

  Steve French: (1)
        CIFS fixes

  Steven Miao: (1)
        blackfin updates

  Steven Rostedt: (4)
        tracing updates
        ktest update
        localmodconfig changes
        tracing/kprobes update

  Steven Whitehouse: (1)
        GFS2 updates

  Sumit Semwal: (1)
        dma-buf updates

  Takashi Iwai: (2)
        sound updates
        sound fixes

  Ted Ts'o: (1)
        ext4 updates

  Tejun Heo: (5)
        percpu patch
        async update
        workqueue updates
        cgroup updates
        libata maintainership change

  Thierry Reding: (1)
        pwm changes

  Tomi Valkeinen: (1)
        fbdev updates

  Tony Luck: (2)
        ia64 fixes
        trivial pstore update

  Trond Myklebust: (2)
        NFS client bugfixes and cleanups
        more NFS client bugfixes

  Tyler Hicks: (1)
        eCryptfs update

  Vineet Gupta: (2)
        ARC port updates
        second set of arc arch updates

  Vinod Koul: (1)
        slave-dmaengine updates

  Wim Van Sebroeck: (1)
        watchdog update

  Wolfram Sang: (1)
        i2c changes

  Zhang Rui: (1)
        thermal management update
