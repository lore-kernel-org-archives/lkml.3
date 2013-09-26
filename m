Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750823Ab3IZNeE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 09:34:04 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:46700 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab3IZNeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 09:34:02 -0400
Message-ID: <524437BE.8040106@gmail.com>
Date: Thu, 26 Sep 2013 21:33:50 +0800
From: Lennox Wu <lennox.wu@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org
Subject: [git pull] Score: Fix compiling error and updatr thee information
 of maintainers
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="J7vtSFxkV30xoxPHw4i567qL7N2ROqqeK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--J7vtSFxkV30xoxPHw4i567qL7N2ROqqeK
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,
Please pull these updates for S+core architecture. These updates include
updating information of maintainers, fix some trivial errors, and add
a necessary function for supporting ipv6.

The following changes since commit 22356f447ceb8d97a4885792e7d9e4607f712e=
1b

mm: Place preemption point in do_mlockall() loop (2013-9-24 18:29:11 -070=
0)

are available in the git repository at:

https://github.com/sctscore/official-linux.git release-up-to-date

For you to fetch changes up to ed38665eb50ef7ad530f9b2db531a09b8520ed32

Score: Update the information of Score maintaners (2013-9-26 01:41:22 +08=
00)

Best,
Lennox Wu

-----------------------------------------------
Summary these commits:
1. Fix some trivial errors for successfully compiling the latest
version Linux kernel.
2. Provide necessary function for support IPV6.
3. Update the information of maintainers.

Signed-off-by: Lennox Wu <lennox.wu@gmail.com>

------------------------------------------------
 MAINTAINERS                       |    4 +-
 arch/score/Kconfig                |    4 ++
 arch/score/Makefile               |    4 +-
 arch/score/include/asm/checksum.h |   93 ++++++++++++++++++++-----------=
------
 arch/score/include/asm/io.h       |    1 -
 arch/score/include/asm/pgalloc.h  |    2 +-
 arch/score/kernel/entry.S         |    4 +-
 arch/score/kernel/process.c       |    4 +-
 8 files changed, 64 insertions(+), 52 deletions(-)



--J7vtSFxkV30xoxPHw4i567qL7N2ROqqeK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEVAwUBUkQ3whIBnItolwGVAQJ1zQgAjbZwQ7C3LeTtozvV8kcYTnaSIVh0CVwn
4InzV/Y0ulN4Hmp4OJtI7wcfQVT07Kb2aQWDAG1Y/SymG7It9CHHRlzAhxt1LvzN
7kgmUcVAMC9qHNo6l6jxCiW5kxIY2xgRdDSjASyibIJVlLHas5ZE93zCDz3lnKyF
iFKoh2dJJ920WHkxwoe0jVUkcXxs3QIpaVOOM9p9/MOZZLZUynsvlnK+V4qo1hVC
+Z4Bsq7Puyqwp9tnICpamc+4ixcQMj2WLN6sSasiA2jw2v3b17gnhflzxsmS6c7K
8QynRDo0dnQVcOMixJ8bnsKiY/5Y8Z7ozLarQ+DNd2Dfn6OHy9Ho8Q==
=PVv1
-----END PGP SIGNATURE-----

--J7vtSFxkV30xoxPHw4i567qL7N2ROqqeK--
