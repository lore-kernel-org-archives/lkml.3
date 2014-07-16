Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaGPUTO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 16:19:14 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:17673 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbaGPUTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 16:19:12 -0400
Date: Wed, 16 Jul 2014 16:19:06 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: boris.ostrovsky@oracle.com, david.vrabel@citrix.com
Subject: [GIT PULL] (xen) stable/for-linus-3.16-rc5-tag
Message-ID: <20140716201906.GA14057@laptop.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Linus,

Please git pull the following tag:

 git pull git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git stable/=
for-linus-3.16-rc5-tag

which has two fixes found during migration of PV guests. David would be the
one doing this pull but he is on vacation. The signed tag has the summary.

Please pull!
=20
 drivers/xen/balloon.c | 12 +++++-------
 drivers/xen/manage.c  |  5 ++++-
 2 files changed, 9 insertions(+), 8 deletions(-)

David Vrabel (2):
      xen/manage: fix potential deadlock when resuming the console
      xen/balloon: set ballooned out pages as invalid in p2m


--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJTxt41AAoJEFjIrFwIi8fJHxYIAIke1WxZEheEeV6/6faNk5l3
WUUqvqMxh0jw30Bq0qjssBEoRQRqrbg3NTo0yobOtKsENQ1jLEWzzAb6i/sdnIZp
ZOp7BcvUDWxuUXonAXdgn+WmPkh8HFQ2DRkwXKK1r+pEhg/fk7Q/tXdTsRL7ZDil
aOQl6pF+qgR2kG/GOFDBEYiHaeo+9ryjW/ATV94QM7vLAOybB3dhS5CQnKQiNJGc
N5RVuYVGPVq/MCHhj5ACm8pgTWkNBsTaoQzwDKnhR0PB3ZOPxbZqerThHma2t1xB
xj3jWQKt+DTIXLtPIarI/oY6Qg60p2ItdavPxhX2mMsz/UFfOnQL2AljCnpOc8c=
=GABy
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--
