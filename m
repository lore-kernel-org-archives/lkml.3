Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379AbaCQDzW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 23:55:22 -0400
Received: from ozlabs.org ([203.10.76.45]:34835 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932221AbaCQDzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 23:55:20 -0400
Date: Mon, 17 Mar 2014 14:55:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: linux-next: manual merge of the block tree with Linus' tree
Message-Id: <20140317145509.41f0042e7ef1db504d9bb62e@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Mar_2014_14_55_09_+1100_hOe1PspIr95JFG5f"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Mar_2014_14_55_09_+1100_hOe1PspIr95JFG5f
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

Today's linux-next merge of the block tree got a conflict in
fs/bio-integrity.c between commit eec70897d81b ("bio-integrity: Drop
bio_integrity_verify BUG_ON in post bip->bip_iter world") from Linus'
tree and commit bf36f9cfa6d3 ("fs/bio-integrity: remove duplicate code")
from the block tree.

I fixed it up (by using the latter - however, I am not sure that this is
completely correct as the BUG_ON more or less returns?) and can carry the
fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__17_Mar_2014_14_55_09_+1100_hOe1PspIr95JFG5f
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTJnIhAAoJEMDTa8Ir7ZwVcUQP/3zKpKZmlobBzCmTlZPNQvAL
M6+8AdWyAWtWGPoOMuK7EKbWq6FmpMs8J1HJJ0Eh4KQMROp75aYO6A3ELJlkh2wP
3HUSnrQ4GXjcRm5KLwziDRjA8oymD9y9tkIsaTneWyBHpAVmOphPwPBA9dWOmMgH
dS4w3C+3dWIcuXx/7DHNeYAGsC6XqwD8eYCB0sP1FVqa5MPoxq273HYyg4eYdGNG
W8353adoNvOkz0VUD5MdcoLPN8Plak+7fTy0rEhZuJ4OndKXTPWakqpKU3e8c9+X
b4FZ/+SYZI4t/F9xzmSZ11sI6YAyTzcgWlkyCCD8261E2mXL9G6uldQgjxwCn5hj
ItcQp1Jdr3x7BKHqo/grFJLTrvEnxeTrZPv4lUCe5vqea4nMio3YdxAsLEr2xjAV
Gw5fqGL0TLNETh7PKmelzLX2dh3qDk7p+mY9vK+5WdHyNpXYuvy8fXwnNjVH3Ixn
Zjcp1jWAWuwSh0qliCm2ViJcVUfVSmYaRxca/yZnmNJAj6SBXDtSlWyM17Trgc+E
3Q0tOwZvjcbORGXGikQYBgVCn8ArcwADOkXmhz90+Z4snlSgVNtopbSMqStuqnQX
HmZS1tPVr37HuKtOw6SbkHfuePN45HAr6mCaNEfT1fbLEaELWF8nZTGL5wuULKvm
ts3mYWH2NC1hLvhwA73E
=fHDk
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Mar_2014_14_55_09_+1100_hOe1PspIr95JFG5f--
