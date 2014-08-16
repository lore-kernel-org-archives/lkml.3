Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712AbaHPTYg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 15:24:36 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:49301 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaHPTYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 15:24:34 -0400
MIME-Version: 1.0
Date: Sat, 16 Aug 2014 13:24:33 -0600
X-Google-Sender-Auth: h5kVxcxS62NTTs6rNXFGsn9XLnM
Message-ID: <CA+55aFy4WSYZ_6p-+E7=XaYn9U0vwid6XAxw_uB21d=KrPW0mA@mail.gmail.com>
Subject: Linux 3.17-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm going to be on a plane much of tomorrow, and am not really
supportive of last-minute pull requests during the merge window
anyway, so I'm closing the merge window one day early, and 3.17-rc1 is
out there now.  Well, it's been out for a while now, but the network
was bad enough where I'm traveling that I couldn't get this
*announcement* out.

Anyway, this merge window was slightly smaller than the last few ones,
probably due to summer slowdowns in the northern hemisphere. Which is
not to say that it was *small* - the last few releases have been
larger than usual, this one is just fairly average. It's certainly big
enough that I can't post the shortlog, so as usual this just appends
the "mergelog" where the people credited are the people I pulled from,
not necessarily the people who wrote the code.

Changes all over the place, but no huge new architectures or
filesystems. About three quarters of the changes are drivers, and of
the rest, roughly half is architecture updates, with the rest being
misc core changes (networking, filesystems etc)

The upcoming week is the kernel summit, so I'm guessing rc2 will be
fairly small, but we'll see how that goes.

          Linus

---

Al Viro (1):
  vfs updates

Alex Williamson (1):
  VFIO updates

Amit Shah (1):
  virtio-rng update

Andrew Morton (3):
  incoming
  more incoming
  leftovers

Artem Bityutskiy (1):
  UBI/UBIFS changes

Ben Herrenschmidt (2):
  powerpc updates
  more powerpc updates

Ben LaHaise (1):
  aio updates

Ben Skeggs (1):
  nouveau drm updates

Bjorn Helgaas (2):
  PCI updates
  DEFINE_PCI_DEVICE_TABLE removal

Borislav Petkov (1):
  EDAC changes

Brian Norris (1):
  MTD updates

Bruce Fields (1):
  nfsd updates

Bryan Wu (1):
  LED updates

Chris Mason (1):
  btrfs updates

Daniel Vetter (1):
  intel drm fixes

Dave Airlie (2):
  DRM updates
  drm fixes (mostly nouveau)

Dave Chinner (1):
  xfs update

David Miller (8):
  networking updates
  sparc updates
  IDE cleanup
  networking fixes
  Sparc fixes
  networking fixes
  networking fixes
  Sparc fixes

David Vrabel (2):
  Xen updates
  Xen bugfixes

Dmitry Torokhov (2):
  input updates
  input layer fixes

Eric Biederman (1):
  namespace updates

Geert Uytterhoeven (1):
  m68k changes

Grant Likely (1):
  device tree updates

Greg KH (5):
  char / misc driver patches
  driver core updates
  staging driver updates
  tty / serial driver update
  USB updates

Greg Ungerer (1):
  m68knommu fixes

Guenter Roeck (2):
  hwmon updates
  hwmon fixes

Hans-Christian Egtvedt (1):
  avr32 fix

Herbert Xu (1):
  crypto update

Ingo Molar (1):
  RCU changes

Ingo Molnar (11):
  locking updates
  perf changes
  scheduler updates
  x86 build/cleanup/debug updates
  x86 cpufeature updates
  EFI changes
  x86 mm changes
  x86 platform updates
  RAS updates
  x86 UV TLB update
  x86 vdso updates

Jaegeuk Kim (1):
  f2fs updates

James Bottomley (2):
  SCSI updates
  more SCSI changes

James Hogan (1):
  metag architecture updates

James Morris (2):
  security subsystem updates
  seccomp fix

Jan Kara (1):
  quota, reiserfs, UDF updates

Jeff Layton (2):
  file locking related changes
  file locking bugfixes

Jens Axboe (2):
  block core bits
  block driver changes

Jiri Kosina (2):
  HID updates
  trivial tree changes

Joerg Roedel (1):
  iommu updates

Lee Jones (2):
  MFD update
  backlight changes

Len Brown (1):
  idle update

Linus Walleij (2):
  pinctrl updates
  GPIO update

Mark Brown (2):
  spi updates
  regulator updates

Martin Schwidefsky (1):
  s390 updates

Matthew Garrett (1):
  x86 platform driver updates

Mauro Carvalho Chehab (2):
  media updates
  EDAC updates

Michal Marek (2):
  kbuild updates
  misc kbuild updates

Michal Simek (1):
  microblaze updates

Mike Snitzer (1):
  device mapper changes

Mike Turquette (1):
  clock framework updates

Neil Brown (1):
  md updates

Ohad Ben-Cohen (1):
  hwspinlock updates

Olof Johansson (8):
  ARM SoC cleanups
  ARM SoC platform changes
  ARM SoC board changes
  ARM SoC device-tree changes
  ARM SoC driver changes
  ARM SoC defconfig updates
  ARM SoC fixes
  chrome platform updates

Paolo Bonzini (2):
  KVM changes
  second round of KVM changes

Paul Moore (1):
  SElinux fixes

Peter Anvin (2):
  x86/xsave changes
  x86/efix fixes

Rafael Wysocki (2):
  ACPI and power management updates
  more ACPI and power management updates

Ralf Baechle (1):
  MIPS updates

Richard Weinberger (1):
  arch signal handling cleanup

Roland Dreier (1):
  infiniband/rdma updates

Russell King (2):
  ARM updates
  ARM fixes

Rusty Russell (3):
  virtio updates
  module updates
  module fix

Sage Weil (1):
  Ceph updates

Sebastian Reichel (2):
  power supply changes
  HSI changes

Steve French (1):
  CIFS updates

Steven Rostedt (5):
  config-bisect changes
  tracing updates
  tracing filter cleanups
  trace file read iterator fixes
  IPI tracepoints for ARM

Takashi Iwai (2):
  sound updates
  sound fixes

Ted Ts'o (2):
  ext4 updates
  randomness updates

Tejun Heo (4):
  workqueue updates
  percpu updates
  cgroup changes
  libata changes

Thierry Reding (1):
  pwm changes

Thomas Gleixner (3):
  irq updates
  timer and time updates
  x86/apic updates

Tomi Valkeinen (1):
  fbdev updates

Tony Luck (2):
  ia64 cleanups
  ia64 system call update

Trond Myklebust (1):
  NFS client updates

Ulf Hansson (1):
  MMC updates

Vineet Gupta (1):
  ARC changes

Vinod Koul (1):
  slave-dma updates

Will Deacon (1):
  arm64 updates

Wim Van Sebroeck (1):
  watchdog updates

Wolfram Sang (1):
  i2c updates

Zhang Rui (1):
  thermal updates
