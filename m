Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab3G3LYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 07:24:46 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49003 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab3G3LYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 07:24:45 -0400
Date: Tue, 30 Jul 2013 12:24:39 +0100
From: Mark Brown <broonie@kernel.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20130730112439.GA15416@sirena.org.uk>
References: <005d01ce8cfd$b1c64a60$1552df20$@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
In-Reply-To: <005d01ce8cfd$b1c64a60$1552df20$@samsung.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 34/35] regulator: use dev_get_platdata()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 30, 2013 at 05:20:47PM +0900, Jingoo Han wrote:
> Use the wrapper function for retrieving the platform data instead of
> accessing dev->platform_data directly.

Applied, thanks.

--gKMricLos+KVdGMg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR96J0AAoJELSic+t+oim939kP/0c5bBmHFjeyJi1xixNEHgqj
rTMFVZkEPOuxh6DG9ofwOJDppltewgPaprjwxFV8a37p8Uop62iqed2aoQ9auY05
av7vTpcy5kZBBlSHLxI5rTqsCq/uVFanetSbfzcaW5Zv2kVYMfjEcGji7C9Irq6s
uAZju/oZuF5BjqQsrpCQoN+ssIWGfwpGLuhq5p031nX23Om14Df4219GVcM4W6r7
afp0251DTPwgqW/Z/eB2mlo+PCBIj4lC5MKGoqhhj1PL1GtuZUCaOOgi+LgDyNBv
eJMHzAHG69m+9+2Cz11hxV2HIwB7OjDt9XXz5Y9RIfNehMUnK4yjAi0Pt7OUorS+
YDJD4j9IGgmbrCQDJ0w7UnKuhPIa9LSEM+B2+ncMW8AKhyBnRY19/Ci9dI9Pfazo
P/r3WaOT3QYIcFa4MialaFCMuNsaNYBX5SXi0WRGyMyTluNl2K1UoMWDM3lOjcLq
ij1hlNNr47Mw1maIlXiN3qvZe5yQ72tF11m97wJORfGzyZB1I0fwYO+S/rTXe99M
diROXsJcaP0WqOqT6x5Urr3Rb5DYx+QwgupzQ0GMOg3xQgO59Nn0i7wZOHIFh4HJ
E1kobeiJLRwP6u1G1S/gMtDPbNHU2y4N7GoJzSWW68umrX2GKZPFrcuVRW6Su2x7
qz44gmA219me3Z45H2tW
=QIj3
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
