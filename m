Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934545AbaDJBfp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 21:35:45 -0400
Received: from ozlabs.org ([103.22.144.67]:56130 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932996AbaDJBfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 21:35:43 -0400
Date: Thu, 10 Apr 2014 11:35:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: linux-next: build failure after merge of the arm tree
Message-Id: <20140410113533.97a55fed92809a6cff6c5b20@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__10_Apr_2014_11_35_33_+1000_2nd7VFDb1ewazTpX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__10_Apr_2014_11_35_33_+1000_2nd7VFDb1ewazTpX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Russell,

After merging the arm tree, today's linux-next build (arm
multi_v7_defconfig) failed like this:

arch/arm/kernel/iwmmxt.S: Assembler messages:
arch/arm/kernel/iwmmxt.S:68: Error: bad instruction `inc_preempt_count r10,=
r3'
arch/arm/kernel/iwmmxt.S:176: Error: bad instruction `dec_preempt_count r10=
,r3'

Caused by commit c9133fdf69c4 ("ARM: 8019/1: Disable preemption in
iwmmxt_task_enable()").

I have used the arm tree from next-20140409 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__10_Apr_2014_11_35_33_+1000_2nd7VFDb1ewazTpX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTRfVtAAoJEMDTa8Ir7ZwVCAUP/j9/wSqAmMqtkTKSw28YSVZR
g6EFjD7AiapG7M1/+SjjY/wTgVqy3HOYOmGpce8iLEXmEwQnveNYiUJqotWjI/29
7gy1KDkoRMoUafIGebXvo2tTlXfLHUYchZFBZT/wRVN9bezb56U6bnXC9w80reUi
UZEVzn+qAwMTTOmU3S5gQTpjACNZceyO6QWmsJ/CkR6xvD3CtdGEV6jRQuKzGC3G
pIWVWhJvT9GUSPQlB1e7lk5X+Lzusr/J9QjkaWPPOTnaiCHgIgNQSBGEpgDlCSVZ
PMQZWc+wFuFZOTi5zzOtwnxaBaNFi5XEjan23Pl7CUdYVJJ2xrzodiHp2h44Mlxo
uUxbYOaH8PBnAOPKeNdb4iaunjBJ+NOR9L/sD/jK7C/WOMMp22FisqQ2r4ix44PN
4MEwJtEqX7mPWunrEDcB5n3Kbf1+Mqy3eef09LOK08i1EhO4iQtjz3zDkd6GjAY0
6lejLaNdrKRHa1rzFJ82ReB8Dm7qZQzj+pKgE6pg+LlEqcdDlN9kYkyE7uGfbedn
phehCNQO5EWyd/CGbBJdgpwP7LmICvjOBZHgGeDtC5qiOTIk1kyinhfPV4Fbgp+C
G7aG1U2U4F8HN2d76KGQko/qQFN9EQkfC7w9NgYNYDwbsIrftht2HdDRmeo9G/tu
6keqSkgeXobZ2kNVtlBW
=0tUV
-----END PGP SIGNATURE-----

--Signature=_Thu__10_Apr_2014_11_35_33_+1000_2nd7VFDb1ewazTpX--
