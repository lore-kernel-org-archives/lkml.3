Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980Ab3HMKSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 06:18:41 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33948 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756816Ab3HMKSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 06:18:39 -0400
Date: Tue, 13 Aug 2013 11:18:36 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20130813101836.GS6427@sirena.org.uk>
References: <1375682917.11490.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2ibbZKN8N91xLJga"
Content-Disposition: inline
In-Reply-To: <1375682917.11490.0.camel@phoenix>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: s2mps11: Fix setting ramp_delay
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2ibbZKN8N91xLJga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 05, 2013 at 02:08:37PM +0800, Axel Lin wrote:
> Current code has wrong mask and val arguments for updating ramp_delay. Fix it.
> Also ensure the return value of get_ramp_delay() won't greater than 3 because
> the mask field for ramp_val only takes 2 bits.

Applied, thanks.

--2ibbZKN8N91xLJga
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSCgf5AAoJELSic+t+oim9RqMP/2JRnSPEPA5Dj29gx2JyzNXF
omOR6gzYIGDmwlnHeG5a1+nUauUuf3MaBG1czdjovUhJucrxLdy+S2Wb54clv29R
c/A/Qe4oTwIoKjl/pgzBCenHzQp7v13kPbrTFaEsNi3Vt7lC9cv7FgNxV35yHWVd
j+1B3K43ba8AI10FqbUFQ7gLn314wWzQUnxdyiq9fSjlhUJjqFuSzfrwYId5YvAY
Z8n+7JstHsrGtgqkoRWL7EiiCCbHBPA2GrPpvSltekQidovjXHr5KQpIlKWIdQxJ
JLcbcEfDaicA58JEcSOI4526xB4IMaNC+z2bltbZtdh3cSZAuIfgIwEMXbuUomgj
zNIi8FPht1iQ1NkLy2WWaDEa9RFtBV7/tWW8im7Qc4UrOFAKZrZ6aIGlZQ9FJRRk
9odywzTzUq3AQKZK/mtwmd95qp6Q9ox29jmeBqWSdHJKMDfe0pGinAOniMoXCH+d
lZxDkGDH5Gg2ToMgZxX7iphUVRcn+jpePXljKNPp74T4fEICvjc70V82QqKq1PdA
ybR+FPPczjCSYoFHKHV2U5TDr28xTB02SWOs8Wqo8z8Qc0/gA2KhUqeJcpS4B3Lb
Fx+aaIUlxad3AiGdhnqK6i7HMgo6PKuAZa+Pbh+iRCUtMllZDjTw+Tq2P6+7KeLn
xOb/57y14H1i3kyrDXDx
=HDWl
-----END PGP SIGNATURE-----

--2ibbZKN8N91xLJga--
