Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965845Ab3DQGqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 02:46:38 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:63703 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965812Ab3DQGqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 02:46:35 -0400
Date: Tue, 16 Apr 2013 23:46:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.74
Message-ID: <20130417064630.GA11780@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VS++wcV0S1rZb1Fb"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.74 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.0.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                              |    2=20
 arch/x86/include/asm/paravirt.h       |    5 -
 arch/x86/include/asm/paravirt_types.h |    2=20
 arch/x86/kernel/paravirt.c            |   25 ++---
 arch/x86/lguest/boot.c                |    1=20
 arch/x86/mm/fault.c                   |    6 -
 arch/x86/mm/numa_32.c                 |  161 -----------------------------=
-----
 arch/x86/xen/mmu.c                    |    1=20
 drivers/mtd/mtdchar.c                 |   56 ++++++++++-
 drivers/net/r8169.c                   |   30 +++++-
 drivers/target/target_core_alua.c     |    3=20
 kernel/sched_clock.c                  |   26 +++++
 kernel/sys.c                          |    3=20
 kernel/trace/ftrace.c                 |    1=20
 sound/soc/codecs/wm8903.c             |    2=20
 sound/usb/mixer_quirks.c              |    4=20
 sound/usb/quirks.c                    |    2=20
 17 files changed, 136 insertions(+), 194 deletions(-)

Alban Bedel (1):
      ASoC: wm8903: Fix the bypass to HP/LINEOUT when no DAC or ADC is runn=
ing

Boris Ostrovsky (1):
      x86, mm: Patch out arch_flush_lazy_mmu_mode() when running on bare me=
tal

Dave Hansen (1):
      x86-32, mm: Rip out x86_32 NUMA remapping code

David Woodhouse (1):
      mtd: Disable mtdchar mmap on MMU systems

Eldad Zack (1):
      ALSA: usb-audio: fix endianness bug in snd_nativeinstruments_*

Greg Kroah-Hartman (1):
      Linux 3.0.74

Hayes Wang (1):
      r8169: fix auto speed down issue

Huacai Chen (1):
      PM / reboot: call syscore_shutdown() after disable_nonboot_cpus()

Linus Torvalds (1):
      mtdchar: fix offset overflow detection

Namhyung Kim (1):
      tracing: Fix double free when function profile init failed

Nicholas Bellinger (1):
      target: Fix incorrect fallthrough of ALUA Standby/Offline/Transition =
CDBs

Samu Kallio (1):
      x86, mm, paravirt: Fix vmalloc_fault oops during lazy MMU updates

Thomas Gleixner (1):
      sched_clock: Prevent 64bit inatomicity on 32bit systems


--VS++wcV0S1rZb1Fb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJRbkVGAAoJEDjbvchgkmk+axwQAKNY+xPtzz6DR2/GXIgXWHbU
sM93qWA0me1xL/wOMDD2FSMcrRpL9pXqRnYYdUEDWfDLjK8k0QHw4yzbusmprYVd
S8IyLgnvw8r5jeQc8niYjA2B+YIbXrwpT/Q8UHR5iPvxtHmHk02nLC13c+D5NLnA
945NXZIYj+t/Gw3ntYrBaq20DA+EcQ79S3PB/E2HMLHKUP1VSy5pAlzYvwWCCA9F
m6izKFMmIp77KYim+x1jFbmCcrMKuGAGzPHiZiaaQxOvcrQkpzYjTIKURN45ppFv
EKTTyWCssMkl7xCWtiOX74mtf5FmiyA0FJWVn7JRP+kfM6kjbDrqq/hc8W8Q4sGJ
hzdsVy4AlwtaB/t8svZA+T+oPefa4YmxH0mJn/Lv+TFTcq5vQqgy7QgOJ/XH49No
aeV3P+b09xqGtG4Ss0//B6IBNbyhR+2MsQoFlArEbaaCR5Ov/1S6gRSMAV2KKvGu
fqc1DecNt/kYrYV0SJjJpXRj3Gz6mvu9VxCE8osg2ssIfe1V6tmYONhwP36v5G7d
IheVz3EYS2vu3zO01Dv06im/bLnfve9LdSuaXSwcxK9YXrrqDJc1POFVtIbiADDq
qVdJg60yjRB8j2PQhPUeT2L9kSpNqELspNKdUGDkRkw2t74m18jYkp/OBwQoeab1
VhM6hM+vQE1CfbgxK3lo
=hVWz
-----END PGP SIGNATURE-----

--VS++wcV0S1rZb1Fb--
