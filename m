Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496AbaDPQZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 12:25:27 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39370 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaDPQZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 12:25:23 -0400
Date: Wed, 16 Apr 2014 11:22:19 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Roger Quadros <rogerq@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        <bcousson@baylibre.com>, <tony@atomide.com>, <rob.herring@calxeda.com>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <linux@arm.linux.org.uk>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        George Cherian <george.cherian@ti.com>
Subject: Re: [PATCH 2/2] ARM: dts: omap5: Add dr_mode for dwc3
Message-ID: <20140416162219.GI28035@saruman.home>
Reply-To: <balbi@ti.com>
References: <1381402195-29257-1-git-send-email-kishon@ti.com>
 <1381402195-29257-2-git-send-email-kishon@ti.com>
 <52580F34.8030809@ti.com>
 <20140416161619.GH28035@saruman.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rwgQ89ZNnFUwFHTC"
Content-Disposition: inline
In-Reply-To: <20140416161619.GH28035@saruman.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--rwgQ89ZNnFUwFHTC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 16, 2014 at 11:16:19AM -0500, Felipe Balbi wrote:
> On Fri, Oct 11, 2013 at 05:46:12PM +0300, Roger Quadros wrote:
> > Hi,
> >=20
> > On 10/10/2013 01:49 PM, Kishon Vijay Abraham I wrote:
> > > From: George Cherian <george.cherian@ti.com>
> > >=20
> > > Added dr_mode property in dwc3 and set its default mode to device.
> >=20
> > If there is a specific reason why this is not set to "otg", we need
> > to explain it here.
> >=20
> > AFAIK the port is meant to be used as OTG port.
>=20
> we still don't have the workaround for dual role ports, I've been
> working on it but still need to retest and make sure it's working fine
> before merging upstream.

man, I went back in time. Nevermind :-)

--=20
balbi

--rwgQ89ZNnFUwFHTC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTTq47AAoJEIaOsuA1yqRE2WwP/2hnDe666WCj3cTwwkTZSvzU
FRpXnKJadXGKnkVWxBEFAbDM3U8RbxugAz/YcoI4SXfwdRSMzw/y42jrQ5xeH7pt
bfcwqUBmwu+7MzQRrW+u4rDZtMjxV88PrT//75IHBge2JKrLf0bD+q2fjxQZPDup
asZe14KGSgJ+VquXroTRjh3Kbxk5jI2t/Cz7D3wEWu8fmW1mqn4/0g4vuk51XX1L
uzDz5CuDSqreD4UzThXVya68lK6ZyOci2Cq0tgpB9FxQG1NQns0/wfhOwbhBhurB
2xlhk7G5zGQMfuqvUjLdD6VmJkOM4hyZqitQtCPNSx32PvhC2PcAUesolvsHb5SZ
HoRMFFlfKchyUjEftwlLKFTi1214P6I93WZCOGUoRKCjdfnTS7PuhYvk6zZv/AVW
3CTaRct7qnYHN3nDk2sPOBj0lfX0LleSvnheT2h4hRZWRPPfHRBquM7B7mvgAr0k
dVIPyuSpAOgPtzIyx2wUHbWcBEXyjXNiF8a9TPbSdLh2NRZ8iOW0Z5d04Ublj7ES
pMetnUUein5xV05LahaEsu8q7lWW8dqMYXYnYt75DqYQHorHxPskVw0EnKo934Wu
nkDGizJ1zFtZr4W2GhxL/B5smklHxSTrhaqi31sxxzGtsdvYgiB78zX5nQ5eqghx
JsIcqGZpxOuY2/5Sc70X
=yjXP
-----END PGP SIGNATURE-----

--rwgQ89ZNnFUwFHTC--
