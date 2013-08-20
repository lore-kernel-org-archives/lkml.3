Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858Ab3HTP5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 11:57:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34662 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab3HTP5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 11:57:33 -0400
Date: Tue, 20 Aug 2013 08:59:23 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.59
Message-ID: <20130820155923.GA10411@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.59 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.4.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                 |    2=20
 arch/alpha/Makefile                      |    2=20
 arch/arm/kernel/perf_event.c             |   10 +++-
 arch/cris/arch-v10/lib/Makefile          |    3 -
 arch/cris/include/asm/posix_types.h      |    2=20
 arch/cris/kernel/vmlinux.lds.S           |    1=20
 arch/frv/include/asm/thread_info.h       |    2=20
 arch/frv/kernel/process.c                |   15 ------
 arch/m68k/emu/natfeat.c                  |   23 ++++++++--
 arch/m68k/include/asm/div64.h            |    9 ++-
 arch/microblaze/configs/mmu_defconfig    |   49 ++++++++++++++-------
 arch/microblaze/configs/nommu_defconfig  |   71 ++++++++++++++++++--------=
-----
 arch/mips/Kconfig                        |    2=20
 arch/mips/include/asm/io.h               |    5 ++
 arch/mips/include/asm/page.h             |   17 +++----
 arch/powerpc/mm/numa.c                   |    2=20
 arch/sparc/lib/Makefile                  |    2=20
 arch/sparc/lib/ucmpdi2.c                 |   19 ++++++++
 arch/xtensa/kernel/Makefile              |    1=20
 arch/xtensa/kernel/vmlinux.lds.S         |    3 -
 arch/xtensa/mm/init.c                    |    6 +-
 drivers/gpu/drm/i915/intel_lvds.c        |    8 ---
 drivers/hid/hid-microsoft.c              |    6 +-
 drivers/md/raid1.c                       |   22 ++++-----
 drivers/md/raid10.c                      |   14 +++---
 drivers/net/can/usb/peak_usb/pcan_usb.c  |    2=20
 drivers/net/wireless/iwlegacy/4965-mac.c |   16 +++---
 drivers/net/wireless/iwlegacy/common.c   |    1=20
 drivers/usb/core/quirks.c                |    6 ++
 drivers/usb/serial/mos7720.c             |   21 ++++++---
 fs/ext4/ext4_jbd2.c                      |    8 +--
 fs/proc/task_mmu.c                       |    8 +--
 include/linux/hugetlb.h                  |   16 ++++++
 kernel/futex.c                           |    3 -
 mm/hugetlb.c                             |   17 +++++++
 mm/nommu.c                               |   10 ++++
 net/key/af_key.c                         |    1=20
 sound/oss/Kconfig                        |    1=20
 38 files changed, 261 insertions(+), 145 deletions(-)

Andreas Schwab (1):
      m68k: Truncate base in do_div()

Benjamin Herrenschmidt (1):
      powerpc/numa: Avoid stupid uninitialized warning from gcc

Daniel Vetter (1):
      drm/i915/lvds: ditch ->prepare special case

David S. Miller (1):
      sparc32: Add ucmpdi2.o to obj-y instead of lib-y.

Geert Uytterhoeven (2):
      xtensa: replace xtensa-specific _f{data,text} by _s{data,text}
      m68k/atari: ARAnyM - Fix NatFeat module support

Greg Kroah-Hartman (1):
      Linux 3.4.59

Jan Kara (1):
      jbd2: Fix use after free after error in jbd2_journal_dirty_metadata()

Jesper Nilsson (1):
      CRIS: Add _sdata to vmlinux.lds.S

Jiri Slaby (2):
      HID: microsoft: do not use compound literal - fix build
      cris: posix_types.h, include asm-generic/posix_types.h

Johan Hovold (1):
      USB: mos7720: fix broken control requests

Linus Torvalds (1):
      vm: add no-mmu vm_iomap_memory() stub

Markos Chandras (1):
      MIPS: Expose missing pci_io{map,unmap} declarations

Max Filippov (1):
      xtensa: fix linker script transformation for .text.unlikely

Michal Simek (1):
      microblaze: Update microblaze defconfigs

NeilBrown (1):
      md/raid1,raid10: use freeze_array in place of raise_barrier in variou=
s places.

Nicolas Dichtel (1):
      af_key: initialize satype in key_notify_policy_flush()

Oliver Neukum (1):
      usb: add two quirky touchscreen

Paul Bolle (1):
      sound: Fix make allmodconfig on MIPS correctly

Paul Gortmaker (1):
      cris: Remove old legacy "-traditional" flag from arch-v10/lib/Makefile

Ralf Baechle (1):
      MIPS: Rewrite pfn_valid to work in modules, too.

Sam Ravnborg (1):
      sparc32: add ucmpdi2

Stanislaw Gruszka (2):
      iwl4965: set power mode early
      iwl4965: reset firmware after rfkill off

Stephane Grosjean (1):
      can: pcan_usb: fix wrong memcpy() bytes length

Stephen Boyd (1):
      perf/arm: Fix armpmu_map_hw_event()

Takashi Iwai (1):
      sound: Fix make allmodconfig on MIPS

Thomas Gleixner (2):
      frv: Use correct size for task_struct allocation
      frv: Use core allocator for task_struct

Will Deacon (2):
      alpha: makefile: don't enforce small data model for kernel builds
      ARM: 7809/1: perf: fix event validation for software group leaders

Zhang Yi (1):
      futex: Take hugepages into account when generating futex_key

yonghua zheng (1):
      fs/proc/task_mmu.c: fix buffer overflow in add_page_map()


--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSE5JbAAoJEDjbvchgkmk+HhUQAKlk553nrFJ1bs2GkTVVVTN3
ijw3kx76Mjp/vQnCv5XjQv8f/moYB9l7x6jSyS0xfealMZb/fk87dR9I1yRcBs13
sZfC5LbUQBTJOstsZQNnNeLhg8zLpd95bR3piOju/W7PJDIw05qwdQOO311gY89r
Yr6aWlHe5lxWFnSZwTNmfNap3wSCGKOHMbEW4/bPgI2tzmM4nN8q7XgQHTnrEsfo
Y4FhKow9O3hqTunUj3sU/FCkgVwWDTu5IKXNZOBj9xy79bU51zgpCDSt2O4N/0z4
iGtInYeKQO2bluq4Ummj1w847c3fI0cdloft9iNwrVP2+MpGqWFSEP+UFuam5K2e
bHRQCk4PQLIcdy+PSCmn6L/VJPwsDw/O7Lb7eIkMpZxI++W6xHmZPwCGQmBt4MEp
0DPyDH/umZEYPuoP4nS6JH2ASLrLWWlUV6UpkXQg7izgqAP3hWv8866xNCXCkFW5
lFGNP+AyX7WH0EMsu/lnPgNg15o4qcxXirs2hDiAmJ6RqkfU+DB6AtDRgnyGbL29
wOJ9n5laZYKtNyeHpT3Bq6663HrPsPMeerGwMmyYcj2uwmc3NGdQK5wqBnONNpCX
xwnwLRUgxg4olzP5JWC1fXZmUqfDv9BBbEBRSZnt4jYf4ypd7I3234u988MR9pC8
6QqXRL6tbowf2M11zkQM
=pai3
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
