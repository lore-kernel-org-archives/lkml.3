Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562Ab3FTTVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 15:21:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50997 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758535Ab3FTTVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 15:21:04 -0400
Date: Thu, 20 Jun 2013 12:21:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.83
Message-ID: <20130620192102.GA336@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.0.83 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                              |    2 +-
 arch/x86/kernel/relocate_kernel_64.S  |    2 +-
 drivers/gpu/drm/i915/intel_sdvo.c     |   10 ++++++----
 drivers/net/wireless/ath/ath9k/init.c |    3 +--
 drivers/net/wireless/b43/main.c       |    2 +-
 fs/ceph/super.c                       |    7 ++++++-
 fs/ceph/super.h                       |    2 +-
 include/linux/swapops.h               |    3 +++
 mm/hugetlb.c                          |    2 +-
 mm/migrate.c                          |   23 ++++++++++++++++++-----
 mm/swap_state.c                       |   18 +++++++++++++++++-
 11 files changed, 56 insertions(+), 18 deletions(-)

Daniel Vetter (1):
      drm/i915: prefer VBT modes for SVDO-LVDS over EDID

Greg Kroah-Hartman (1):
      Linux 3.0.83

Kees Cook (2):
      b43: stop format string leaking into error msgs
      x86: Fix typo in kexec register clearing

Naoya Horiguchi (1):
      mm: migration: add migrate_entry_wait_huge()

Rafael Aquini (1):
      swap: avoid read_swap_cache_async() race to deadlock while waiting on discard I/O completion

Sage Weil (1):
      ceph: fix statvfs fr_size

Sujith Manoharan (1):
      ath9k: Disable PowerSave by default


--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRw1YeAAoJEDjbvchgkmk+EHcP/1DKe1TkMkbqAcWDqMlC2IyQ
zgJbgCoW+TbWdTl2xJkw/O0KSfRDyF7neuxhEq2z8DMbHwZF+vC1oPZD5R1VwZcy
dX8qYThFUfUjvO32uwfAKf/5byvnC/jSmEanqT+3q2k8nO4gKRZB6gtz8AJvosxP
JhAdGHE9RMwNJvPi6ede9DC9yRF8tjQUraBcptzAtCBKdVe/CXSL1Vo1LAxZYQOu
hM9PsexKqeqUUFBg0mX6yrPyEYo7zg9YeGf2InQMwAI5Axdxt/xwJAmaMLUEDTau
rweINnWz7cZxJpW68uI4yo14p1rROwjh4pJxM8Onqe5zBAUCWRCfGyT9DOB3O4Hc
q5L5jyQCRgEcQs7AfEwFxPr603SfdMLQc7qGk0EdjB5z4PW++jNUmkq8qrKAp8fj
n3HiBl2X4mFRT8vfE3Nh1M93l+JZPWBD+Yl2wbat9ioQmySIfwhblu3j+s2/KEMO
uBXIOf/JQl2xoEIQZJglxoXlplUMpLoFt2c/pu0zSrAlEFL4k+MAmj2ab9sD9q0U
qFHLyVqNL94/U80tp0gKVS/JR2lV4qwERFykQ4524+EGOttPiBz6S9PbjemknJwx
s1qHDVtjh6mg0GHtRzGKOy3dH1zcV13KGRjzD84TX/aP/Xpj+AIj8O670CStoR8l
yoetfBI0KdBemmTKRFyI
=JhIR
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
