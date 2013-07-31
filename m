Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760184Ab3GaOIo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 10:08:44 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:30731 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759607Ab3GaOI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 10:08:26 -0400
Date: Wed, 31 Jul 2013 10:08:14 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [GIT PULL] (xen) stable/for-linus-3.11-rc3-tag
Message-ID: <20130731140814.GB23258@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus,

We are trying out a new git flow where both me and Stefano are going
to use one git tree. Not sure yet how we are going to figure out
the branch names (discussing that now) but in the meantime here is a
git pull from that tree and also using git request pull to construct
this writeup.

Thanks!

The following changes since commit 0b0c002c340e78173789f8afaa508070d838cf3d:

  xen/time: remove blocked time accounting from xen "clockchip" (2013-06-28 12:11:39 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git tags/stable/for-linus-3.11-rc3-tag

for you to fetch changes up to 741ddbcfd26f192b0677961385b599aa785f8119:

  xen/tmem: do not allow XEN_TMEM on ARM64 (2013-07-30 13:44:02 -0400)

----------------------------------------------------------------
Fixes:
 - Three fixes for ARM/ARM64 to either compile or not certain generic drivers
 - Fix for avoiding a potential deadlock when an user space event channel is destroyed.
 - Fix a workqueue resuming multiple times.

----------------------------------------------------------------
Aurelien Chartier (1):
      xenbus: frontend resume cleanup

David Vrabel (1):
      xen/evtchn: avoid a deadlock when unbinding an event channel

Julien Grall (2):
      xen/arm64: Don't compile cpu hotplug
      xen/arm: enable PV control for ARM

Stefano Stabellini (1):
      xen/tmem: do not allow XEN_TMEM on ARM64

 drivers/xen/Kconfig                        |  2 +-
 drivers/xen/Makefile                       |  5 ++---
 drivers/xen/evtchn.c                       | 21 ++-------------------
 drivers/xen/xenbus/xenbus_probe_frontend.c | 19 ++++++++++++++++---
 4 files changed, 21 insertions(+), 26 deletions(-)

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQEcBAEBAgAGBQJR+Ro5AAoJEFjIrFwIi8fJ0OMIALS5/fv7jaiQQBibLP6XeIFy
zrfv+XZoDfTu5htWjWOtC6Zdpy8ZahmFZl19K4/k8YxyzMAcVBSVIsCDbp+8ex6q
bGZ4vnZK+eT5bJRfupquGggJkSjIQPsanMrOeNtLJ5QDHVM8o9f92beGnvH+Vs6/
nnE9kFziHQBgOYQuPWWjHm2XS5BrEx6HpAJZ+M0Mioj2EI9Fzd0LzJjxyzajmqY3
a2zMC2nY83PdCm7cMD7P1YMWsVbnQP1EEQB6BsCK5QRohALNCvZ9VtyX/5lZS32X
Xadw5UXBnM1e68hfbNWhfrd5UzEhj10e7hTzzI6SNRkEEj+hjc2fy8v0OXPlnlM=
=3YQP
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
