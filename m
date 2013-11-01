Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab3KAGoH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 02:44:07 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51980 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab3KAGoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 02:44:06 -0400
Date: Thu, 31 Oct 2013 23:42:40 -0700
From: Mark Brown <broonie@kernel.org>
To: NeilBrown <neilb@suse.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20131101064240.GN2493@sirena.org.uk>
References: <20131101134833.7070a5c5@notabene.brown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QUAc4O4i7jPlU8jt"
Content-Disposition: inline
In-Reply-To: <20131101134833.7070a5c5@notabene.brown>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 63.239.94.10
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: check for devicetree early.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QUAc4O4i7jPlU8jt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 01, 2013 at 01:48:33PM +1100, NeilBrown wrote:

> The behaviour of regulator core with respect to device-tree and
> CONFIG_REGULATOR_DUMMY is inconsistent.

Wei Ni reported this issue and is working on a patch which I'm expecting
to do this as part of device tree initialisation rather than by faffing
around with initcall ordering; this will be simpler and more robust
since there won't be any possibility of races being introduced.

--QUAc4O4i7jPlU8jt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSc01WAAoJELSic+t+oim9VdkQAJHYF/DbnsJRX/lcpflaDHUk
jYNWDXX/F230VXvuBntV9rEwh9RDj1X50Xj2OfZm3ceTP/f6bTUT7mh46O0KKTrU
4zp4ocHdLybvuozlyYjG0lpvroRb1jKAWQS//9rOGT0H5sJSdEUGTGXiTXt5PZeb
+35cPjUWntHnGwqEl9A7lflBwfsk7/fmcAifZjAm9Rp/byI3HQM9uZMN78aTaop8
Au28KhtfbLBp9vQb2Cc6hxNbQN+VjtUdLjdowUVU1LCkjwAV5kg3omjLrReGjfom
jikwHJCCRvZ+UGR1tyTtlfIrDrD5VhDPF038O4SchFkMDmEFb8nI1mjssfUNbhHk
ZW/EYwhNsiVfSxI7bCFsSvwjqWuWhgprP/Vs5bhWyiCDXwNYKqsU8UqTDyvtW8wF
WichPgm3Vz+q7QuasU232IrmC9Xrl/igzghGkZUAVVp8qou8r1CrzkAnUjRRtVRO
8F92XYIMfbhmL1ybZMop46HKQV7SJ0gFwIwvctzJC8DS0j6/FybUhvjzzNH0L/W2
ybzvCtLjqHwjW6QdpG2HMt8GwQABFQefyZP5Q62KgPGhPtHdhR5dLhvtwS0yi4Ee
i9vXkzWaedPLh96OZhTMqxF3FviRi7LFm69D7iSgvNPnVD8+S5iJKMuV/ShSIcsN
xVMSTMZH2Y7NjywFerEQ
=RNMm
-----END PGP SIGNATURE-----

--QUAc4O4i7jPlU8jt--
