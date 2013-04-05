Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab3DEEe4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 00:34:56 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52091 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab3DEEez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 00:34:55 -0400
Date: Fri, 5 Apr 2013 15:34:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        John Linn <John.Linn@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the xilinx
 tree
Message-Id: <20130405153453.75b76d68fe9adc6e981e02fb@canb.auug.org.au>
In-Reply-To: <20130405153335.baf29606a97b1bee415f3546@canb.auug.org.au>
References: <20130405153335.baf29606a97b1bee415f3546@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__5_Apr_2013_15_34_53_+1100_al/L1eky5RHizf52"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__5_Apr_2013_15_34_53_+1100_al/L1eky5RHizf52
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 5 Apr 2013 15:33:35 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/mach-spear/spear13xx.c between commit c79e33b3e828 ("ARM:
> smp_twd: convert to use CLKSRC_OF init") from the xilinx tree and commit
> 2b9c613c4ee1 ("ARM: spear: move generic.h and pl080.h into private dir")
> from the arm-soc tree.

BTW, that xilinx tree commit has no "Signed-off-by" for the committer ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__5_Apr_2013_15_34_53_+1100_al/L1eky5RHizf52
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRXlRtAAoJEECxmPOUX5FE2eQP/0APDyuee9yeqdsmjyFT8D0C
R1VTHqD1AOtBeVQiEe4MVvYJ44cCR+T5G188RVRa7GydQRln2NFSDvdPzi1yE+mL
x9iL0lp2ZOzrCG5+lAwp/2/1Zv/Db3EqWfT1FDJAFgUqIadQzTZif89NKkaPWcVa
N4fYKz4rMOrcQ9vJy9VgVfAsBVobXkw7S6JunR//zn3ohov84v5q0zv/AogcRrpM
GTQgIjOBVqNr9UOwbyXYAGuJ0wYqdW/B1+rNoLuqp9YGAufsz0jvCzjvMkuWSlz9
NCoD/HPcrUdk9xNnCETz7NFKZ3ANwoPRuk5BHga1wTP0Npolx82VZkltJmjLsjlP
fgV9PR08UK2LluwZ8sAMxV2K2SS4dJ6fiB99RHXcNM+LoGwzVcMe529hH6AZSCF1
CLloFPsfah0re4p3fnHduSXgXYnA8GE59qRPhxs9/wm7fsnCkShx2p0mIQjAi1jn
JYXiq20b+14Ncm1bIutxRBQd3vMuuygb0riCgobk81O3P+3wURy1Wx0ZgIYSsqi7
ITaxYoBriRflK653Kue0fRQ95oXGfx31UfCnU4wt8X+xYUxs9ND96EzMktiSUiAS
PL+Bf/1Fva1U3fI6ysxuoJ63AUwHj+6ERc0Isby0qz/a59iQp3Vk+541CL7Dw01N
Ztde0s9Y4LNWmYtOs7f9
=+cFV
-----END PGP SIGNATURE-----

--Signature=_Fri__5_Apr_2013_15_34_53_+1100_al/L1eky5RHizf52--
