Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbaFXPXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:23:37 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55773 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbaFXPXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:23:35 -0400
Date: Tue, 24 Jun 2014 16:23:29 +0100
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@samsung.com>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com, spk.linux@gmail.com,
        anilkumar@ti.com, j-keerthy@ti.com
Message-ID: <20140624152329.GP23300@sirena.org.uk>
References: <1403598556-22536-1-git-send-email-sachin.kamat@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DBUa/BSa4z6QPQv1"
Content-Disposition: inline
In-Reply-To: <1403598556-22536-1-git-send-email-sachin.kamat@samsung.com>
X-Cookie: But it does move!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: tps65217: Fix build warnings
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DBUa/BSa4z6QPQv1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 24, 2014 at 01:59:15PM +0530, Sachin Kamat wrote:
> rdev_get_id() returns an int. Convert rid to type int to avoid the
> following warnings:

Applied, thanks.

--DBUa/BSa4z6QPQv1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTqZfuAAoJELSic+t+oim9jUYP/iCqs5EfZ1RT7XvymVJvAYfW
AbhgPqscst4JGxTqBA/ANdXRnTrFHTmHTYMcdpBuHR5VRuDfB4Rz7n/rZ8Lk8AGs
t/BWsu/tL3+RIEh3scwjLacyx7dd1CF4oNMV734D/Vb2lm2Y3am9Tp+riYZRe/vS
iGL/ngH//l8xQ3ztJS4vdpkK+iBuY3S/YA/RlSoFmXAls+Y28ga1OmQM84//eB7p
qXNGxxD3dCn1bqg9CHTdiO+V2HTboj+oG6qqVvY5gGSzdDY7YWUd1DI/WatTk7FA
VJgLSItZmUzTE8NCYFwfaKlPMuTMdkX8LOmmjM6KzTSkp0FIpzGYMxEiM4/HYuTG
2GEypea/MECIrOio3tr+qx0WDcBhjYkxuZWWWQwCbpf/S00TrSo0e/WqQ9Qb+UdA
CI2CR+QgLOzI3TbFjCSTwd9vTNr9bzc4eXcjUYryIXNnSMYuqDXbKFqTZsQ2QeWU
w4yg00O7Z6raPyGi/fw04XAh4OmiMS8FEqKsZbMZc2gGocC9zH2BoMxnd2GVCLtl
ll9jVXxwlF4hym/fc9Wx20v4jUAtpnm7+a/syViUTc5ebaNapNtcIxrUzyICpD5u
MQMSZpKfunVpfdNgC+YacA5+KnAdR4HGEYT+ByYow3dLDoQL6DULOw7shDNwaqHQ
vWWimQLX5pD+jW/cfThy
=PQlN
-----END PGP SIGNATURE-----

--DBUa/BSa4z6QPQv1--
