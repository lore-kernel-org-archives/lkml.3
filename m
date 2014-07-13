Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbaGMFDt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 01:03:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:47025 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbaGMFDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 01:03:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,652,1400050800"; 
   d="asc'?scan'208";a="561054964"
Date: Sun, 13 Jul 2014 10:30:39 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, dma <dmaengine@vger.kernel.org>
Subject: [PULL REQUEST] slave dmaenegine fixes
Message-ID: <20140713050039.GI2296@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QnBU6tTI9sljzm9u"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QnBU6tTI9sljzm9u
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Here is the fixes pull request for 3.16. We have two small fixes. First one=
 from
Daniel to handle 0-length packets for usb cppi dma. Second by Russell for
imx-sdam cyclic residue reporting

The following changes since commit 4c834452aad01531db949414f94f817a86348d59:
  Linus Torvalds (1):
        Linux 3.16-rc3

are available in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git fixes

Daniel Mack (1):
      dma: cppi41: handle 0-length packets

Russell King - ARM Linux (1):
      Update imx-sdma cyclic handling to report residue

 drivers/dma/cppi41.c        |   13 ++++++++++---
 drivers/dma/imx-sdma.c      |   22 ++++++++++++++++++----
 sound/soc/fsl/imx-pcm-dma.c |    1 -
 3 files changed, 28 insertions(+), 8 deletions(-)

--=20
Thanks
~Vinod

--QnBU6tTI9sljzm9u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJTwhJ3AAoJEHwUBw8lI4NHgIsP/jWdeVpEH7QUu7TcMghy3pQL
VyqL7kGAFTp56LzHYYH22embyB7JmkXEuu/WVOHOHKoIUCqwUKvjvhOWEck7dmbq
q7UNnV3N2JbGSxjjtSWI2+6zH8k1kzvZhfqvfdfjFMZeS59hY0VXeknzUQtkvkGK
ZzCFnxqM0cLtHqOoCpZJBURMmbIg/6MRwiJJOUHcMSgklEgeZ3m8i4EH3Ee5MLT5
l6I2FFoEYEP/9pR1GS09JXurd6Rzr4kMar0jl+lbH0MeAgmsQP0JbU80/3YlRZG7
WCjJtHDmULxPktKOX4wxvdksy9I3wtUruPpuaxKNo4r+sLInAXfA6aFZhA5BXyzd
5JZoyq0NFm0E/Aj7dy9Ohxvr+BTzSBa4hlxuiU9XMHKj+e4cibiDCHjF7KYyy60H
aSsoQbDQq4U/uE/ibLk1asS5afEGKPP7YYJxDRG79lPY17FSKDddV7Uej+1NT2F/
PgdtyHPqlszahZteT+ESbpRgchMTEOThPg4XqoFHGFQ3XLr/+VzVAtFdzzSRDWBa
TE258GlqzrpIwzGndq5Z94DGiuY61/dUljogCeBIKyvL5bM0fRgWQachallhpL4i
KiBLjksccQmwHhDpto1qgsguGGKWYR0AfO8SCHn1ZSU+K2juwQ1oshstax+PUhGP
ftibho0Z2loto6MXN3eH
=xbhb
-----END PGP SIGNATURE-----

--QnBU6tTI9sljzm9u--
