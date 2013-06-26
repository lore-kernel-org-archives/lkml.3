Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804Ab3FZIX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 04:23:57 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50720 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab3FZIXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 04:23:37 -0400
Date: Wed, 26 Jun 2013 09:23:14 +0100
From: Mark Brown <broonie@kernel.org>
To: Chao Xie <xiechao.mail@gmail.com>
Cc: Chao Xie <chao.xie@marvell.com>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        yizhang@marvell.com
Message-ID: <20130626082314.GJ27646@sirena.org.uk>
References: <1371713467-3256-1-git-send-email-chao.xie@marvell.com>
 <20130621152416.GC27646@sirena.org.uk>
 <CADApbeigFTQNhxR-CVBGUhXvg+jVtt7ZVvEHuKqeSA80CFz-dQ@mail.gmail.com>
 <20130624101454.GG27646@sirena.org.uk>
 <CADApbeh7upEmy7URYvoMdU0jUR4qC-a+AErH5ND5QG5xwVdAdg@mail.gmail.com>
 <20130625091201.GW27646@sirena.org.uk>
 <CADApbehiFuom7DJ8L9upE3yawHmreqGovCFeLuXoVhzLXsLENQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kWguO0SK8p2Kaexx"
Content-Disposition: inline
In-Reply-To: <CADApbehiFuom7DJ8L9upE3yawHmreqGovCFeLuXoVhzLXsLENQ@mail.gmail.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V2] regulator: 88pm800: add regulator driver for 88pm800
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kWguO0SK8p2Kaexx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 26, 2013 at 09:35:01AM +0800, Chao Xie wrote:

> The regulator driver does not only work for 88pm805 but also for the
> next lite version 88pm822.
> 88pm822 only have 14 LDOes. So i defined array of points in pdata.
> When user define pdata for 88pm805, it can fill all 19 LDOes, while
> for 88pm822, it only fill 14 LDOes, and set
> others to be NULL, and do not need fill some dummy data into the left 5 LDOes.
> The 88pm822 is just tape out, and we are debugging at it. So the
> detection of 88pm822 is not added to this driver yet.

Handling of multiple devices like that would normally be done by using
the device name that is registered.

--kWguO0SK8p2Kaexx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRyqTvAAoJELSic+t+oim9qngP/3/pYEceWJYidEMzskgMpzt2
D/eqP1iFPQqDGux1NeBsEVemFJSnbzP5tP6Zd+TC5LbPP832+lrmLvGDivJBgfMA
N9Cul1FMJif8XH58zLrvevEDbPsn0HahYq/vkFb8FoQi0fpogE7Lc8Dj08D7x1cA
opub/w1FdTxIwCLW/MOkfu63SZe2SfuSY2INiWp7PmDyarsGYVAW9npqGDNzhXRw
zmE115rhAH3foYLNv/9VQp84IT4flbpNr8xD+r5erDQf+WZnNw1J26ft/5Hc+0lc
CjIdmlWRl8AfBoLIzixMO2DfBud0TLtyz6yCC8RGG5cqbwxW6EnIAU6hvTv7kkT5
cJgQRiCgwKU0RB4R76nAmMpKxIER7X77EcAAopCLz2eFYv4LzgA6z3F1onvzs9ha
qze/19SYj4ziU62G/zhkzIj9PBmbgf2G1S8oqNPoBJamm1y43nNVegEa8b8cm/xk
B8QLJ1JOApIjOEkrJuyzVs+mwf2ZD+a8kCXSsnQAPuXOYg7B3ziXSr1Si0a91Vn4
lLwsHwOq0hkwBUT5XVYYd76d++5ku3uxbTl/l3fd7XeyPeY7V6NtOCHS1V0rXEY2
bLdRiLbc68zfeGa7pq2zy8lQtwxw21uADh234eT+4BYp56N+MlX54Z4/kzJvNBMP
8bj1MO+BwHFXtORmQEX4
=6eJS
-----END PGP SIGNATURE-----

--kWguO0SK8p2Kaexx--
