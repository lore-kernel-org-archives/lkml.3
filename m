Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778AbaGWNuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 09:50:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41160 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751660AbaGWNuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 09:50:05 -0400
Date: Wed, 23 Jul 2014 15:48:57 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: LABBE Corentin <clabbe.montjoie@gmail.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, linux@arm.linux.org.uk, davem@davemloft.net,
        grant.likely@linaro.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v4 3/3] crypto: Add Allwinner Security System crypto
 accelerator
Message-ID: <20140723134857.GO20328@lukather>
References: <1405169953-13695-1-git-send-email-clabbe.montjoie@gmail.com>
 <1405169953-13695-4-git-send-email-clabbe.montjoie@gmail.com>
 <20140723131620.GC29178@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qse+WBH4guesipZ+"
Content-Disposition: inline
In-Reply-To: <20140723131620.GC29178@gondor.apana.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qse+WBH4guesipZ+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jul 23, 2014 at 09:16:20PM +0800, Herbert Xu wrote:
> On Sat, Jul 12, 2014 at 02:59:13PM +0200, LABBE Corentin wrote:
> > Add support for the Security System included in Allwinner SoC A20.
> > The Security System is a hardware cryptographic accelerator that suppor=
t AES/MD5/SHA1/DES/3DES/PRNG algorithms.
> >=20
> > Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
>=20
> This is essentially a synchronous driver, no? If so please
> switch to the blkcipher/shash interface.

The exact opposite has been asked for during v1's review...

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--qse+WBH4guesipZ+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTz71JAAoJEBx+YmzsjxAgaVsP/0xNa8IdEmFgT9L1w9Ccet2F
GlXDBRrKmz8HVVSWFsTH6THWlGFsVpax4MpY5QmPNu2LuOm97W/Z8EFwQ1Ot1r9p
wempUcJnmMluClBT4X4/1yf73ot99iq3I1o37BOrt13W3C5bkLMerSShyoenuEA2
WrgJIkoxdCAiumJ1o4hEPtHppVBQDG0MNjIiElRosozey5Toc4vutSCO5D3LEkV0
AjapjrAGsVYR/B+bpZ1BjwKD/vyzJWX4x4sQjyaZW7ZFPl2n28qw64R3haRB28Qd
e6ZVo1wZX0JaMlvmECftWPfWywJVZJJeFBJH0xlRk6Ps8Jhq8ItrVqFHIpwrpR3j
BgxH06L7AS/yumTc5Wr23wH3VLs/jJe8t3Iqp1yRFoJkH7WieXbcALdRy+UQbpgN
WsbL6N/xB4SqxfyxNavxKL/ZwaOtSWlUq6hajE+ILGaeNvYrpK3wB7Bu6jEtVmcU
7Bb8vwSQ4+NFu3u6vTXMw1HtJXmKVVuTNx0awLUp0B4+L8WCzrIvdnYKXTSk2Swb
ibX9aUyhSi1cpya0gYKcbzQf/Y/zLr0aPSbwVjsD38EIcxKbBpc9hdBjZ7NBgMJ0
Y3cpr5rd8f8+I8w9yrLbTl9WO9tQRa+foKUlz0W1NVJMv8DF1EFD5YK8P9ZihvYu
MEMJu1cAs2odJjCkQdiZ
=G/lS
-----END PGP SIGNATURE-----

--qse+WBH4guesipZ+--
