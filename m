Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab3C0TuS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 15:50:18 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:28220 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab3C0TuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 15:50:16 -0400
Date: Wed, 27 Mar 2013 15:50:08 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: [GIT PULL] (xen) stable/for-linus-3.9-rc4-tag
Message-ID: <20130327195008.GA8767@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus,

Please git pull the following tag:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-3.9-rc4-tag

which is full of fixes and has the proper fix that delayed the previous
git pull.

The signed tag has the details (as always) but this is mostly just the last
stragglers of the regression bugs that this merge window had. There are also
two bug-fixes: one that adds an extra layer of security, and a regression
fix for a change that was added in v3.7 (the v1 was faulty, the v2 works).

Please pull!

 arch/x86/include/asm/xen/hypercall.h |  4 +--
 arch/x86/xen/mmu.c                   |  3 +-
 drivers/xen/Kconfig                  |  2 +-
 drivers/xen/events.c                 | 20 +++++++++---
 drivers/xen/fallback.c               |  3 +-
 drivers/xen/xen-acpi-processor.c     |  3 ++
 drivers/xen/xen-pciback/pci_stub.c   | 59 +++++++++++++++++++++++++++---------
 include/xen/interface/physdev.h      |  6 ++++
 8 files changed, 74 insertions(+), 26 deletions(-)


David Vrabel (1):
      xen/events: avoid race with raising an event in unmask_evtchn()

Jan Beulich (1):
      xen-pciback: notify hypervisor about devices intended to be assigned to guests

Konrad Rzeszutek Wilk (2):
      xen/acpi-processor: Don't dereference struct acpi_processor on all CPUs.
      xen/acpi-stub: Disable it b/c the acpi_processor_add is no longer called.
      xen/mmu: Move the setting of pvops.write_cr3 to later phase in bootup.


--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQEcBAEBAgAGBQJRU01DAAoJEFjIrFwIi8fJ70wH/0vJu/SeuseKQutosGaAFkfz
GJ8C9HA55DkqcLVPv642dYyx/KCkc+lQdNLBz802PqNUOiwM5E1JWM7cWN8jlUQ8
FgazFlZU55ua13E81fXdWxapI8IS3qhlkC2DorTk/W/Qb7UGKQhwGfynAKkuASke
35Dg6lbA0n3/r61QC4puqCHg7yNn+5mL/3LDnkcYCferfQJggSLL6U9MTbsdY7E1
+3uizKUi50Qz/w9Zk6NeUsvl+cDXV6ZkSNXyvMNCKc75JNzM6ETnUik85n20/IjB
6w6y9YG+yYtgHxmInso/Iz99vrneMje9l0iV3aglHhUjotc6I52Nce7BiGwiTiw=
=PdmK
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
