Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab3EVQlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 12:41:11 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51865 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756074Ab3EVQlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 12:41:10 -0400
Date: Wed, 22 May 2013 11:40:38 -0500
From: Mark Brown <broonie@kernel.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org
Message-ID: <20130522164038.GR1627@sirena.org.uk>
References: <1369228886-3527-1-git-send-email-wsa@the-dreams.de>
 <1369228886-3527-3-git-send-email-wsa@the-dreams.de>
 <20130522155628.GK1627@sirena.org.uk>
 <20130522160357.GA2917@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AXAqmCxJPvkQLT2P"
Content-Disposition: inline
In-Reply-To: <20130522160357.GA2917@katana>
X-Cookie: You will have long and healthy life.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 144.188.69.1
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/3] sound/soc/fsl: remove leftover release_mem_region
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AXAqmCxJPvkQLT2P
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 22, 2013 at 06:04:00PM +0200, Wolfram Sang wrote:
> On Wed, May 22, 2013 at 10:56:28AM -0500, Mark Brown wrote:

> > This doesn't apply against current code, can you please regenerate
> > against topic/fsl or mainline?

> ? Works fine against v3.10-rc2 here. Or is mainline v3.9 for you?

To be honest I didn't actually try mainline as I wasn't expecting any
conflicts from the branch and it didn't seem urgent as a bug fix.

--AXAqmCxJPvkQLT2P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRnPUDAAoJELSic+t+oim9rNkP/RsmFHXy0jfIOVWB2pCkgDhk
ow5HhbzqWYgbI7wdbvq20dzddtWPSJzmZEohJ/jwKTnxInuZfaQYZ+b1+FPsoCue
Nv8nk84pIwmgmpz8meCL1cAG0wHMOJrudZAkqsUYgBwu0I+IOIjbtG+i6IJbMAJT
twQmoRWQEOizBUWoYtf07+gnETjKrilfALSa5AigZbRmD9K6oR6irgwi/Y5luOYY
CSicTQcTWnJLmKkau0pzIUzILRItqn6meFMjcwTeMpTpXRYab7n4uDUmkoOrIbUL
vLlFLHoWYhrcPbjNxIOGfP/YIOJ01/1pR3ALDFfu1njBB8jHdquSPxOexMDSN+/g
8Lh9SpmBdR2sP4TUcRCp1wYw9gxKmKD3O5IL6nUH4oycFRnf9rC0Dv7kQoavvbex
FBAOdmCTLp5T6RmQdZMWjwsLIb6nsEVETM5VsnD0V4DsNrDTHpAophNjKG34ayaQ
OYCLAJGyuxQnnVHmOqIdT2adCqEO0BXip2wgqPejpGvVdP3CVkXfBQf4yBCUoXCt
MJx74jHzqqLbJLbhqAt0LAl6FX9Nv8mbIK1TxSv+/tqGZ6j+SApQBqah36MWXqt+
57oR+Xco/rhcHdrvpIf0zAr/TaCFF05OnhoV9DHxhrep3cGZW63sZOoBYvR3uQw6
5WbS3Udezdjn1g+rrDdb
=vaOs
-----END PGP SIGNATURE-----

--AXAqmCxJPvkQLT2P--
