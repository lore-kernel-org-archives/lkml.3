Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760205Ab3HOGIC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 02:08:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59124 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713Ab3HOGIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 02:08:00 -0400
Date: Wed, 14 Aug 2013 23:09:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.58
Message-ID: <20130815060933.GA16651@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.58 kernel.

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

 Makefile                                  |    2=20
 drivers/char/virtio_console.c             |   47 ++++++++++++--------
 drivers/hwmon/adt7470.c                   |    2=20
 drivers/scsi/megaraid/megaraid_sas_base.c |   20 ++++++--
 drivers/scsi/nsp32.c                      |    2=20
 drivers/scsi/scsi.c                       |    3 +
 drivers/usb/core/hub.c                    |    5 +-
 fs/cifs/cifsencrypt.c                     |    2=20
 fs/cifs/cifsglob.h                        |    1=20
 fs/cifs/connect.c                         |    7 +--
 fs/cifs/sess.c                            |    6 +-
 fs/dcache.c                               |    2=20
 fs/debugfs/inode.c                        |   69 +++++++++----------------=
-----
 fs/ext4/ialloc.c                          |   10 ++--
 fs/ext4/super.c                           |   17 ++++++-
 include/linux/ftrace_event.h              |    4 +
 kernel/trace/trace.c                      |    1=20
 tools/perf/util/map.c                     |    3 -
 18 files changed, 111 insertions(+), 92 deletions(-)

Amit Shah (5):
      virtio: console: fix race with port unplug and open/close
      virtio: console: fix race in port_fops_open() and port unplug
      virtio: console: clean up port data immediately at time of unplug
      virtio: console: fix raising SIGIO after port unplug
      virtio: console: return -ENODEV on all read operations after unplug

Andrew Vagin (1):
      tracing: Fix fields of struct trace_iterator that are zeroed by mista=
ke

Arnd Bergmann (1):
      SCSI: nsp32: use mdelay instead of large udelay constants

Chen Gang (1):
      cifs: extend the buffer length enought for sprintf() using

Curt Brune (1):
      hwmon: (adt7470) Fix incorrect return code check

Greg Kroah-Hartman (1):
      Linux 3.4.58

Joshua Zhu (1):
      perf tools: Add anonymous huge page recognition

Julius Werner (1):
      usb: core: don't try to reset_device() a port that got just disconnec=
ted

Martin K. Petersen (1):
      SCSI: Don't attempt to send extended INQUIRY command if skip_vpd_page=
s is set

NeilBrown (1):
      vfs: d_obtain_alias() needs to use "/" as default name.

Oleg Nesterov (1):
      debugfs: debugfs_remove_recursive() must not rely on list_empty(d_sub=
dirs)

Piotr Sarna (1):
      ext4: fix mount/remount error messages for incompatible mount options

Sumit.Saxena@lsi.com (1):
      SCSI: megaraid_sas: megaraid_sas driver init fails in kdump kernel

Theodore Ts'o (1):
      ext4: make sure group number is bumped after a inode allocation race


--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSDHCdAAoJEDjbvchgkmk+pQcP/2mNJSdA7aEm5gJmTdgQ2rOj
OhKFd8FYnyEmoLnFFAYFaFOR3vwjWqhIKE4zbRIktvEVnzcjfj7h95lzqcdwE1Zf
4WWEkRM1Vmu7805nKXYoy/A05ERvaJjbGUKCs7yl1LyXeVO4iMAVL4vy0ojP3ELu
M9R0HSDcjyT/PdC84NRyI6wJzy+CoH2648JAxBXVpP4rLHYTUIoIYISA7H0TIp6X
Uh9Rij0ODgSpTIZ+iHS7ZZjyACgwtZmRbGWROwdVYm6LxVsIIRiCRnsFlv2wEf6r
68h/rCD/KQF1od6y8qDTVMNUPvbJUj73Sx0TG6l1281A5nCI0uz0wovjXPVwMjZS
fbEkNcToSlPqTBkWruekHGNpG6ekIpWfZGr8oWqyNlCtZ3QDDThCcQO3iJwWRo+l
vw9FE8lWbQ7qlMQvIjPeGuTr7VmwSX0M2iONpAzUJObdqezjd8Xd28M1GLR3Boau
FXqF2DCVaYlCDzJ+RD++iOrdm/iMTarvvkc+zxVjWFzg8KEfMp1k5wYMM6WmqcHx
WPlfCFEdI3jOcA5aPRIGv+CZpWiaQWYryEjxIeEkE4YcaGuXVRpk96AndEsiq9x3
4pZ/ndKGwGLu17lZatIHxJFsl8pNikvdktKKWy+ome2iJLYqMScm8f9BFQB8m0ht
UAwLef+Q7mIJU2+/M78Q
=X95D
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
