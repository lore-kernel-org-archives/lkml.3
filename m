Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab3CNSsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 14:48:21 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:59798 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab3CNSsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 14:48:17 -0400
Date: Thu, 14 Mar 2013 11:48:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.69
Message-ID: <20130314184814.GA22849@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.0.69 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                |    2 +-
 arch/arm/mm/alignment.c                 |   11 ++++-------
 arch/arm/vfp/vfpmodule.c                |    2 +-
 drivers/char/hw_random/core.c           |   19 ++++++++++++++++---
 drivers/cpufreq/cpufreq_stats.c         |    1 +
 drivers/firmware/dmi_scan.c             |    5 ++---
 drivers/gpu/drm/radeon/radeon_combios.c |    9 +++++++++
 drivers/hwmon/sht15.c                   |    8 +++++++-
 drivers/md/raid0.c                      |    2 +-
 drivers/net/e1000e/netdev.c             |    2 +-
 drivers/net/wireless/ath/ath9k/common.h |    2 +-
 drivers/scsi/dc395x.c                   |    2 +-
 drivers/target/target_core_pscsi.c      |    1 -
 fs/btrfs/volumes.c                      |    1 +
 fs/cifs/cifsfs.c                        |    5 +++++
 fs/pipe.c                               |    3 +++
 kernel/trace/Kconfig                    |   24 ++++++++++++++----------
 net/decnet/af_decnet.c                  |    4 ++++
 net/decnet/sysctl_net_decnet.c          |   28 ++++++++++++++++++++++++++++
 net/sunrpc/xprt.c                       |    6 +++++-
 security/keys/process_keys.c            |    2 +-
 sound/core/vmaster.c                    |    5 ++++-
 sound/pci/ice1712/ice1712.c             |    2 ++
 23 files changed, 112 insertions(+), 34 deletions(-)

Al Viro (1):
      vfs: fix pipe counter breakage

Alex Deucher (1):
      drm/radeon: add primary dac adj quirk for R200 board

Asias He (1):
      target/pscsi: Fix page increment

Ben Hutchings (1):
      dmi_scan: fix missing check for _DMI_ signature in smbios_present()

Dan Carpenter (1):
      SCSI: dc395x: uninitialized variable in device_alloc()

David Howells (1):
      keys: fix race with concurrent install_user_keyrings()

Eric W. Biederman (1):
      decnet: Fix disappearing sysctl entries

Felix Fietkau (1):
      ath9k: fix RSSI dummy marker value

Greg Kroah-Hartman (1):
      Linux 3.0.69

Jeff Layton (1):
      cifs: ensure that cifs_get_root() only traverses directories

Konstantin Khlebnikov (1):
      e1000e: fix pci-device enable-counter balance

Mark Brown (1):
      hwmon: (sht15) Check return value of regulator_enable()

NeilBrown (1):
      md: raid0: fix error return from create_stripe_zones.

Russell King (2):
      ARM: VFP: fix emulation of second VFP instruction
      ARM: fix scheduling while atomic warning in alignment handling code

Rusty Russell (1):
      hw_random: make buffer usable in scatterlist.

Sean Connor (1):
      ALSA: ice1712: Initialize card->private_data properly

Steven Rostedt (1):
      ftrace: Update the kconfig for DYNAMIC_FTRACE

Takashi Iwai (1):
      ALSA: vmaster: Fix slave change notification

Thomas Gleixner (1):
      btrfs: Init io_lock after cloning btrfs device struct

Trond Myklebust (1):
      SUNRPC: Don't start the retransmission timer when out of socket space

Tu, Xiaobing (1):
      Fix memory leak in cpufreq stats.


--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRQhtuAAoJEDjbvchgkmk+xQYQAMEbhxvms3a8zP5CES6CDu9J
VaNSnEjpL2hUlmsPJxSO8WT+KmHJL1+HFYZvEmjA0c5DuMvcK4ai8zQnPd7Du650
NjM9WjEzl7rgHp/24U8Uc5wNO3PehGXg2WXPWcicBhwfzZT9oRWUZhgd6ct3pC2m
7QWXVPB5VQp6zpM5WMx0XhGh8xj0s+g+y65lmQPVsl0ZtuVIvNlq3qc/xXffBGeB
HH2GOBwkQrAxfdTHRbh3FL2aHRGsGiRM80YjkormV+9TEvdiIra/C9DPKeVkkIz3
r7+LHN61q6KLxsdlg5x2enP2FHy3VkawZ/HbYOXMKAwC4LNxa+Ud0+VHntezjZGy
FLjLpSJmhuJXd+hrqmOstzSK6pZG2NQLMiScZVWHtDcXDB7Ry6U6kEx9tz+eToyM
QTvNUZa8wODzBOpaoQ5Pv/gPvpjizcWl4hKcHwg44ZiUjC3SGW0G9/7i94L4NTGA
tBaqfee7n2QPe+g4RvInYIyJvCY9wf4k/dvg8bueAu82bMB/ce8FuM4fRdQsHGv4
bqNdBLeVULwTNJs3QEoZ9UpYuLksWhjk2NFEsYUBubpw45fIoiPbNbIOcCp2pn4Z
361BKhu7UUsoWF/p5vULvWUg4GThBHQWiukN25n8X0MBBTkjLob80YOeZIqMajHQ
Hls0P0SZUaasao89VqPY
=32Tn
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
