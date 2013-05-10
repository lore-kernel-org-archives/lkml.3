Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab3EJTL4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 15:11:56 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:21572 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089Ab3EJTLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 15:11:55 -0400
Date: Fri, 10 May 2013 15:11:47 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Subject: [GIT PULL] (xen) stable/for-linus-3.10-rc0-tag-two
Message-ID: <20130510191147.GA3367@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus

Please git pull the following tag:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-3.10-rc0-tag-two

which has bug-fixes, docs, and cleanups. I wish I could give you some exotic
comment to add in the merge commit, but alas the best I can do is:

<begin>
Fixes!!!
<end>

OK, that is pretty dull :-(

Please pull!

 arch/x86/pci/xen.c       |  5 ++---
 arch/x86/xen/enlighten.c | 50 +++++++++++++++++++++++++++++++++++++++++++++++-
 arch/x86/xen/spinlock.c  |  2 +-
 drivers/xen/Kconfig      |  2 +-
 drivers/xen/events.c     |  3 ++-
 5 files changed, 55 insertions(+), 7 deletions(-)

Arnd Bergmann (1):
      xen: SWIOTLB is only used on x86

Bjorn Helgaas (2):
      xen/pci: Use PCI_MSIX_TABLE_BIR, not PCI_MSIX_FLAGS_BIRMASK
      xen/pci: Used cached MSI-X capability offset

Julien Grall (1):
      xen: clear IRQ_NOAUTOEN and IRQ_NOREQUEST

Konrad Rzeszutek Wilk (5):
      xen/vcpu/pvhvm: Fix vcpu hotplugging hanging.
      xen/vcpu: Document the xen_vcpu_info and xen_vcpu
      xen/smp/pvhvm: Don't point per_cpu(xen_vpcu, 33 and larger) to shared_info
      xen/spinlock: Fix check from greater than to be also be greater or equal to.

Zhenzhong Duan (1):
      xen: mask x2APIC feature in PV


--ibTvN161/egqYuK8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQEcBAEBAgAGBQJRjUZuAAoJEFjIrFwIi8fJ+n8IAIaNf5vLi03lLk2mlbLe7Na4
0027521Om7ex9Qjw5W7Y7BSXR/cy/9bw0LyV3wn1iKXThxlCiX07pARvNrATxywj
wXu6qkue4Oyxe32Ghil2oRbyFuoky+/z3O3PlSWjlwpzHWh8r84ApWTGVcLiXUm7
lmp0Zj/Hc6Bp9oagaVKod6FhT/y0Uo8EJPTzso3wQ1K8NVA/wVNHcoPCxHMKYEdZ
DcIY10ehzZyu0UHSUHmJkHtAjkuLy3J3ejmzBodjg8worG8mwGaq2+KazM9oBNdm
7cB/N6iZ+wz1RIQlDTKF6t2IYmLPR10Cw7fpr8Y+aEC4M8p1IWHxbzSgwYnsZIA=
=WtmD
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
