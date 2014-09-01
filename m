Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbaIAWyf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 18:54:35 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45425 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbaIAWye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 18:54:34 -0400
Date: Mon, 1 Sep 2014 23:54:16 +0100
From: Mark Brown <broonie@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20140901235416.5181ece8487f3365511bbf93@kernel.org>
X-Mailer: Sylpheed 3.5.0beta1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__1_Sep_2014_23_54_16_+0100_oSe7sZrUv.4ZSw.S"
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@kernel.org
Subject: linux-next: manual merge of the akpm-current tree with the  tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__1_Sep_2014_23_54_16_+0100_oSe7sZrUv.4ZSw.S
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in scripts=
/checkpatch.pl between commit 8678fa326053d41 ("checkpatch: relax check for=
 length of git commit IDs") from Linus' tree and what looks like the same c=
ommit from the akpm-current tree.

I fixed it up by taking Linus' version and can carry as required.

Thanks,
Mark

--Signature=_Mon__1_Sep_2014_23_54_16_+0100_oSe7sZrUv.4ZSw.S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUBPkYAAoJELSic+t+oim9MUQP/iD3ayVhQ1LjYar9c+UJ8BDn
6Zyeo7WBSoTd8vztZdwuKqR9N6K+KzTRGx0DGk/cbPCQ+sG6tjmH5zuWrgS2naux
4Pv7f67LMbAL2I+JEwgVMAK2YRHDckxv1vOXnBHpN33DWjfNUkDheqk1eLHARpXt
Lbgx7my5zjbS5ZloN2y8BY/lT4+5tEnEjxwv9Xgfn6m4JZg5FxjM5Kq6eIVgi5iG
l3CK7thGoxdnyZKXD9dvKjZtzH56D0fzHWLu4tE5Ftoq9Etgw0mle6dm+ITNpgKJ
OZczyd/oT/o8DmN/o+zgkwKFUltP9DRrlJiBwAWhwM6KTvmPuWv8YjTBGxDg0RhQ
7cL92bML+NkCAvCZ/0+Od60clXnmatAQeNyHl0ro2MHGFaLwNhXmAhoiImKZfdrH
k1Ot+n+AiG32C9E5VFWytJRP+QcZb5mkVnkGZ8E/nvIVmm5zowXJR0zrCTSDVNu1
Nq1p8vA7r7lACkKde6wk5F3UCVG+RVj+/YN0qAxAAeWTeZFhkAfgijI08fO1tKNS
7RlBPkkHOGBpudFIV7HxHixFgJW9XWOiFhEsnRIlV+OO4usgQziRAps+q/j/9hOq
2UhXeH4Zhh6MxiaTuwGAeDINXf2gLc04xUb+laKvN2d+pnLH33AiXU/faxzYw0dH
ClvPLJmoYwyEdGG0pSoJ
=VQpg
-----END PGP SIGNATURE-----

--Signature=_Mon__1_Sep_2014_23_54_16_+0100_oSe7sZrUv.4ZSw.S--
