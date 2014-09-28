Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbaI1QDQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 12:03:16 -0400
Received: from mga03.intel.com ([134.134.136.65]:43221 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907AbaI1QDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 12:03:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,614,1406617200"; 
   d="asc'?scan'208";a="609910485"
Date: Sun, 28 Sep 2014 21:03:48 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, dma <dmaengine@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] slave dmaengine fixes
Message-ID: <20140928153347.GF1638@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="osDK9TLjxFScVI/L"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--osDK9TLjxFScVI/L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull to receive two small fixes for omap dmaengine driver which fixes
cyclic suspend and resume.

The following changes since commit 9e82bf014195d6f0054982c463575cdce24292be:
  Linus Torvalds (1):
        Linux 3.17-rc5

are available in the git repository at:

  git://git.infradead.org/users/vkoul/slave-dma.git fixes

Peter Ujfalusi (2):
      dmaengine: omap-dma: Add memory barrier to dma_resume path
      dmaengine: omap-dma: Restore the CLINK_CTRL in resume path

 drivers/dma/omap-dma.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

--=20
~Vinod

--osDK9TLjxFScVI/L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJUKCpbAAoJEHwUBw8lI4NHCzsP/jbl+CyhaHyEJjO9W1YRH74w
ELyCOc8aeJfRew45ZR7Wto7dFHlChxdXxFREyKbaYLmrnsGk7HfrYBSbsTSomaCX
fcilKgfph5ffPMfFSkGzlO4HkSTZ4Y3P1o0lqqxp6xKJIYPMGyEt0PAhxNl6yANM
cflNKyw7C3VNy36i2c2Jx7s9TtBGielFnPKzPnwx6Lqi2Gi4oRfsJh4vWwHjv4JV
s3td8l5qF20CKw8Z05Z9YG7S5YPTzQJK0rvNILRa0d3QOsgr6VJtUxl66MqXGVWG
Ncan0jfiMQawT7KjklGVpwvMUaTRJK42VaLp70NVkqYIEpZtD/I2WzoJlk4mLkdJ
g1Z1ncP63tmCrdmBelkxzb2+c7ZKpX7uNZeIR4Rx2tmRosmvQ29Rcj/iRcMACfQg
cYKW3uYYacYtT12QcpPUBGYpkGtVwcL96clj8ThtCCDQkLT41A5aKMfmhbKo5G2C
Ln6ZyxjmMkEJY7khyUUa5lmT4UeA4pWl5kZGAGnXoGWG4BHyNJRTJlRegf7Gufn0
yhB5k0pAySXi/bHPEh527Ho0ic9NR5xO8M8kT76n49DdbbMU7ki5TVPip/YMjvZw
OB6SIDhhY0RmqChprTZfzDr7t81hARCQMiVIfAD7sZ/v/AuJnuNsiMVWWIvNcao5
4eVOUmNF88Mrx5M8ibQp
=swK2
-----END PGP SIGNATURE-----

--osDK9TLjxFScVI/L--
