Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962AbaFPEM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 00:12:56 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:62121 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767AbaFPEMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 00:12:55 -0400
MIME-Version: 1.0
Date: Sun, 15 Jun 2014 18:12:54 -1000
X-Google-Sender-Auth: nhVo3GoapogTWCEdd4waLaUF0T4
Message-ID: <CA+55aFzNDTm_O8rGYdNw1S99P06u6EeSdttXBvtURJocQT2O0g@mail.gmail.com>
Subject: Linux 3.16-rc1 - merge window closed
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So it's been two weeks since the merge window opened, and rc1 is out
there and thus the merge window is closed.

It may have been a slightly unusual two week merge window, in that
it's only one week since the release of 3.15 and the first week
overlapped with the last -rc for that previous release, but that
doesn't seem to have affected development much.  Things look normal,
and if anything, this is one of the bigger release windows rather than
on the smaller side. It's not quite as big as the merge window for
3.15, but it's actually not that far off.

It also looks fairly usual from a statistics standpoint: about two
thirds of the changes are to drivers (and one third of *that* is to
staging), and half of the remainder is architecture updates (with arm
dominating, dts files leading - but there's mips, powerpc, x86 and
arm64 there too).

Outside of drivers and architecture updates, there's the usual mixture
of changes elsewhere: filesystems (mainly reiserfs, xfs, btrfs, nfs),
networking, "core" kernel (mm, locking, scheduler, tracing), and
tooling (perf and power, also new self-tests).

Also as usual, the shortlog is much too big to be generally useful and
posted as part of this announcement, but you can obviously look at the
details in git. I'm posting the "mergelog" as usual, which I think is
a slightly better way to see the high-level picture. And as usual, it
credits not the people who necessarily wrote the code, but the
submaintainers that sent it to me. For real credits, see the git tree.

Go forth and test,

              Linus

---

Al Viro (1):
    vfs updates

Alex Williamson (1):
    VFIO updates

Andrew Morton (3):
    misc updates
    more updates
    leftovers

Arnd Bergmann (1):
    part two of ARM SoC updates

Artem Bityutskiy (1):
    UBIFS updates

Behan Webster (1):
    LLVM patches

Ben Herrenschmidt (2):
    powerpc updates
    more powerpc updates

Ben LaHaise (1):
    aio fix and cleanups

Bjorn Helgaas (2):
    PCI changes
    more PCI updates

Boaz Harrosh (1):
    exofs raid6 support

Borislav Petkov (1):
    EDAC changes

Brian Norris (1):
    MTD updates

Bruce Fields (1):
    nfsd updates

Bryan Wu (1):
    LED updates

Catalin Marinas (1):
    arm64 updates

Chris Ball (1):
    MMC update

Chris Mason (2):
    btrfs updates
    more btrfs updates

Chris Metcalf (1):
    arch/tile changes

Dave Airlie (1):
    drm updates

Dave Chinner (1):
    xfs updates

Dave Kleikamp (1):
    jfs changes

David Miller (2):
    networking updates
    networking fixes

David Teigland (1):
    dlm fix

David Vrabel (1):
    Xen updates

Dmitry Torokhov (1):
    input updates

Eric Van Hensbergen (1):
    9p fixes

Geert Uytterhoeven (1):
    m68k updates

Greg KH (5):
    char/misc driver patches
    driver core / kernfs changes
    staging driver updates
    tty/serial driver updates
    USB driver updates

Greg Ungerer (1):
    m68knommu updates

Guenter Roeck (2):
    hwmon updates
    hwmon updates

Herbert Xu (1):
    crypto updates

Ingo Molnar (17):
    RCU changes
    core locking updates
    perf updates
    scheduler updates
    x86 asm cleanups
    x86 boot changes
    x86 build cleanups
    x86 irq cleanup
    x86 microcode changes
    x86 mm update
    x86 IOSF platform updates
    x86 RAS changes
    x86/UV changes
    more locking changes
    more perf updates
    more scheduler updates
    x86 irq fixes

Jaegeuk Kim (1):
    f2fs updates

James Bottomley (2):
    SCSI updates
    more SCSI updates

Jan Kara (1):
    reiserfs and ext3 changes

Jeff Layton (1):
    file locking changes

Jens Axboe (4):
    block core updates
    block driver changes
    block follow-up bits
    block layer fixes

Jiri Kosina (2):
    trivial tree changes
    HID patches

Joerg Roedel (1):
    IOMMU updates

Lee Jones (3):
    MFD updates
    more MFD updates
    backlight fixes

Linus Walleij (3):
    GPIO updates
    pin control changes
    GPIO fix

Marek Szyprowski (1):
    CMA and DMA-mapping fixes

Mark Brown (3):
    regmap updates
    spi updates
    regulator updates

Martin Schwidefsky (1):
    first set of s390 updates

Matthew Garrett (1):
    x86 platform driver updates

Matthew Wilcox (1):
    NVMe update

Mauro Carvalho Chehab (3):
    media updates
    updates and DT support for media engines
    OMAP3 updates

Michael S (1):
    vhost infrastructure updates

Michal Marek (2):
    kbuild updates
    kbuild misc updates

Michal Simek (1):
    Microblaze updates

Mike Snitzer (1):
    device mapper updates

Mike Turquette (2):
    clock framework updates
    more clock framework updates

Neil Brown (1):
    md updates

Nicholas Bellinger (1):
    SCSI target updates

Olof Johansson (7):
    ARM SoC low-priority fixes
    ARM SoC cleanups
    part one of ARM SoC updates
    ARM SoC board support updates
    ARM SoC defconfig updates
    ARM SoC devicetree updates
    ARM SoC driver changes

Paolo Bonzini (1):
    KVM updates

Peter Anvin (7):
    x86 x32 ABI fix
    x86-64 espfix changes
    x86 cdso updates
    x86 EFI updates
    ARM64 EFI update
    x86 vdso build fix
    x86 vdso fixes

Rafael Wysocki (2):
    ACPI and power management updates
    more ACPI and power management updates

Ralf Baechle (1):
    MIPS updates

Rob Herring (1):
    DeviceTree updates

Roland Dreier (1):
    main InfiniBand/RDMA updates

Russell King (1):
    ARM updates

Rusty Russell (2):
    module updates
    virtio updates

Sage Weil (1):
    Ceph updates

Sebastian Reichel (2):
    HSI (High Speed Syncronous Interface) changes
    HSI build fixes

Serge Hallyn (2):
    security layer updates
    more security layer updates

Simon Horman (1):
    SH driver update

Stefan Richter (1):
    firewire updates

Steve French (1):
    CIFS fixes

Steven Miao (1):
    blackfin updates

Steven Rostedt (2):
    tracing updates
    tracing cleanups and bugfixes

Steven Whitehouse (1):
    gfs2 updates

Takashi Iwai (2):
    sound updates
    sound fixes

Ted Ts'o (1):
    ext4 updates

Tejun Heo (4):
    percpu updates
    workqueue updates
    libata updates
    cgroup updates

Thierry Reding (1):
    pwm changes

Thomas Gleixner (2):
    timer core updates
    core irq updates

Tomi Valkeinen (3):
    main fbdev changes
    omap fbdev changes
    OMAP DT fbdev updates

Trond Myklebust (1):
    NFS client updates

Ulf Hansson (2):
    MMC update
    MMC fixes

Vineet Gupta (1):
    ARC updates

Vinod Koul (1):
    slave-dmaengine updates

Wim Van Sebroeck (1):
    watchdog updates

Wolfram Sang (1):
    i2c updates

Zhang Rui (1):
    thermal management update
