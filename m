Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab3LPAHm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 19:07:42 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44993 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751824Ab3LPAHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 19:07:39 -0500
Message-ID: <1387152449.2803.3.camel@deadeye.wl.decadent.org.uk>
Subject: Re: pull request: linux-firmware: update cxgb4 firmware
From: Ben Hutchings <ben@decadent.org.uk>
To: Hariprasad S <hariprasad@chelsio.com>
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org, felix@chelsio.com
Date: Mon, 16 Dec 2013 00:07:29 +0000
In-Reply-To: <20131215193220.GA7536@hariprasad-pc>
References: <20131215193220.GA7536@hariprasad-pc>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-V+j0K9XGJlBWc2u4b4u9"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.224
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-V+j0K9XGJlBWc2u4b4u9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-12-16 at 01:02 +0530, Hariprasad S wrote:
> Hi,
>=20
> Can you please pull from the following URL?
>     git://git.chelsio.net/pub/git/linux-firmware.git for-upstream
>=20
> The following changes since commit 7d0c7a8cfd78388d90cc784a185b19dcbdbce8=
24:
>   Ben Hutchings (1):
>           Merge branch 'wilink4' of git://git.kernel.org/pub/scm/linux/ke=
rnel/git/balbi/linux-firmware
>=20
> are available in the git repository at:
>=20
>   git://git.chelsio.net/pub/git/linux-firmware.git for-upstream

I'm no longer able to pull from this repository.  Depending on whether I
use my cellular data or home DSL connection it fails with either:

$ git fetch git://git.chelsio.net/pub/git/linux-firmware.git for-upstream
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.

or:

$ git fetch git://git.chelsio.net/pub/git/linux-firmware.git for-upstream
fatal: unable to connect to git.chelsio.net:
git.chelsio.net[0: 67.207.112.37]: errno=3DConnection refused

Ben.

> Hariprasad Shenai (1):
>     cxgb4: Updated T4 firmware, add T5 firmware
>=20
>  WHENCE                  |    8 +++++---
>  cxgb4/t4fw-1.6.2.0.bin  |  Bin 431616 -> 0 bytes
>  cxgb4/t4fw-1.9.23.0.bin |  Bin 0 -> 486912 bytes
>  cxgb4/t4fw.bin          |    2 +-
>  cxgb4/t5fw-1.9.23.0.bin |  Bin 0 -> 481280 bytes
>  cxgb4/t5fw.bin          |    1 +
>  6 files changed, 7 insertions(+), 4 deletions(-)
>  delete mode 100644 cxgb4/t4fw-1.6.2.0.bin
>  create mode 100644 cxgb4/t4fw-1.9.23.0.bin
>  create mode 100644 cxgb4/t5fw-1.9.23.0.bin
>  create mode 120000 cxgb4/t5fw.bin
>=20
> Thanks,
> Hariprasad Shenai

--=20
Ben Hutchings
Lowery's Law:
             If it jams, force it. If it breaks, it needed replacing anyway=
.

--=-V+j0K9XGJlBWc2u4b4u9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUq5EQee/yOyVhhEJAQqZsA/+JmA2fO/vDR2iK7pd78fiGP68LZyYMuD7
bkZmhP7a3K2ETr28VWlIKo9FYjbLxGH5jHj+RxTJWIU1NVRt4ZJfelygbk+7qexE
gXXH75ogkuzrpz1ii1cBMghrFWfomENoy+l5Ytr1u47xkYXDa+P9TEVyAPZ9dFjj
KeKtSEZYqVEZ7F80TO1vYFpl5WeoTMSp4ZRCozIANqqZxdQmq3AavMHUJXIu+7iw
M3N2PrbDMR0kwsQG2+MbEF2Ai4BuiSUIq+wsFqxt/14ZBBuzcI+Z3qMs6SJ9TRSO
xWO50M82q3bMffyKAWwxW3RWPZMsO/K2z5IHjqD0EUQfuZl0Xr14egu5h+Vz9pgT
BEYgLn7EPi3sKXz2F6CSum5cvdXFyYDaY56M64FtUDcrwZ14bC/4rs/baS9OXpKY
fA6NOE2XBmVXCcrEZY9jhXvjKS0C3uTYzqXgfKpb1azIOqBc6ql1ycJZ3iSTVylN
/MzCPfT7nJzNUpMM9XJCY7Zw9lJ483dErYUgLNrwWHK9RgfPrtIRiwTZqtAmSte9
M5iQpISE/Fw7klo8zXXbnwsdFDtre28d9K0stC3EOdCdMTB4e6Hkz0rY+xuktFV7
0lxumE+oO5jjCriQZyND/ClkghlrrRHiP6VwW9MQnR1l/sdgJb0m1tLiQmiqSgEv
EVeIqL29VJY=
=/J2B
-----END PGP SIGNATURE-----

--=-V+j0K9XGJlBWc2u4b4u9--
