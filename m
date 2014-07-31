Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbaGaW4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 18:56:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52785 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaGaW4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 18:56:40 -0400
Date: Thu, 31 Jul 2014 15:56:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.101
Message-ID: <20140731225612.GA24429@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.4.101 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.4.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                   |    4 +++-
 arch/s390/kernel/ptrace.c  |    9 +++++++--
 arch/x86/kernel/entry_32.S |    9 +++++----
 block/blk-tag.c            |   33 +++++++--------------------------
 drivers/ata/ahci.c         |    1 +
 drivers/ata/libata-core.c  |   12 ++++++++++--
 fs/ceph/snap.c             |    2 +-
 include/drm/drm_mem_util.h |    4 ++--
 include/linux/kernel.h     |    1 +
 include/linux/libata.h     |    1 +
 include/linux/slab.h       |    2 +-
 mm/hugetlb.c               |    1 +
 mm/kmemleak.c              |    4 +++-
 mm/vmalloc.c               |   14 ++++++++++----
 14 files changed, 53 insertions(+), 44 deletions(-)

Catalin Marinas (1):
      mm: kmemleak: avoid false negatives on vmalloc'ed objects

Christoph Hellwig (1):
      block: don't assume last put of shared tags is for the host

Greg Kroah-Hartman (1):
      Linux 3.4.101

Kevin Hao (1):
      libata: support the ata host which implements a queue depth less than 32

Linus Torvalds (1):
      Fix gcc-4.9.0 miscompilation of load_balance() in scheduler

Martin Schwidefsky (1):
      s390/ptrace: fix PSW mask check

Naoya Horiguchi (1):
      mm: hugetlb: fix copy_hugetlb_page_range()

Romain Degez (1):
      ahci: add support for the Promise FastTrak TX8660 SATA HBA (ahci mode)

Sven Wegener (1):
      x86_32, entry: Store badsys error code in %eax

Tejun Heo (1):
      libata: introduce ata_host->n_tags to avoid oops on SAS controllers

Xi Wang (1):
      introduce SIZE_MAX


--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT2smLAAoJEDjbvchgkmk+OH8QAKGATV2um1qcyLyl09GaCrcO
SwtbpKnWBg0ei/MPJREmKRRgmdl5aQPJU3yYedE/I7A51EZgnFNuCJWEw2Xheahh
koCLuildRlNGLSfdgHD3hkYlX7qosfFQrXS9zl38YJi2tw1zK00dCQMYgXnf+Lh1
lvZCbpgJ8yskd84Osz+E8tnlwXgCLem/JrtrkOfCEZp52GBwMHtxvrN082SRjKG1
C0ZmE9LV3+0DRA0JblNhQv20TV7HEnVM/9p0mMPouDhddIVWsSDwuWSQDk7vLStV
zjP+kVnlUkZqDxU2QzVbZvKHk2fDroSTwTtV7sM3ZCKZy9oIYgYX0ENKBMdesGOQ
vIdAtioZpMxVrcVSxMLJr4pw6FfD1Gwe9TuQQ3O23bXvu3Aftg1X1ygUTiSKqwWc
yDnS2sBbg8krIxP+M33KwZUMynYSKEWYbGn+SYxyrwhjhmdJY6zjySVV6MyWMuQE
EoQw1lb8hejsL+KJbvlJvXPaZG/qprqhNpae7hmgNof/pja0gcBY7i+yYIYGtfBJ
bMUwJvkxNE1tXfbpDaHo5iTwgYLgK4AgM8hI94oq2QuRanOQ2vlWlz8Xhn1rso4Q
9amd31V46tF4gAgAf68ioGB27Np9nZtO8SyLb2TpTXmlCpB6zfF7RyiasmwGaRGv
F7clAzRvScUmxQzaE42/
=sXmb
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
