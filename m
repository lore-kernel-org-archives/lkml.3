Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbaJFSco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 14:32:44 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:36009 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbaJFScn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 14:32:43 -0400
Message-ID: <5432E03E.8000304@gmail.com>
Date: Tue, 07 Oct 2014 02:32:30 +0800
From: Lennox Wu <lennox.wu@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: [GIT PULL] S+core : Patches for building allmodconfig and for removing
 useless flags (Resend/with a signed tag)
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="sIPuhSrEFmXHDT6g31KEssOWsK5cpMQ7Q"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--sIPuhSrEFmXHDT6g31KEssOWsK5cpMQ7Q
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Please pull these updates for S+core architecture.
Three of the patches are for building allmodconfig, and the others are
for removing useless flags. Thanks.

P.S. Sorry for the previous version without a signature.

The following changes since commit 58586869599f6bb38aeca71a847cd77bfea748=
08:

  Merge tag 'pm+acpi-3.17-final' of
git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
(2014-10-02 18:47:28 -0700)

are available in the git repository at:


  git://github.com/sctscore/linux-off.git tags/for-linus-20141006

for you to fetch changes up to 1742b630e43a6ccca67cf634704e8b76d128947f:

  score: Remove GENERIC_HAS_IOMAP (2014-10-05 04:38:08 +0800)

----------------------------------------------------------------
PULL Request issued on 2014/10/6
Signed by Lennox Wu.

----------------------------------------------------------------
Chen Gang (3):
      arch: score: Export necessary symbols in related files
      arch/score/mm/cache.c: Export 'flush_icache_range'
      arch/score/include/asm/Kbuild: Add generic "serial.h"

Michael Opdenacker (1):
      score: remove deprecated IRQF_DISABLED

Richard Weinberger (1):
      score: Remove GENERIC_HAS_IOMAP

 arch/score/Kconfig             | 3 ---
 arch/score/include/asm/Kbuild  | 1 +
 arch/score/kernel/time.c       | 2 +-
 arch/score/lib/checksum_copy.c | 1 +
 arch/score/mm/cache.c          | 2 ++
 5 files changed, 5 insertions(+), 4 deletions(-)



--sIPuhSrEFmXHDT6g31KEssOWsK5cpMQ7Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJUMuBEAAoJEN984+whgMZczhEP/2FE/BwB25eEWE6F9686tSVS
McH9dgWyvIUNfZPk8RAjwBOj2429Ziyd/pNLWAc5VxO7j9HSJw1lpDWiTSryIrDa
YjLoCJzpRxyXx74POCFhi2YNOi4YyrqT5e7/UWIeA3YRd3hrcY7GyHpPRyio4dbq
1ImFpKuCBw757rRMomOA96FruAyNXtB5px8gzYqQhzD9oP2lj9Fb6FchvGQQaOi2
ono3NcwuLMgKJhNJFetOeIPWKRuAKnYo0m9T61rOUiVo59T0kff6Q1gNBze2dRTF
4MvPw3Xakl2Fxw7C+KbOTvPs0R1WFOvZXLsycKuW5oKaom593xfJQdqoLZCQGTYJ
XACheOiDU/yOGJGqMMQ9WXlr84j0d4UAwjRff8ULrfSCE2zeVplxf27u/foDopmV
19NSk2Yi0fwq4QHF0Uk1i9EhEkDyfn44GO/KidK5B9uHZgend2H7tHLi365+wx/l
cTMZm8L+RAQlIFtorJIbekmRt9Q7tYNOILuSImPJk9693w9EaY8vQkobAY8wzjAy
ty09B4IsAD/ZYxy1YaN1LggQLM5oTZ+Ce8tt9it3qYIeoGj5dwLPiq1dh/Za9DLQ
+DV42TdYi17cyZyJK+R3A6aJ+q2NnxPX1n4240JXdJSlQzG8f9PSe3VEMen2pD4o
Vptpvgd09n6pT1GPHDOp
=xlwo
-----END PGP SIGNATURE-----

--sIPuhSrEFmXHDT6g31KEssOWsK5cpMQ7Q--
