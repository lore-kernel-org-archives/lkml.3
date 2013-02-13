Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934297Ab3BMUub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 15:50:31 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:26680 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab3BMUu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 15:50:29 -0500
Date: Wed, 13 Feb 2013 15:50:26 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] (xen) bug-fixes for v3.8-rc7
Message-ID: <20130213205026.GA25290@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus,

Please git pull the following tag:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-3.8-rc7-tag

which has <signed tag>
Two fixes:
 - A simple bug-fix for redundant NULL check.
 - CVE-2013-0228/XSA-42: x86/xen: don't assume %ds is usable in xen_iret for 32-bit PVOPS.

</signed tag>

Please pull!

 arch/x86/xen/xen-asm_32.S | 14 +++++++-------
 drivers/xen/pcpu.c        |  3 +--
 2 files changed, 8 insertions(+), 9 deletions(-)

Cyril Roelandt (1):
      xen: remove redundant NULL check before unregister_and_remove_pcpu().

Jan Beulich (1):
      x86/xen: don't assume %ds is usable in xen_iret for 32-bit PVOPS.


--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQEcBAEBAgAGBQJRG/yNAAoJEFjIrFwIi8fJSXIH+gISTQPlMGEv1ocg0BryD4g0
DPcF2JdaopZn1dBXAB4kriYzsiVxVm4/k49PellvJXXqPcDyQ6ZhbvP+YDZt2LBl
kdhxBZLRrYN3vEv2BsrNtJ+ktFBazkfHuGR5JvxIpmx3Y9UEFZcnQayI72MT3YpV
ox4Yi+60g9TVSJFHuTk/MBqEL/+RdN+yYSLbr6gFEdnj9fwI+KlnPZhFUNMekcw1
oHMn2kYrW0HYC6/KmUjOYDFqE0sM2ePhGge4XlsRFA2JD8GvS+ohRpK8j5hM1wj0
BkX2VyTKt8juzcHim/7+liPuPoplUyTitSb38gGZDKJTySHPTnVQgCWJbS+Sd3c=
=iWZ1
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--
