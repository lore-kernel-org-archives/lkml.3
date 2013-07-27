Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab3G0VpX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 17:45:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60730 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752594Ab3G0VpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 17:45:22 -0400
Message-ID: <1374961508.3607.18.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 15/59] sparc32: vm_area_struct access for old Sun SPARCs.
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Olivier DANET <odanet@caramail.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Sat, 27 Jul 2013 22:45:08 +0100
In-Reply-To: <20130726205015.440894498@linuxfoundation.org>
References: <20130726205013.795696531@linuxfoundation.org>
	 <20130726205015.440894498@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-bgu/5c4XRRQ/xsP4tNj0"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-bgu/5c4XRRQ/xsP4tNj0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2013-07-26 at 13:52 -0700, Greg Kroah-Hartman wrote:
> 3.4-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Olivier DANET <odanet@caramail.com>
[...]

This, and the other SPARC fixes for 3.4 and 3.0, are missing upstream
commit references, which should be:

[SPARC] sparc32: vm_area_struct access for old Sun SPARCs.
commit 961246b4ed8da3bcf4ee1eb9147f341013553e3c upstream.

sparc64 address-congruence property
commit 771a37ff4d80b80db3b0df3e7696f14b298c67b7 upstream.

sparc: tsb must be flushed before tlb
commit 23a01138efe216f8084cfaa74b0b90dd4b097441 upstream.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-bgu/5c4XRRQ/xsP4tNj0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUfQ/ZOe/yOyVhhEJAQqthA//Sg8mA9KSFaaBnXpO2c7HkO5V+YGK3BTZ
1zRSiTaFicH4u5zyI4W+di51hGQdb+Qzf39a146OYDabVcElFUoBNc0gQcbNnHPz
Y7NXhVzmhhIH7YQCP1Qe9a+3cd+GY20St1YnF7DyjjZ6UyyGenT33CqQYuOe3hqL
qz4vTv3YNV4UJ3isOzvKwYZoyhLoNSUv3fdH5CIohFqXHjmWzLhpxpvwRp5YWC3L
HGg647Zy66r0Yclb2qnqzCgnd1Vy+iOnoGjX5zN65qVZ0FKxPupFGFdbmWKOh486
1SGhKyR10VLFyfnspXQylnyIIxZhz+X09sqfl4mtOJUDnY4IWXqa1hPKzIKORQXH
l0XxnuWzI6t3VIdsoBX2lgpJnXGPdKW4wkLQla+cEvAXik0aHIb4sLSGQSRsPr+z
0oc5SnFR+p4hMBDjztiKO42w3FYburTlf9XGwFE1epxLGo7bUs55qIS2xsIdvUE6
i7/u/MMpaZCe2OHAUcsYCKg9IiXtgvGQILmay2dsuvk5dhR1+4VkqQYKCwsjN0Ke
7/IizK31cQCECViopW8EQ1SLWbZ6LeqbCY2D/kcEoT6C5MdPG1PRaN0VmfU/Z84N
thtvcuE/mfxFvDcC12dxud3nDtHB/faKytCm2i9iPKv5FGBP6C2HGNAxLgkNldXk
iTf2BAihoz0=
=QVML
-----END PGP SIGNATURE-----

--=-bgu/5c4XRRQ/xsP4tNj0--
