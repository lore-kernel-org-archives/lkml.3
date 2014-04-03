Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbaDCVul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 17:50:41 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50965 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbaDCVuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 17:50:40 -0400
Date: Thu, 3 Apr 2014 22:50:27 +0100
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Message-ID: <20140403215027.GD14763@sirena.org.uk>
References: <1396535537-1352-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PUgybOivvlPvn0/l"
Content-Disposition: inline
In-Reply-To: <1396535537-1352-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: To make an enemy, do someone a favor.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] regulator: core: Add of_node_get to
 of_regulator_match
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PUgybOivvlPvn0/l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 03, 2014 at 03:32:15PM +0100, Charles Keepax wrote:
> Currently, of_regulator_match does not increment the reference count of
> the of_nodes it takes new references to. This could cause the node
> pointer held to be invalid, by the time it is passed to the regulator
> core. This patchs adds an of_node_get when we copy each of_node pointer
> into the match structure.

Applied all, thanks.  You just made all users of of_regulator_match()
buggy - I'm assuming you're going to be fixing that!  :P

--PUgybOivvlPvn0/l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTPdegAAoJELSic+t+oim9HI8P/2Sb5N/i6U7QB8v/wYut9VpP
iz78JpVDKPsh4GmZV3010bTQ6JatfG47/xXP0+jBJcjCu/vzVBXFCtRGMnc7gxO9
VRq1O6/LnnmrFJV8OTGz4fFbqF2lGsezROI2plHli+EkGIKTZUNI5DiCG2GXpuCu
32rzvd+8chSPEUCWKMdBRiLMsv4dsbFQBHY2Y9WVlm61qX5BZ+H9mtDZg9xN9s3w
Rt7N2h2xWoL4txFAf90o2VxyfAAlk7HdAe3lW9flxr/X2Zp73UUJ7wAPExNa1Oka
C9k/aU8+lnfJyOtmB3v/MQ2ju8IbyvNsCX5awc+PCBLIrKlZZsmnjCy7orira+UD
5+qpCVTZ4hLDW/W7ifhShb3jKItJ5YmpkjVUxNFI+hkc09UeLiN4N4FQJAT2LwIy
NyudXavzwnJ3EhJirZR1sTxNduzxFvi3VTHRqlD6x90WR2qTgcTor/DYUIXTYA37
QGCXvOAy7pJ6SpjhcvUKtWMYyJn+hgZia0+RHn5+Tcn/HntLycHFp8DZAq/T3fM+
E/bHdan6QcnZUnQ1AifApg3D2fN59QjdVm+FB1CsmOaurDZAk4opF4SsGGZoB6oT
EfYhfQkiUfwmNkTnhLUy0XSkP88QBkIAxI9vnPNUwvFfWIBcDocPlhlE0Tw3JZQV
NeooMoOpyaT+8xcd0gAR
=lWpL
-----END PGP SIGNATURE-----

--PUgybOivvlPvn0/l--
