Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932981AbaHVQ40 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:56:26 -0400
Received: from ozlabs.org ([103.22.144.67]:36447 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932959AbaHVQ4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:56:24 -0400
Date: Sat, 23 Aug 2014 02:56:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@linaro.org>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: linux-next: build failure after merge of the mfd tree
Message-ID: <20140823025616.690f0c83@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/uAeledwA1CpxMp_vKkXO66_"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/uAeledwA1CpxMp_vKkXO66_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Lee,

After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

ERROR: "wm8994_base_regmap_config" [drivers/mfd/wm8994-core.ko] undefined!
ERROR: "wm8994_irq_init" [drivers/mfd/wm8994-core.ko] undefined!
ERROR: "wm1811_regmap_config" [drivers/mfd/wm8994-core.ko] undefined!
ERROR: "wm8958_regmap_config" [drivers/mfd/wm8994-core.ko] undefined!
ERROR: "wm8994_regmap_config" [drivers/mfd/wm8994-core.ko] undefined!

Presumably caused by commit a3ee6a4e2729 ("mfd: wm8994: Allow modular
build").

I have used the mfd tree from next-20140822 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/uAeledwA1CpxMp_vKkXO66_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT93Y1AAoJEMDTa8Ir7ZwVSukP/3mY5dG9zShuOzutAiSLtz9n
zjvXdz66ImfJ879QpfGS+UuwSjyHdjG0z4qv+8gnmbqi6jFMQNS0tr88nHyM1Nau
rInetyZd8JVr362p22GIFhg/Z22PlViVRK2lz9JxZPFYlz0DG099d3K0nbEKP4GB
fEjQjdKEkiTrv/2dZ3js4i/teAhsl+yJZz/0K1NoIFfbybK6/0WG8H8J0CNnaz2K
hqxJ3n01tV5M7Zn5ZSc4Dr4LBln6gxZRF+l56NyKtXUGErnBSHvw9yMw8Anp5Lok
8/1ZuRs+KjAxNi5VJMvmpXOyCF3fImDNOh3fjWfunfea28w9sHJgNtD+rAnc5wGZ
NtVVMmMsP4285zkQ6rqnr3DW3aw4jNRLp/pkdLlt/umHTsph6hWy2DQFu1P4UWI5
Go8qEtxlCS+VGOZaPLvAtGJ9GZKKGWY9cR7sp7+ViH4EdcNMOKsWq+K8VgmtbyLO
C6jnhGnxmqlFA8W9sRsN5cmXD8Y719DSfb10dgn9IHQvimSSyseOETiupMpy4ZUR
NdoJ8wG680rruzCl76R2Pjuyl8MeQnmE+vq0EM6exmB7SrQNK3QG+MshFTsC3Yyq
1H53G99DF1O07XwnuTrBKV1ESLq3qZdP6fO4kQsccAz0vzXZ8brU8aUzGJJ8oFuf
XBSku2AFYBNHnW+lcmJk
=w5rS
-----END PGP SIGNATURE-----

--Sig_/uAeledwA1CpxMp_vKkXO66_--
