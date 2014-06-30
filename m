Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875AbaF3Svy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 14:51:54 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38852 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162AbaF3Svw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 14:51:52 -0400
Date: Mon, 30 Jun 2014 19:51:39 +0100
From: Mark Brown <broonie@kernel.org>
To: Tushar Behera <tushar.b@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        dianders@chromium.org, kgene.kim@samsung.com, tiwai@suse.de,
        lgirdwood@gmail.com, galak@codeaurora.org,
        ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org, trblinux@gmail.com,
        Wonjoon Lee <woojoo.lee@samsung.com>
Message-ID: <20140630185139.GF23300@sirena.org.uk>
References: <1403251396-17487-1-git-send-email-tushar.b@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OM63UbYQsNeyh2dn"
Content-Disposition: inline
In-Reply-To: <1403251396-17487-1-git-send-email-tushar.b@samsung.com>
X-Cookie: But it does move!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] ASoC: max98090: Add max98091 compatible string
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OM63UbYQsNeyh2dn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 20, 2014 at 01:33:15PM +0530, Tushar Behera wrote:
> From: Wonjoon Lee <woojoo.lee@samsung.com>
>=20
> The MAX98091 CODEC is the same as MAX98090 CODEC, but with an extra
> microphone. Existing driver for MAX98090 CODEC already has support
> for MAX98091 CODEC. Adding proper compatible string so that MAX98091
> CODEC can be specified from device tree.

Applied, thanks.

--OM63UbYQsNeyh2dn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTsbG4AAoJELSic+t+oim9MmcP/RKT93/dRKmZEoSXaeISq6Up
n+4O0BDxLY+Awb895ctTuP0Nlq5yAx8GMh27mcTL5skUWRcxbNP8GMbFPUduNoVF
G1F6rsYPCAgr7EoC1EJfMe0LpXXq+sFfw9Zw4knKReTqBxEwAfhyOqcmOiiLf9hD
ERsT+0mCoGbuk5Wr8egINRtdpFwkSONCyoINRKirw59W/DzehuUF5YDiaoNdcieF
3d5kYF96cbyIK+nLFhDMQz7xoXuWkM6cJjCRZXqxqyIhLarN6Jkpv22xGXNgn7mJ
qA1YXH/tuM8DRb5hyKw9HOXdsaiiDzIBmNxbxjIYNfD8XkKGWrAdFNK+tOmNtB+z
VhjISgq9Te58LzsoftE7t9mwzNdH+JbP9FWiWBpwAf7aP0q3qtbW97EoADM4dfp0
aThc1okSM5klz/R/2R0LLuoIW+Ps+AKWAWwTrPTuFBSZGTcnMT/kPWGq7KMFHAyF
tklNAayw1KfH2fQGRF0ICQKnHvmcaCiHgvQYseapBwPE6jiK6I8ZRcNxZVCVx2+p
yC1y3pU0mn1EJ0KfdLtSmde9HvJZLv1L13ErKZ4/u+ns3r9ejXGEeSvb4AceYMew
iPk/lkyLtSdGP/Gn2gq7bcPKqrQNTGduIXYAZonhFTu/UF/zQ7GH8aJs8JB+oKlM
GwRbDYyp0RGjXiagz/AN
=Fqkg
-----END PGP SIGNATURE-----

--OM63UbYQsNeyh2dn--
