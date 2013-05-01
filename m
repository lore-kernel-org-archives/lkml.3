Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276Ab3EAP1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 11:27:51 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43072 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761469Ab3EAP10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 11:27:26 -0400
Date: Wed, 1 May 2013 16:26:55 +0100
From: Mark Brown <broonie@kernel.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <20130501152655.GN26160@sirena.org.uk>
References: <412f8f434c32c557b8c17e73163d003b895e2e56.1366046390.git.sarah.a.sharp@linux.intel.com>
 <1366164906.18069.110@driftwood>
 <20130417182328.GA7690@xanatos>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Vxa5joy26gVGOrvU"
Content-Disposition: inline
In-Reply-To: <20130417182328.GA7690@xanatos>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 212.183.132.78
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC 5/7] Docs: Expectations for bug reporters and maintainers
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Vxa5joy26gVGOrvU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 17, 2013 at 11:23:28AM -0700, Sarah Sharp wrote:
> On Tue, Apr 16, 2013 at 09:15:06PM -0500, Rob Landley wrote:

> > Patches go from the developer, to the maintainer, to one of Linus's
> > lieutenants, to Linus himself. If you submit a patch to a maintainer
> > they owe you a response. The lieutenant (subsystem maintainer) owes
> > that maintainer a response, and Linus (the project's architect) owes
> > the lieutenant a response.

> Do we want to go into this much detail in a document meant for
> frustrated bug reporters?  Or perhaps we should create a separate
> document about the kernel maintainer hierarchy and reference it here?

The rule of thumb I tend to give people here is to make sure that the
people who tend to sign off changes to the driver are on the mail.  Not
everyone is comfortable with git but if they are that's fairly easy to
do.

--Vxa5joy26gVGOrvU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRgTQ8AAoJELSic+t+oim9kAIQAJFx87jlWQlnw+aP58JV7Bxj
sIgnW2TFDwOW0GmzozoplOUnckI83RT959kVjDXY6x50JDB5Kx15QARhXH5J28IH
qPGNbREFhlZzWMNv8cX11EQOCa9bINMUIO4A4Kmh0EXXV119/2YmjKJnxKLBO/Lu
DA/jkuHLWs6Tb/OE+XdkGgIUpReOEDFID3n7e7yDY9NcLO3ualgSi4lhoYuvVYf3
+i0QFRP1j9OMFzsO38dvSNT24vS3EcD9RorGaeXdveQYvwbaFjSf8fSiWM7s9aG1
UIAyS8MyCawgoRQw783kXUO/LKCkRp8T8g0dPpSHCsWtAClMMcmoRB0CGkkuS/+t
zFEF/Ah1yDtTDArqAhnM11f7ATXnFiwu/ya5VSE0Dxs/JK+69L4ZuBJvdmDX4uB7
nlQVqnWTDDAcK6cj9b/nvuC3TKAkQQw12Oma7rp81VvIYRnDW6AK61Y+qcJugFk1
Xklg6Kd6obgMIbYCCnSChx8GYMiS+8lgKxy41MsihSuM7S/bHQazH7hX0CSxYaan
oQcSZdQKECRjoIDjLgNJbV+B7yLN+aZph2l0DYeexHF6VqftmcyoBPxccWRBrqcu
GSOqpDxKwiSu4MYVqzYK3MrBFIysiGQzdP9zqqv6UUnQ/kdAtBbtCkBOQfjIm+nE
tsiQuE+DqF7la8y4CsF7
=TYTa
-----END PGP SIGNATURE-----

--Vxa5joy26gVGOrvU--
