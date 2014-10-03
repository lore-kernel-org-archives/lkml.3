Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbaJCPJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 11:09:23 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60588 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbaJCPJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 11:09:20 -0400
Date: Fri, 3 Oct 2014 16:08:07 +0100
From: Mark Brown <broonie@kernel.org>
To: Dmitry Lavnikevich <d.lavnikevich@sam-solutions.com>
Cc: shawn.guo@freescale.com, kernel@pengutronix.de, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, lgirdwood@gmail.com, perex@perex.cz,
        tiwai@suse.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        alsa-devel@alsa-project.org
Message-ID: <20141003150807.GD24441@sirena.org.uk>
References: <1410854903-26419-1-git-send-email-d.lavnikevich@sam-solutions.com>
 <1412342336-25700-1-git-send-email-d.lavnikevich@sam-solutions.com>
 <1412342336-25700-5-git-send-email-d.lavnikevich@sam-solutions.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AkbCVLjbJ9qUtAXD"
Content-Disposition: inline
In-Reply-To: <1412342336-25700-5-git-send-email-d.lavnikevich@sam-solutions.com>
X-Cookie: The coast was clear.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 4/4] ASoC: tlv320aic3x: fix PLL D configuration
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AkbCVLjbJ9qUtAXD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 03, 2014 at 04:18:56PM +0300, Dmitry Lavnikevich wrote:
> Current caching implementation during regcache_sync() call bypasses
> all register writes of values that are already known as default
> (regmap reg_defaults). Same time in TLV320AIC3x codecs register 5

Applied, thanks.  This should really have been sent separately to the
other patches - it's not in any way specific to the board and there's no
dependency in either direction.

--AkbCVLjbJ9qUtAXD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJULrvWAAoJECTWi3JdVIfQtooH/j0VRfy0vVnHUBnkWD8aN55h
H1Mn+9YdAXAGhgyq23BlFndWvmxRvDpj+CwN6vQpQTkn1na4QV9Uw3QKCdP22hBm
ZUi/Y5BXkmi8dn5L26w0WPcV6/gfwSkemCy3WVPVlb1AFg1W8lkdfwuWlW26yxO2
shuK8KXJ/BzNH8/N0fDi1aZcimpnxWVOBiYmJcpQc+BmNMm6kMPCNNHwTwq+Ij9h
oePetN3sBFTm+n/X6tLV7t7nai11O/SWdAYt9/WmVXpCHGXIctdpYtLJ5fDWwocw
dB2bWHbm263tVElpHhlKnEunGmQ0eGWCnmAbD3TS+FIZRMapq5AHuWdM808QYL8=
=m9N/
-----END PGP SIGNATURE-----

--AkbCVLjbJ9qUtAXD--
