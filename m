Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbaI2WbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 18:31:24 -0400
Received: from ozlabs.org ([103.22.144.67]:39182 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbaI2WbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 18:31:23 -0400
Date: Tue, 30 Sep 2014 08:31:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Will Deacon <will.deacon@arm.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: linux-next: build failure after merge of the asm-generic tree
Message-ID: <20140930083116.753ae631@canb.auug.org.au>
In-Reply-To: <6184197.FUKmdXcAaQ@wuerfel>
References: <20140926200251.78f0d713@canb.auug.org.au>
	<20140926105333.GG22293@arm.com>
	<6184197.FUKmdXcAaQ@wuerfel>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/kygyAXGdddUod_74.oYk78M"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/kygyAXGdddUod_74.oYk78M
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

On Fri, 26 Sep 2014 13:14:45 +0200 Arnd Bergmann <arnd@arndb.de> wrote:
>
> Thanks, applied on top with Stephen's full report in the commit
> message and your Ack.

I look at your tree today, and its empty ... just checking that you
didn't forget to push or something.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/kygyAXGdddUod_74.oYk78M
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUKd24AAoJEMDTa8Ir7ZwVKKAQAIB3gVp1PwjGuNEq5bHLHvaE
+XVtP8EhX3hDImjwU6JyHU8GH8B3r5Jhg42kVz6KDEz7EzM7zWa96Puem2TBgLIn
WRhrH/tnfDlbVBRKV1HmcH+tpiZhQe/qoe9mMLnNg1BQf6Od3Ya1hswJsDYSDQeB
9VpFdlECpaCvEmQrBrEJpHGU8pDCMxYXP+pIDyqffs46s1mZl218KqDeisqzAnpw
gCnUFquWXWpYWG9/Xv6yZ6rDCb0yiwyz2p4qfspnGHRiF1MchxzIuUsX44MVmRPU
GsyDJflSf0sTKwxr4sW9a8g+h6M7FdScjS6BcVKx3pwpISy1j6dCMym3BDZYcohf
udPjIH7TYxzB8pA4Fxg5meaPrQlL4IRUk7gTdzsA/MwnWETfCiksrxh7JnXI+cSB
gqs6kPmDis+hDP9p1giz4ElEJtDp05596dBhrXT+y7goa2TDxpblQ2v2/Kb76McV
np88FQXHNqgLvouWj/7VRyHnTFTP0DUTfcgGmadzYGuAgUGKEgb7ESW0axXZkN4m
U12t1ypVMeYcxihIOOvkvcneRy2QJHqFuya+gAtYFCSWpRwOZbWtdYIUQUqn5Jy6
usrL0pp3OuXja0jik7zHkXRbzOP9kbbPBuUK4Ypk8NiI/fhkXhoVCuEY/sT9S72y
90waqyLxkOpEUX/if20/
=cGag
-----END PGP SIGNATURE-----

--Sig_/kygyAXGdddUod_74.oYk78M--
