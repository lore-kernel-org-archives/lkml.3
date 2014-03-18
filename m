Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757855AbaCRUSq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 16:18:46 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57475 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757508AbaCRUSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 16:18:45 -0400
Date: Tue, 18 Mar 2014 20:18:38 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: alsa-devel@alsa-project.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-kernel@vger.kernel.org, Xiubo Li <Li.Xiubo@freescale.com>
Message-ID: <20140318201838.GA1693@sirena.org.uk>
References: <cover.1394883134.git.moinejf@free.fr>
 <1cf50fea2306bcb05987533042dbf1495b2c6f07.1394883134.git.moinejf@free.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
In-Reply-To: <1cf50fea2306bcb05987533042dbf1495b2c6f07.1394883134.git.moinejf@free.fr>
X-Cookie: My haircut is totally traditional!
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 2/4] ASoC: simple-card: dynamically allocate the DAI
 link and properties
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 15, 2014 at 12:09:39PM +0100, Jean-Francois Moine wrote:
> The DAI link array and the properties (fmt, sysclk slots) are
> hard-coded for a single CPU / CODEC link.

Sorry, I dropped this patch - it conflicts with Nicolin's patch to force
the two ends of the DAI link to have the same format which probably
isn't the ideal fix but at least allows sensible looking DTs to be
written and parsed.  Nicolin is on holiday and I don't have any systems
which use simple-card.

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTKKobAAoJELSic+t+oim9xbkP/3R58B/U+uuKlXBfhjaeqN1J
b60R899vM10T7DIZedPUWL3o6erl9qbSyZiTku3rsrJtKFklJsGeF8xpcJTkNLut
b7Vp+2bMrMx886DWegAFoyg0/kz1cT/xNWnuP3ve9dGNBsTLvajIIdlNDPwuWFBM
JuJlSBBmKXZwq4Wl68Rhq5Wib+PrflckJyK7IcehtmVDEZZYBD5uhXi8abaiEdEf
YBGQHWf+npv1mA0ZI6UnEXxHkuPyka4Sca+orOQG1Xxdk6iXgzgQNy4QL5WHbO8D
t5sZGs1f5KORHGadZME/MPAZM3dbb0WEkL/vEnobJZnWLYFtj4maLmu8sF5RPTxK
PnEZNSbqCLZ0YUbuYsyrShRt3VllNCM78jGWiuiXO5nsxdvX1Lo3IGef/bfK5JQK
3qmXLlQEZgX3cnfWqFrsV3f7gknVbDIQ2YDcEygZk2UhewerlaHdx0GQX/vrjzPd
OhFC/y6YRPBlMG8D8z8ZSP7SBW2NV1lVfjcmxVNGICeXjJaVUQ4Wfiu83n6cPY25
U+1mSBbP/LsVfvyjXknnzP7l7UsMq5tBMNqJsanoaFHUx2KiMrDY9E5IdRfI7x4a
p4kIx0rKXLFIlPUS6pcNnDRdYv8fYg/1HJKmr2J/3u2o3wDl7IZOrlhUbhZ59Zsx
ezsnUY9d51i3Ec/U5/O9
=TTin
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
