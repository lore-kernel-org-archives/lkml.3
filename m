Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab3JFNtZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 09:49:25 -0400
Received: from sauhun.de ([89.238.76.85]:35736 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647Ab3JFNtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 09:49:24 -0400
Date: Sun, 6 Oct 2013 15:49:21 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, Michal Marek <mmarek@suse.cz>,
        cocci@systeme.lip6.fr
Subject: Re: [PATCH] scripts/coccinelle/api: remove
 devm_request_and_ioremap.cocci
Message-ID: <20131006134921.GA4173@katana>
References: <1376562633-16204-1-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <1376562633-16204-1-git-send-email-wsa@the-dreams.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 15, 2013 at 12:30:25PM +0200, Wolfram Sang wrote:
> Use of this function is discouraged in favour of
> devm_ioremap_resource(). Don't advertise it.
>=20
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

Ping.


--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSUWphAAoJEBQN5MwUoCm2/0cP/A0jdSo4qbLW5ZRUbPrQBbhP
TUEn68xZOtMDvVUL9BUWD4BA8Kd3/sFJxMqDtH0fUOO0CRbxnMXwskuCQgMl5CX6
/6FRD9RVL8wrVCsJIvyxpaNL9H5NN9dmMFfjYFLSKYbee1BZOzSb1mvjAINlsbco
e1s1WRWMxCQeL5X/NRMDSJcNv6fhJhv/kXhI46iSKfbRbLoD/CLlF8Uii694vxma
UKCuf86Ire5NNhrSx0kW0nPWzwD/kEb3CDka9NMmn6n+mkNTJPW5ecTwob7LaN8f
4w+FamHIPl4dgXKnk/LU5uVKo6+up9Yv8qpcIqaDkwMBdHCUg5b43T9HQCgE3/da
7Npjf/EmHNdJWaRxeGyCrDP51acl3pNL4Xr7nw7f24QHuRCHh5tVJ5H++He487GF
UhdthJ9Ei4kVmjX6tIg8haDDV/biVmH3bn9zKpGqGyZrq5NVxwNtSaCwon5M2e0Y
bJk0Is0zPgisE0LswJaq2VQO9V+zXoaUi37gOQQgMX+t3cFeIwhoEazuPFYysoWl
NgIoBDRypR7xx897Zj2hAiovR5cBB27G2rSKAFRHEr5nss7X1pn1CXO05e7+gjsx
Wdgstz0Y585nF+MH9b9G94x7luVxPXEiHSMQ8NzH8qT4TxJvsUDGA8n3YqZLTmti
7mp9VjxBSUAQq7jpwd5j
=Zg03
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
