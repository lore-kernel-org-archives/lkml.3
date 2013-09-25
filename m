Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab3IYM4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 08:56:10 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40112 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456Ab3IYM4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 08:56:07 -0400
Date: Wed, 25 Sep 2013 13:55:38 +0100
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Message-ID: <20130925125538.GP3226@sirena.org.uk>
References: <1379960073-23245-1-git-send-email-broonie@kernel.org>
 <1379960073-23245-2-git-send-email-broonie@kernel.org>
 <20130925111954.GG5132@lee--X1>
 <20130925113103.GN3226@sirena.org.uk>
 <20130925114643.GH5132@lee--X1>
 <20130925115502.GI5132@lee--X1>
 <20130925123536.GO3226@sirena.org.uk>
 <20130925125139.GJ5132@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v9g2r9e2kvGs7M7R"
Content-Disposition: inline
In-Reply-To: <20130925125139.GJ5132@lee--X1>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3] mfd: mc13xxx: Move SPI erratum workaround into SPI
 I/O function
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--v9g2r9e2kvGs7M7R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 25, 2013 at 01:51:39PM +0100, Lee Jones wrote:
> On Wed, 25 Sep 2013, Mark Brown wrote:
> > On Wed, Sep 25, 2013 at 12:55:02PM +0100, Lee Jones wrote:

> > > https://git.linaro.org/gitweb?p=3Dpeople/ljones/mfd.git mfd-asoc

> > Thanks, could you include the first patch as well please (there's a
> > dependency for bisection due to the BUG_ONs)?=20

> Okay, done. Same branch.

Pulled, thanks.  That URI isn't directly pullable BTW.

--v9g2r9e2kvGs7M7R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSQt1HAAoJELSic+t+oim9jdgP/jv41dbYWWtFgmmrUSw84Xth
MekE1Dm+57Vh8EXATIW60nbOO3lcg72msJrg+fdDzQasOWCbzb6AbMmwNYqp5kQt
pZ1iRoHX348+De5rNeLxz5+V8gthqw0IET4dk2Dj8DKlCKABn7+kjvkgm228OMm9
0+UoM3u4RvaxZNFNTJPpSn2C8EV5kmzJcQIDdMtxcKc56NztnU45YDWTBjRUs1tn
xYZ76nK00/m9oLGmD+C4sN8W4H5+3UkuQqfqbUGnxIsmkvQ65qB//XnDy3bAJ6ZJ
StgzG89pgqIY4mdyEGRdU3ItWscNfOq9b0VEG7QBkXHRCvjlms1w5L0H6BK0e5cJ
4PH9nblKs/RbVJt2wKK/8fRKJGOT2R+a3Pivu6sRm/tEpBC4h7Ua3VPnhdRjNMv0
v27jmAhslp7DuS3x19pckaKuuvo6Op0Ef05cLuZLnn9vYeTUxtSYywdC4v/Vc+E7
6z9mtkQN2qPDY/zffQGdVGuHvhwJl7e6mj7q+ysb3sxdmp+krY2YBQHt4+TuT4Zd
LX8DzW8L0C0rnTVwcUXzpZ/bEfKa0jmdVIYUmzh4NwZmLLS0O08EoIYI96ZwAnnh
iEy283XMreWR9VLwlE4APcwrHlgQYa1kXVSZBSguVOn858yawLtDvjytgCz5NAoe
4y0qKFrt1D1xVIDYk7Xg
=4r01
-----END PGP SIGNATURE-----

--v9g2r9e2kvGs7M7R--
