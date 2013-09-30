Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835Ab3I3OqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 10:46:09 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:54587 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080Ab3I3OqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 10:46:06 -0400
Message-ID: <52498EA2.2080207@gmail.com>
Date: Mon, 30 Sep 2013 22:45:54 +0800
From: Lennox Wu <lennox.wu@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: [git pull] Score: Fix compiling errors and update the information
 of maintainers (Fixed format)
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="N2SgWIUbJ1IkpxcRIFQeosr47REIF6E9u"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--N2SgWIUbJ1IkpxcRIFQeosr47REIF6E9u
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,
Please pull these updates for S+core architecture. These updates include
updating information of maintainers, fix some trivial errors, and add
a necessary function for supporting ipv6. We fix the format of the link
and use a tag.

The following changes since commit 22356f447ceb8d97a4885792e7d9e4607f712e=
1b

mm: Place preemption point in do_mlockall() loop (2013-9-24 18:29:11 -070=
0)

are available in the git repository at:

git://github.com/sctscore/official-linux.git
<https://github.com/sctscore/official-linux.git>tags/for-linus-20130929

For you to fetch changes up to ed38665eb50ef7ad530f9b2db531a09b8520ed32

Score: Update the information of Score maintaners (2013-9-26 01:41:22 +08=
00)


Thanks for your patience.

Best,
Lennox Wu

-----------------------------------------------
Summary these commits:
1. Fix some trivial errors for successfully compiling the latest
version Linux kernel.
2. Provide necessary function for support IPV6.
3. Update the information of maintainers.

Signed-off-by: Lennox Wu <lennox.wu@gmail.com <mailto:lennox.wu@gmail.com=
>>

------------------------------------------------
 MAINTAINERS                       |    4 +-
 arch/score/Kconfig                |    4 ++
 arch/score/Makefile               |    4 +-
 arch/score/include/asm/checksum.h |   93
++++++++++++++++++++-----------------
 arch/score/include/asm/io.h       |    1 -
 arch/score/include/asm/pgalloc.h  |    2 +-
 arch/score/kernel/entry.S         |    4 +-
 arch/score/kernel/process.c       |    4 +-
 8 files changed, 64 insertions(+), 52 deletions(-)


--N2SgWIUbJ1IkpxcRIFQeosr47REIF6E9u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEVAwUBUkmOpxIBnItolwGVAQJoiAf/WFLad305mAZZddldQ9ITc2nlqsuKT0zK
yc6E5hshZUXqU2hA8GR6UF30DxU23C+KJ+R39ayF3iHKc/b7ca8xIpImeR/HpGTe
93MqFJYmGwuDN8bp4nSlg7tBooN/b97GMSxi/qHXQzLGrINsrZMbpig0eFaw/sSF
+g3Kocp6E6DDfZ+j2wVEuSrjEabx4blN3LImU7NIgv2K+bc3giXHeTzT7jWzRxXP
wXKDol7BKLGH1Jv/eUwRIgf4LM8fEEAzZCgyQJsm4W//tV8c5j3tCmurUxlNofPb
jNhpFmcdLTOX2YozOuktb/4ziEncvOmNizfANav9433/lP/FzoOcnw==
=vYuT
-----END PGP SIGNATURE-----

--N2SgWIUbJ1IkpxcRIFQeosr47REIF6E9u--
