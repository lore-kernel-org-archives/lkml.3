Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbaBGMPQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:15:16 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37690 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765AbaBGMPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 07:15:11 -0500
Date: Fri, 7 Feb 2014 12:14:40 +0000
From: Mark Brown <broonie@kernel.org>
To: Bjorn Andersson <bjorn@kryo.se>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-ID: <20140207121440.GY32298@sirena.org.uk>
References: <1391493268-3242-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1391632226-10060-1-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O2izrSG9ltmUPm45"
Content-Disposition: inline
In-Reply-To: <1391632226-10060-1-git-send-email-bjorn.andersson@sonymobile.com>
X-Cookie: Take it easy, we're in a hurry.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: Allow regulator_set_voltage for fixed
 regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--O2izrSG9ltmUPm45
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 05, 2014 at 12:30:26PM -0800, Bjorn Andersson wrote:
> Make it okay to call regulator_set_voltage on regulators with fixed
> voltage if the requested range overlaps the current/configured voltage.

Applied, thanks.

--O2izrSG9ltmUPm45
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS9M4tAAoJELSic+t+oim9b8wP/0QmgbBlkplFd+vaeoDYAnyj
shHBPqQN6N0CcJgBEptO8kWqkGDPtrMmWKJPy3jGmwsgG8H64jQKWiFLbrKlDDSz
CV6oTEvLh/b2rAPVY7kliNn52y3ecD9iXa2B8LuSIdPo2ElSXTiKDSz67/UjUzxn
zteaQjR/FQT6LCJI+4tk6zzgk2Oa03UVI9fsgi7Ck8lmx2PQlHR5sCeVJ2DAjvPk
EyP9NeH7VGAG3mrrSv3Plgio1nBnW79ZCzRFZdPr8K4pgteSBjirMtc8YAV4w+On
yVs3+zALTTD6p0nKNRe6L19XCTBBgphNME59ScC2Gl2BJ2BtGfQ5Q9VzgnI4hGR8
2d7AZv4bmO3sWrcVfBeOdy34GIG6CVxt6C8MqWA0t8fW5oXDV2gMvykdwdcaUlh+
ut0P9KvJQJd2Vvi77cG962fd3lEk/pYZ3bVtpfhEuiYoLTaUxlZXlXVyjzGBk20x
G22bpZKN43WkPt98Mtv/vsbh+IjrrHBZ7DsF03xQnHG+WjXCJgYTHOTKHhiqrEql
xQcgw0clYVBU9c0U547317q7RoeK3DJahN671SVeDkatGtf6/jY9jjAnoj+gauCd
CFM/zEilZKyGxCPrtg9zgnqvDoEZDTC6MOzqHRLi/cfk2wy8flTTZ91MXmz7Tq3O
octgeO9vaTxTPE0I0M+K
=J73y
-----END PGP SIGNATURE-----

--O2izrSG9ltmUPm45--
