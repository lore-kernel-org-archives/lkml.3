Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505AbaIYEol (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 00:44:41 -0400
Received: from ozlabs.org ([103.22.144.67]:40883 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbaIYEok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 00:44:40 -0400
Date: Thu, 25 Sep 2014 14:44:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: error trying to fetch the devicetree tree
Message-ID: <20140925144432.1794fdbe@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/XkaZJIZf6eIZ7Ka7eO8utu7"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/XkaZJIZf6eIZ7Ka7eO8utu7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Grant,

Fetching the devicetree tree
(git://git.secretlab.ca/git/linux-2.6#devicetree/next) failes like this:

fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/XkaZJIZf6eIZ7Ka7eO8utu7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUI521AAoJEMDTa8Ir7ZwVLegP/1/Jwlqu786cTbi4Z6B/BFSJ
0/ahBe9lVF/+jUpKnLEaHK0QLg4BXBG0sz+1BvXrf0kjvFVPfevDcEDntvwb5Rn6
xcYp56Zfb/ZfaaCznAE1wcVpbxeDqpf+teS0rqlU8cXWhY6MLxo+X495uqKQ9uvX
HBJ69Rc2ia/MqEdaMoRR0VRQ++jqjjsLtljQI12BeaWSm3gR+bRubzE6zWtJY9Wk
srIPVbn7LcHLXeHpkFj7E2HOfmhFaLwrRZOKYtR4+b/G5+/F6wkH8UH9nMMgAkTN
an1f1MUx7iP3mqX1GebdjwX75y64fX7u38vFBjTDJ5yt6ZTDbrDvPTEqLLW0tRkj
PjOIYkhN+xEUGorW10MVGP1K1EIHgDGF8aUN8TdpSqnGlQ9K6WslbRGE9Vqd/8cV
a7SdEeBWv5XIE5U2W3tKYH6wOfFXYUL15jZfvlsRt3zO731jPC4jtEIq9zVfn5hK
l8EuE8pJJ0t+7eLriy3mORvoAgGsB4SqU358mi2+qNGe4S7kma168r592OQRo+Es
PxkJ4yeUEGrrSLhLW46yuPWGEBJaaHAwObdHFQx11+ocAawIF1jnnIUuPTNgM4kb
/RYpavMJUEdMEkRvcaQWeeRp2wyjCj7xNUwkrA4iOuJr8eyl1jlBFLi6zqz+tDS4
SLUqbRateKsg9B10Xm0+
=bbjr
-----END PGP SIGNATURE-----

--Sig_/XkaZJIZf6eIZ7Ka7eO8utu7--
