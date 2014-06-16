Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbaFPVTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 17:19:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45512 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363AbaFPVTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 17:19:31 -0400
Date: Mon, 16 Jun 2014 14:19:22 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.15.1
Message-ID: <20140616211922.GA2075@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.15.1 kernel.

All users of the 3.15 kernel series must upgrade.

The updated 3.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.15.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                |    2 +-
 drivers/ata/ahci.c                      |    4 ++++
 drivers/media/dvb-core/dvb-usb-ids.h    |    2 ++
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c |    6 ++++++
 drivers/misc/mei/hw-me.c                |   25 +++++++++++++++++++------
 drivers/pci/msi.c                       |    2 +-
 fs/attr.c                               |    8 ++++----
 fs/dcache.c                             |    4 +++-
 fs/inode.c                              |   10 +++++++---
 fs/namei.c                              |   11 ++++++-----
 fs/xfs/xfs_ioctl.c                      |    2 +-
 include/linux/capability.h              |    2 +-
 kernel/auditsc.c                        |   27 ++++++++++++++++++---------
 kernel/capability.c                     |   20 ++++++++------------
 14 files changed, 81 insertions(+), 44 deletions(-)

Al Viro (1):
      lock_parent: don't step on stale ->d_parent of all-but-freed one

Alessandro Miceli (2):
      rtl28xxu: add [1b80:d39d] Sveon STV20
      rtl28xxu: add [1b80:d3af] Sveon STV27

Alexei Starovoitov (1):
      PCI/MSI: Fix memory leak in free_msi_irqs()

Andreas Schr=E4gle (1):
      ahci: add PCI ID for Marvell 88SE91A0 SATA Controller

Andy Lutomirski (2):
      fs,userns: Change inode_capable to capable_wrt_inode_uidgid
      auditsc: audit_krule mask accesses need bounds checking

Brian Healy (1):
      rtl28xxu: add 1b80:d395 Peak DVB-T USB

Greg Kroah-Hartman (1):
      Linux 3.15.1

J=E9r=F4me Carretero (1):
      ahci: Add Device ID for HighPoint RocketRaid 642L

Tomas Winkler (3):
      mei: me: fix hw ready reset flow
      mei: me: drop harmful wait optimization
      mei: me: read H_CSR after asserting reset


--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTn19aAAoJEDjbvchgkmk+u34P/0MwMi6IF49FCN2SAD+RXeqC
PfVqyRnnUPxnRs/YvlH4akwzv6WLgBQkQBK47DeuQXpWd/KAN9UyX/GfeLmUt2Q7
bDYZFfVcZhGPZlfkRZkGghpdW3ARcWLWBC8EKscl3A51fvK6AlnvxmJsZrw9iThj
wCfnHItVXgVk4SVjmosu7Zo+QcdQIfCmDPA5QoRVuc7HpElDpTU/Nd8egBIcIao0
XAygabb31fYfeBNeOV+hLNRHtkR2x1brBmTiM2khJaqFB0y25hhQrA6vqKwjH1VH
8pdeX0PuBwLOHrJlHERJLytbngUgnA9tyYsZ6BDDOGNYngpP8j1VA427NEMRi8zD
o7WJDFJ3r7qDGEZjPPNrWOf2JHZ6qehBL5g0kK99FOFpiM6vDhPsrwbMN5cwQtym
cooSVDRq3dXbIKbMY7f8P9o1NdckNzWItr0GUp7ZakiVw4zAm3Lr/1wDP/GZrZ9h
gORjz1oGi+fdfFlNkop7rkj6kJ+SaKLR3gVaOmjjZV9Xh9fcwaIDgDsW5N1UZPHv
Ip0StiUqjPexsResNuRLYwIwm6coCTo0HP5kyI/8Iu/ijd2ERN1YzRc70ReSwmU7
ff/z336CpRYPtourCVviIpsBTW2D3uyOsV1IxKYG3p0/DSiiy80A+Si6mu51iPA2
it7vLHjMyOFGPJvjjiK6
=kCEj
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
