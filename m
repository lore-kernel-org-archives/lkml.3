Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbaIZI3X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 04:29:23 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43005 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609AbaIZI3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 04:29:18 -0400
Date: Fri, 26 Sep 2014 09:28:56 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140926082856.GD27755@sirena.org.uk>
References: <1411611449.25671.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VZLKKa0PG5KXlQhV"
Content-Disposition: inline
In-Reply-To: <1411611449.25671.1.camel@phoenix>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 82.45.252.252
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: qcom_rpm: Fix FORCE_MODE_IS_2_BITS macro
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VZLKKa0PG5KXlQhV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 25, 2014 at 10:17:29AM +0800, Axel Lin wrote:
> Current code does not take the macro parameter, fix it.
> This is not a problem at this moment because the only user actually passes
> vreg to FORCE_MODE_IS_2_BITS().

Applied, thanks.

--VZLKKa0PG5KXlQhV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUJSPHAAoJECTWi3JdVIfQmSsH/1OSIBer7Ewsl0yu34TIjNUg
MgsAigdlWyWdnZQYARyBI1upcoty8pCKVYkocCbJRaVGnYmM4QhtU6STcSP2czs4
BIbY9J+OZO57mMX8vKZIpLJWnfYLgBSC7sYNMYoF/SGKlxNBK6R0cQEAquUPjzAo
1qz3i5abLFkQtLRweXp6qnA09zd0FGQPHnvHgvgeP7aSf/EDp5T3lVpUYLfUwzG8
/qyiz9B3/BXv+SeQP3t8LcmTuDxj26IXp9d5wCbYyPxkUAU1n3mGxIKKAxdG4sCZ
w3YABLUEy6r8qgndZCkrp+IRnrhv5ZJnsKRupkvq9RjoJx1SNmYzaV+5AelN6kU=
=MmST
-----END PGP SIGNATURE-----

--VZLKKa0PG5KXlQhV--
