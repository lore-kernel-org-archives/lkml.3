Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808Ab3HAPYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 11:24:24 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54210 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725Ab3HAPYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 11:24:23 -0400
Date: Thu, 1 Aug 2013 16:23:56 +0100
From: Mark Brown <broonie@kernel.org>
To: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20130801152356.GW9858@sirena.org.uk>
References: <20130731131627.GA32631@opensource.wolfsonmicro.com>
 <20130731132522.GP9858@sirena.org.uk>
 <20130801151336.GA1112@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l+pUxxqDKySPXtXF"
Content-Disposition: inline
In-Reply-To: <20130801151336.GA1112@opensource.wolfsonmicro.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: core: init delayed_work for codec-codec links
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--l+pUxxqDKySPXtXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 01, 2013 at 04:13:52PM +0100, Richard Fitzgerald wrote:
> On Wed, Jul 31, 2013 at 02:25:22PM +0100, Mark Brown wrote:

> > Why is this better than pointing at the normal work that you'd expect to
> > be used there?

> By 'normal work' do you mean the close_delayed_work() used for
> standard PCM DAIs?

Yes - making up this empty work doesn't seem like a robust approach.

--l+pUxxqDKySPXtXF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR+n2JAAoJELSic+t+oim9b+8P/14vvuE2H3/wOa8+XFu5TNx8
zY4ryRH5SXvL1CDOmOth16EwDjI+bqeDB7wI0MzafaE1MHOCHW84KLR0Bhso1c2E
KDTecSl5geJkimJPiqlEJfbLK0VnP+rFQlz6aEBpl310+vs7krLxOJLxZKDgQJDG
81WL5MD6gMfr/AoFyg8LIxDUE7oYe9NwWHoDwZaugO81AckOBuVHB4b1q6MppTbQ
xkCwx3fAnW5/suUj/aaA2IaWFIeHh5gDko+JXmJH/m0ddI/Kle3Y82Z7Fcde5BIQ
TqSWsW+JI7jbwPzpyOG47oBUc2ydPJ/+pPcQemU8Vi3pPuAibG2id5OYLHfVkeLS
/hJkPxFEXrorZUbfUSwV4KnICQTy1lP9007Lu94N29PEAFXoiLf99oSgDSePHIo/
mEinb8TkpNlq5sH/WI4sg4mD/xQkuVIDsbfhtamG492lbwwOi7k4Zc1699BNv/GJ
p50+WDv8Ck4BIIaQ86z0pKj6pP8pR0eV7Vv2pqx6co9EqALYBfYFTTaUd+7G6V2Q
oAcDBBp9CKUBYTAlP+uSHoEg6Z1DY4lncfIOmy8AXTUnWKBX6zu9U4qBMEw+PM9z
5uyildvUtKiv7ulODxtsuN1UWTgc9cpjwKb4hT3xdIW2PWB7qvqxEOmIvBMTvdXk
3RX5u2zoMCrsboq+AEqY
=4ws9
-----END PGP SIGNATURE-----

--l+pUxxqDKySPXtXF--
