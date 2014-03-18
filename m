Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286AbaCRRdf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 13:33:35 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37736 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbaCRRdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 13:33:33 -0400
Date: Tue, 18 Mar 2014 17:33:13 +0000
From: Mark Brown <broonie@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com,
        Sekhar Nori <nsekhar@ti.com>, linux-spi@vger.kernel.org
Message-ID: <20140318173313.GG11706@sirena.org.uk>
References: <1395154561-1199121-1-git-send-email-arnd@arndb.de>
 <1395154561-1199121-2-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YOiw+WO4Gc95oc3L"
Content-Disposition: inline
In-Reply-To: <1395154561-1199121-2-git-send-email-arnd@arndb.de>
X-Cookie: Turn the other cheek.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] spi: remove obsolete spi-ti-ssp driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YOiw+WO4Gc95oc3L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 18, 2014 at 03:55:59PM +0100, Arnd Bergmann wrote:
> The tnetv107x platform is getting removed, so this driver
> will not be needed any more.

Applied, thanks.

--YOiw+WO4Gc95oc3L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTKINWAAoJELSic+t+oim97fMP/ipb6+Fv5LyNnhu94MD2M2lU
Xwq30lZRIkJHF9nlNPu94Sr75StwI7H5B8olqYr+Us8I+BKEXq9FseK8TrO+W3j/
2PcI3M/TU/El8AT8mqpwLv4WNM4ikOoPN6xfssAxMR2j+qhGcXlYM+1QfMCogNuu
UiZAWz8g4ZmhgIf1i1LYajGGq6mNpQTijjLRqF5GETLNPqlyMXQ+BwN2EIitUwe+
WGiLfxNwjpKVBWQ92st2FAWNymUkAodb/10ssmeomac2foJ7o+zCTPJZ0ASIbE63
71MGh33SxeNRtbZT7f3kD9lNMzaYWpDfasdL63/fgNoBrb4H6++7piqmk4pjjVVI
dRh7T/TMhl9QSsf/EmuMvaEIK472JkgtFdWgC1KdpuKFrFhbb3j6JCkCHzFWmTVP
1EfzStgQ8v3TdBPA95ElNmbdMNr/wsmNY46E1tnJLQZQlhM80nUIPA5y5XHkbH5Y
ifbDAxJkY5psyxPw8xwyzA1behrvutfmn7oObAd5ErV6Pwf1qBFQb7Y12rQDSiRh
gVdxnaC4XdNdJAcuo8JT9kbX+nFz254jW7S1XZFpx172vliGJoE4sel8JzRl8e3A
u7+Dn9uJsqZPieibPJv0pEl6B1kK412VRTX1Cjc+EZhsmAmmzaLDIhJWegLDfJ6a
yfP4jQHqtP60UXPt4inj
=Pxrh
-----END PGP SIGNATURE-----

--YOiw+WO4Gc95oc3L--
