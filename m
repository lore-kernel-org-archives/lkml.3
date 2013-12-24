Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab3LXMIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 07:08:46 -0500
Received: from s3.neomailbox.net ([178.209.62.157]:24905 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576Ab3LXMIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 07:08:45 -0500
Message-ID: <52B9790A.3040507@meshcoding.com>
Date: Tue, 24 Dec 2013 13:07:38 +0100
From: Antonio Quartulli <antonio@meshcoding.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: The list for a Better Approach To Mobile Ad-hoc
	 Networking <b.a.t.m.a.n@lists.open-mesh.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [B.A.T.M.A.N.] [PATCH v2 07/20] batman-adv: use batadv_compare_eth
 for concise
References: <52B96FD6.6030309@huawei.com>
In-Reply-To: <52B96FD6.6030309@huawei.com>
X-Enigmail-Version: 1.6
OpenPGP: id=43FD7307
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="wkj9UfS6i1tFp3S8mNpPOqKcNUn0KVwGG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wkj9UfS6i1tFp3S8mNpPOqKcNUn0KVwGG
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 24/12/13 12:28, Ding Tianhong wrote:
> It is better to use batadv_compate_eth instead of memcpy for
> concise style.
>=20
> Cc: Marek Lindner <mareklindner@neomailbox.ch>
> Cc: Simon Wunderlich <sw@simonwunderlich.de>
> Cc: Antonio Quartulli <antonio@meshcoding.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: b.a.t.m.a.n@lists.open-mesh.org
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Tan Xiaojun <tanxiaojun@huawei.com>
> Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>

Acked-by: Antonio Quartulli <antonio@meshcoding.com>


--=20
Antonio Quartulli


--wkj9UfS6i1tFp3S8mNpPOqKcNUn0KVwGG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSuXkTAAoJEEKTMo6mOh1VH+0P/AwTpJ/kI0JVqnwKOyRcXCj7
61EksRtpWuhKF5y9kDWeIEU/Ehfn1XM5mhQoJCdY5b2ZjpVUe2M5ICVKSWS3R3pp
15stmdrD2EmWhFG0t4GeoIuZUFfqKZ6Eg4s8l3aTkSFSNpSWP5+8aX8aaW31HTxC
Aqq+MV/HSgjtVhreKoIWCYiL8F48Zxw/rPFWXA9VEeDtWjLqItCfcpesPxR5jUmH
S2/71NEE77vQ5wPGg9M6TnfEPIuxPkpcXDDliLF/Q15eKqQBuNs0Z3ulK6xejHq+
XfLR2n6t6wBT4ufI+ruCcwfgyXeTFtbzZUlhq1lAY6zMKZv7CmAP6R+rUErZ0BEg
gjYIKmEa8IltaebNDQSch7oa3d4HE6MhqLPm6jD9OS1O9bdFjftIlvWHTPSGuNKU
vnZANzRIpRgupmhR53Rjx9hltUiWKTrd0pAo9BZWirjpvuYwS8B+CGTlY+Cx9AsQ
9UKTL1kuAM+jnswaxJ/3oa645gMXTPNE7q6T3ttYAeb81kHcROfTG7/ktLcfj2G4
Cg28tgX5nAy71KuPTKHQN8qjyprP0s9G5Cy/xM4s5fI+CuaTDZvB4+5oyQGU6T18
rxQseqhjsqktHUcGF42mEBUZ5my+UsoRklUhSnToncAsgEYrX/asluSFU81ckTXg
EL+sk0zTmrsXpm3Hl+X5
=ClJt
-----END PGP SIGNATURE-----

--wkj9UfS6i1tFp3S8mNpPOqKcNUn0KVwGG--
