Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460AbaCQIIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 04:08:51 -0400
Received: from ozlabs.org ([203.10.76.45]:36356 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932175AbaCQIIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 04:08:49 -0400
Date: Mon, 17 Mar 2014 19:08:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, David Miller <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        "Zhao, Gang" <gamerh2o@gmail.com>
Subject: linux-next: manual merge of the staging tree with the net-next tree
Message-Id: <20140317190842.795b9d29db9a131a9cff91a9@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Mar_2014_19_08_42_+1100_NpNP02eTe_x=Xyjw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Mar_2014_19_08_42_+1100_NpNP02eTe_x=Xyjw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/wlan-ng/cfg80211.c between commit 3ead0d2e220e ("wlan-ng:
fixup staging driver for removal of ieee80211_dsss_chan_to_freq") from
the net-next tree and commit 4e5e9d7c66f0 ("staging: wlan-ng: replace
function ieee80211_dsss_chan_to_freq()") from the staging tree.

I fixed it up (I used the staging tree version) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__17_Mar_2014_19_08_42_+1100_NpNP02eTe_x=Xyjw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTJq2OAAoJEMDTa8Ir7ZwVe+MP/RAPisWxnpi7eERRukWgyrzC
cuVENomgiHi44G8DfgpChCjjBQ1j9jc/34xNDhFm4usS4U2tY5PhImSIESebN9Eq
A15JcbCtofiaS729/6IZxmGC+2rmi0ZGZzRnFQ8x3H+GEkKMLEM05ejT1DIwITsj
wHErJWRB4A5qDf0UXpt4DhxH+Y22yP85LI3EPbuiprsS8NLoms4QUI76NKLam7/c
jJl9Dh80OQNyE6v2OIH3tVPYC299AtfX+4rvuRzpI6EdTXy1vBGrgUOrF4rxS7Vs
i2x0apeuWC0IqR43NkOIOt/RWvZ0NlaNRV97C2tlklse3ZKou6lwCS8NG5m8rsdP
TYhi56f6P0BDjIi5nHojb78O1ZYWxPtWHWMgZwysUbZRR4yb/V5aMF3V19Sjv76s
laC0myqgIavzLc11Ku6mX5ZDUR9z+U6lvvel2G9t36iorsmlnLZV4iYBBqn/GWVD
d8//UfI1vNxxhB+0DP7OVMWrLoIGdkO2g5I5WqTUIEJlFydyW+9Lm+3yZRFMtwDF
C4hQD44J0qTi28IsX2fGSnsG6WZaVrBqaE4bs1nyUUBXZXf3ImKoHDXAkFDbGM3f
JTPiVLndzJQDa9EuCu/swoF4Ce3LqflT/XSNLMEqsPVIoobBOAJvmzPpVbN7ifkU
X/038DAVB9N+50r+mZjP
=1e0s
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Mar_2014_19_08_42_+1100_NpNP02eTe_x=Xyjw--
