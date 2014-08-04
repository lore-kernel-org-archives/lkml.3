Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbaHDE25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 00:28:57 -0400
Received: from ozlabs.org ([103.22.144.67]:44633 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbaHDE24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 00:28:56 -0400
Date: Mon, 4 Aug 2014 14:28:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Thierry Reding <treding@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the gpio tree
Message-ID: <20140804142847.408921cf@canb.auug.org.au>
In-Reply-To: <CAAVeFuJmHX351WQpEo43sQUf+4BHk9QRJqZfJMsgWf8AXH=_8w@mail.gmail.com>
References: <20140729183153.0e77a6f6@canb.auug.org.au>
	<20140729084237.GE31360@ulmo.nvidia.com>
	<CAAVeFuJmHX351WQpEo43sQUf+4BHk9QRJqZfJMsgWf8AXH=_8w@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/bdGJJKDNvBDt9cNX4NpuqnW"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/bdGJJKDNvBDt9cNX4NpuqnW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Alexandre,

On Mon, 4 Aug 2014 13:10:14 +0900 Alexandre Courbot <gnurou@gmail.com> wrot=
e:
>
> I have sent a patch to fix this. In the meantime, if the merge
> conflict of the GPIO tree on board-paz00.c is solved by taking the
> GPIO version, there is no build error.
>=20
> There are a few important patches pending in the GPIO tree that should
> undergo testing - Stephen, do you think you could resolve the conflict
> that way to enable the latest GPIO tree to be tested again?

No, but I will apply that fix patch in my merge of the gpio tree - just
make sure it is applied to the gpio tree before Linus (Torvalds) is
asked to pull it.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/bdGJJKDNvBDt9cNX4NpuqnW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT3wwFAAoJEMDTa8Ir7ZwVlXkP/A185U/AtHzbqIFwN4YST3vH
cbPuOn2EPB0OohgKO3gil5u6pb1hey1NKzHJbnQjgdU+lhDswSok/A+l5CCZqCiT
z0PtQSGsSkOaZcQoTo21kfGUX0CdKZo0huGnOnflghcgNmCWwEY9MjQ2XSyvTE0n
RrcNPbQceZz6A6lKNIRFI7yDBJexUjzSfqdbCo47XXlhkgaOsWWxe4IV2ILh5S0y
EQuOPpBeSmLKp/asbdfMHoSWjCsBELL66l9skUkQbwZr+9Euqku3nuAurHdcLRMt
8MP8Y3pxsqHubMuiI+IW+IM/KqWXDgCsiGow0s9iy6cGwnzc2vJRC/3OKbW9/dvx
ExUgve2ua+pehVuiNXGCwnnq691wbrBlNLrPMRkzG4/BWaw9I+SxLYnX94RwMz4v
0/4aX3ET0VY3yNFun1SQmUgO5dzrewKBJjLBF/B57AhoK7WCnlfgkcWbfRoLvCoN
yIFoHu+wdJJcv22/ox6btwOxAylBiZDrZLH1p3UOfM1KlSSjttlz9bv8ud/11Buz
SVMqtJnx8Pw0bLbxfYXSxdM8/BcfLVavV5kaHLNJA9WbgncQhqIPoHd3RBPY0X/z
Jcp+9Ct58n/BP0e+/FtCoVErWSgvI/XP0hFSpHD+Ewpw7f71/+wm8J/1Ewe6jzLB
rQZbTkP1tM3Z84EBEnq3
=Oq6H
-----END PGP SIGNATURE-----

--Sig_/bdGJJKDNvBDt9cNX4NpuqnW--
