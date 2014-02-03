Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbaBCBMY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 20:12:24 -0500
Received: from mail-vb0-f43.google.com ([209.85.212.43]:56254 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbaBCBMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 20:12:23 -0500
MIME-Version: 1.0
Date: Sun, 2 Feb 2014 17:12:22 -0800
X-Google-Sender-Auth: Y1xdZYHu1RrnMERvz5uBDNTfsd8
Message-ID: <CA+55aFyTzEjZiWK+B7cZj=0q-GsDPK372CK2a+F02OXnCeBsYw@mail.gmail.com>
Subject: Linux 3.14-rc1 is out
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, it was a normal two-week merge window, and it's closed now. As
far as I'm aware, I've pulled everything asked from me (with one
exception, see later) and applied all patches I was meant to apply. If
you feel I overlooked your work, it might be due to an email being
caught as spam (it happened several times lately, but I think I caught
them all) or just plain incompetence on my part (that happens too).

I realize that as a number, 3.14 looks familiar to people, and I had
naming requests related to that. But that's simply not how the
nonsense kernel names work. You can console yourself with the fact
that the name doesn't actually show up anywhere, and nobody really
cares. So any pi-related name you make up will be *quite* as relevant
as the one in the main Makefile, so don't get depressed.

Besides, any self-respecting geek will know pi to twenty decimal
places from their dorky youth, so 3.14 isn't really *that* close, is
it?

Anyway, the one missing pull request is the rename2 system call that I
felt I needed to look at myself, and was also hoping for more
commentary on (I'm looking at you, Al). So I didn't feel I had the
mental throughput to look at it during the merge window, and will take
a more leisurely look the upcoming week. I *might* still pull it
before -rc2, but quite frankly it's more likely to be left pending for
3.15.

Other than that? The stuff that actually got merged? It was a pretty
normal merge window, nothing stands out. The statistics are the normal
two-thirds drivers, with the rest being a mix of architecture updates
(ARM dominates, but there's powerpc, x86, mips. s390, and even ia64
shows up with stale xen code removal too) and misc. Where misc is core
kernel, mm, networking, tooling etc etc.

I'm attaching my merge-log, since (as usual) the actual merge window
shortlog is much too long to bother with for general consumption. And
again, note that my merge-log is about who was the submaintainer that
sent me the pull request, not about who necessarily wrote the code.
You need to go to the full git logs to see that level of detail.

                            Linus

---
Al Viro (2):
  vfs updates
  vfs fixes

Alex Williamson (1):
  vfio update

Andrew Morton (5):
  first patch-bomb
  second patch-bomb
  misc updates
  random fixes
  misc fixes

Artem Bityutskiy (1):
  ubifs updates

Ben Herrenschmidt (3):
  powerpc mremap fix
  powerpc updates
  more powerpc bits

Ben Myers (2):
  xfs update
  second xfs update

Bjorn Helgaas (1):
  PCI updates

Boaz Harrosh (1):
  exofs and ore fixes

Borislav Petkov (1):
  EDAC updates

Brian Norris (1):
  MTD updates

Bruce Fields (1):
  nfsd updates

Bryan Wu (1):
  LED subsystem update

Catalin Marinas (1):
  ARM64 updates

Chris Ball (1):
  MMC updates

Chris Mason (1):
  btrfs updates

Chris Zankel (1):
  Xtensa patches

Corey Minyard (1):
  ipmi fixes

Dave Airlie (1):
  drm updates

David Kleikamp (1):
  jfs fix

David Miller (4):
  networking updates
  IDE fixes
  sparc update
  networking fixes

David Teigland (1):
  dlm update

Dmitry Eremin-Solenikov (1):
  battery updates

Dmitry Torokhov (1):
  input subsystem updates

Eric Biederman (1):
  user namespaces work

Eric Paris (1):
  audit update

Eric Van Hensbergen (1):
  9p changes

Geert Uytterhoeven (1):
  m68k updates

Greg KH (7):
  char/misc driver patches
  driver core / sysfs patches
  staging driver tree changes
  tty/serial driver updates
  USB updates
  serial fixes
  rtl8812ae staging wireless driver

Guenter Roeck (1):
  hwmon updates

Helge Deller (1):
  parisc updates

Herbert Xu (1):
  crypto update

Ingo Molnar (25):
  core debug changes
  core locking changes
  RCU updates
  strong stackprotector support
  IRQ changes
  perf updates
  scheduler changes
  timer changes
  x86/apic changes
  x86/asm changes
  x86/build changes
  x86 cleanups
  x86 TLB detection update
  x86 EFI changes
  Intel MID updates
  x86 microcode loader updates
  x86 mm changes
  Intel SoC changes
  x86 RAS changes
  leftover x86 fixes
  scheduler fixes
  perf fixes
  core debug changes
  scheduler fixes
  timer/dynticks updates

Jaegeuk Kim (1):
  f2fs updates

James Bottomley (1):
  SCSI updates

James Hogan (1):
  Metag architecture changes

James Morris (1):
  security layer updates

Jan Kara (2):
  UDF & jbd fixes
  fanotify use-after-free fixes

Jean Delvare (2):
  hwmon updates
  hwmon kconfig fixes

Jens Axboe (2):
  core block IO changes
  block IO driver changes

Jesper Nilsson (2):
  cris changes
  cris fix

Jiri Kosina (2):
  HID updates
  trivial tree updates

Joerg Roedel (1):
  IOMMU Updates

Jonas Bonn (1):
  OpenRISC updates

Kevin Hilman (1):
  ARM SoC late changes

Konrad Rzeszutek Wilk (3):
  Xen updates
  swiotlb bug-fixes
  Xen bugfixes

Lee Jones (1):
  MFD changes

Len Brown (1):
  turbostat updates

Linus Walleij (2):
  GPIO tree bulk changes
  bulk pin control changes

Mark Brown (3):
  regmap updates
  regulator updates
  spi updates

Martin Schwidefsky (2):
  s390 updates
  s390 patches

Matt Turner (1):
  alpha updates

Matthew Garrett (1):
  x86 platform drivers update

Mauro Carvalho Chehab (1):
  media updates

Michal Marek (3):
  kbuild changes
  __TIME__/__DATE__ removal
  misc kbuild changes

Michal Simek (1):
  microblaze patches

Mike Snitzer (1):
  device-mapper changes

Mike Turquette (2):
  clk framework changes
  more clock framework changes

Miklos Szeredi (1):
  fuse update

Neil Brown (1):
  md updates

Nicholas Bellinger (1):
  SCSI target updates

Olof Johansson (8):
  ARM SoC non-critical fixes
  ARM SoC cleanups
  ARM SoC platform changes
  ARM SoC DT updates
  ARM SoC board updates
  ARM driver updates
  chrome platform cleanups and improvements
  ARM SoC fixes

Paolo Bonzini (2):
  KVM updates
  more KVM updates

Pekka Enberg (1):
  SLAB changes

Peter Anvin (7):
  x86 kernel address space randomization support
  x86 cpufeature and mpx updates
  x32 uapi changes
  more x32 uabi type fixes
  intel MID cleanups
  x86 build bits
  x86 asmlinkage (LTO) changes

Rafael Wysocki (2):
  ACPI and power management updates
  ACPI and power management fixes and cleanups

Ralf Baechle (1):
  MIPS updates

Richard Weinberger (1):
  UML changes

Rob Herring (1):
  devicetree updates

Roland Dreier (1):
  infiniband updates

Russell King (2):
  ARM updates
  more ARM updates

Rusty Russell (2):
  virtio update
  module updates

Sage Weil (2):
  ceph updates
  some further ceph acl cleanups

Stefan Richter (1):
  firewire updates

Steve French (1):
  cifs fixes

Steven Miao (1):
  blackfin updates

Steven Rostedt (4):
  localmodconfig update
  ktest updates
  tracing updates
  tracing fixes

Steven Whitehouse (1):
  GFS2 updates

Takashi Iwai (2):
  sound updates
  sound fixes

Ted Ts'o (1):
  ext4 update

Tejun Heo (4):
  workqueue update
  percpu changes
  cgroup updates
  libata updates

Thierry Reding (1):
  pwm changes

Tomi Valkeinen (1):
  fbdev changes

Tony Luck (1):
  ia64 Xen removal

Trond Myklebust (2):
  NFS client updates
  NFS client bugfixes

Vineet Gupta (1):
  ARC changes

Vinod Koul (1):
  slave-dma updates

Wim Van Sebroeck (1):
  watchdog updates

Wolfram Sang (2):
  i2c updates
  more i2c updates

Zhang Rui (1):
  thermal management updates
