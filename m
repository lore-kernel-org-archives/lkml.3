Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821Ab3I3P1f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 11:27:35 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:37196 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797Ab3I3P1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 11:27:32 -0400
Message-ID: <5249985A.1030400@gmail.com>
Date: Mon, 30 Sep 2013 23:27:22 +0800
From: Lennox Wu <lennox.wu@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
CC: lennox.wu@gmail.com
Subject: [git pull] Score: Fix compiling errors and update the information
 of maintainers (Fixed format 2)
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="G4cSkbRovRWNSQvrp4pQPWlJ6kCB9a3lB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--G4cSkbRovRWNSQvrp4pQPWlJ6kCB9a3lB
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

git://github.com/sctscore/official-linux.git tags/for-linus-20130929

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

Signed-off-by: Lennox Wu <lennox.wu@gmail.com>

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


--G4cSkbRovRWNSQvrp4pQPWlJ6kCB9a3lB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEVAwUBUkmYXRIBnItolwGVAQLw8Qf+OTqOGeyorw2mm0HkFGaexoCkUxIIC0px
Gqh3+76wTZdX0BfYTIUOTThjlu9npDwsQSyMB3sbgYsQFQRSIgYgpTZqi//kWEEZ
ogMDqQb1h57Fgt6iddYtn64K9njGE5vy73HkpIxY+U7gldnrhaIwfE43ywUpDDoI
yhwJdeMNMU/qs4evLT2xLbLYDIV4p6gW+bEkWXjmQFTFgfT68aHNYJOwUQ677cWr
BGGECwAPjULpuR5ASDOLJEjPD55D7/A4T1fZ97eUhh36+IpekQs9TAYPZsViouOQ
QtFVpn+ve81Wb408igv1urAxRfF1B6saGWBeEfg77Dc/Ys+6AFpfgQ==
=QskS
-----END PGP SIGNATURE-----

--G4cSkbRovRWNSQvrp4pQPWlJ6kCB9a3lB--
