Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965774Ab3DQGtu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 02:49:50 -0400
Received: from mail-da0-f52.google.com ([209.85.210.52]:38345 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756925Ab3DQGtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 02:49:49 -0400
Date: Tue, 16 Apr 2013 23:49:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.41
Message-ID: <20130417064945.GA13055@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.41 kernel.

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

 Makefile                              |    2 -
 arch/x86/include/asm/paravirt.h       |    5 ++-
 arch/x86/include/asm/paravirt_types.h |    2 +
 arch/x86/kernel/paravirt.c            |   25 +++++++--------
 arch/x86/lguest/boot.c                |    1=20
 arch/x86/mm/fault.c                   |    6 ++-
 arch/x86/xen/mmu.c                    |    1=20
 drivers/gpu/drm/i915/i915_gem_gtt.c   |    2 -
 drivers/gpu/drm/udl/udl_connector.c   |    4 ++
 drivers/mtd/mtdchar.c                 |   56 +++++++++++++++++++++++++++++=
-----
 drivers/net/ethernet/realtek/r8169.c  |   28 +++++++++++++++--
 drivers/scsi/libsas/sas_expander.c    |   12 +++++++
 drivers/target/target_core_alua.c     |    3 +
 fs/cifs/connect.c                     |   16 +++++++--
 fs/inode.c                            |    2 -
 include/linux/kref.h                  |   21 ++++++++++++
 kernel/sched/clock.c                  |   26 +++++++++++++++
 kernel/sys.c                          |    3 +
 kernel/trace/ftrace.c                 |    1=20
 lib/kobject.c                         |    9 ++++-
 sound/soc/codecs/wm8903.c             |    2 +
 sound/usb/mixer_quirks.c              |    4 +-
 sound/usb/quirks.c                    |    2 -
 23 files changed, 195 insertions(+), 38 deletions(-)

Alban Bedel (1):
      ASoC: wm8903: Fix the bypass to HP/LINEOUT when no DAC or ADC is runn=
ing

Boris Ostrovsky (1):
      x86, mm: Patch out arch_flush_lazy_mmu_mode() when running on bare me=
tal

Chris Wilson (1):
      drm/i915: Use the correct size of the GTT for placing the per-process=
 entries

Dave Airlie (1):
      udl: handle EDID failure properly.

David Woodhouse (1):
      mtd: Disable mtdchar mmap on MMU systems

Eldad Zack (1):
      ALSA: usb-audio: fix endianness bug in snd_nativeinstruments_*

Greg Kroah-Hartman (1):
      Linux 3.4.41

Hayes Wang (1):
      r8169: fix auto speed down issue

Huacai Chen (1):
      PM / reboot: call syscore_shutdown() after disable_nonboot_cpus()

Linus Torvalds (2):
      mtdchar: fix offset overflow detection
      kobject: fix kset_find_obj() race with concurrent last kobject_put()

Lukasz Dorau (1):
      SCSI: libsas: fix handling vacant phy in sas_set_ex_phy()

Namhyung Kim (1):
      tracing: Fix double free when function profile init failed

Nicholas Bellinger (1):
      target: Fix incorrect fallthrough of ALUA Standby/Offline/Transition =
CDBs

Sachin Prabhu (1):
      cifs: Allow passwords which begin with a delimitor

Samu Kallio (1):
      x86, mm, paravirt: Fix vmalloc_fault oops during lazy MMU updates

Suleiman Souhlal (1):
      vfs: Revert spurious fix to spinning prevention in prune_icache_sb

Thomas Gleixner (1):
      sched_clock: Prevent 64bit inatomicity on 32bit systems

Thomas Hellstrom (1):
      kref: Implement kref_get_unless_zero v3


--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJRbkYJAAoJEDjbvchgkmk+81gQAKlF6jmzzoYQ6TuuhwX48uid
XQ6qy2cOCLN/90S5xs98uD9gu/oRD9ypBNrPSXrbC4R6HeU1R078UEbQbyknqiK1
x056xW/JOGGyUcO32yFIj6y2qkkNZu9KgDbTj8w8oqZmPg7WSWm8myhlqoH9cMrY
LXplhWzmoXAqtlwm4BbXMtJU2AGpUq7o9z0Z2VHPVqz6Fy76GY6gx/joJqJ88eTe
M/Y/+UUusdTlAtwQBlE17O5DUs/4OlATMUVo/nXYRI0HOYG+EaX7PJwdSJcU8y6v
EFGX0yuuObT++Pdsrczb+6ICedfUqmHMlkO4dy8j0ZL/rUXufDc6ajZ0Tod93aaz
HohSPhuu+TC46S/Z1IByTZv8gy1Fup2PK0hNasszGQ165D3iXfNOZdcljHJCpbCb
iX+43BCTGTAzmPv/h+npQAWaMS+BbMMYjldL7TjjOZ02y6/Zls5272ESxRpVHin7
iru/wd5uzbRvYGQh+b+yRe0SwzrmULPYuVqA/XNJioIBTRA1JcWt/fU2sP/UM+kh
COGQ3+wT9TYFrZXNOy/2v1yGPu3y/S4F2h+IsskC8ZvtDkSJqht4sDWy8w052UgY
0l4Oqz5tqxNdwQcrOG/btM85t2TrpL7lTnO7mApoNSZ06+RIqRbzVTp6XB9lmyrN
qCF4YHgWjkZWoRyJhkeU
=RIfQ
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
