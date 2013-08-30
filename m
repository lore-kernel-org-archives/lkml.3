Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651Ab3H3O05 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 10:26:57 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41593 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011Ab3H3O0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 10:26:55 -0400
Date: Fri, 30 Aug 2013 15:26:23 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: AnilKumar Ch <anilkumar@ti.com>,
        Colin Foe-Parker <colin.foeparker@logicpd.com>,
        Matthias Kaehlcke <matthias@kaehlcke.net>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Message-ID: <20130830142623.GA10783@sirena.org.uk>
References: <1377857166.25715.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZU25/NGocqLNwEGF"
Content-Disposition: inline
In-Reply-To: <1377857166.25715.1.camel@phoenix>
X-Cookie: Snow Day -- stay home.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFT][PATCH RESEND] regulator: tps65217: Convert to use linear
 ranges
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZU25/NGocqLNwEGF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 30, 2013 at 06:06:06PM +0800, Axel Lin wrote:
> Below is the equation in original code:

Applied, thanks.

--ZU25/NGocqLNwEGF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSIKuMAAoJELSic+t+oim9S8AP/i0FtrTUZOXgiRda7zc5QenV
RDsF2aFYwtCsG+5nebnCpNKG2f2l0fInasm9MRBuL178aqk/xLmFPPmoyn/ZDAZp
XHZlu8UmnmUrgaKoRKZv3uV42P3TDcYmk5np+lsJWovUAwLKspze8X82+VKWaNeS
kE+PhHpWmRackIPhEDkl7IFpYnbKeceq0EE7NdyQ0OsBQXz71AofnS98zroUJ6bS
hSJ3vfrAifYN4HVAYaN0J1iPcH0Mj7EH1/pXkjEy5JrXkIltn90AaS7ZGtz9DVbL
vaNTv+JD2VVw+fmnDADavxVxo7TuFPmS/aNCk75j/bEsnEzmIXOnjOpzmbrvNuOI
4hKLXpzdF+MMpf/PfuOGcx64aBsaoMQ8dX9LbnWF8CIPuYde2vNFjHw4VM0lGt0b
FQMp2pP9G02C8Xp9W9qJ8FELA+fCP1HzvJMrmvI0JntUBROEeO0HXPlgnxnA+OPg
wBDPkuruaEe3PYeBvuVtJOpd5JM34/eTcypcEPrUI9hFxJ3g5n5flOiKCkLJqiwt
1MM1378N+O2hxWKZuQvbI7PCUjnqkFisjBwx4XBX4oTgb+zOlkp4p3IlhdAKfXhe
BX10+kSGySFFZKgHQQMJAyFHG43Mrl0+7kjyKvF0N9Oj8sSjRJi4A1RcEzV09Re6
Us1zzZUKrQxexuLsPVCc
=vZxA
-----END PGP SIGNATURE-----

--ZU25/NGocqLNwEGF--
