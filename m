Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab3GNX50 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 19:57:26 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:59798 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab3GNX5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 19:57:24 -0400
MIME-Version: 1.0
Date: Sun, 14 Jul 2013 16:57:23 -0700
X-Google-Sender-Auth: YG6s8Luykk_ZSFonvJpzmRkpjrc
Message-ID: <CA+55aFyfTJKRnsFHGxQ+-2+GVstMUj6t4f0q5-8wJMbN-Y93+g@mail.gmail.com>
Subject: Linux 3.11-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's been two weeks, and the merge window has closed. If I missed
anything, holler, but I don't have anything pending that I am aware
of.

This merge window was smaller in terms of number of commits than the
3.10 merge window, but we actually have more new lines. Most of that
seems to be in staging - a full third of all changes by line-count is
staging, and merging in Lustre is the bulk of that. Let's see how that
all turns out, I have to say that we don't have a great track record
on merging filesystems through staging.

Ignoring the lustre merge, I think this really was a somewhat calmer
merge window. We had a few trees with problems, and we have an
on-going debate about stable patches that was triggered largely thanks
to this merge window, so now we'll have something to discuss for the
kernel summit. But on the whole, I suspect we might be starting to see
the traditional summer slump (Australia notwithstanding).

Despite being a bit smaller than the last merge window, it's not like
this was a _tiny_ one, and so as usual I'm only summarizing with the
normal -rc1 mergelog: and as usual the people credited here are *not*
the people who actually wrote the code (although in some cases that is
true), they are the people who I merged the code from.

Hey, let's all start testing,

                     Linus

---
Al Viro: (4)
        VFS patches (part 1)
        second set of VFS changes
        third set of VFS updates
        more vfs stuff

Alasdair G Kergon: (1)
        device-mapper changes

Alex Williamson: (1)
        vfio updates

Andrew Morton: (3)
        first patch-bomb
        second patch-bomb
        more patches

Anton Vorontsov: (1)
        battery subsystem update

Arnd Bergmann: (7)
        ARM SoC non-cricitical bug fixes
        ARM SoC cleanups
        ARM SoC specific changes
        ARM SoC board specific changes
        ARM SoC device tree changes
        ARM SoC driver specific changes
        ARM SoC late changes

Artem Bityutskiy: (2)
        ubifs fix
        ubi fixes

Ben Herrenschmidt: (1)
        powerpc updates

Ben Myers: (2)
        xfs update
        more xfs updates

Bjorn Helgaas: (1)
        PCI changes

Borislav Petkov: (1)
        AMD EDAC update

Bruce Fields: (1)
        nfsd changes

Bryan Wu: (1)
        LED subsystem updates

Catalin Marinas: (1)
        ARM64 updates

Chris Ball: (1)
        MMC updates

Chris Mason: (1)
        btrfs update

Chris Zankel: (1)
        Xtensa updates

Dave Airlie: (1)
        drm updates

Dave Hansen: (2)
        branch 'kconfig-diet'
        Kconfig menu diet patches

Dave Kleikamp: (1)
        jfs update

David Howells: (1)
        FS-Cache updates

David Miller: (4)
        networking updates
        IDE updates
        Sparc bugfixes
        networking fixes

David Teigland: (1)
        dlm updates

Dmitry Torokhov: (2)
        input updates
        second round of input updates

Eric Van Hensbergen: (2)
        9p update
        second round of 9p patches

Geert Uytterhoeven: (2)
        m68k updates
        "exotic" arch fixes

Gleb Natapov: (1)
        more KVM changes

Grant Likely: (2)
        device tree updates
        irqdomain refactoring

Greg KH: (5)
        USB updates
        tty/serial updates
        staging tree update
        char/misc updates
        driver core updates

Guenter Roeck: (1)
        hwmon updates

Helge Deller: (1)
        parisc updates

Herbert Xu: (1)
        crypto update

Ingo Molnar: (22)
        locking changes
        WW mutex support
        RCU updates
        core irq changes
        perf updates
        scheduler updates
        voluntary preemption fixes
        asm/x86 changes
        x86 boot build fix
        x86 cleanups
        x86 cpu updates
        x86 debug update
        x86 EFI changes
        x86 FPU changes
        x86 microcode loading update
        x86 mm changes
        x86 platform updates
        x86 RAS update
        x86 tracing updates
        x86 UV update
        x86 fix
        perf fixes

Jaegeuk Kim: (1)
        f2fs updates

James Bottomley: (2)
        first round of SCSI updates
        final round of SCSI updates

James Hogan: (2)
        Metag architecture changes
        arch/metag fixes

James Morris: (1)
        security subsystem updates

Jan Kara: (1)
        ext3 fix and quota cleanup

Jean Delvare: (1)
        hwmon update

Jean-Christophe PLAGNIOL-VILLARD: (1)
        fbdev update

Jens Axboe: (1)
        core block IO updates

Jiri Kosina: (2)
        HID updates
        trivial tree updates

Joerg Roedel: (1)
        IOMMU updates

Konrad Rzeszutek Wilk: (1)
        Xen bugfixes

Linus Walleij: (2)
        GPIO updates
        pin control changes

Marek Szyprowski: (1)
        ARM DMA mapping updates

Mark Brown: (4)
        regmap updates
        spi updates
        regulator updates
        regulator fixes

Martin Schwidefsky: (1)
        s390 updates

Matthew Garrett: (1)
        x86 platform driver updates

Mauro Carvalho Chehab: (1)
        media updates

Michael S Tsirkin: (1)
        vhost fixes and cleanups

Michal Marek: (3)
        kbuild updates
        kconfig updates
        coccinelle updates

Michal Simek: (1)
        microblaze update

Mike Turquette: (1)
        clock framework updates

Mikulas Patocka: (2)
        branch 'hpfs'
        hpfs patches

NeilBrown: (1)
        md updates

Nicholas Bellinger: (1)
        SCSI target updates

Ohad Ben-Cohen: (1)
        remoteproc fixes

Olof Johansson: (1)
        ARM SoC fixes

Paolo Bonzini: (1)
        KVM fixes

Paul Gortmaker: (1)
        first stage of __cpuinit removal

Pekka Enberg: (1)
        slab update

Rafael Wysocki: (2)
        power management and ACPI updates
        more power management and ACPI updates

Ralf Baechle: (1)
        MIPS updates

Roland Dreier: (1)
        InfiniBand/RDMA changes

Russell King: (2)
        ARM updates
        ARM fixes

Rusty Russell: (3)
        trivial module and virtio fixes
        virtio updates
        module updates

Sage Weil: (1)
        Ceph updates

Samuel Ortiz: (1)
        MFD update

Stefan Richter: (1)
        firewire updates

Steve French: (2)
        cifs updates
        cifs fixes

Steven Miao: (1)
        blackfin updates

Steven Rostedt: (1)
        tracing changes

Steven Whitehouse: (1)
        GFS2 updates

Takashi Iwai: (2)
        sound updates
        sound fixes

Ted Ts'o: (1)
        ext4 update

Tejun Heo: (5)
        per-cpu changes
        workqueue changes
        cgroup changes
        cpuset changes
        libata updates

Thierry Reding: (1)
        pwm changes

Thomas Gleixner: (7)
        timer core updates
        printk locking fix
        core locking updates
        perf fixes
        timer updates
        irq updates
        scheduler fix

Tony Luck: (4)
        misc ia64 updates
        pstore update
        ia64 IOH hotplug fixes
        thermal power-limit update

Trond Myklebust: (2)
        NFS client updates
        second set of NFS client updates

Tyler Hicks: (1)
        eCryptfs updates

Vineet Gupta: (2)
        first batch of ARC changes
        second set of ARC architecture updates

Vinod Koul: (1)
        slave-dmaengine updates

Wim Van Sebroeck: (1)
        watchdog updates

Wolfram Sang: (1)
        i2c updates

Zhang Rui: (1)
        thermal management updates
