Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825Ab3HNStb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 14:49:31 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36275 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760026Ab3HNSt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 14:49:29 -0400
Date: Wed, 14 Aug 2013 19:49:16 +0100
From: Mark Brown <broonie@kernel.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>, Felipe Balbi <balbi@ti.com>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20130814184916.GM2401@sirena.org.uk>
References: <Pine.LNX.4.44L0.1308141209410.1701-100000@iolanthe.rowland.org>
 <520BB0B4.4090400@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L5nTHegdhbHhzmSD"
Content-Disposition: inline
In-Reply-To: <520BB0B4.4090400@wwwdotorg.org>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Non-enumerable devices on USB and other enumerable buses
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--L5nTHegdhbHhzmSD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 14, 2013 at 10:30:44AM -0600, Stephen Warren wrote:
> On 08/14/2013 10:14 AM, Alan Stern wrote:

> > No, no -- this is exactly the point I was trying to make.  The on-board
> > hub _won't_ appear on the USB bus until the GPIOs are set.  Therefore
> > the callback to set the GPIOs needs to be at a different place, not
> > when the device appears.

> The device Mark was talking about is the controller end of the bus (EHCI
> controller, or hub's downstream port) not the device end of the bus (any
> USB device's upstream port).

Actually it genuinely is a hub - it's not part of the controller, though
the startup does need to be synchronised with the controller.  It ends
up parenting some other devices but that's not suchan issue.

--L5nTHegdhbHhzmSD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSC9EpAAoJELSic+t+oim9FoEP/2XDDCmr+Ar/CvIhzmYn1tRp
uGXnDvTzQ203SyEOhldvG03P1aCprrvdbhy5gBCPMGiAOctaoom4WdEk6IPKqqi6
AD5/Ev8xeNLlJsJlZvZBaN6qAzMWe9RfMjl1hNvIbG982aR+ym25psicAlq1mtww
GvCnZ2Gd7e1Sp8bK87Z+z7HA3V/ztQFoTfPDrhg/TCfb8iI7LiyOTOddCEECfBfO
CDuDcio4XQHy70E79xg7/0HRyALcmd2u4ATdGz1hnJKNUuuISKWKxtrWbDY7aDK/
Hnt/M6lhPDGkskuTbCRKBd80cwAgVlmcl1vXpVtiltpy+Vo9+7fnGh7VNg0OboXv
DfGozA7moV5qAHNeld/rGeiAb8ZeSe+ddjJ8Ah/HGWWz/nEHIrV4lmsmpMNCt3qO
zmdOQ3HdEe8ynUdKoVzppnT7r/DvaPfCeRmfsu0Ahrb53dw+na7KmlzI55kGFpXO
nEOedH5KgsTecC9dnv711raOtTnbuKTzbMp/ETqBWg/xvI+ZtiHOZoqo+ZBn/v7q
xpJVW4MyVCcpTQMFMNOanyB6zAqEXBkm6UXWB0qTuIn1A3DVCKOpodTBQnThfAQo
TbheBJ4E/BnQFvSdRE3VWlngUFtdXzoHTZ9k65rlpP4ko4jr/jOgVZB8+6YKc8+U
r1Ojc+2CSmTRa8apE/rU
=C0RF
-----END PGP SIGNATURE-----

--L5nTHegdhbHhzmSD--
