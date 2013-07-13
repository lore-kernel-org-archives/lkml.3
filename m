Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933342Ab3GMSzR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 14:55:17 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:51974 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933354Ab3GMSzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 14:55:03 -0400
Date: Sat, 13 Jul 2013 11:55:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.1
Message-ID: <20130713185503.GA673@kroah.com>
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

I'm announcing the release of the 3.10.1 kernel.

All users of the 3.10 kernel series must upgrade.

The updated 3.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.10.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 MAINTAINERS                        |    1 +
 Makefile                           |    2 +-
 arch/x86/kvm/vmx.c                 |   11 +++++++++--
 block/genhd.c                      |    2 +-
 crypto/algapi.c                    |    3 ++-
 drivers/block/nbd.c                |    3 ++-
 drivers/cdrom/cdrom.c              |    2 +-
 drivers/cpufreq/cpufreq_stats.c    |    1 +
 drivers/power/charger-manager.c    |    2 +-
 drivers/scsi/osd/osd_uld.c         |    2 +-
 drivers/scsi/sd.c                  |    2 +-
 drivers/tty/serial/8250/8250_pci.c |    4 ----
 drivers/tty/tty_io.c               |    2 ++
 fs/ceph/xattr.c                    |    9 +++++----
 fs/hpfs/map.c                      |    3 ++-
 fs/hpfs/super.c                    |    8 +++++++-
 fs/nfs/nfs4state.c                 |   23 +++++++++++------------
 fs/nfsd/nfs4xdr.c                  |    2 +-
 include/linux/ceph/decode.h        |    5 -----
 include/linux/hugetlb.h            |   16 ++++++++++++++++
 kernel/futex.c                     |    3 ++-
 kernel/module.c                    |   34 ++++++++++++++++++----------------
 mm/hugetlb.c                       |   17 +++++++++++++++++
 mm/memcontrol.c                    |    2 --
 net/ceph/auth_none.c               |    6 ++++++
 25 files changed, 108 insertions(+), 57 deletions(-)

Andy Adamson (1):
      NFSv4.1 end back channel session draining

Ben Hutchings (1):
      SCSI: sd: Fix parsing of 'temporary ' cache mode prefix

Gleb Natapov (1):
      KVM: VMX: mark unusable segment as nonpresent

Greg Kroah-Hartman (3):
      MAINTAINERS: add stable_kernel_rules.txt to stable maintainer information
      Revert "serial: 8250_pci: add support for another kind of NetMos Technology PCI 9835 Multi-I/O Controller"
      Linux 3.10.1

J. Bruce Fields (1):
      nfsd4: fix decoding of compounds across page boundaries

Jonathan Salwan (1):
      drivers/cdrom/cdrom.c: use kzalloc() for failing hardware

Josh Durgin (1):
      libceph: fix invalid unsigned->signed conversion for timespec encoding

Kees Cook (3):
      charger-manager: Ensure event is not used as format string
      block: do not pass disk names as format strings
      crypto: sanitize argument for format string

Michal Hocko (1):
      Revert "memcg: avoid dangling reference count in creation failure"

Mikulas Patocka (1):
      hpfs: better test for errors

Peter Hurley (1):
      tty: Reset itty for other pty

Rusty Russell (1):
      module: do percpu allocation after uniqueness check. No, really!

Srivatsa S. Bhat (1):
      cpufreq: Fix cpufreq regression after suspend/resume

Tyler Hicks (1):
      libceph: Fix NULL pointer dereference in auth client code

Zhang Yi (1):
      futex: Take hugepages into account when generating futex_key

majianpeng (1):
      ceph: fix sleeping function called from invalid context.


--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR4aKHAAoJEDjbvchgkmk+IeoP/RKd2b9S3lvhrk1SlU9F/BZ/
mv398I83ZG7IXZrirKd2iG9ybQiTsgXK9DTPVrIHU9Wwjbxks0+0JYClEZPLXvUq
5PVKZvSqW0zRza1FBJRc4vUbsrWIfZeWVYNkL0sB4hVL2m9HQ0Ucc2rPGwWNRztz
G40CM2a2ksqlzN1Ud9dgcOJ7S+BZNDI5P/pUx/qbnqxOXhvxb9dDeFU3XuiSQegX
5nD0rziU71s8GcxE/0QSwd4ft67ZGXxCb8XgTieiSTGsP7MYm1d8rzK9uojIGyuO
hRXnsPdToeR4TfRBrWWMjAlyw6v1ToQ1aCxGVTz5XWwxNRwJrjz2mvxRFf+TUgqj
FJFpieUUEbv8T2vXwBjCSug8RtXA3wN7dkKAT8lFVPDVut2lxfoec4H10+Qn3CtN
gJVX9MQZgOG8qZrn80jkxxSQxR5I2b048vQL1u1qO/j7GRPjqErcTuFK9qOM6uh/
Xwbworbo/0qgpHr092T8RLYP14QFuUFTL5CgUz4qnB5/yIWh9QlrGwaFdS96pf4V
wKK/bo9xA/dmq5KJyB12nBtT6xDJqHydiW2bcjZNGS+y8VU0I0o2hzfX6V16Azr/
GTENWhzcbMFWh9JynS1epevTIGdo3mKiJixAtawYUuNk7+Z9uYA2gvpcEBkkECF3
8o5/MwuPGDPkILLW2E/Z
=InUa
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
