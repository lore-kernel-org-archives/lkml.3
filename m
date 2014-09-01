Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbaIAXHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 19:07:39 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45437 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbaIAXHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 19:07:37 -0400
Date: Tue, 2 Sep 2014 00:07:28 +0100
From: Mark Brown <broonie@kernel.org>
To: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140901230728.GM29327@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ura8jf0QYTXVPAoa"
Content-Disposition: inline
X-Cookie: Simulated picture.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: linux-next: Tree for Sep 1
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ura8jf0QYTXVPAoa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Changes since 20140829:

The akpm-current gained a conflict against Linus' tree.

Non-merge commits (relative to Linus' tree): 2553
 2686 files changed, 98625 insertions(+), 79475 deletions(-)

I have created today's linux-next tree at
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git .
If you are tracking the linux-next tree using git, you should not use
"git pull" to do so as that will try to merge the new linux-next release
with the old one.  You should use "git fetch" and checkout or reset to
the new master.

You can see which trees have been included by looking in the Next/Trees
file in the source.  There are also quilt-import.log and merge.log files
in the Next directory.  Between each merge, the tree was built with an
allmodconfig for x86_64 and a multi_v7_defconfig for arm.

Below is a summary of the state of the merge.

I am currently merging 214 trees (counting Linus' and 30 trees of patches
pending for Linus' tree).

Stats about the size of the tree over time can be seen at
http://neuling.org/linux-next-size.html .

Status of Stephen's local build tests will be at
http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
advice about cross compilers/configs that work, we are always open to add
more builds.

--ura8jf0QYTXVPAoa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIbBAEBAgAGBQJUBPwtAAoJELSic+t+oim9NHAP9jegzsmmNFcyWEeqZprh1xML
IyyrelCCMQgfZ3v5N4BuxVBwW8VZuRWIoM7ecxdzmlrHxBmVxiSyZKY563cph7xt
b4YGB+jijGzYmpj1RaX9HAdzwbqxiSo9U8eOl617MF86xP+Q3UTDySP2EhuwImK9
s30YY4Gj501v+7ns3d3F2sMQb2LjEfU0awNblyPNRFzcrQYfUmoDkQaTOv+4wXEP
+CMqepy+U7rAZlDTAuGri348B0TEhUWum1859bsFGa3dVYV2fB2vpBIeA8GTSkWN
OOFIvLgu5mNA4kkrzfzVjjsBC15RR5A+kn091QSFiY4T02bR85s/qC6TN3qKzfyg
Rt+WOLEIF6gHlYlosI8qOvna5dWJq+HqhNQwV+ATD35SXii4ne7ogx3FqSmpbVYB
sXvz/Z5FdldW0kCxLt+vYwn4MhrhclpKv2tVbrTyLJlvc2nmzJlfjMCYs56qZrTQ
Pq0AE4juymkvMos4zkwwb1kftmW0Ddl0oRBofViXA7jHrlQy6/QNTFzWNmOrKo+Y
yuplU56S+QXDStvdCqXpK3sSOhvKLV5lo+8hkLdXLhrY/f17FRs/H7DeC3TRp5Dd
aAAtUqoSF7SDYwbn3ImpodV5lTCLDpXkFGXWr+mNLkNUKrJpvKvtRZlXKQoslPeR
jhMY73cBJVjTMQQ5Jb4=
=WBmw
-----END PGP SIGNATURE-----

--ura8jf0QYTXVPAoa--
