Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab3AUSgr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 13:36:47 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:63149 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab3AUSgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 13:36:44 -0500
Date: Mon, 21 Jan 2013 19:36:30 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: David Miller <davem@davemloft.net>
Cc: mugunthanvnm@ti.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: davinci: Fix build breakage
Message-ID: <20130121183630.GA11797@avionic-0098.adnet.avionic-design.de>
References: <1358761119-25846-1-git-send-email-thierry.reding@avionic-design.de>
 <20130121.131314.1276887267486833907.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
In-Reply-To: <20130121.131314.1276887267486833907.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:2U1i8pfnvLdnteyhCeniqzVP1BdRAJjO83B2Pv49prL
 1oJ9u0OAURNar1gXOoqA39fWIvct7wk3ET7JLlV9rwmYSM8EW4
 yaiPy7d295aOZzzTRSAGwMomLSL4Z5cnG7xWzmWxOGMnh6+7rm
 pzhXbzadTPAvcc6TS/PcJFR4GQCcZRX6Kd90OERbl9FTCalBze
 FWZKX/ELCp8gCLHldRM5YfMKlunKaQVzpQEkRjOFspl4/fgQye
 IT6g2og6ElRlIkQZvQU32YfgmWRB/hoIS8KcUZNHrOG4UGFzha
 07qVtQxF4IOuqAQr1vARlUQVncSvC5pe0i3uW98hDH2P++lGjc
 ZUV7RDJpvqdEq+jOqrnnCUHhCHNJA4KlhCsRwKt5g/2sYaTTzm
 wR6dAOXsQvPAkhx/JtmhH7zXfpIh7poxG0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 21, 2013 at 01:13:14PM -0500, David Miller wrote:
> From: Thierry Reding <thierry.reding@avionic-design.de>
> Date: Mon, 21 Jan 2013 10:38:39 +0100
>=20
> > The correct name of the transmit DMA channel field in struct emac_priv
> > is txchan, not txch.
> >=20
> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
>=20
> Nothing is more irritating than someone not saying what tree their
> patch is targetted for.  My time is not well used by playing a
> guessing game about where a patch is supposed to go.
>=20
> After some futzing around I was able to determine that this patch
> is needed for net-next only, but please make a specific mention of
> this next time.

I'm sorry about that. I'll make a mental note to think of it next time.

Thierry

--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ/YquAAoJEN0jrNd/PrOhpNMP/2odA5O25xGez/HQpH780/gX
KLdT69uLVHocGaZNqYU8bdcVfNGXGHltp6V6uY1N5ZRCIB007LphnuM7ziwh11ay
zzQi+ZiZyRY6dlkha08D8gCWj9wdcA1KHuUm4zggxeasWL7ftOrh+3uvF+WW8JkB
NlzINk/VqqLcq1ZOlHTeKr7rn8kP4w8pGwqkWMA0W7G/SK0UMtnBSElTNr3JnKul
z1Oik8fipfCX3fRK79IxT0ZyV+7n5xOq9cXp+4/Ub6fKC7oWFs5i7TMqKWLXqDpA
QcevTFHfXqsLA2cLFUnOv2syk1XvFzRZiqtUMLWqCyTiWbFJM6SM6K2V2KZgZgWR
4cOghRcM42TvQew8Rnofixj2KsXJ8JqXhXr5+Y3jg2xM3Mubbs7VxF4NqccBpPwd
afBZI3BXWFrSLn3low7jRz3Cm9aTn8qKdHEbR8nOKAaAvr5ZOfiGC/38vdIodD3M
FklVAH1FijFxHI8IBMrdbd64RKYLpJzpEO+vw0r38Y+1vvPG15ZpPMwW3atc2QjR
+a+SH2lLHmS9IUoL56s2wl5UCOH518bBSFshoQbzVMfGPHxCgMHlB84of0hKm6zZ
6j4WvnGwRxOBTuSQDhSSkdS3GuAjVtXs6WNECNaLElvLdRNkNNDUK7ehkcyRoB5j
Bl/KLTydYynuFrJGB8xP
=GbMN
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--
