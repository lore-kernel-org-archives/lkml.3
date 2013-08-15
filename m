Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab3HOGHd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 02:07:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59116 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab3HOGHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 02:07:31 -0400
Date: Wed, 14 Aug 2013 23:09:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.91
Message-ID: <20130815060905.GA16595@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.91 kernel.

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

 Makefile                      |    2 -
 drivers/char/virtio_console.c |   47 +++++++++++++++++-----------
 drivers/hwmon/adt7470.c       |    2 -
 drivers/scsi/nsp32.c          |    2 -
 fs/cifs/cifssmb.c             |   24 +++++++-------
 fs/dcache.c                   |    2 -
 fs/debugfs/inode.c            |   69 +++++++++++++------------------------=
-----
 include/linux/ftrace_event.h  |    4 +-
 kernel/trace/trace.c          |    1=20
 tools/perf/util/map.c         |    3 +
 10 files changed, 72 insertions(+), 84 deletions(-)

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

Curt Brune (1):
      hwmon: (adt7470) Fix incorrect return code check

Greg Kroah-Hartman (1):
      Linux 3.0.91

Jeff Layton (1):
      cifs: silence compiler warnings showing up with gcc-4.7.0

Joshua Zhu (1):
      perf tools: Add anonymous huge page recognition

NeilBrown (1):
      vfs: d_obtain_alias() needs to use "/" as default name.

Oleg Nesterov (1):
      debugfs: debugfs_remove_recursive() must not rely on list_empty(d_sub=
dirs)


--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSDHCBAAoJEDjbvchgkmk+su4QAMawg7vJISID8PoHRLamdwdv
9hppZk8kijtYwrcqYPtDm4YVC0XcI9Sk+Z5EY8PDC7eGjULbfOXdN5HTZOYRHjAD
VT6NnZyfXgp1zmCsTq1bt6oKJ4gBgDbae3SwPsCcJocSKBchpCGZxyauT8WfEHNG
/WNFVXvOLUpAj+GYiUdY2kirsnjMK2PT+anQWF8jGxE0azhrIm3MfRmnHo+dq/Sr
wRnsJauyojVdzXzk2x9cnfThUFY1gx32fCzi/klubC+okScGPuPs9VYiFUbtF08D
Vnerj8t5TK1y48I/yd1WHY4xxDBJTdZp+Kk+3GfMvXfhvuzJY+nTLA18NW6QpMHe
JaU84mk8P+dThLaNPuXqnyXWwRSNgEJYig9mKAmWgMMqgEKJB0Jcha3WVEBb2jdf
OCIegIIiOBuZcpRL65Pju9L6/YcDtf0oVNTW+NPJWmMvU2X2m3E9jGGxbQsoUC6v
lizJxZX7auX4a9e510AkTGQ8bZ384lbzp0Evse2aY6ZxHgrs30SaogAy400xMPfm
ewXuU5fJ7uc9CNmgydte5dYL9KC9Y5kX8A5O1dhmKgeoIZ/RBb2PfCC2IPup4jQS
jhQv3vgMP8o32t+4pc1ixf2aApICi3iOkaT5GuDrhZ5XqQe4FUTvwes9hD1EyhnU
U/wD60OQHajnEOrwC22R
=o2A4
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
