Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988Ab3EFA30 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 20:29:26 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44181 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab3EFA3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 20:29:25 -0400
Date: Mon, 6 May 2013 10:29:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Crispin <blogic@openwrt.org>
Subject: linux-next: the mips tree is screwed up again
Message-Id: <20130506102914.54b5d59b086e19223d5ba1e1@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__6_May_2013_10_29_14_+1000_Yu9ykdA+SX3yw5GV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__6_May_2013_10_29_14_+1000_Yu9ykdA+SX3yw5GV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ralf,

It looks like John Crispin has cherry-picked or rebased part of Linus'
tree into his branch that you have now merged.

Guys, don't rebase your trees - especially this late and especially after
they have been merged into a published tree.

I will use the mips tree from Friday.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__6_May_2013_10_29_14_+1000_Yu9ykdA+SX3yw5GV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRhvlaAAoJEECxmPOUX5FEhJ8QAKJibL9l4kcfPTKqPOa1ZiL7
PpDPlHvj7oZ9GXJuGBFRx7M09Fsrk96LMTx4YpAF7DgHfpEsTldqwNHheX6MQmFO
iuKvI1t29djtf01qULGvoVybl0s2KjIE+Yul6TO17m4xw5r9Mn+EjHD3GQ07WyaW
xYmR/YNZQiCJWthyqZR7Xtblot7NN8VzjMkONIxbeq0CHg7f8/vourVXZO2yxuNx
PdY0zIjxII/Ax0fJxFs97SLQ0+fPDzml+EJx0KEoNo6/K/QXdEwgBmTvE/3NtUuy
KvblhFnWx1b9+32qVRffPC4jTQR5540jG5hvwXyU1sI0NXJVPrvY/t0hxS9Fa6mu
vf6p9qFhzcSIbJYrrNIFt33hSyAvlMIibsU/l9AHyWYGfcGvIrAyTyXvhwwaM37e
bWOKxzQBVOHjhAtnIqDk5w1G/XBiI2WNPFALLnxy1ysTGBRRChTi6HEolrfyZO3E
E991byMQd9z/+P4lSaC/GzOwTBeaJJLrzgzWCnHUrmoYvcG+hyWVHokKy3lLZGpL
PCkg9pZ4pI5A/vLsoR4ki/jwB5HsywpikzHrR/W8LBjh+D97YEj2ALOsZPf+7egv
RwJkEDslFmYLkO3YLzXlq/8ZK8ozRgl1+7viSCYFBmCeDv4peTlbC3P/UxNJCQYK
2stYkDn1UbAeOH8FrBbq
=zBtM
-----END PGP SIGNATURE-----

--Signature=_Mon__6_May_2013_10_29_14_+1000_Yu9ykdA+SX3yw5GV--
