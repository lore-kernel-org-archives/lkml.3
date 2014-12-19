Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbaLSSLy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 13:11:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:37222 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbaLSSLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 13:11:52 -0500
Date: Fri, 19 Dec 2014 12:11:47 -0600
From: Tyler Hicks <tyhicks@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        ecryptfs@vger.kernel.org
Subject: [GIT PULL] eCryptfs fixes for 3.19-rc1
Message-ID: <20141219181146.GA6629@boyd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit c3351dfabf5c78fb5ddc79d0f7b65ebd9e441337:

  Merge branch 'for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending (2014-10-21 13:06:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tyhicks/ecryptfs.git tags/ecryptfs-3.19-rc1-fixes

for you to fetch changes up to 942080643bce061c3dd9d5718d3b745dcb39a8bc:

  eCryptfs: Remove buggy and unnecessary write in file name decode routine (2014-11-26 15:55:02 -0600)

----------------------------------------------------------------
Fixes for filename decryption and encrypted view plus a cleanup
- The filename decryption routines were, at times, writing a zero byte one
  character past the end of the filename buffer
- The encrypted view feature attempted, and failed, to roll its own form of
  enforcing a read-only mount instead of letting the VFS enforce it

----------------------------------------------------------------
Michael Halcrow (1):
      eCryptfs: Remove buggy and unnecessary write in file name decode routine

Tyler Hicks (2):
      eCryptfs: Force RO mount when encrypted view is enabled
      eCryptfs: Remove unnecessary casts when parsing packet lengths

 fs/ecryptfs/crypto.c   |  1 -
 fs/ecryptfs/file.c     | 12 ------------
 fs/ecryptfs/keystore.c |  6 +++---
 fs/ecryptfs/main.c     | 16 +++++++++++++---
 4 files changed, 16 insertions(+), 19 deletions(-)

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUlGpiAAoJENaSAD2qAscKClgQAJxnHZA3xDauy/bW9/vd9e9v
D4xaSkpufV3WfmbJGSgGIaF8Hm72Li5OUk5WJ2GiT3kPiWMTqRNvwWKuzYo2fkep
E3WUiPNPAzUgrmKcSEHF3oma8IEDOjyEl4uj4jrykXgn8lHu6sRPHY8ZGcUubEuT
WBczw4A7gsSzdpTmIm0uixck1UIhCVUYOam8lrjVuSI720qPDWoq7nJAsACFoE14
l/KEnv8S3Annsi2+rJRiC+AJd8sgbfHacU8EZohoLjoph1qW7jlFDdeqUPky7pc4
asK0IUuEkbdp5+sSaIoc3JC0iOBaE+/hSv2dzh+65XMw8D1MQmxGdJwu+jMawMBn
Whx1cAjhJozJyJVmjOPWlK7tFqsvDqJexYVsUP4xM3mAthy/eNnTRUW0JuO2+Eeu
X7NKV/7E+sSUCiesl0HkvXrjF5hquEUiMWxqaK/5iCfom/tfDLBrq0MImuVP0Flj
oc32jz0TlxhjT7B0H66Z/0sNkYyUeLYxHpGfeTaZ/P/PV7QYLZ1XD8sCjfYti387
25wIfvKbOpYARrq9XQ5oGqHD0dYrTXqUqIWykApvqQlMT4duNwSQB54CeesB8C4W
/LSKVL9WjDjJ+G35d1egDY4MOmKIOMaC6lsSWOYYeLhM/vacvdqT3C0uf8S34dPY
nTu5FV3yCDVjOjX4s+kZ
=bFse
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
