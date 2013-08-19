Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751091Ab3HSQCP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 12:02:15 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44507 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab3HSQCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 12:02:13 -0400
Date: Mon, 19 Aug 2013 17:01:30 +0100
From: Mark Brown <broonie@kernel.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Felipe Balbi <balbi@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <20130819160130.GD30073@sirena.org.uk>
References: <20130816224654.GV30073@sirena.org.uk>
 <Pine.LNX.4.44L0.1308162117240.24059-100000@netrider.rowland.org>
 <CACVXFVPFqHLQRpd0QBzoVapqHtKqrfGvWT0_nhXeFqjQVRsp5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JGq01gMRpXZxBGpH"
Content-Disposition: inline
In-Reply-To: <CACVXFVPFqHLQRpd0QBzoVapqHtKqrfGvWT0_nhXeFqjQVRsp5Q@mail.gmail.com>
X-Cookie: There is a fly on your nose.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Non-enumerable devices on USB and other enumerable buses
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JGq01gMRpXZxBGpH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 19, 2013 at 08:17:53PM +0800, Ming Lei wrote:
> On Sat, Aug 17, 2013 at 9:29 AM, Alan Stern <stern@rowland.harvard.edu> wrote:

> > Aong those lines, I would like to point out that the device concept
> > embodied in the kernel's data structures can be pretty thin.  For
> > example, it might be little more than a port number or bus address.

> Maybe the principle behind drivers/usb/core/usb-acpi.c is helpful
> for the problem, and DT may refer to ACPI to describe on-board
> USB devices, and the way to retrieve platform data too.

I can't parse this at all well - why would DT want to refer to ACPI, do
you mean people may wish to look at the code as an example?  As Grant
noted DT already has some mechanisms for enumerable buses which looking
at the code appears to be broadly what that's doing.

--JGq01gMRpXZxBGpH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSEkFXAAoJELSic+t+oim9ZGUP/2B3dNHHkAtNIXAzK9WcLXv6
4smmEHzKQtcpuN6xAZdZk3tFFCHg94i2n2yKkmRaCvw+3OxYKdBN2MRQU0tyYVJJ
oK+/eXn3ODpYdXZouH1cw7WFSxY72jVIZDvEMvvVlKE9RbYE1Q/lpeFpV9BxAZ0s
8tHYdN7w19hO7cS8/kzT8hULAv902ptrDNsq1ftbMNub2WUKaCZVKBuv52N0/DiE
14Pi/VKvNRlMIrMyg8eKmVeBkL+h0RBglOZtqWOayBNflIbcF+0IHZZwtIrqIrHl
4NkOMC0RoDEF+AqTNJ+owdQl+Sve0iu9D+8jr2EVRa0Qbhg4Jt+Lti1ZWzQWQyzM
i7YjcwZG57n0b/5iMq94pOkNucNkdWTv/BQCSagtMDBL5ob8FH/SpPq/+ADSJjvj
qoLZYSyAtYOfvDGXxFpqr3HRZLi6bRS4KLTrtzH/+w0ISURA27X04RxZxNd2/9yf
p/ZVRHE6yjh9NukBAHZXRWsJZ/aOn4eYzXBF+1ACiNjY0p5CfS7+qgY12yZX8Yr7
x9Ywd3qMOnU4hYL+eB+GWj0mpRVIcYk0I5/JuauaAdDQ5YXvq9ElMeEkDbu+JGmB
wO9D81uB2ZQ9IPcQ2QtQZ4iGbF8+1wAm9JuMHKnDb6RVAFpScRoeXbwqnQfwZc99
dKHpHpD8m68OGsHKrr8A
=apVX
-----END PGP SIGNATURE-----

--JGq01gMRpXZxBGpH--
