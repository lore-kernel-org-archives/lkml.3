Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461AbaJTBdQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 21:33:16 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:43886 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaJTBdO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 21:33:14 -0400
MIME-Version: 1.0
Date: Sun, 19 Oct 2014 18:33:13 -0700
X-Google-Sender-Auth: MR4HHLruDS5e_lUdBjRD_d0fY6M
Message-ID: <CA+55aFynXFyH0orzmMxR-HR6hNO8T-dmOoRrmExDepQA1BfDCw@mail.gmail.com>
Subject: Linux 3.18-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So when I released 3.17, I said that I'd extend the merge window to
three weeks due to travel.

I clearly lied.

Because here we are, the usual two weeks later, and I've already
pushed out 3.18-rc1.

What happened is that not only did I merge actively despite travels -
I was out of communication just for a couple of days (almost, but not
entirely, due to flights - the hotel in Düsseldorf lost all internet
for a day too). But perhaps more importantly, people seem to have
aggressively sent in their pull requests, because rc1 contains more
than linux-next did a couple of days after 3.17.. So holding it up
another week just seems pointless.

That said, I realize that people might have taken my statements at
face value, and planned with that in mind. I hate it when I get pull
requests really late in the merge window, but having closed it as per
the regular schedule, I also understand that somebody might have
planned on sending their pull request a bit later. It's ok. Grovel a
bit, and explain what's up, and you can almost certainly guilt me into
taking stuff.

Also, maybe I just missed something due to jetlag (hmm. yes, let's
call it "jetlag", that sounds so much better than "core incompetence
and bad planning"), so if you feel unfairly overlooked, send me a note
explaining how I've unfairly wronged you.

There is also at least one pull request that I am hoping to get asap
and planning on still pulling, ie I'm very much still hoping to get
overlayfs finally merged. But there were a few last-minute questions
from Al. Assuming that all works out, that's an expected late pull.
Not worth holding up the rc1 release for one known straggler, though.

So there you have it. The merge window is closed, but with room for
excuses and possible missed requests. As usual, the shortlog is much
too big to post (core stats: roughly 74% drivers, 10% architecture
updates, the rest networking, filesystems, core kernel, documentation,
include files, tool updates...), and the appended is my "mergelog"
which as usual credits the people I pulled from, which is not at all
necessarily the same as the people writing the code.

Go forth and test,

                           Linus

---

Al Viro (1):
  vfs updates

Alex Williamson (1):
  VFIO updates

Andrew Morton (2):
  patch-bomb
  second patch-bomb

Andy Lutomirski (2):
  do_umount fix
  pivot_root() fix

Anton Altaparmakov (1):
  NTFS update

Arnd Bergmann (7):
  ARM SoC non-critical bug fixes
  ARM SoC cleanups
  ARM SoC platform changes
  ARM SoC DT updates
  ARM SoC driver updates
  ARM SoC defconfig changes
  ARM64 SoC changes

Artem Bityutskiy (1):
  UBI/UBIFS fixes

Behan Webster (1):
  LLVM updates

Bjorn Helgaas (1):
  PCI updates

Borislav Petkov (1):
  EDAC fixes

Brian Norris (1):
  MTD update

Bruce Fields (1):
  nfsd updates

Catalin Marinas (1):
  arm64 updates

Chris Mason (2):
  btrfs updates
  btrfs data corruption fix

Chris Metcalf (1):
  arch/tile updates

Corey Minyard (1):
  ipmi patches

Dan Williams (1):
  dmaengine updates

Darren Hart (1):
  x86 platform driver updates

Dave Airlie (1):
  drm updates

Dave Chinner (1):
  xfs update

David Howells (1):
  fs-cache fixes

David Miller (8):
  networking updates
  sparc updates
  networking fixes
  IDE cleanup
  Sparc bugfix
  networking fixes
  networking fixes
  sparc fixes

David Teigland (1):
  dlm fix

David Vrabel (1):
  Xen updates

Dmitry Torokhov (2):
  input updates
  second round of input updates

Eric Paris (1):
  audit updates

Geert Uytterhoeven (1):
  m68k updates

Grant Likely (1):
  devicetree changes

Greg KH (6):
  USB updates
  staging updates
  tty/serial driver updates
  driver core update
  compression update
  char/misc driver updates

Greg Ungerer (1):
  m68knommu update

Guenter Roeck (2):
  restart handler infrastructure
  hwmon updates

Helge Deller (1):
  parisc fix

Herbert Xu (1):
  crypto update

Ingo Molnar (22):
  timer fixes
  RCU updates
  arch atomic cleanups
  core locking updates
  perf updates
  perf fixes
  watchdog fixes
  scheduler updates
  x86 asm updates
  x86 bootup updates
  x86 build update
  x86 cleanups
  x86 cpu offlining patch
  x86 cpufeature updates
  x86 FPU updates
  x86 microcode loading updates
  x86 mm updates
  x86 platform updates
  x86 seccomp changes
  x86 fixes
  x86 ras, uv and vdso fixlets
  more perf updates

Jaegeuk Kim (1):
  f2fs updates

James Bottomley (1):
  SCSI updates

James Morris (2):
  security subsystem updates
  selinux fix

Jan Kara (1):
  UDF and quota updates

Jeff Layton (1):
  file locking related changes

Jens Axboe (2):
  core block layer changes
  block layer driver update

Jiri Kosina (3):
  documentation updates
  "trivial tree" updates
  HID updates

Joerg Roedel (1):
  IOMMU updates

Jon Mason (1):
  ntb (non-transparent bridge) updates

Josh "Paper Bag" Triplett (1):
  tinification fix

Josh Triplett (1):
  "tinification" patches

Lee Jones (2):
  backlight driver updates
  MFD updates

Lennox Wu (1):
  S+core updates

Linus Walleij (2):
  pin control changes
  GPIO changes

Marc Zyngier (1):
  second batch of changes for KVM/{arm,arm64}

Marek Szyprowski (1):
  dma-mapping update

Mark Brown (3):
  regmap updates
  regulator updates
  spi updates

Martin Schwidefsky (1):
  s390 updates

Mauro Carvalho Chehab (2):
  media updates
  edac updates

Michael Ellerman (2):
  powerpc updates
  powerpc fix

Michal Marek (2):
  kbuild changes
  misc kbuild updates

Mike Snitzer (1):
  device-mapper updates

Mike Turquette (1):
  clock tree updates

Neil Brown (1):
  md updates

Olof Johansson (1):
  ARM SoC fixes

Paolo Bonzini (1):
  KVM updates

Rafael Wysocki (1):
  ACPI and power management updates

Ralf Baechle (1):
  MIPS updates

Richard Weinberger (1):
  UML update

Roland Dreier (1):
  infiniband/RDMA updates

Russell King (1):
  ARM updates

Rusty Russell (3):
  module update
  module fix
  virtio updates

Sage Weil (1):
  Ceph updates

Sebastian Reichel (1):
  power supply and reset updates

Shuah Khan (1):
  kselftest updates

Steve French (1):
  cifs/smb3 updates

Steven Rostedt (4):
  tracing updates
  tracing fixes
  ktest update
  ftrace test code

Steven Whitehouse (1):
  gfs2 updates

Takashi Iwai (2):
  sound updates
  sound fixes

Tejun Heo (4):
  libata update
  cgroup updates
  percpu updates
  percpu consistent-ops changes

Thomas Gleixner (2):
  timer updates
  irq updates

Tomi Valkeinen (1):
  fbdev updates

Tony Luck (2):
  ia64 update
  pstore fix

Trond Myklebust (2):
  NFS client updates
  NFS client updates

Tyler Hicks (1):
  eCryptfs updates

Ulf Hansson (1):
  MMC updates

Vinod Koul (1):
  slave-dmaengine updates

Wolfram Sang (1):
  i2c updates
