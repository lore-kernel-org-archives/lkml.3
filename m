Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312Ab3BFRQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 12:16:27 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:24880 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773Ab3BFRQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 12:16:24 -0500
Date: Wed, 6 Feb 2013 12:16:15 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xen.org
Subject: [GIT PULL] (xen) stable/for-linus-3.8-rc6-tag
Message-ID: <20130206171615.GG24458@konrad-lan.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus,

Please git pull the following tag:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-3.8-rc6-tag

Which has two fixes. One is a security fix wherein we would spam the kernel
printk buffer if one of the guests was misbehaving. The other is much tamer
and it was us only checking for one type of error from the IRQ subsystem (when
allocating new IRQs) instead of for all of them.

Please pull!

 drivers/xen/events.c                  |  4 ++--
 drivers/xen/xen-pciback/pciback_ops.c | 14 +++++++-------
 2 files changed, 9 insertions(+), 9 deletions(-)

Jan Beulich (1):
      xen-pciback: rate limit error messages from xen_pcibk_enable_msi{,x}()

Wei Liu (1):
      xen: fix error handling path if xen_allocate_irq_dynamic fails


--DocE+STaALJfprDB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAEBAgAGBQJREo/bAAoJEFjIrFwIi8fJ8dkIAKpkiFYvHiqWLoVKstgcyd86
qkJ7ULG2Ltw+04evQ5ldEvk+Enq7yLeur8gx+M1n86b+Dit6RZP31FMmWQkzJ1kF
isXMTbW2plvsYMhP6E3+CRDou+PhU+a6Q3uhLRedc7TtlnAsvIeAW0C9+THWxMop
Az4HvrNCcfPY3KuE15mEU3jZ5DdQQfWgXCLKL7e4rcC2Fig1b8eAXcWWHrihhmtI
b4F0WPJpJd4JfEuq6zAzcramPaYUh1q3NnpZEpaJa2aze9Hux5ccF1I0JE1kHpIM
y8ztpXL96UzqQJSMNZ6aRwCjcMkpf43N6HpQpSwVYkd2vLUm3fHPiBS5B+8UR6M=
=JnhC
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
