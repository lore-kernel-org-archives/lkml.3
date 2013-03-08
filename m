Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204Ab3CHMg2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 07:36:28 -0500
Received: from multi.imgtec.com ([194.200.65.239]:63760 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105Ab3CHMg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 07:36:27 -0500
Message-ID: <5139DB10.7080103@imgtec.com>
Date: Fri, 8 Mar 2013 12:35:28 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Paul Mundt <lethal@linux-sh.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James Hogan <james.hogan@imgtec.com>
Subject: [GIT PULL] metag fixes for v3.9-rc2
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig26E5E7C6A6C36D699705306C"
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_03_08_12_36_25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enig26E5E7C6A6C36D699705306C
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull these two minor arch/metag fixes for v3.9-rc2 (both minor
integration stuff missed in v3.9-rc1).

Thanks
James


The following changes since commit 6dbe51c251a327e012439c4772097a13df43c5=
b8:

  Linux 3.9-rc1 (2013-03-03 15:11:05 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jhogan/metag.git tags/met=
ag-for-v3.9-rc2

for you to fetch changes up to 40f09f3cd69a356b4245794e46439674336413fb:

  metag: Inhibit NUMA balancing. (2013-03-04 10:29:19 +0000)

----------------------------------------------------------------
A couple of fairly minor arch/metag integration fixes from v3.9-rc1:

 - remove SET_PERSONALITY(): use default definition like other arches
   now do.

 - inhibit NUMA balancing: like SH, NUMA is used for memories with
   different latencies. ARCH_WANT_VARIABLE_LOCALITY has been added for
   this purpose.

Signed-off-by: James Hogan <james.hogan@imgtec.com>

----------------------------------------------------------------
James Hogan (1):
      metag: remove SET_PERSONALITY()

Paul Mundt (1):
      metag: Inhibit NUMA balancing.

 arch/metag/include/asm/elf.h | 3 ---
 arch/metag/mm/Kconfig        | 1 +
 2 files changed, 1 insertion(+), 3 deletions(-)


--------------enig26E5E7C6A6C36D699705306C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJROdsgAAoJEKHZs+irPybfzPEQAJVP9vHJTeXwlwuQD2yM/fXj
uw7BD3unaM3AY9t/kDfLMwv14FLf3lXaTF32VRzqM9d65hY+JBsA048JnVH9g8yD
Do6dephrE5SfpyEJPTSYiBo1yODLZUTA/G7XBU5YSIK9MsgIuGi6oKFAR9gg+h8h
CaXhXoG6Kdf9Oc9mncAXAUus9he4RJzllEWiykAXz0inFN2dG9IWJY6AzMi7mHMU
mLfE3rMT68a9dY0MZmN93N2FTcxZlKAeOzCaZfa+fi5P9HN3grk/upeJgbX9oBW7
W3TFHod76LZfXs69zlWTLgxrWSYx2b+qL4SFvvTJQainiDr702x/tMnprCfsgAaU
rNSGOPHSA9rjK8MjtYTTMlssbFgBx9z8mKV3DsfqWSIWmVIml7UB1FApCJvA5Q2j
m990jMwMc7ESUEHJqNgsa8HB8Ftmsva3NoAy1+JwbCc/5LFj9VdZbhPQtbFpHjw2
QXWEK/vT2EyNTlVX9VpitssQBLE+DN8m8TmLsyyV1s4lFAWajbYryupeENoGJKof
e/H4CSxhqZNsyw34kglzeUIFZCCMO7nTrBFIIfL0MMerrHQsaek3NQ+u0VjGPk/y
psieQhbVUzTGA+20QyaRS6C8vkcjtrMorN3WPHd7F2NjSvr3TixPMUH2quZOVtqY
GIhMLv7dX3VLAYv74ZTj
=mQWH
-----END PGP SIGNATURE-----

--------------enig26E5E7C6A6C36D699705306C--

