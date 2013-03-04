Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab3CDBmO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 20:42:14 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:35373 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab3CDBmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 20:42:12 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.1303040213590.11934@twin.jikos.cz>
References: <CA+55aFx0HcOXKpxmZzM5jcbAaOroxafomX5ggMFV4A=py1qh-Q@mail.gmail.com>
	<alpine.LRH.2.00.1303040213590.11934@twin.jikos.cz>
Date: Sun, 3 Mar 2013 17:42:11 -0800
X-Google-Sender-Auth: _WxN1kmIwaAx8vOlJxz6YBhVtZs
Message-ID: <CA+55aFxA1pH_aKJc85DXuS2-Q=7b4pP-h_ms6XQiSzQcpWaO6Q@mail.gmail.com>
Subject: Re: Linux 3.9-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 3, 2013 at 5:17 PM, Jiri Kosina <jkosina@suse.cz> wrote:
>
> I actually quite liked your merge shortlog, which of course I can generate
> easily myself, but it was nice to have for free :)

No, you're right, I should do it. In fact, I should automate it better
so that I do it by default and don't have to do so much hand-editing
of the result of a (really) stupid shell script.

It's all based on just

    git log v3.8.. --author=Torvalds --merges |
        egrep '^    ((Merge)|(Pull)) .* from '

and then some nasty sed+sort crud, followed by some manual fixup. It's
the kind of thing perl is perfect for, but I'm not much of a perl
person, so I have never written a *good* script to just do this right.

Anyway, here it is, the merge-log of stuff that happened in the merge
window for 3.9.

                   Linus

---
Alasdair G Kergon:
        device-mapper update

Alex Williamson:
        VFIO updates

Al Viro:
        vfs pile (part one)
        vfs fix
        more VFS bits
        signal/compat fixes
        signal handling cleanups
        sigprocmask compat fix

Andrew Morton:
        misc patches
        second patch-bomb
        third patch-bumb

Anton Vorontsov:
        battery updates

Arnd Bergmann:
        ARM SoC board specific changes
        ARM SoC cleanups
        ARM SoC device tree conversions
        ARM SoC driver specific changes
        ARM SoC multiplatform support
        ARM SoC-specific updates
        non-critical ARM SoC bug fixes
        sh-mobile pinctrl conversion

Artem Bityutskiy:
        ubifs updates

Benjamin Herrenschmidt:
        powerpc updates

Ben Myers:
        xfs update

Bjorn Helgaas:
        PCI changes

Bob Liu:
        small blackfin update

Borislav Petkov:
        EDAC updates

Bryan Wu:
        LED subsystem update

Catalin Marinas:
        arm64 patches

Chris Ball:
        MMC update

Chris Mason:
        btrfs fixup
        btrfs update

Chris Zankel:
        xtensa update

Dave Airlie:
        drm merge

David Howells:
        fbdev UAPI disintegration

David Miller:
        networking update
        networking fixes
        sparc updates

David Teigland:
        dlm update

David Woodhouse:
        MTD update

Dmitry Torokhov:
        input updates

Eric Van Hensbergen:
        v9fs updates

Eric W Biederman:
        user namespace and namespace infrastructure changes

Geert Uytterhoeven:
        m68k update

Gleb Natapov:
        KVM ARM compile fixes
        one kvm bugfix

Grant Likely:
        device tree changes
        GPIO changes
        SPI changes

Greg Kroah-Hartman:
        char/misc driver patches
        char/misc patch
        driver core patches
        staging tree update
        tty/serial patches
        USB patches
        USB patch revert

Guenter Roeck:
        hwmon updates

Helge Deller:
        parisc updates
        second round of PARISC updates

Herbert Xu:
        crypto update

Ingo Molnar:
        core locking changes
        irq core changes
        perf changes
        perf fixes
        preparatory smp/hotplug patches
        RCU changes
        scheduler changes
        scheduler fixes
        timer changes
        timer fixes
        two x86 kernel build changes
        x86/apic changes
        x86/asm changes
        x86 bootup changes
        x86 cleanup patches
        x86/debug changes
        x86 fixes
        x86/hyperv changes
        x86 platform changes
        x86 UV3 support update

Jaegeuk Kim:
        f2fs update

James Bottomley:
        first round of SCSI updates
        SCSI updates

James Hogan:
        new ImgTec Meta architecture

James Morris:
        security subsystem fixes
        security subsystem updates

Jan Kara:
        ext2, ext3, udf updates

Jason Wessel:
        KGDB/KDB fixes and cleanups

J Bruce Fields:
        nfsd changes

Jeff Garzik:
        libata updates

Jens Axboe:
        block driver bits
        block IO core bits

Jiri Kosina:
        HID subsystem updates
        trivial tree

Joerg Roedel:
        IOMMU Updates

Jonas Bonn:
        OpenRISC updates

Konrad Rzeszutek Wilk:
        Xen bug-fixes
        Xen update

Linus Walleij:
        pinctrl changes

Marcelo Tosatti:
        KVM updates

Marek Szyprowski:
        DMA-mapping updates

Mark Brown:
        regmap updates
        regulator updates

Markus Oberhumer:
        LZO compression update

Martin Schwidefsky:
        s390 update
        second set of s390 patches

Matthew Garrett:
        x86 platform driver updates

Mauro Carvalho Chehab:
        EDAC fixes and ghes-edac
        media updates

Michael Turquette:
        clock framework update

Michal Marek:
        kbuild changes
        kconfig changes
        misc non-critical kbuild changes

Michal Simek:
        microblaze update

Miklos Szeredi:
        fuse updates

Nicholas Bellinger:
        scsi target updates
        SCSI target patches

Olof Johansson:
        ARM SoC i.MX DT changes
        ARM SoC late OMAP changes
        ARM SoC mvebu platform changes

Peter Anvin:
        more x86 fixes
        x86 cpu updates
        x86/EFI changes
        x86 microcode loading update
        x86 mm changes

Rafael Wysocki:
        ACPI and power management updates
        ACPI and power management fixes

Ralf Baechle:
        MIPS updates

Roland Dreier:
        infiniband update

Russell King:
        ARM updates (part one)
        ARM updates (part two)
        late ARM updates

Rusty Russell:
        module update
        virtio updates

Sage Weil:
        Ceph updates

Samuel Ortiz:
        MFS updates

Steve French:
        CIFS fixes

Steven Rostedt:
        ktest update

Steven Whitehouse:
        GFS2 updates

Sumit Semwal:
        dma-buf framework updates

Takashi Iwai:
        sound updates
        sound fixes

Ted Ts'o:
        ext4 updates
        ext4 regression fix
        ext4 bug fixes

Tejun Heo:
        async changes
        cgroup changes
        cpuset changes
        workqueue changes
        workqueue [delayed_]work_pending() cleanups

Thierry Reding:
        PWM changes

Tony Luck:
        ia64 update
        misc ia64 bits
        ia64 build breakage fix
        pstore patches

Trond Myklebust:
        NFS client bugfixes
        more NFS client bugfixes

Vineet Gupta:
        new ARC architecture

Vinod Koul:
        slave-dmaengine updates
        second set of slave-dmaengine updates

Wim Van Sebroeck:
        watchdog updates

Wolfram Sang:
        i2c updates

Wu Fengguang:
        writeback fixes

Zhang Rui:
        thermal management updates
