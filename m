Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933391Ab3GMSyS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 14:54:18 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:46405 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933377Ab3GMSyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 14:54:16 -0400
Date: Sat, 13 Jul 2013 11:54:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.9.10
Message-ID: <20130713185417.GA618@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.9.10 kernel.

Note, this might just be the last 3.9-stable kernel release, I'm not
quite sure I can guarantee another 3.9-stable kernel will be released.
Please move to the 3.10-stable series at this point in time.  If that
isn't working for you, please let us know NOW!

All users of the 3.9 kernel series must upgrade.

The updated 3.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.9.y
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
 drivers/power/charger-manager.c    |    2 +-
 drivers/scsi/osd/osd_uld.c         |    2 +-
 drivers/scsi/sd.c                  |    2 +-
 drivers/tty/serial/8250/8250_pci.c |    4 ----
 fs/ceph/xattr.c                    |    9 +++++----
 fs/hpfs/map.c                      |    3 ++-
 fs/hpfs/super.c                    |    8 +++++++-
 fs/nfsd/nfs4xdr.c                  |    2 +-
 include/linux/hugetlb.h            |   16 ++++++++++++++++
 kernel/futex.c                     |    3 ++-
 kernel/module.c                    |   34 ++++++++++++++++++----------------
 mm/hugetlb.c                       |   17 +++++++++++++++++
 mm/memcontrol.c                    |    2 --
 net/ceph/auth_none.c               |    6 ++++++
 21 files changed, 94 insertions(+), 40 deletions(-)

Ben Hutchings (1):
      SCSI: sd: Fix parsing of 'temporary ' cache mode prefix

Gleb Natapov (1):
      KVM: VMX: mark unusable segment as nonpresent

Greg Kroah-Hartman (3):
      MAINTAINERS: add stable_kernel_rules.txt to stable maintainer information
      Revert "serial: 8250_pci: add support for another kind of NetMos Technology PCI 9835 Multi-I/O Controller"
      Linux 3.9.10

J. Bruce Fields (1):
      nfsd4: fix decoding of compounds across page boundaries

Jonathan Salwan (1):
      drivers/cdrom/cdrom.c: use kzalloc() for failing hardware

Kees Cook (3):
      charger-manager: Ensure event is not used as format string
      block: do not pass disk names as format strings
      crypto: sanitize argument for format string

Michal Hocko (1):
      Revert "memcg: avoid dangling reference count in creation failure"

Mikulas Patocka (1):
      hpfs: better test for errors

Rusty Russell (1):
      module: do percpu allocation after uniqueness check. No, really!

Tyler Hicks (1):
      libceph: Fix NULL pointer dereference in auth client code

Zhang Yi (1):
      futex: Take hugepages into account when generating futex_key

majianpeng (1):
      ceph: fix sleeping function called from invalid context.


--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR4aJZAAoJEDjbvchgkmk+Uh8P/ja42dK5o2e5nGx75SanEfqu
Q0eeO11Bi43EHUdf4U0G9+uKNZpPOFnn5y3WIrsZGyBbdnaILdvpEEMPxvtbt1Dj
wyXJZpWNeyH+jixw0TpnGZJtsU8BF7Vr7VzBKbruCSGtNBjC3e5FRbVwmve2141G
dj90AvCEug+7Ynrfl6uAZdY4RNQ/gtBl8n1SjFfsMpmrnZ90fyS3tVcVVqZ/Bgyy
8x/kO1YwYmcMhzY1GCnvFHGQuWG1D0UCvo/cYl8TMmq4fK2a6ygE7/OrJEMXPlSo
SqSXHahwYvW4MfX3XnWCV9QEPCnT2AqrI4maZ6xNmeIIVtUwWshNnd7jZZQh4bPs
nH1hia04uhn1sGksnDfQTKSNCPZy9+yPIjxXju8kbIdEbEOeDHAFCm+MjaNpGJhi
VAWcaUm2qmLz1S2RBfPQ3zCJ7D346IquZ0z0YEs+6/G/sCsJ46G07STvHptnUYFT
edWGBGEU7pNbOhJex8YuyV/Y8Kf2IDAqONoMlVlgogvayDwV9sWk9oNRqwFiKfOw
xBvp/uGwtZyaadw1Ol4lUnfRZ8JUCIBEVTuVNpCW8bwlW2kelEP8lO9B/Ex0OTE4
k6h+cjG7Yi0GJOGOXLEzPl76rUmJvQ9iR35Xt29arZSyLxj6E/spLozWb3KEN48a
GPbb+HtYTl6e3Rvln5oO
=UtuX
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--
