Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbaA2NL7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 08:11:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57640 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbaA2NL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 08:11:57 -0500
Date: Wed, 29 Jan 2014 05:13:11 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.78
Message-ID: <20140129131311.GA15016@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.4.78 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.4.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                   |    2 -
 arch/x86/kernel/cpu/perf_event_amd_ibs.c   |   53 ++++++++++++++++++++++++-----
 arch/x86/kvm/lapic.c                       |   24 +++++++------
 arch/x86/kvm/lapic.h                       |    4 +-
 arch/x86/kvm/x86.c                         |   33 ------------------
 drivers/hwmon/coretemp.c                   |    2 -
 drivers/md/raid10.c                        |   12 +++---
 drivers/staging/comedi/drivers/cb_pcidio.c |   21 ++++-------
 fs/nilfs2/segment.c                        |   10 +++--
 mm/memory-failure.c                        |   16 ++++++--
 security/selinux/hooks.c                   |   20 +++++++++-
 security/selinux/include/objsec.h          |    5 ++
 12 files changed, 118 insertions(+), 84 deletions(-)

Andreas Rohner (1):
      nilfs2: fix segctor bug that causes file system corruption

Andy Honig (1):
      KVM: x86: Convert vapic synchronization to _cached functions (CVE-2013-6368)

Greg Kroah-Hartman (1):
      Linux 3.4.78

Ian Abbott (1):
      staging: comedi: 8255_pci: fix for newer PCI-DIO48H

Jean Delvare (1):
      hwmon: (coretemp) Fix truncated name of alarm attributes

Jianguo Wu (1):
      mm/memory-failure.c: recheck PageHuge() after hugetlb page migrate successfully

NeilBrown (2):
      md/raid10: fix bug when raid10 recovery fails to recover a block.
      md/raid10: fix two bugs in handling of known-bad-blocks.

Robert Richter (1):
      perf/x86/amd/ibs: Fix waking up from S3 for AMD family 10h

Steven Rostedt (1):
      SELinux: Fix possible NULL pointer dereference in selinux_inode_permission()


--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS6P5nAAoJEDjbvchgkmk+7dIP+wcGX87Z7whRLUkXsAtAygwN
MtdeAxN/1scYiuW16aLh/pgA3FoyNhbp30b4l75PoT9j1JKb2ltcWpjGGoX/3Diy
HgOWVq7hlvo+piADwyD2W3ktSoKz6bmCEcrrJujQBIO2uMO3RGxgbk4CWM+s5I7P
uyd//NSMbobtxbNJJIc1KL2wJve9NrsEwflvAUAGQKb+TdThAW1zvDKEInyBTudt
BqmZ1SBag33jp+ppMqK2U9P0aCijO+9BQKeGyhHqemuJBhDAC5sEAs2yPI3licOV
RZ0q1uz8PaEO9zSGSCKRooTG2WDt8uNZuHG3BdWlzZ3wSdKZjnQsvPkdZXUDrM+C
Ls1RUWz5zoE8saCy7gJt2xLGi+zQoomYrXfxBAyiNCwa1bT8cVMlYuMh0LzllQnc
YSz5ighd5C0ND1G1tn91GUC2XgMlSkM0SnNemMfS+cAJ0XfRPvlW2Ru6DWfZmSYT
1fX5+tI2qTBtfPD61UU8r1WJSybKjpaWQ9gbwk40fuhK1Ny0qBTf+7hny4O01v+p
1yJ2wxHNedVLr6Rab38/RJdFs+Fmm9ctsBA8c+TfiNclLKQQnZEJwy8dnf/6D5HY
xmR7fWkqXa00Go/S9Rbjn0Pv0U6fnNBXl/YcXRT6KoGcYO8ZvBi1MvlHkh3cdon4
zWqZJljGfsphgrY2iQMP
=4dS6
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
