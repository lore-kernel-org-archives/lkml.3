Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbaKRKEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 05:04:51 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47978 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917AbaKRKEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 05:04:48 -0500
Date: Tue, 18 Nov 2014 10:04:33 +0000
From: Mark Brown <broonie@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Alan Tull <atull@opensource.altera.com>
Message-ID: <20141118100433.GH22111@sirena.org.uk>
References: <1413559023-18293-1-git-send-email-linux@roeck-us.net>
 <20141117210009.GA28122@roeck-us.net>
 <20141117232620.GA22111@sirena.org.uk>
 <546AC8A4.4030705@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nFBW6CQlri5Qm8JQ"
Content-Disposition: inline
In-Reply-To: <546AC8A4.4030705@roeck-us.net>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 81.128.185.34
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: Ensure unique regulator debugfs directory
 names
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nFBW6CQlri5Qm8JQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 17, 2014 at 08:18:44PM -0800, Guenter Roeck wrote:

> Sorry, I have no idea how you expect me (and others) to handle situations
> like this, much less with this patch. Please keep in mind that this is
> a per-maintainer process, and each maintainer handles things differently.
> Individual maintainers may expect me to send a ping like I did, or to
> resend the patch, or they may not reply because they dislike the patch

The default process is to resend the patch; I'm sure there are some
people who won't like that for some reason but it's reasonably rare.

> and they don't want to be bothered with a discussion. Some even go
> ballistic if they get an e-mail with more than 80 columns of text.

That's going to annoy essentially everyone, some people will be more
vocal than others but it's just a pretty basic thin.

> I can't even find out by browsing the regulator mailing list since it
> appears that there is no such list.

lkml.

--nFBW6CQlri5Qm8JQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUaxmwAAoJECTWi3JdVIfQL8QH/22+dOnw7gGUeZwOHA6JngqG
CoMcumxpI2fkIZUsDgITlhBl6ujygthyknVnYlWjvw+rNQdIuC5AGqOCRbgAfNOw
8or1Hwcevg+bsQhzOc/btWxrxUILdF9p+0ooEcmdvbZwhbgII4pEBXmgbiayURgu
6QpV7+41B3aS2L4NX0kd5v+etRLVU9LtA7VQP5YMgya/6PZ0EU9+bqK1d0ODrGsU
nFX8k5vQFjbp83pOUKZnxFVNAWQ3DGqbGYcEMD78l+Lg54/t3sHxP14k3aCw41UY
UweOibys+9MO01r4OdtCWK59AWiLJbhhsT+rhfa0l+h9loEmstsQmfQWanpd2xY=
=pwE9
-----END PGP SIGNATURE-----

--nFBW6CQlri5Qm8JQ--
