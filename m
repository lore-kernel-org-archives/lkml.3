Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737Ab3KEWnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 17:43:13 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:60222 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400Ab3KEWnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 17:43:11 -0500
Date: Wed, 6 Nov 2013 09:42:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>, Joe Thornber <ejt@redhat.com>
Subject: Re: linux-next: build failure after merge of the device-mapper tree
Message-Id: <20131106094257.43d679d08de823ee5064ddff@canb.auug.org.au>
In-Reply-To: <52791B33.9060001@kernel.dk>
References: <20131105135128.496b8b2f599d11f2d30ad70c@canb.auug.org.au>
	<20131105032054.GA19421@redhat.com>
	<20131105143248.551f68c3cd9fe1902860c1ff@canb.auug.org.au>
	<20131105125456.GA25219@redhat.com>
	<52791B33.9060001@kernel.dk>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__6_Nov_2013_09_42_57_+1100_JU5+8HMkSb87XEKf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__6_Nov_2013_09_42_57_+1100_JU5+8HMkSb87XEKf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

On Tue, 05 Nov 2013 09:22:11 -0700 Jens Axboe <axboe@kernel.dk> wrote:
>
> Just a heads up that I plan on sending the block bits shortly, hopefully
> merging sooner rather than later. This round is huge, so I'd like to get
> it in asap.

Given the problems we have seen since the inclusion into linux-next of
some of it, don't you think it could do with a little more bedding in?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__6_Nov_2013_09_42_57_+1100_JU5+8HMkSb87XEKf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSeXR2AAoJEMDTa8Ir7ZwV1OcP/2ODWCPzpoILIJQaQYK/4OvO
bguPDFN7ag8zCwoAccZU9+xZoK8ICYKIRecMMTkWC+1mJKdM823bsJi78cTdx/vV
v+tVYmjxA/q+CpqHuiE2uCbp2e3pqni/45WEi8Z7VKsJLjHszjP6RJAzXYT7UX0P
Pjesq55utR1OudEgUWkZsRhVGPSd/vW0ULAKCd1DZ6CKi32v5SqEH93GOs0Gu1Vi
Nn8looxyznWwiP4LgRPwbMTf0HgktRuBtw0oELeVDXANXLakHNftkpyKXEWZn21J
VpNaqlL4/84dfBaC04b6kgRTaoM/8/N5JAB+TljkE4/yMAzByqvPdsUQFdBtePkJ
14VI71ayFvpA6ki8f8dWVB3bz5d0ldELc8HNr20xwy5k5AprNMk3B/XRMsi7c/fT
oztokwIOZn2xeYaIGniZqXKEu1dO2ML55uxJBv/feq2yrhzhjipRCuLzrnOUqJH4
xdf2/YPfYHWAmug6Yf5vdPEX8Xs/IoOLfm6anFFIazDh1AgKNeOVyegrf8ma6vO8
7JDk+8Co/F1W+d3ahX1Pon0Kk1Z9sAnVEthz+zMeTvQGLE3dqe3MYEktr9YLMnuf
wRAPKvFu923TfQ0G51VzkH+AtkuceqKQwBu4PVEiQaqyQ+rsly2F2MTZYWRs5Pxk
qaD1shiyhY6zTgWtKoQf
=uRbC
-----END PGP SIGNATURE-----

--Signature=_Wed__6_Nov_2013_09_42_57_+1100_JU5+8HMkSb87XEKf--
