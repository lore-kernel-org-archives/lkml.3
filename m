Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbaGTLw0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 07:52:26 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbaGTLwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 07:52:17 -0400
Message-ID: <53CBAD68.8040504@nod.at>
Date: Sun, 20 Jul 2014 13:52:08 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PULL] UML fixes
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="UV1rdKwJaKx97B3NACALBi7FEmWdWcqeL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UV1rdKwJaKx97B3NACALBi7FEmWdWcqeL
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Linus,

The following changes since commit d057190925d994b808e1d07e6c76b90a32caac=
77:

  Merge branch 'locking-urgent-for-linus' of git://git.kernel.org/pub/scm=
/linux/kernel/git/tip/tip (2014-07-19 06:27:55 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rw/uml.git for-linus

for you to fetch changes up to bb6a1b2e189f797c0e4a116aec7ce77c344f11e0:

  um: segv: Save regs only in case of a kernel mode fault (2014-07-20 13:=
39:27 +0200)

----------------------------------------------------------------
Four fixes, all discovered by Trinity.
----------------------------------------------------------------
Richard Weinberger (4):
      Revert "um: Fix wait_stub_done() error handling"
      um: Ensure that a stub page cannot get unmapped
      um: Fix hung task in fix_range_common()
      um: segv: Save regs only in case of a kernel mode fault

 arch/um/kernel/tlb.c            | 9 ++++++++-
 arch/um/kernel/trap.c           | 2 +-
 arch/um/os-Linux/skas/process.c | 9 ++-------
 3 files changed, 11 insertions(+), 9 deletions(-)

Thanks,
//richard


--UV1rdKwJaKx97B3NACALBi7FEmWdWcqeL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTy61uAAoJEPmeIjfg4UaatjEP/1Wwtvhcv23OabCQydop9TwP
JmCVCQBNs4Z0ic5hKGCtZoPKP18nn5WUuF4vfCXjjpwoFS9YPq4WOiBdRG7a5tk2
6ZY1zYZ3jkNFhrL+B5AGtq1gZ8mJDcacM0HgMINuDUhmGjGREDKHxLI8gievAQJK
Q/CReyUaX268Xm0SdIe7iMONh7zgho/xsbHGJ5DI3BlaEp1FbEz1dfmCbgJ6I1nc
r90kCzh/bnwXKOSEpfiH5hTSKU3PBFFkXUQ1DWvC1rG7WcyoWHmjXk3CDHwN0uJH
RL1f1lpdTdWCdXLU1EpZhmPPhoXN0HHPMO7LPl9isuiNRiJATfOUZxK91SjDhpeG
658gC4u/2ghctlif29pYt64RIvXXUkaONFTBmXSGWnWIhVx5GqVRZ2U5ttOtLSCF
SqGpBCgAH2NhJJtJSYHA0Gs+alpNossVkS0APywSXU1FmLaeYOo2T+J+w4czO2xH
afPCPHhWt7Y/hz2XSUTqWzxzogyiskvVAuEL7CbbL2SCV3pkNJ1WpPJezZe3IIZG
lFFsTDP1SXMPx4L265yC5ZjxkS5sI1/TvFrqqrbA6Ss81oHxVun5VmklaAbdoZzc
I9daZPiPxD5m01hKlshiU/UA+9LT5eYSfe991amXoyNZkzCQ7svo8DW0watM9Ojc
nZdLvaXdEyaw8xkiBnIn
=7aWA
-----END PGP SIGNATURE-----

--UV1rdKwJaKx97B3NACALBi7FEmWdWcqeL--
