Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbaFDPot (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 11:44:49 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53329 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbaFDPoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 11:44:44 -0400
Date: Wed, 4 Jun 2014 16:44:07 +0100
From: Mark Brown <broonie@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Message-ID: <20140604154407.GM2520@sirena.org.uk>
References: <4605709.T97aRyQTUM@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XbHSybK3LHOYQtWI"
Content-Disposition: inline
In-Reply-To: <4605709.T97aRyQTUM@wuerfel>
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 109.148.252.180
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: add regulator_can_change_voltage stub
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XbHSybK3LHOYQtWI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 04, 2014 at 04:46:00PM +0200, Arnd Bergmann wrote:
> When CONFIG_REGULATOR is not set, we cannot call
> regulator_can_change_voltage() from a device driver, which results
> in a build error like

Applied, thanks.

--XbHSybK3LHOYQtWI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTjz7DAAoJELSic+t+oim99eoP/3zBLkyjQbnB2Ry6yhy1/THU
qzehf6ZMfuelU58G/qnXGRuKwInkNzPYVnzgQJ1GS911wT6UjRGVrOC7rTItvl4S
He59u1tcWUHeXZ5F+ZIQJ+dnFoysx5rS3S/lo/6ivFSqoBCD7828AbjAY9hJDCI+
b/3sDlkp5Cu/o2WjY5jtY3LED0ok3smxnMZf2M4Zk7Qq3NcZw9zEhW9i0w2ECgS7
QmB1DlLM3mpre1EicJ0OqAO4IcB0G1CjxSmiJzkOK6z9V0ugkWGt1cOIXUvIm+BA
gaL2iSzFpL/U6bJy8MT1FuXmjNlgj7evPazAG0eCrB7B9rUMV52UDCyp4t/Gu97d
CgGCsKtoNi4FYpLrsyME+7+enWVF7GOUUf6Lg/LL3MU1TOSxSlPO/7hvNzC8r3uN
b+R7KjrxlV++IN16q/ggcaJnY6Cfts+pbSMskNu92xcbUX7BbzCFyjL6aYvC+dva
fNy14nzPi+SMtLqtVlXaRlwVU22vMB9XW9WrthDjyNg/4Y36r6BWPXMPvSh+Ur9h
dojploYBdm5K1fo/No+hTAuJDVv93XT6QLGxqwNLNu5jfxnCxfeCHG0ng6Pd4ZaP
mvdKixY3qY6l6ZzxhWYFU16kCpIvpPEERWpypKKLDsTorVrMQCJce/EB//wKIpRs
c7W3f4zRG0JyZiISBCns
=5Jyd
-----END PGP SIGNATURE-----

--XbHSybK3LHOYQtWI--
