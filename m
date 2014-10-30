Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730AbaJ3K71 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 06:59:27 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56976 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758162AbaJ3K70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 06:59:26 -0400
Date: Thu, 30 Oct 2014 10:58:48 +0000
From: Mark Brown <broonie@kernel.org>
To: Mike Looijmans <mike.looijmans@topic.nl>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org
Message-ID: <20141030105848.GU18557@sirena.org.uk>
References: <1414570560-10320-1-git-send-email-mike.looijmans@topic.nl>
 <1414570560-10320-2-git-send-email-mike.looijmans@topic.nl>
 <20141029123005.GH18557@sirena.org.uk>
 <5451DF10.7030605@topic.nl>
 <20141030101555.GT18557@sirena.org.uk>
 <5452131F.9000307@topic.nl>
 <545218B1.8030306@topic.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3qdiFAD7DM00q+Z9"
Content-Disposition: inline
In-Reply-To: <545218B1.8030306@topic.nl>
X-Cookie: FORCE YOURSELF TO RELAX!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] Add ltc3562 voltage regulator driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3qdiFAD7DM00q+Z9
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2014 at 11:53:37AM +0100, Mike Looijmans wrote:
> =EF=BB=BFOn 10/30/2014 11:29 AM, Mike Looijmans wrote:

> >So I should add "regulator-default-voltage" to the generic code? That wo=
uld
> >indeed be better than trying to do it into this driver.

> >But would that need a separate patch for regulator core to add the prope=
rty?

Yes.

> Hmm, I looked into doing that, but that isn't trivial, and too many devic=
es
> will suffer.

Why would this have a negative effect on other devices?  Unless somehow
the other devices add the property they should not be affected by it; if
users do add the property presumably that's because it's doing something
useful.

--3qdiFAD7DM00q+Z9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUUhnnAAoJECTWi3JdVIfQutIH/RMo0S1wnX1IXdy5Zm25HTu/
HOCfSrVcIJUKEzwlZ+H5DuQ+NrLX6gbVCNKsYknK8m2PhdxlTTPMTJe6ruQ1jmvK
tLonLxuUSm9pdbMPcX1apZXWiivNqsbf++3Jiltk/OI8rh0Cy1W5zUiUeD4YsGIO
mihbKZMJl4AMs7/pNzuno52c81Ft/F0Jcd2WVuvJZ6O1xSMBz9yOUqVbW0miFcbk
lgT8OMF+UJh3M5BQp7YBoRHEH4oar9E+THlvUNqGWangbkOTS7eF0KlslwJ3sMtg
h9v59XIKucokHubpXN5fnnfXHl2hAJz8yLw+mMfQ2YBpgkKdHYuhq9W09HFtqRA=
=Ojke
-----END PGP SIGNATURE-----

--3qdiFAD7DM00q+Z9--
