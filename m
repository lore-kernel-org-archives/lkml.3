Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbaEVFa5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 01:30:57 -0400
Received: from ozlabs.org ([103.22.144.67]:56487 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbaEVFa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 01:30:56 -0400
Date: Thu, 22 May 2014 15:30:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincenzo Aliberti <vincenzo.aliberti@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>
Subject: linux-next: build failure after merge of the l2-mtd tree
Message-ID: <20140522153047.62c1721c@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/lLXfgum7c+./6YuadbWZbbD"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/lLXfgum7c+./6YuadbWZbbD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Artem,

After merging the l2-mtd tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/mtd/lpddr/lpddr2_nvm.c: In function 'ow_enable':
drivers/mtd/lpddr/lpddr2_nvm.c:149:2: error: implicit declaration of functi=
on 'writel_relaxed' [-Werror=3Dimplicit-function-declaration]
  writel_relaxed(build_mr_cfgmask(pcm_data->bus_width) | 0x18,
  ^

Caused by commit 96ba9dd65788 ("mtd: lpddr: add driver for LPDDR2-NVM
PCM memories").

I have used the l2-mtd tree from next-20140521 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/lLXfgum7c+./6YuadbWZbbD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTfYuMAAoJEMDTa8Ir7ZwVDmIP/3/Dt+mk/VtF1mBvSiJ2HaeY
i01ZubtEMZWR39fXMmHK6b33SynEXjnO9o9bR39uN6PFFdgIplutbfbnPpbt2fS+
Cg13SUlLJQzDF+g1dZKc0cBQmu/I+zdquaEzHfD1cJ8XlfkQdJt1cwBUUseUdAP7
bXqCrpt9DWvOonasKKpzxROcv/LqrXMavSFgf39mnlAX82kJoudCaG026pAF99Q5
LSPp8VJ04Un43B1GYCZVBFdH5iFUX7Kehj0OE32IbJKKDpuNhtBTDacZrYgAiH53
p9UbLaihyvKoLj8yfkaSBfQoX5d2s5WygvumyqXETyyYttvN1oTOUDlKK6vhm075
XDeok2cZRf696HycAG4yU8Mq1axlBRDxQkO37eqkj5YkhPt2cYzTMMGWt7CePBmR
w6BUM+sa3bmpLQYLF3i5XOMEhdJ8Oy8B6ArNqNNzBevIbVCUwPK/iiexYViPwq5k
jjCetGxic8+sGLMHRFHMm1qsRB2g+prxOpxJfrAZBjlFqKiXX5P7KHkAeyEwlGgo
VlccIjgpL6zRtu+9+yD5D8pI/K91ALf7OWsqF/OYoviIedjh76hRPiP0U04j2GeX
j3+PlaGcoWAVn0piLVlhMTI+duGdHPEk4H/4xjKAhVVGKysR6ksnofW1HXUWaV+n
p0vE7wGTEjBPyoN23O9k
=Um/C
-----END PGP SIGNATURE-----

--Sig_/lLXfgum7c+./6YuadbWZbbD--
