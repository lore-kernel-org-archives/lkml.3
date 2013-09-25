Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab3IYPQq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 11:16:46 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:20576 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756018Ab3IYPQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 11:16:45 -0400
Date: Wed, 25 Sep 2013 11:16:38 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: [GIT PULL] (xen) stable/for-linus-3.12-rc2-tag
Message-ID: <20130925151638.GA5856@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus,

Please git pull the following tag:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git stable/for-linus-3.12-rc2-tag

which has bug-fixes and one update to the kernel-paramters.txt documentation.
The signed tag says it all:
<signed tag>
Bug-fixes:
 - Fix PV spinlocks triggering jump_label code bug
 - Remove extraneous code in the tpm front driver
 - Fix ballooning out of pages when non-preemptible
 - Fix deadlock when using a 32-bit initial domain with large amount of memory.
 - Add xen_nopvpsin parameter to the documentation
</signed tag>

Please pull!

 Documentation/kernel-parameters.txt |  4 ++++
 arch/x86/include/asm/xen/page.h     | 31 ++++++++++++++++++++-----------
 arch/x86/xen/p2m.c                  | 10 ++++------
 arch/x86/xen/spinlock.c             | 26 ++++++++++++++++++++++++--
 drivers/char/tpm/xen-tpmfront.c     | 36 ------------------------------------
 drivers/xen/balloon.c               | 23 +++++++++++------------
 6 files changed, 63 insertions(+), 67 deletions(-)

David Vrabel (2):
      xen/balloon: don't alloc page while non-preemptible
      xen/p2m: check MFN is in range before using the m2p table

Jason Gunthorpe (2):
      tpm: xen-tpmfront: Fix default durations
      tpm: xen-tpmfront: Remove the locality sysfs attribute

Konrad Rzeszutek Wilk (2):
      xen: Do not enable spinlocks before jump_label_init() has executed
      xen/spinlock: Document the xen_nopvspin parameter.


--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQEcBAEBAgAGBQJSQv5QAAoJEFjIrFwIi8fJaGIH/jbvpJTR5Ayr6v9vNGkqiGI7
6/684M2fZ0fInoex1UwhJynQWCYbS898DnLVuTwjUQSdhTVkOeiQphjata0VdniW
Q5DHqiYKw0OSBG9V4/5WrPO0Qno250sooqrhsqnPu8J9kARJgIgxUxqOXJGVOv69
8oftq2GPTyvPzMX11YS3SzfGfSFk+WmbRt7Rv8n0COHPrINkeryhkaG+cAEhitBX
X2zovzfwyyEpt2jEb/82XHogFDSDabe5uqIQObWMn2Dvz66RpQAzBKdx9cSeJZd1
tSaN3ftAaFvVjj4xiMUAWEXYkqX6t1LiUWXfeTI/V35TBIljr+OM0ASjAdeIREs=
=KlDO
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--
