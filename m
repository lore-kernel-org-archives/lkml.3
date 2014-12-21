Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbaLUBn1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 20:43:27 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:47926 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbaLUBnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 20:43:23 -0500
MIME-Version: 1.0
Date: Sat, 20 Dec 2014 17:43:22 -0800
X-Google-Sender-Auth: lb6Mc3XAStv-QIhtqzRWoDBfTjU
Message-ID: <CA+55aFwu19GP5vHTwadX+ygAKwOqNLuEBA9TVEdnfxgvzP1zHA@mail.gmail.com>
Subject: Linux 3.19-rc1 - merge window closed
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So it's been a day less than two weeks, and the merge window is closed.

Considering how much came in fairly late, I find it hard to care about
anybody who had decided to cut it even closer than some people already
did.   That said, maybe there aren't any real stragglers - and judging
by the size of rc1, there really can't have been much. Not only do I
think there are more commits than there were in linux-next, this is
one of the bigger rc1's (at least by commits) historically. We've had
bigger ones (3.10 and 3.15 both had large merge windows leading up to
them), but this was definitely not a small merge window.

Anyway, we've got changes all over the place, including a new
architecture (nios2). My "short mergelog" is appended, and as usual I
want to point out that that credits the people sending me the changes,
which is generally not necessarily at all the same thing as the people
actually writing the code, even if there is obviously overlap.

In the "big picture", this looks like a fairly normal release. About
two thirds driver updates, with about half of the rest being
architecture updates (and no, the new nios2 patches are not at all
dominant, it's about half ARM, with  the new nios2 support being less
than 10% of the arch updates by lines overall). The remaining one
sixth is "misc": networking, header updates, documentation,
filesystems, tooling, and core kernel (in pretty much that order).

Obviously, with the holidays coming up, I'd expect that the next few
weeks are pretty quiet, but we'll see. I do hope that people will have
time to test this all in between all the eggnog,

                              Linus

---

Al Viro (3):
  VFS changes
  vfs pile #2
  vfs pile #3

Alex Williamson (1):
  VFIO updates

Andrew Morton (3):
  first patchbomb
  second patchbomb
  misc patches

Arnd Bergmann (13):
  ARM SoC non-critical bug fixes
  ARM SoC cleanup on mach-at91
  ARM SoC cleanups
  ARM SoC platform changes
  ARM SoC driver updates
  ARM SoC DT updates
  ARM SoC/OMAP GPMC driver cleanup and move
  ARM SoC defconfig changes
  ARM64 SoC changes
  asm-generic asm/io.h rewrite
  ARM SoC fixes
  ARM SoC DT updates part 2
  ARM SoC/iommu configuration update

Artem Bityutskiy (1):
  UBI/UBIFS updates

Benjamin LaHaise (1):
  aio updates

Bjorn Helgaas (1):
  PCI changes

Borislav Petkov (1):
  EDAC updates

Brian Norris (1):
  MTD updates

Bruce Fields (1):
  nfsd updates

Bryan Wu (1):
  LED subsystem update

Chris Mason (2):
  btrfs update
  more btrfs updates

Chris Metcalf (1):
  arch/tile updates

Chris Zankel (1):
  Xtensa fixes

Christian Borntraeger (1):
  ACCESS_ONCE cleanup preparation

Corey Minyard (1):
  IPMI driver updates

Darren Hart (1):
  x86 platform driver update

Dave Airlie (1):
  drm updates

Dave Chinner (1):
  xfs update

David Miller (6):
  networking updates
  sparc update
  IDE update
  another networking update
  sparc fix
  networking fixes

David Teigland (1):
  dlm update

David Vrabel (2):
  xen features and fixes
  additional xen update

Dmitry Torokhov (1):
  input subsystem updates

Eric Biederman (1):
  user namespace related fixes

Geert Uytterhoeven (1):
  m68k updates

Grant Likely (1):
  devicetree changes

Greg KH (5):
  USB updates
  tty/serial driver updates
  driver core update
  char/misc driver updates
  staging driver updates

Guenter Roeck (1):
  hwmon updates

Herbert Xu (1):
  crypto update

Ingo Molnar (17):
  locking tree changes
  RCU updates
  perf events update
  leftover perf fixes
  scheduler updates
  x86 asm updates
  x86 boot and percpu updates
  x86 build, cleanup and defconfig updates
  EFI updates
  x86 platform changes
  x86 mm tree changes
  x86 RAS update
  x86 vdso updates
  x86 microcode loading updates
  x86 fixes
  perf fixes and cleanups
  x86 fix

Jaegeuk Kim (1):
  f2fs updates

James Bottomley (2):
  SCSI updates
  SCSI update

James Morris (2):
  security layer updates
  security subsystem fixes

Jan Kara (2):
  quota updates
  isofs and reiserfs fixes

Jassi Brar (1):
  mailbox framework updates

Jens Axboe (3):
  block driver core update
  block layer driver updates
  core block fix

Jesper Nilsson (1):
  arch/chris updates

Jiri Kosina (2):
  trivial tree update
  HID updates

Joerg Roedel (1):
  IOMMU updates

Jonathan Corbet (1):
  documentation update

Lee Jones (2):
  MFD updates
  backlight updates

Ley Foon Tan (2):
  Altera Nios II processor support
  arch/nios2 fixes

Linus Walleij (1):
  pin control changes

Mark Brown (3):
  regmap updates
  regulator updates
  spi updates

Martin Schwidefsky (1):
  s390 updates

Mauro Carvalho Chehab (3):
  media updates
  edac updates
  second set of media updates

Michael Ellerman (2):
  powerpc updates
  second batch of powerpc updates

Michael S Tsirkin (1):
  virtio fixes

Michael Tsirkin (1):
  virtio updates

Michal Marek (2):
  kbuild updates
  misc kbuild changes

Michal Simek (1):
  Microblaze fix

Mike Snitzer (1):
  device mapper updates

Mike Turquette (1):
  clk framework updates

Miklos Szeredi (1):
  fuse update

Neil Brown (1):
  md updates

Nicholas Bellinger (1):
  SCSI target fixes

Ohad Ben-Cohen (1):
  rpmsg update

Paolo Bonzini (1):
  KVM update

Paul Moore (1):
  audit updates

Phillip Lougher (1):
  squashfs update

Rafael Wysocki (3):
  ACPI and power management updates
  more ACPI and power management updates
  CONFIG_PM_RUNTIME elimination

Ralf Baechle (1):
  MIPS updates

Richard Kuo (1):
  arch/hexagon updates

Roland Dreier (1):
  infiniband updates

Russell King (1):
  ARM updates

Rusty Russell (2):
  virtio updates
  module updates

Sage Weil (1):
  ceph updates

Sebastian Reichel (2):
  HSI update
  power supply updates

Shuah Khan (1):
  kselftest update

Stefan Richter (1):
  firewire updates

Steve French (1):
  cifs update

Steven Rostedt (7):
  tracing updates
  ftrace self-test updates
  nmi-safe seq_buf printk update
  ktest changes
  tracing fixes
  tracing fixlet
  tracing updates

Steven Whitehouse (1):
  GFS2 update

Takashi Iwai (2):
  sound updates
  sound fixes

Ted Ts'o (1):
  ext4 updates

Tejun Heo (4):
  percpu updates
  workqueue update
  libata changes
  cgroup update

Thierry Reding (1):
  pwm updates

Thomas Gleixner (10):
  timer core updates
  irq core updates
  irq domain updates
  x86 MPX support
  more 2038 timer work
  irq domain ARM updates
  x86 MPX fixes
  irq core fix
  NOHZ update
  x86 apic updates

Tomi Valkeinen (1):
  fbdev updates

Tony Luck (3):
  pstore fixes
  pstore update #2
  ia64 __get_cpu_var removal

Trond Myklebust (1):
  NFS client updates

Tyler Hicks (1):
  eCryptfs fixes

Ulf Hansson (1):
  MMC updates

Vineet Gupta (1):
  arch/arc updates

Vinod Koul (1):
  dmaengine updates

Will Deacon (2):
  arm64 updates
  arm64 fixes

Wim Van Sebroeck (1):
  small watchdog update

Wolfram Sang (2):
  i2c updates
  more i2c updates

Zhang Rui (1):
  thermal management update
