Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab3LFApY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 19:45:24 -0500
Received: from ozlabs.org ([203.10.76.45]:33063 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399Ab3LFApW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 19:45:22 -0500
Date: Fri, 6 Dec 2013 11:45:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cesar Eduardo Barros <cesarb@cesarb.eti.br>
Subject: linux-next: build failure after merge of the crypto tree
Message-Id: <20131206114515.8bbe1dcd837ebc71924db3a1@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__6_Dec_2013_11_45_15_+1100_MjQhBemwyCiapGMX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Dec_2013_11_45_15_+1100_MjQhBemwyCiapGMX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Herbert,

After merging the crypto tree, today's linux-next build (arm
multi_v7_defconfig) failed like this:

crypto/memneq.c: In function '__crypto_memneq_16':
crypto/memneq.c:145:2: warning: no return statement in function returning n=
on-void [-Wreturn-type]
crypto/memneq.c: At top level:
crypto/memneq.c:147:2: error: expected identifier or '(' before 'return'
crypto/memneq.c:148:1: error: expected identifier or '(' before '}' token

Caused by commit fe8c8a126806 ("crypto: more robust crypto_memneq").

I have used the crypto tree from next-20131205 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__6_Dec_2013_11_45_15_+1100_MjQhBemwyCiapGMX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSoR4fAAoJEMDTa8Ir7ZwVCiMP/2Ke9Q3xTjRLu3JWawDd+v4R
oitIe0M+Y5/KwNE/oyr05A7d+BqJaO8SCPzzEFUNv7WLAPpI1x1Q7GXdFxArIXx/
Vvy1KG1J/t/sbPhpeC1MFzvPWCEGvoYAX4MhMQhWg9Ig5jIeDPfHt/+nU7mAav5h
qlUNCI8wrCH+9j1Tsu1JVMVBu/pRN09kVJsNGnrMLIUUcaeQNea4xt0/oG3YxgVu
BEMDwDQThf8JAaYyZfXNWnDnvv6Cm2Yg1LIow306scelmQq11OaEtrJHfuw+72ET
4bq7pmnKsYH11vyLCNvX1bXMqZiCPkWaMQ0eTZrqhfTNdKQ1tk5i6s9Y9nN0c3Yo
M9tGYkGGi1DG7hbqRyYM7W2d3XI5OcqqHRve2eT4w10JoZmNDbstxId0DteUvrL2
BxvvePumqmkOOgM53l6Q46l00w3Wm0odBBO/JfSI/Qd8kzWmSZ4NiZgPnOWEbnEB
GpCytE5ynRx765InbTN/lN447J4JgiqTSSG3FNs4b0kpI5PEsxxuYK3k8rRqZ3R7
lG5ALUgg8RNsWsD0UHL7Mezs3KWwBvQAeUhnh9SPmmMjKBpJfITTad1NcKP735vc
hLfx/MoZ6sijB1vzWN69u6MVpSe4GFzRE0yZDsmtY5HJ2TZDvuA5Fg8Q5BAoaz7s
Rt9HrtTIZdYtRK+cQ8Ln
=sEeM
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Dec_2013_11_45_15_+1100_MjQhBemwyCiapGMX--
