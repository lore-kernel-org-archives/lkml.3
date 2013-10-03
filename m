Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab3JCNHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 09:07:47 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41821 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab3JCNHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 09:07:46 -0400
Date: Thu, 3 Oct 2013 14:07:21 +0100
From: Mark Brown <broonie@kernel.org>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, monstr@monstr.eu, linux-spi@vger.kernel.org
Message-ID: <20131003130721.GN27287@sirena.org.uk>
References: <27e289763bbcb7d10f84081543cfc3a4dc770398.1380793579.git.michal.simek@xilinx.com>
 <cd3d21358986b23653f1ca35d2761fef7f747dd8.1380793579.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lbQeYSs6J2ITmUo7"
Content-Disposition: inline
In-Reply-To: <cd3d21358986b23653f1ca35d2761fef7f747dd8.1380793579.git.michal.simek@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 7/9] spi: pl022: Remove unnecessary amba_set_drvdata()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lbQeYSs6J2ITmUo7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 03, 2013 at 11:46:29AM +0200, Michal Simek wrote:
> Driver core clears the driver data to NULL after device_release
> or on probe failure, so just remove it from here.

A patch for this from Jingoo Han already been applied.

--lbQeYSs6J2ITmUo7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSTWwFAAoJELSic+t+oim9pMsP/iFGIHRIvbNlcbj+eMYYselQ
aFeMyw8WNGKdxcYgk157+a96xGUDI42Yx9BnnrbW/0EetsPMG67R+M7BSDTVie3F
FSyPT5R8OsSDdupjwYdpeHF7N5E+KEfcm3Odu6BNGonnRvnnggVkiQra/6G1f8W3
yrvcNnefbsk14+dLYZx6FDdlIEyCahxjdJWjI2eBSLbxrZGfpiytsP1jtXg88Zre
OqQBwzoyYiskI6RK93NjELjQLN/zRLEGYUMJIeYs/HvOh/L694XMZ2rGbtrLWFHB
hG7dbDO8Opeg3YSRQurlhawCq0/3a+lMW3gKBb9EUe1lQdygQ+3nT/ZAuzg4Nz0R
a+wsQgTyA47euvDK9w/sBgyODs+UI0MYQa6RUw5GsoPxD2q4LEZl86nHl8Y3lKoy
CadV+kjMeAJR1HpD1KdBr0pmb4v150PyEWMlhYbCQLTkZXEDcZ4Gj8lFaOttumG6
PG26qmuDohf1v14ZCkfTqdii83tTzP/4OL9X7UqWOcigTHVOW0esLvRAPcRs1h4+
IZ0A/dbqL2gdULxHkGzVLt0AZEjvj2JBMC+54OP3igHsKDOZ2njFj+60ztLZ29h2
Vy2oFDmh0vZv5EGKQGQ/u4jAFhUVwDtlPixrpGkgl1tqkp1FkDtSA1bCo+q+8/Dq
MwLy3ma/ty/RYtJXCJE5
=N5vf
-----END PGP SIGNATURE-----

--lbQeYSs6J2ITmUo7--
