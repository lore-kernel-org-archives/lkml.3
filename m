Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289Ab3CAIFS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 03:05:18 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49867 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750709Ab3CAIFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 03:05:17 -0500
Date: Fri, 1 Mar 2013 16:04:17 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Tero Kristo <t-kristo@ti.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: twl: Convert twl4030ldo_ops to get_voltage_sel
Message-ID: <20130301080414.GO25302@opensource.wolfsonmicro.com>
References: <1360980594.6332.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GPOl6LAGMgeiWDic"
Content-Disposition: inline
In-Reply-To: <1360980594.6332.1.camel@phoenix>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GPOl6LAGMgeiWDic
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Feb 16, 2013 at 10:09:54AM +0800, Axel Lin wrote:
> This fixes an inconsistent behavior between list_voltage() and get_voltage()
> because current implementation of get_voltage() does not check the case
> IS_UNSUP() is true.

Applied, thanks.

--GPOl6LAGMgeiWDic
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRMGD1AAoJELSic+t+oim96qYP/AlK35/pg7FQuzuRRpUriGBl
5amFAHhWNmnSAlfba0Y69RJr8uKApXBHUhvXYAoOyP0Yf5l2Y+fmmDoGv+mdZmnD
og5d71bGSbQI7U+nZmQynvsIxC46aO8inkZeY7F8U1S1uizTpSuf65Q4WpOIzCXT
O3w57FHyeAEhA0Hoa5RJ0/fDiEWCN5tOn3kvep28Yav6AjljbNVpyE5oS/VyN/u6
s4PNSwrlj/L8SRRoAmG6heboTzfrNFDkxk6PkZg3udlwcgNkAIp2i8tOFp4U9NqU
qtcfIXAjQuvAe7BDudHpMuPcS4Yu/4IliI4BE3UPRFeXetJp0ZOSIENRXiHZpBgx
O/491SlwI0cIcXyEf4aj46NsSuABWdCdrD48/d+vtSs4UjU998QclxlRprt2Zcve
RXUzMRUaRwdN+YK4B/7UZFcreTnQJCXlFLWDJtzCXSe6M4JZT6l/vXYl0gyn2fQ0
reT6+RdiRk4vEVoFs7OEK4RiLjVuIWXz5dGEfwreLxbaSst+DBl7FfFLQJVh2OZ8
F45DK6V7slq7v+VrLbb4Oh4onlkpJRmZAE4vNtx3eoC3kCYIoskLTJZgZoNKQggH
dH8U56Hakr48mUg89lRv1VJhDZkFDrszDKtxDHbMYEcY0gguUSP6keZ26tRN/v3B
paXpOpmZAnCawQpNKLws
=6/j9
-----END PGP SIGNATURE-----

--GPOl6LAGMgeiWDic--
