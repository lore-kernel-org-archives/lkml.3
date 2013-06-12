Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab3FLOvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 10:51:38 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58186 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362Ab3FLOvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 10:51:36 -0400
Date: Wed, 12 Jun 2013 15:51:26 +0100
From: Mark Brown <broonie@kernel.org>
To: gg@slimlogic.co.uk
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, lgirdwood@gmail.com,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org, balbi@ti.com
Message-ID: <20130612145126.GG1403@sirena.org.uk>
References: <20130604093816.GY31367@sirena.org.uk>
 <51ADB6BF.6020205@ti.com>
 <20130604100511.GA31367@sirena.org.uk>
 <51B5A14E.6000500@ti.com>
 <20130610100330.GO31367@sirena.org.uk>
 <51B5B268.8090908@ti.com>
 <20130610124924.GU31367@sirena.org.uk>
 <51B8345F.601@nvidia.com>
 <20130612141409.GE1403@sirena.org.uk>
 <bcb26ab704763c7ae7ef815b8fa0f652@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PqX6tBBuHl4HmZHK"
Content-Disposition: inline
In-Reply-To: <bcb26ab704763c7ae7ef815b8fa0f652@slimlogic.co.uk>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH] regulator: palmas: enable all modes for SMPS10
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PqX6tBBuHl4HmZHK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 12, 2013 at 03:31:09PM +0100, gg@slimlogic.co.uk wrote:
> On 2013-06-12 15:14, Mark Brown wrote:

> >Yes, that seems like the most obvious thing here as far as I can tell
> >from the frankly fragmented and obscure information but given all the
> >confusion that seems to exist among the people working on the driver
> >it's really not clear if there's something else going on.

> What about the case where they are inputs? For bus power?

So the current flow can change direction here?

--PqX6tBBuHl4HmZHK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRuIrrAAoJELSic+t+oim9L7cQAI0Bnf2wXp5R8mRyFiHU93qx
GWzy59MkwwtkZDynPLor9C3pfwYZWWVspQ5N3FJHY3/FBc2aM9YjJzjxRYyhCIA3
0iPa59kw3O9u6SV10QkKlXZ+ATG9mllreCoVDGNl06oZzyZf9OKybZdKiIKA+tnx
M5/x3NqCci4uWNx2+iWy5KIBZlww7A7Ec0ixwL37967p8vazJtFBriORssC1DJNe
1+9s7XNlqj062oy9hWWPGcQkikaNqgCtlq7tfUGx93NK1Pia6sOFVJBEL3ufwovy
JnpChNfrXlevpcq7YVg2PhfKgWM83w+bDKbEf41WE+96I9LqgTpIQC3H6I6BHgCZ
Qzi18HMA3TYnGxN7tPLDF3B0q/K4b+3KXd2a65PFrhN2I6Dof2IXNxdIm5XBQ58G
g9lgw9e6WtKytJg4VnEDSINOMzD7n7ZBCC1Agfr7P+zZZ0f+weZ+mIVUjiguwCiM
qm1qouEO4oulxI856ZAVJY7voOQO9HxN3+drjLCEFcSpGzn7BJU/CYqd4NY9sksF
1YRoqUI4NK2LRUt4lofgO/al03uY4nxY0Q4PUE5Ouupr6vmb72SZyEFd4IsYGnF1
xVtGhfIFYYC/3kGV9OWtOtXi/0vHdE1Kv0HBwuOhsAcbSY8VyfKNoZAyKopZ/Ows
Ur2J3p7qGU2ntvgscNAH
=dMYS
-----END PGP SIGNATURE-----

--PqX6tBBuHl4HmZHK--
