Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569Ab3FZBEZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 21:04:25 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:50534 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab3FZBEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 21:04:24 -0400
Date: Wed, 26 Jun 2013 11:04:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the arm-mpidr tree with the arm tree
Message-Id: <20130626110411.d1fe3913769385fa056010be@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__26_Jun_2013_11_04_11_+1000_xngf7hcwsJidhfSO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__26_Jun_2013_11_04_11_+1000_xngf7hcwsJidhfSO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Lorenzo,

Today's linux-next merge of the arm-mpidr tree got a conflict in
arch/arm/kernel/suspend.c between commit 7604537bbb57 ("ARM: kernel:
implement stack pointer save array through MPIDR hashing") from the arm
tree and commit 3fed6a1e3bf0 ("ARM: kernel: implement stack pointer save
array through MPIDR hashing") from the arm-mpidr tree.

The former is just a rebase of the latter, so I used it.  It then turns
out that the arm-mpidr contains nothing that is not already included in
the arm tree, so is it needed any more i.e. is there further work coming?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__26_Jun_2013_11_04_11_+1000_xngf7hcwsJidhfSO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRyj4PAAoJEECxmPOUX5FEO4MP/2t5LMhib6XYVZl/RfM5uu9U
t/BNmECi9ON+wr991lTsyNHr4uey1jtSLuUSbIxYqVVeSzbbXaJnSeap0Qji3Bnr
96Oh+gnDoi8bWmh+OKJ83q1zqnQn8/Lt19YepKVpGcqzHJtoBB1RjzS2AVbXXew7
sN2oQ7dgZwSmCITRM53QbgTPJ6Cv0sx/UjK+YR1eu0Nnm4uSi8YfsFK3fAdM4Y/r
/fRoCkKaf89CI4OHx0WnJjN0R2lKOYhLfwividgWaNHCmJATsF0qJIpSBq3cA9cV
Szw28d5tcX2XNoYxJqx2jR/G5SRgLaqI9lonpToSpj0jCzRcuxvFpdL5NoJ/qZzR
j+4oGNJICzNCoZr/aVVKz8V98bf7uWcG0Psa2zPwaKjxdCslYmjN2JPSBCuZjwRk
sjOzjfecv+uJPA7wrXxJxfj2WsRFx1gvze+t1GwteBK+lNwaRV6Gs9I41EGuVH+t
/MsoSBFFDKfUVpQtHo1vhZDc5AwvIkFuHsQ6+NuXLTGcopgXr6V+XObUlmAGhoQj
MkeRQ/Zl0sqfY/OV/x+YGATqrvF4TH8YHxnMu5eqBe7jCKebkNt/qHufAbq+rVbk
RvRuw4EB2JEAiNiXZsUz67ZzZfiTLkiL0WYeLT9zzWel+mUR3yEPCLZxsSW80oeI
bxhbDs3FdbvTLhEMjtku
=SWmq
-----END PGP SIGNATURE-----

--Signature=_Wed__26_Jun_2013_11_04_11_+1000_xngf7hcwsJidhfSO--
