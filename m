Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbaKFOaK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 09:30:10 -0500
Received: from down.free-electrons.com ([37.187.137.238]:50689 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751454AbaKFOaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 09:30:07 -0500
Date: Thu, 6 Nov 2014 15:26:33 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Corentin LABBE <clabbe.montjoie@gmail.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, davem@davemloft.net, grant.likely@linaro.org,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org, joe@perches.com,
        mchehab@osg.samsung.com, crope@iki.fi, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v5 4/4] crypto: Add Allwinner Security System crypto
 accelerator
Message-ID: <20141106142633.GK2989@lukather>
References: <20141021191149.GQ21108@lukather>
 <544A9FEA.6020304@gmail.com>
 <20141030171933.GR21251@lukather>
 <20141031072030.GA7563@gondor.apana.org.au>
 <20141031081323.GS21251@lukather>
 <20141031081803.GA8012@gondor.apana.org.au>
 <20141031095706.GA8054@lukather>
 <20141031100522.GA8655@gondor.apana.org.au>
 <20141103093446.GG11263@lukather>
 <20141103103528.GA30154@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JvUS8mwutKMHKosv"
Content-Disposition: inline
In-Reply-To: <20141103103528.GA30154@gondor.apana.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JvUS8mwutKMHKosv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 03, 2014 at 06:35:28PM +0800, Herbert Xu wrote:
> On Mon, Nov 03, 2014 at 10:34:46AM +0100, Maxime Ripard wrote:
> > What I mean is that since you are saying that drivers should do the
> > kmap themselves, then *all* of the drivers are broken if they are not
> > using it. And all of them are missing this kmap.
>=20
> kmap is used by the software implementations to map the input/output
> into virtual address space.  Drivers typically use DMA and operate
> on physical addresses so they don't need kmap.

Yes, plus all memory allocated with GFP_KERNEL is in lowmem.

But you still haven't explain why the driver, while it doesn't handle
the user space buffer at any time, should be worried that the data the
framework has given him are actually mapped.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--JvUS8mwutKMHKosv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUW4UZAAoJEBx+YmzsjxAgDMcP/1PI8AbGVPKn44oM9vlitRY2
zkR4bqd8Ka52kpPFiDzz8BMFjYXyLYxGZRydtAk78XM5WZy0diY5raC8TmU/nWVP
oWjWlPbj9xmHTuUXhawzw71uSfNSAqyDaXGPGBDCovgi7Y5XD9mZmybDx9xqY73V
FNNXyTmmkX+mn3i8pPMVzgPjWS/eWhs6zt3Sy8I8aI6BU+lnUmJAhutCX+F8+XX1
klD7+KQ1ABwaXed1nj3cHYx4pzDfqsCVx04GSuHD0DmLT5/bEv0WYM54kQ2gmXKy
2748Ec7hd07IH0ybcEXYQYCEV0hokF4udABo4XZpp8sqdz+O1jaYW7BLbGco8//g
P+4wlHvHYMMNgqaKZHT9cBNKdB1pHP8iAaYlF3Gk4ekHZWq5K5sSRb8Z0elBJf/m
Wk+XptdoX6Egrxg9O9wj9Ph29s5uDaLEP6Xtm6tmRjynSPWQqf3WEPuIGihD7CCP
7GPZ40LRUXK+9u7DxeBqZPAFBomtRQ1MEhTFjWNQV4wLFPxAEb752s5B8mETwJoo
bqgD60RLVU1FT35VCpnZMcj9tgudR5cZ7O/TzeimUQsDgReix5CWCd25JKU5K8tR
b/d2BIIa9iok6mttNXqCabQeROEdSPnUCDkGX8Ur4EBCwg0vhSOZzFnyPgYZ9vUH
udGNo+6MjczuQVcXdlHu
=AyfL
-----END PGP SIGNATURE-----

--JvUS8mwutKMHKosv--
