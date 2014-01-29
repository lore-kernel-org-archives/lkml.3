Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbaA2Xkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 18:40:32 -0500
Received: from ozlabs.org ([203.10.76.45]:50810 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924AbaA2Xka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 18:40:30 -0500
Date: Thu, 30 Jan 2014 10:40:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steven Miao <realmz6@gmail.com>, Mike Frysinger <vapier.adi@gmail.com>,
        Bob Liu <lliubbo@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: bad commits in the blackfin tree
Message-Id: <20140130104023.b176abc94ca4e79aeb3862cf@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__30_Jan_2014_10_40_23_+1100_N_8=TXWzF+zszJiT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__30_Jan_2014_10_40_23_+1100_N_8=TXWzF+zszJiT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Looking at the changes in the blackfin tree, I noticed that there are
several commits that are missing a Signed-off-by line from the
committer.  :-(

Also a couple of the commits subject lines are pretty useless (the have
the "From:" lines as the subject and their author's are wrong) ...

Please take more care.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__30_Jan_2014_10_40_23_+1100_N_8=TXWzF+zszJiT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS6ZFrAAoJEMDTa8Ir7ZwVNZEQAIJcDPe71mXsyMnzPyaQoPmu
JIpboZSW2qqtNMryH75BOtAGrh/+ZdeBuptkBqNbyBMqKc5VMkqReeIfSoRmhBe4
qvwc7IDpu0fw+jDyIr995C9htpv8+7GOs2kTFbrehfPz7IsDTQA7rwvRhujeOZDv
Y/RdA0fM1BawRjJDH8hHNBYTSXcgyPcoseh+zLLyeT5ZaUUgdaQVx1xNREi5tzmk
fRIdLwVxhSwk1alVt9VQiRZeBtO+cKgkK+BMw95AhGkwaLtpdxB8R1zH/GkT5WIF
pxjGB2KC3Pd9os57SlUCqzhyhsgSTsgfbfg0+p18WLaKkoTSsW/qswR8u3sQD8pT
yBAxv6odhgOHiN/Fm+zwB9N5QnGbmKbqjBPqoYSu8n1J9LKlQyobo4pn9jceVf4L
LVNj8aVr19U1XhEK2KU0D/vs5gys/vT6sVFAiumN28NPIyMcZCMy+tv8E7Wydf6f
9dT1J6DBSXTcnmsYVCoWuIp1PsHmHIZ6EzPJzEfX4rxE3QdOTgEBRqL/bEpwakvq
iu8K7ftNeQSYOBSU1Uiy6tdp3pFDJbrRUX32HH+0g7zMKVZV2T+To6DZ4Q/YCqiV
s6oZzV1Dyb97gYfo/kjx+7hTGeItA1kcQ7Fd7/IVEUy5LsWGaznrj5rUEN2NK9oD
eDXwTFwSI1ZlqJsfnUmI
=rGVC
-----END PGP SIGNATURE-----

--Signature=_Thu__30_Jan_2014_10_40_23_+1100_N_8=TXWzF+zszJiT--
