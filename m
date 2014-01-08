Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbaAHS4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 13:56:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40649 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbaAHS4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 13:56:04 -0500
Date: Wed, 8 Jan 2014 10:56:33 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.76
Message-ID: <20140108185633.GA10918@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.76 kernel.

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

 Makefile                                      |    2=20
 arch/powerpc/include/asm/exception-64s.h      |    2=20
 arch/powerpc/kernel/head_64.S                 |    1=20
 arch/powerpc/kvm/book3s_64_mmu_hv.c           |    6 ++
 arch/powerpc/kvm/book3s_hv_rm_mmu.c           |    4 +
 arch/sh/lib/Makefile                          |    2=20
 drivers/ata/libata-core.c                     |    3 +
 drivers/dma/Kconfig                           |    1=20
 drivers/gpio/gpio-msm-v2.c                    |    4 -
 drivers/gpu/drm/drm_edid.c                    |    8 +++
 drivers/gpu/drm/radeon/ni.c                   |   20 +++++++--
 drivers/hwmon/w83l786ng.c                     |    9 ++--
 drivers/idle/intel_idle.c                     |   38 ++++++++++++++++++
 drivers/input/input.c                         |    4 +
 drivers/net/usb/dm9601.c                      |   34 ++++++++++++----
 drivers/net/wireless/ath/ath9k/ar9002_mac.c   |   52 +++++++++++++++++++++=
----
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   25 ++++++++----
 drivers/net/wireless/ath/ath9k/main.c         |    5 +-
 drivers/net/wireless/rtlwifi/pci.c            |    4 +
 drivers/tty/serial/pmac_zilog.c               |    3 +
 drivers/usb/class/cdc-wdm.c                   |    8 +--
 drivers/usb/serial/generic.c                  |    9 ----
 fs/ceph/addr.c                                |    8 ++-
 fs/ceph/mds_client.c                          |    8 ++-
 fs/ext4/extents.c                             |   19 ++++++++-
 fs/ext4/mballoc.c                             |   11 +++--
 fs/gfs2/aops.c                                |   30 ++++++++++++++
 fs/gfs2/ops_fstype.c                          |   12 +++++
 fs/jbd2/transaction.c                         |    6 +-
 include/drm/drm_pciids.h                      |    2=20
 kernel/sched/debug.c                          |    8 +++
 kernel/sched/fair.c                           |    2=20
 kernel/sched/rt.c                             |   14 ++++++
 kernel/trace/ftrace.c                         |    2=20
 mm/rmap.c                                     |    4 +
 net/wireless/radiotap.c                       |    4 +
 security/selinux/hooks.c                      |   53 ++++++++++++++++++++-=
-----
 security/selinux/include/xfrm.h               |    9 ++--
 security/selinux/xfrm.c                       |   53 ++++++++++++++++++++-=
-----
 sound/core/pcm_lib.c                          |    2=20
 sound/soc/codecs/wm8904.c                     |    2=20
 tools/power/cpupower/utils/cpupower-set.c     |    6 +-
 42 files changed, 401 insertions(+), 98 deletions(-)

Alex Deucher (2):
      drm/radeon: fix asic gfx values for scrapper asics
      drm/radeon: 0x9649 is SUMO2 not SUMO

Anton Blanchard (1):
      powerpc: Align p_end

Ben Segall (1):
      sched: Avoid throttle_cfs_rq() racing with period_timer stopping

Bj=C3=B8rn Mork (1):
      usb: cdc-wdm: manage_power should always set needs_remote_wakeup

Bo Shen (1):
      ASoC: wm8904: fix DSP mode B configuration

Chad Hanson (1):
      selinux: fix broken peer recv check

Dan Williams (1):
      net_dma: mark broken

Dmitry Torokhov (1):
      Input: allocate absinfo data when setting ABS capability

Eryu Guan (1):
      ext4: check for overlapping extents in ext4_valid_extent_entries()

Geert Uytterhoeven (2):
      TTY: pmac_zilog, check existence of ports in pmz_console_init()
      sh: always link in helper functions extracted from libgcc

Greg Kroah-Hartman (1):
      Linux 3.4.76

Jean Delvare (1):
      hwmon: (w83l768ng) Fix fan speed control range

Jianguo Wu (1):
      mm/hugetlb: check for pte NULL pointer in __page_check_address()

Johan Hovold (1):
      USB: serial: fix race in generic write

Johannes Berg (1):
      radiotap: fix bitmap-end-finding buffer overrun

JongHo Kim (1):
      ALSA: Add SNDRV_PCM_STATE_PAUSED case in wait_for_avail function

Josh Boyer (1):
      cpupower: Fix segfault due to incorrect getopt_long arugments

Junho Ryu (1):
      ext4: fix use-after-free in ext4_mb_new_blocks

Kirill Tkhai (1):
      sched/rt: Fix rq's cpupri leak while enqueue/dequeue child RT entities

Larry Finger (1):
      rtlwifi: pci: Fix oops on driver unload

Len Brown (2):
      intel_idle: initial IVB support
      intel_idle: enable IVB Xeon support

Li Wang (1):
      ceph: Avoid data inconsistency due to d-cache aliasing in readpage()

Mathy Vanhoef (1):
      ath9k_htc: properly set MAC address and BSSID mask

Miao Xie (1):
      ftrace: Initialize the ftrace profiler for each possible cpu

Michael Neuling (1):
      powerpc: Fix bad stack check in exception entry

Michele Baldessari (1):
      libata: add ATA_HORKAGE_BROKEN_FPDMA_AA quirk for Seagate Momentus Sp=
inPoint M8

Oleg Nesterov (1):
      selinux: selinux_setprocattr()->ptrace_parent() needs rcu_read_lock()

Paul Moore (2):
      selinux: look for IPsec labels on both inbound and outbound packets
      selinux: process labeled IPsec TCP SYN-ACK packets properly in selinu=
x_ip_postroute()

Peter Korsgaard (2):
      dm9601: fix reception of full size ethernet frames on dm9620/dm9621a
      dm9601: work around tx fifo sync issue on dm962x

Rafa=C5=82 Mi=C5=82ecki (1):
      drm/edid: add quirk for BPC in Samsung NP700G7A-S01PL notebook

Stephen Boyd (1):
      gpio: msm: Fix irq mask/unmask by writing bits instead of numbers

Steven Whitehouse (2):
      GFS2: don't hold s_umount over blkdev_put
      GFS2: Fix incorrect invalidation for DIO/buffered I/O

Sujith Manoharan (1):
      ath9k: Fix interrupt handling for the AR9002 family

Theodore Ts'o (1):
      jbd2: don't BUG but return ENOSPC if a handle runs out of space

Yan, Zheng (2):
      ceph: cleanup aborted requests when re-sending requests.
      ceph: wake up 'safe' waiters when unregistering request

pingfan liu (1):
      powerpc: kvm: fix rare but potential deadlock scene


--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSzZ9hAAoJEDjbvchgkmk+xxwQAJQvn4yaUiJQLvmRrBcNx+kx
YoIgc0oVRIea1XzlnLZ8jjqe3IL5J8UJGx/NL7tzAIfuUh5qJMhVqintq6cTuYpZ
r/As3i/PQUncsmJe4KAb74PLmmwAgoJCzdXcRbCZhdg30YtJM2MSaOUiLmWdGWgb
XvWed5mR4546RaNxXzg49p4atA3SlMO7ciZElYfNgMN7P3Mm7jk9ZNtMtKgp1DSR
0ZvNK3v5UHnuPvs+tLrZaX9Z56ACSZ6qZt2X2HNygWNnPSZB6BeRP0HK1afPoOxO
0lu4rEfIBMEmNRHg28R7dHxU2w4XjXON4ieN9CRtynvirvAUgxO09D7aLyYkk+nq
3kmgwzIThQZzk+2J3wmQUoHNAwLWD3X9W+wvnphLt6MMKUiO+K3Ow2Vdb+N+aKRR
YgQ3qghEzx+PxYUHpUGWXo4whrIzHHq+77leWkaO354CSedDDv/2YLOXNCXFno7p
S0FO3qY/tBuwxf3XGgFaOskBs++4VmBQm1YnMTIn7Grh4P3CYGLO+3YC1gfTud9+
46wzfcezt7vnjkjdxoSyiOLgDWgKy4RKUq281+01cpqs70fgtGF7cLZwBdupatgW
y8RfndCIKUAQtMmZLvHyWsBYQm2KjSfmfNngDjkW0VVTklEPlRKe0Pe+Q5b2YmwQ
+JXjOP0oielUd4PcsJk8
=kwP/
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
