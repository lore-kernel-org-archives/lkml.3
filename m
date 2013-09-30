Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab3I3Nc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 09:32:56 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45606 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378Ab3I3Ncz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 09:32:55 -0400
Date: Mon, 30 Sep 2013 08:32:30 -0500
From: Felipe Balbi <balbi@ti.com>
To: Ben Hutchings <ben@decadent.org.uk>
CC: <balbi@ti.com>, Luca Coelho <luca@coelho.fi>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, Pavel Machek <pavel@denx.de>
Subject: Re: [PATCH] ti-connectivity: add wl1251 firmware and license
Message-ID: <20130930133230.GC2455@radagast>
Reply-To: <balbi@ti.com>
References: <1380033894-5007-1-git-send-email-balbi@ti.com>
 <1380107096.4503.8.camel@porter.coelho.fi>
 <1380107278.4503.9.camel@porter.coelho.fi>
 <20130925132359.GE10746@radagast>
 <1380512269.1441.10.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XMCwj5IQnwKtuyBG"
Content-Disposition: inline
In-Reply-To: <1380512269.1441.10.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--XMCwj5IQnwKtuyBG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 30, 2013 at 04:37:49AM +0100, Ben Hutchings wrote:
> On Wed, 2013-09-25 at 08:23 -0500, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Wed, Sep 25, 2013 at 02:07:58PM +0300, Luca Coelho wrote:
> [...]
> > > Ah, and I forgot to say that you should update the WHENCE file
> > > accordingly too.  Check the wl12xx and wl18xx drivers for examples.
> >=20
> > I'll send a pull request, but how about this ? I don't think we can
> > change the license. It seems like the other firmwares are using the
> > older license, I'd argue those should be changed to the new one, but
> > that's another discussion.
> [...]
>=20
> I haven't seen this pull request, so it looks like there is nothing for
> me to apply at the moment.

yeah, give me a couple more days, I need to finish something up here.

cheers

--=20
balbi

--XMCwj5IQnwKtuyBG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSSX1tAAoJEIaOsuA1yqREP2sQAIOcvGcxARmAJNbAqJlnzp+0
da1RnaxE5Abmg2WQBmzYPYV4cFq+Nu8dU3C6HCdzo5nFP6Ht52rjTsc4iH3SF77k
mqDCWvaMbicpQFzym5f2KwA2NHx2gHkCY80EcLGozN16DNryIqKm9MrGVWZYSK/X
vDn0Dif5Jh0G+xtJpiNEJjXFhz0PesnMZiAaE6gvDUAN0IILnWy76YeGAexan/H5
6hWrMdirHiQkGoqCP7Yvqi2EvuWIwP6pg9bqulJi/hn/pbojfOVeJaob/HZIBlWX
OkSCTGPcLBTFEKiuBiMRQictrFg4yY3WM6y1ZF2h0NN2js1wcFFx+czuKWMDe78D
hvnB9ZlS8miH2agffCMexEFXUXmoGlfKk4c6UJKNkBn5eIrJMEccHbuqkJDKEcaL
HbgbaIGRWUCEihANE9MHJBOzqvFz/L07AWFjvtZIQEOk0CgTCocEG9FKCrupoBBt
0gJ1cWgbdqCtXpS2Zy8YzTi48GtqcQNN0aG0dKnqmOEtPPRasGK7kF4SMkCXvlEe
fodqHkjGYfH4Uop3kbL05lsB18rn/pORipgSD1mMJxsOFWVPdcEJCGGpAU9fv2Dg
NgbGCV24S82jfxOkPIIMaqgjfCViQuIeGhgUjL+GoJJQoZukQHyk973WplTRk+j0
+EXbe2ALa7Y90ywK4Ybj
=Q91R
-----END PGP SIGNATURE-----

--XMCwj5IQnwKtuyBG--
