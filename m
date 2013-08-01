Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab3HAJyE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 05:54:04 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44542 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab3HAJyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 05:54:00 -0400
Date: Thu, 1 Aug 2013 10:53:38 +0100
From: Mark Brown <broonie@kernel.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Richard Genoud <richard.genoud@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Bo Shen <voice.shen@atmel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Message-ID: <20130801095338.GK9858@sirena.org.uk>
References: <1375180329-4860-1-git-send-email-richard.genoud@gmail.com>
 <1375180329-4860-3-git-send-email-richard.genoud@gmail.com>
 <51F7FBA8.6080400@wwwdotorg.org>
 <20130730204511.GX9858@sirena.org.uk>
 <51F8302D.406@wwwdotorg.org>
 <20130730225845.GB9858@sirena.org.uk>
 <51F98CBC.6000302@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fZWh67R7a8iXbUAa"
Content-Disposition: inline
In-Reply-To: <51F98CBC.6000302@wwwdotorg.org>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v6 2/8] ASoC: atmel: machine driver for at91sam9x5-wm8731
 boards
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fZWh67R7a8iXbUAa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 31, 2013 at 04:16:28PM -0600, Stephen Warren wrote:
> On 07/30/2013 04:58 PM, Mark Brown wrote:

> > You seem to be assuming that the strings are a bad thing.  I'm not
> > sure that this is the case modulo the tooling issues...

> I do tend to think that using strings is pretty evil...

Well, they do avoid the legibility issues that tend to plague device
tree - I don't really mind if they're in the property names (as with
regulator supply properties) or in the data but having something that is
directly legible is a substantial win.  Constants deal with this in the
source but they make runtime debugging more painful which isn't ideal.

--fZWh67R7a8iXbUAa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR+jAeAAoJELSic+t+oim94zkQAJ5lTteMeiZBwkZyS6hAsF7t
o+V3EHASmYxcw8dj+OgXRx2RlmSzN/eSPYk0S3TW1hxBvi93tJGrw417rjmrYN7M
sciDjwGaR7w79+/a1dZYkHMzVAdNf3krK8cCq2lh1rRhQD1H/+6BWsT+9ObrMbM3
Fy98Ed6h1IN7aKC+BKGl3PHQlCWDumz8dIEEjKIodARQvZWdLwzjzkgDrAUZoMeR
C82CfkPm+Se1PLuPLArqX/2vYZGHFHORHrJKWew8VYQ/cxQ7x/BIG4zHU9ejcWS/
0C+g6pmC85fCnzeOLNqKTxPPQe61XGukezYkVm+/m7vkr/YzrdsxcYOXadBHZjoG
FF0ryXyYh/CXUDDHo3sjOGTIYxliRgCxlAgWQIJura+gGIV5nwuqDQem1OAM/622
CaQ6Kfc/P4LZ/Qo5AlYB35DpeSfuUI9ILfapgxWtVqLOYcjyu3AR2waiV/e0Vc+4
pxmn/qKasaxvDLycZ8l/SsgoEbsO1iiyci42YGZuiWkcNlbu4FC1u6PchD9xEVoH
2mS4zR/qbqC2puhvLuuvu6mTFcezWtSjUf+3DNTqlt/WZtLAVg875xL2fFBY5Wym
L9qgyyrOhkB/wUa1Ie6TH1dXB/US6hiLmB5R1nrdSPUaqLnPnsV0ezDVRo3P0BJh
LmsQsRCwDgXriZXbgip2
=pB8f
-----END PGP SIGNATURE-----

--fZWh67R7a8iXbUAa--
