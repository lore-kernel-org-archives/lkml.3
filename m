Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687AbaBNCmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 21:42:25 -0500
Received: from ozlabs.org ([203.10.76.45]:33090 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbaBNCmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 21:42:24 -0500
Date: Fri, 14 Feb 2014 13:42:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the mfd-lj tree
Message-Id: <20140214134217.aa7e1994b4cab7ee563c8307@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__14_Feb_2014_13_42_17_+1100_fXIOBl3zUsoz8i+L"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__14_Feb_2014_13_42_17_+1100_fXIOBl3zUsoz8i+L
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Lee,

After merging the mfd-lj tree, today's linux-next build (x86_64
allmodconfig) failed like this:

In file included from drivers/mfd/max665x.c:19:0:
include/linux/mfd/max665x-private.h:31:1: error: expected ';', identifier o=
r '(' before 'struct'
 struct max665x_dev {
 ^

Caused by commit e77bb5297293 ("mfd: max665x: Differentiate between
MAX665X devices").  Clearly never built by anyone :-(

I have used the mfd-lj tree from next-20140210 again for today (since the
other version had other problems).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__14_Feb_2014_13_42_17_+1100_fXIOBl3zUsoz8i+L
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS/YKNAAoJEMDTa8Ir7ZwVxmgP/A7QEEAcIiSSDFvxD3SHjDve
xM64gPzTH7jQ5l+9wmxfeSx9YVn51nm3ySF3K29elvPfGHHQC65kd2B2sYeayTq7
4cnWWLDuKmYkfFpCIWOUd+NGIaO7FkYReP5YnXwsJ/QdwnVU9q0jjfFfa3WoO6I0
Aq+N/LhMKMmYQEMuf/2/0p9qLJT3NU8sQn03bsRRctCWNCIU3+bDBzafjw+Eqo3f
il6NbnNDMHjcZwJ+guDWs3XvU/12N1eQMoHVEC3dgRuo1MAg5RGHt+IRP+4uQVUm
z5/63AuIWcCz00r8NEfnROMfmac4rrFvnZKIv4obsIsBCpOtP3q5VsxQCzFMwbf1
SVsgjcayEdJu4eVMdTykky7UyGHiPQ1r4LLihCK/6pr8vOpeuExHtQt/mMkWFhVn
4+emwB8qRzxp9jmWfraLkc3tl2u9iKNPiMZXT6YxCibN473wxMlXS+2XR6DVRne2
PAOlVvfNM771FR6uotO1DiafXPxgH89jHTzQ4/8e1k4+joy5N3/AVFeYMvIDRFqo
pGAo6S9y2GW0EFQIoUZDIj9OnkDkEG8ac86Ut7FetnmGNxU+DAS6y3CXIHPzdaS4
HFQCq/afyQ4kp8p7lePZUl1WMbxQuR1BsXK1k9TNYarLzTp4Aubfpkh5fLqdIj7F
wM+ROgx1xhzMK0XP7rnF
=9wxA
-----END PGP SIGNATURE-----

--Signature=_Fri__14_Feb_2014_13_42_17_+1100_fXIOBl3zUsoz8i+L--
