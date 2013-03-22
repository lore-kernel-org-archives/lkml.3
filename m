Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423146Ab3CVVHJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 17:07:09 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:18443 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423027Ab3CVVHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 17:07:07 -0400
Date: Fri, 22 Mar 2013 17:02:01 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: [GIT PULL] (xen) stable/for-linus-3.9-rc3-tag
Message-ID: <20130322210201.GA7932@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus,

Please git pull the following tag:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-3.9-rc3-tag

which is full of fixes. The signed tag has the details (as always) but
this is mostly just the last stragglers of the regression bugs that this
merge window had. There are also two normal bug-fixes in the lot.

P.S.
We are working out the kinks in an early warning #linux-next testing framework
so that it can give us heads up in the future - so the when the next merge
window opens we shouldn't have surprises.

Please pull!

 arch/x86/include/asm/xen/hypercall.h |  4 +--
 arch/x86/xen/mmu.c                   |  3 +-
 drivers/xen/Kconfig                  |  2 +-
 drivers/xen/events.c                 | 10 +++---
 drivers/xen/fallback.c               |  3 +-
 drivers/xen/xen-acpi-processor.c     |  3 ++
 drivers/xen/xen-pciback/pci_stub.c   | 59 +++++++++++++++++++++++++++---------
 include/xen/interface/physdev.h      |  6 ++++
 8 files changed, 64 insertions(+), 26 deletions(-)

David Vrabel (1):
      xen/events: avoid race with raising an event in unmask_evtchn()

Jan Beulich (1):
      xen-pciback: notify hypervisor about devices intended to be assigned to guests

Konrad Rzeszutek Wilk (3):
      xen/acpi-processor: Don't dereference struct acpi_processor on all CPUs.
      xen/acpi-stub: Disable it b/c the acpi_processor_add is no longer called.
      xen/mmu: Move the setting of pvops.write_cr3 to later phase in bootup.


--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQEcBAEBAgAGBQJRTMbEAAoJEFjIrFwIi8fJjGoIAIxV1U/OobRSyJ1nj/PmpojG
c22cXFaK5OzAV7B/XYnABhFzay9q/Y86IazDFc22P+pDxXhhjLBVDso79mSW0Bj8
smFwh2a1zsIbUlORFz5b8KmM54r/WZ8BFEaeH67vnYDPndwgiZ/D1NH7wLR7Hlq3
agnpnJqq8MNgtrOMIEErbZC0k6BYri+pgVpLDT18DfqaCwWFHNYuy/yPS/m994Bs
iap9vi7bRLN87b7W3mafaQD9RosGSuIPceJx3N8YDdBuGn+OfC+OmkiAKsAiLJOr
jtoIjM9C6Fna/u3XNnWgkOpDSYOlSvUMzU6sOIju0YUhprmVJh+EnXNfuztI8Us=
=kQ66
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
