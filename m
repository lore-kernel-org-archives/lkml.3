Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758387Ab3D2Nk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 09:40:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10498 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757413Ab3D2NkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 09:40:17 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=3MEIRCKq8PkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=IneQv0fk5xMA:10 a=VwQbUJbxAAAA:8 a=sQ-ECH3usI2sYILb3zgA:9 a=QEXdDO2ut3YA:10 a=zPYlkWuv83c_oFrUe6MA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130429133939.352003598@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 29 Apr 2013 09:39:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 0/2] [GIT PULL] ktest: Updates for v3.10
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Linus,

A couple of fixes to handle a config file that tests multiple machines
and has conflicts it the grub menus. That is, if the machines use
the same grub menu name, but they are at different locations in the
menu.lst file.

Please pull the latest ktest-v3.10 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-ktest.git
ktest-v3.10

Head SHA1: 66566ce651763c542ef4e420335148ebe9dbc082


Steven Rostedt (Red Hat) (2):
      ktest: Allow tests to use different GRUB_MENUs
      ktest: Reset grub menu cache with different machines

----
 tools/testing/ktest/ktest.pl |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRfng9AAoJEOdOSU1xswtMMg4H/2xOwTQgPDHqUQkvrmbAZ1+6
Da1hvUhhsO351QeIM5AMlXQi7AZD52DWPhA2ZL4+8Vs3aOal/NCXXS312cpZZA/1
VCTt02FRYHM+8hsROAI2YrN4DnC3TwP5+vpmw6BKsR0s6bzcOz+YGf6u995ZmBGi
RTfnv4Nvzm6fdyV32DERBIBk79XqhbHhBj/fUe1Z2FlWPritYLdRnkrUzWca3i6k
Mp+8zrHsm29davHa0KEeG84aXm5u23q7/gTJU6hSsouWdg/tIBbW0FLXDjVCsjF7
1k3nu1S6mi4YSolv2rjL0TgVyUe2AL7KeN25mQQ2HqFBmVwuoGAutnl1RjxTAbU=
=cnCm
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
