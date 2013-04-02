Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760802Ab3DBJft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:35:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50593 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757309Ab3DBJfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:35:46 -0400
Date: Tue, 2 Apr 2013 11:35:40 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Axel Lin <axel.lin@ingics.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Shiraz Hashim <shiraz.hashim@st.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] pwm: spear: Fix checking return value of clk_enable()
 and clk_prepare()
Message-ID: <20130402093540.GA4416@avionic-0098.mockup.avionic-design.de>
References: <1364647402.3822.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
In-Reply-To: <1364647402.3822.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:ufdUt52Jgg1oA5fRSj9IESDnu8qSPCHNOhccXtWtUgl
 S5+bmqEufIte8fjHPctrfFgxCCK9e7aJwIpSmUe60owDpjOfEy
 XPAlxlA/ADPfoljQYAC5HmxVUsgvLqkYjdrTxlJdzJsezBZHpU
 sUn+7GumETnfsLMwGtqYEBcABIUywghM4naDtTPPwWL14UjwBS
 VK5W9k0lJd3xT50zi+UzfJwVUo6NpwvqI3ctADaUULxWNeLctW
 eDYrczC7Oibpfea+aD/CLnepu+Y+Ji182AbdwPjyQk8/dvmzje
 SYPhxYmqgW6gylrlUtB0jwESQyYuE9cFmWngglzBQpMs0qFzgg
 j+XJOutyOKjnnvYPuF23FDiZKekeBMOnj1l72fXWni938g9KBr
 d3ulk3QUOs17RrmOPT/tiY7HK/v2V6f7PI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 30, 2013 at 08:43:22PM +0800, Axel Lin wrote:
> The logic to check return value of clk_enable() and clk_prepare() is reve=
rsed,
> fix it.
>=20
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> Cc: <stable@vger.kernel.org>
> ---
> This is v3 of "pwm: spear: Fix enable pwm output".
> I change the subject line because it also fixes checking return value of
> clk_prepare().
> Also add cc stable.

Applied, thanks.

Thierry

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRWqZsAAoJEN0jrNd/PrOhR9MP/3zQvd+qg/KooDYrh9lfhV2C
6BEEZCjz+SZkAsG5RRxYs3LKHBAi3PEJ68lG3V+joxixTZqP+MmoCdLdROB53ZXg
U2Rfb7uoChBAqC/QHCGZnC2dJEf79Oun01liENMpo2Xpo9BLduQU6wMJVmmKhNnC
4/05HL5rQ7b1357mtcs6TVJP82PFXX+X+wXb1dk1jhOdYUu9uWmXcpzXUO7lch+0
kvPyF8qq0TqPpFsucuUH0m1YwysPh5WbkV2rWebg4dTxKZBLFK300iPCRRIgVZ6B
oR1jDKilmsYY7GGwXIEsWeuZk5fZzcCONHf6ixyCIJxzISLZ+hBWgVKypWhzkRtH
r84dRjRVUD29mBAgGbyid9uMrJ4wknARP6/0/AYDXVnlGdbvSoy+a7eo/hoHg184
0q3+jQq7131qNdjRzrPoPfF81N8eEVQ7K/2KoPQRtmo8dp3UZoUidV5uWsrB6CD1
NPTRj9CVIKe/94Ra1WPDu+QC2vX1/VwSGHU20ZI1CgcsJyv8rGPEsyduUU0PQbjT
eCga8Vw857u3Nwsi4gXqcQZJj+AUV7c89OBZK1gqGBY8/bYyo6KIPXnFpiTM3/0z
Gw+jOBSdCBvWCzikWr1SqbBFrfVmtOE22WySCyuW5XNFNbwIcB9NbXQQ9v3KgGcL
Kf9Pvd7OmFV23IKJfxJd
=0KoA
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
