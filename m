Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab3H3OZJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 10:25:09 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41544 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206Ab3H3OZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 10:25:04 -0400
Date: Fri, 30 Aug 2013 15:24:59 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Krystian Garbaciak <krystian.garbaciak@diasemi.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20130830142459.GZ10783@sirena.org.uk>
References: <1377864458.12097.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4X41Nl0d78nB71pl"
Content-Disposition: inline
In-Reply-To: <1377864458.12097.2.camel@phoenix>
X-Cookie: Snow Day -- stay home.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: da9063: Optimize da9063_set_current_limit
 implementation
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4X41Nl0d78nB71pl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 30, 2013 at 08:07:38PM +0800, Axel Lin wrote:
> All the current limit tables have the values in ascend order.
> So we can slightly optimize the for loop iteration because the first match
> is the minimal value.

Applied both, thanks.

--4X41Nl0d78nB71pl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSIKs4AAoJELSic+t+oim9jC4P/2cTg+gzrJI0HMhLvsAZMmsc
Ftc3JJJY4KAEJ9VP8bNrL8LDiViV7otAYtJ+wiKTrQIdDX+JfM0SwwxnDEOO3JWU
s4eeQq+V/1kCgSydf/iasJ26ZZQizMf4bh4MGJG31PDCaDIU28U4RzZfzabpUcIr
nWMpBu6qeA1RkpTfh9sAge2jjern2cPxVWBmaLlJatbSwWKJFb7yvtkS0y5uXjd+
BZaJN4jXZiDOWqxUGhMMipd4C7tKvN6q9bMAxvvrMl6rJcLTg0VVxlutJ1qa1iiL
q34Tyz+S1uvOtkgOz8t9E74XIHpQSWkkG1QMo/nEriK/8PWmJZmgOM/oFla3tNxT
XolDOPpLkHbbRsn0GfFT48K9UNdkvICMuFf7bWtWBIDO5OBCRt18CSZGXNlgMreO
oVblvM4LlFfuJ7Zqu0CSfsoZoFdOHHdlBrozGa9KGteZvipk96lBcS6F0nWn+9c3
MRIUn4UEvViVezoBR2jMvfbyRWyzD3CwQT1ghnOcLlb0ctLTJnF9YEwvzlw93ZMo
Fzvgh0S0VfuDVH8YsLmNSRtBKMOj6Hs7yOTk/s+IV+v1LtNSxakYKURO6IvTlRQ2
1EMwRNo8tlVXu2m9tYClaenj/b1cY9zC0rmDW8kKgIUhSlY+38eJNZ3bcHE7EGcc
3dkNp6VhqIhQuPhkgZSe
=kzaw
-----END PGP SIGNATURE-----

--4X41Nl0d78nB71pl--
