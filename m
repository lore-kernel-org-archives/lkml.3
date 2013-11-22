Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab3KVUgl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 15:36:41 -0500
Received: from mail-vb0-f42.google.com ([209.85.212.42]:42700 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605Ab3KVUgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 15:36:38 -0500
MIME-Version: 1.0
Date: Fri, 22 Nov 2013 12:36:37 -0800
X-Google-Sender-Auth: 7-reOZFUiYN8NHSquPRW2UVq0fc
Message-ID: <CA+55aFxK5hkhteiL5cyPtHX5reup6aOiHQTCDKKdBsHiWsroGA@mail.gmail.com>
Subject: Linux 3.13-rc1 is out
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So you had an extra week to prepare your pull requests, and if you
were planning on sending it in the last two days thinking I'd close
the merge window on Sunday as usual, I can only laugh derisively in
your general direction, and call you bad names. Because I'm not
interested in your excuses. I did warn people about this in the 3.12
release notes. As it was, there were a few people who cut it fairly
close today. You know who you are.

If there are pull requests I missed (due to getting caught in spam
filters, or not matching my normal search patterns), and you think you
sent your pull request in time but it got overlooked, ping me -
because I don't have anything pending I know about, but mistakes
happen.

Talking about mistakes... I suspect it was a mistake to have that
extra week before the merge window opened, and I probably should just
have done a 3.12-rc8 instead. Because the linux-next statistics look
suspicious, and we had extra stuff show up there not just in that
first week. Clearly people took that "let's have an extra week of
merge window" and extrapolated it a bit too much. Oh, well. Live and
learn.

Anyway, other than that small oddity, this was a fairly normal merge
window. By patch size we had a pretty usual ~55% drivers, 18%
architecture code, 9% network updates, and the rest is spread out (fs,
headers, tools, documentation). Featurewise, the big ones are likely
the nftables and the multi-queue block layer stuff, but depending on
your interests you might find all the incremental updates to various
areas interesting. There are some odd ones in there (LE mode Powerpc
support..)

Go forth and test, and start sending me regression fixes. And really,
if you didn't send me your pull request in time, don't whine about it.
Because nobody likes a whiner.

Shortlog of merges appended. The real shortlog is much too big to be
readable, as always for rc1.

             Linus

---
Al Viro (3):
  vfs updates
  VFS fixes
  vfs bits and pieces

Andrew Morton (3):
  first patch-bomb
  patches
  patches

Anton Vorontsov (1):
  battery updates

Artem Bityutskiy (2):
  ubifs changes
  UBI changes

Ben Myers (2):
  xfs update
  second xfs update

Benjamin Herrenschmidt (3):
  powerpc updates
  powerpc LE updates
  third set of powerpc updates

Benjamin LaHaise (1):
  aio fixes

Bjorn Helgaas (2):
  PCI changes
  PCI updates

Borislav Petkov (1):
  EDAC updates

Brian Norris (1):
  MTD changes

Bruce Fields (2):
  nfsd changes
  nfsd bugfixes

Bryan Wu (1):
  LED subsystem changes

Catalin Marinas (1):
  ARM64 update

Chris Ball (1):
  MMC updates

Chris Mason (2):
  btrfs fixes
  btrfs fixes

Dave Airlie (3):
  drm updates
  drm regression fix
  DRM fixes

David Miller (7):
  networking fixes
  networking updates
  sparc update
  IDE updates
  sparc fixes
  networking fixes
  networking fixes

David Teigland (1):
  dlm fix

Dmitry Torokhov (1):
  input updates

Eric Paris (1):
  audit updates

Geert Uytterhoeven (1):
  m68k updates

Gleb Natapov (1):
  KVM fixes

Greg KH (5):
  USB driver update
  char/misc patches
  driver core / sysfs patches
  tty/serial driver updates
  staging driver update

Guenter Roeck (3):
  h8300 platform removal
  hwmon updates
  hwmon fixes

Hans-Christian Egtvedt (1):
  AVR32 updates

Helge Deller (2):
  parisc update
  parisc fixes

Ingo Molnar (30):
  RCU updates
  IRQ changes
  leftover IRQ fixes
  perf updates
  scheduler changes
  timer changes
  x86/apic fix
  x86 user access changes
  x86 boot changes
  x86 build changes
  x86 cleanups
  x86 cpu changes
  x86 EFI changes
  x86/hyperv changes
  x86/intel-mid changes
  x86 iommu changes
  x86 RAS changes
  x86 mm fixlet
  x86 platform fixlet
  x86 reboot changes
  x86 uaccess changes
  x86 UV debug changes
  x86/trace changes
  core locking changes
  scheduler fixes
  two x86 fixes
  perf updates
  perf fixes
  irq cleanups
  x86 fix

Jaegeuk Kim (1):
  f2fs updates

James Bottomley (1):
  first round of SCSI updates

James Hogan (1):
  metag architecture changes

James Morris (1):
  security subsystem updates

Jan Kara (1):
  ext[23], udf and quota fixes

Jean Delvare (1):
  hwmon fixes and updates

Jens Axboe (4):
  block IO core updates
  block driver updates
  second round of block driver updates
  block IO fixes

Jiri Kosina (2):
  trivial tree updates
  HID updates

Joerg Roedel (1):
  IOMMU updates

Jonas Bonn (1):
  OpenRISC updates

Konrad Rzeszutek Wilk (1):
  Xen updates

Linus Walleij (2):
  pin control updates
  GPIO changes

Mark Brown (3):
  regmap updates
  regulator updates
  spi updates

Mark Salter (1):
  Kconfig cleanups

Martin Schwidefsky (2):
  s390 updates
  second set of s390 patches

Matt Turner (1):
  alpha updates

Mauro Carvalho Chehab (3):
  EDAC driver updates
  media updates
  media build fixes

Michal Marek (3):
  kbuild changes
  kconfig changes
  misc kbuild changes

Michal Simek (1):
  microblaze updates

Mike Snitzer (1):
  device mapper changes

Mike Turquette (1):
  clock framework changes

Miklos Szeredi (1):
  fuse updates

Neil Brown (1):
  md update

Nicholas Bellinger (1):
  SCSI target updates

Olof Johansson (7):
  ARM SoC low-priority fixes
  ARM SoC cleanups
  ARM SoC platform changes
  ARM SoC board updates
  ARM driver updates
  ARM SoC DT updates
  ARM SoC fixes

Paolo Bonzini (1):
  KVM changes

Pekka Enberg (1):
  SLAB changes

Phillip Lougher (1):
  squashfs updates

Rafael J Wysocki (1):
  ACPI and power management updates

Rafael Wysocki (1):
  more ACPI and power management updates

Ralf Baechle (1):
  MIPS updates

Richard Weinberger (1):
  UML changes

Rob Herring (1):
  devicetree updates

Roland Dreier (1):
  infiniband/rdma updates

Russell King (3):
  DMA mask updates
  ARM updates
  ARM fixes

Rusty Russell (2):
  module updates
  virtio updates

Samuel Ortiz (1):
  MFD updates

Steve French (2):
  CIFS updates
  CIFS fixes

Steven Miao (1):
  blackfin updates

Steven Rostedt (2):
  perf/ftrace fix
  tracing update

Steven Whitehouse (2):
  gfs2 updates
  GFS2 fixes

Takashi Iwai (3):
  sound updates
  sound fixes
  second set of sound fixes

Ted Ts'o (2):
  ext4 changes
  /dev/random changes

Tejun Heo (3):
  percpu changes
  libata changes
  cgroup changes

Thierry Reding (1):
  pwm changes

Tomi Valkeinen (1):
  fbdev changes

Tony Luck (1):
  ia64 fix

Trond Myklebust (1):
  NFS client updates

Tyler Hicks (1):
  minor eCryptfs fix

Vineet Gupta (2):
  ARC changes
  second set of ARC changes

Vinod Koul (1):
  slave-dmaengine changes

Wim Van Sebroeck (1):
  watchdog changes

Wolfram Sang (1):
  i2c changes

Zhang Rui (1):
  thermal management updates
