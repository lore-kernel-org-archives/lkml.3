Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756994Ab3IDSet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 14:34:49 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43308 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab3IDSer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 14:34:47 -0400
Date: Wed, 4 Sep 2013 19:34:05 +0100
From: Mark Brown <broonie@kernel.org>
To: "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>
Cc: Ashish Chavan <ashish.chavan@kpitcummins.com>, lrg <lrg@ti.com>,
        alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "kiran.padwal" <kiran.padwal@kpitcummins.com>
Message-ID: <20130904183405.GX3084@sirena.org.uk>
References: <1375689331.28910.5.camel@matrix>
 <20130805144201.GF9858@sirena.org.uk>
 <1375717898.29528.23.camel@matrix>
 <20130805162342.GS9858@sirena.org.uk>
 <1377778108.15438.6.camel@matrix>
 <2E89032DDAA8B9408CB92943514A033751E611AF@SW-EX-MBX01.diasemi.com>
 <20130902103843.GL3084@sirena.org.uk>
 <2E89032DDAA8B9408CB92943514A033751E612F5@SW-EX-MBX01.diasemi.com>
 <20130902174121.GV3084@sirena.org.uk>
 <2E89032DDAA8B9408CB92943514A033751E6157D@SW-EX-MBX01.diasemi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R9qb+eAX/AZDW6n0"
Content-Disposition: inline
In-Reply-To: <2E89032DDAA8B9408CB92943514A033751E6157D@SW-EX-MBX01.diasemi.com>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH] ASoC: codecs: da9055: Update driver name to
 fix breakage due to pmic driver with same name
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--R9qb+eAX/AZDW6n0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 04, 2013 at 04:13:25PM +0000, Opensource [Adam Thomson] wrote:

> Personally I don't see the issue in having two I2C clients defined for the one
> chip, in the machine bindings. Logically it's absolutely correct for the chip,
> and as long as the I2C IDs for the devices make sense (which wasn't the case for
> DA9055, and is something I want to rectify), then it should be obvious
> to anyone who comes across that code. Actually having them as two separate
> entries in machine code helps to highlight that they are individual I2C devices
> in one package rather than somehow linked internally and requiring ordered
> initialisation. That seems right to me, and would tally with the associated
> datasheet for the device.

The goal is that users shouldn't even need to have to think about how
the chip is constructed, they should just be able to use it with minimal
thought or effort.  Anything that can be encapsulated within the drivers
should be.

--R9qb+eAX/AZDW6n0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSJ30aAAoJELSic+t+oim9GYMP/1/kPPw/HZIwU9S1XcaXbkcI
p7y4/x1zkIevB1aSlgGYCymludYuiMwapf9pPh179JqtTd/S5sXusu0TCsrUzeRB
nCIyCitn+f1KbsM1FvF2R1uix59JoIqhEBqMO8LfVUeqBLJPNchXQjTwJY1Qq42H
3LkVvETBtuXSAhh8JVjjMlDzZN3b0FpoqEcq7lkFty5UNN9/XdUny/eulqIMh3SL
9Oeaz3yW0xaC9H3HuPXQbNaG1KFz0ue9LbpTlw7PFYov0JFTachaYWLp2BARrDbJ
FTWxVUFIEYT3rqVgeQiBcgsmRXdzxIemTGpdrAFPJgfKjqv3X5yd50G5JW/qcaHK
LDts0S3CnpGo1RvdYuBQJWuJktIwQNu1vKYPcL6kCTBCaZxX1lsu2hCQP3mGYXOQ
E27oGHFUp8afW4TC7B/fK1W4tXC/vuIyR65OlDl1kEttJQiB2QwaXljKx7xwK8Y/
1qS9bDrxZOUG0EEVhIE2CuwRXh1/06Glkn32a3opvW78uH3ixabXAKrf+ULy37MN
XMZ49m3qlkquZXWiDJcESvrJWt45sqxzyx9ivSuyPKiOFQYS8WASYP3HTfzDGlX7
Dk7AJMgtH8N/2jH6cSq1Mzv4aYeAEc29J4QFf2FLQEx4/+rviN2OOojDwQYHFdKj
sjgOKMgBRJfEaeg/za7/
=E+U6
-----END PGP SIGNATURE-----

--R9qb+eAX/AZDW6n0--
