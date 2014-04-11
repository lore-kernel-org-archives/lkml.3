Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbaDKLKQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 07:10:16 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48646 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278AbaDKLKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 07:10:14 -0400
Date: Fri, 11 Apr 2014 12:10:00 +0100
From: Mark Brown <broonie@kernel.org>
To: Harini Katakam <harinik@xilinx.com>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        michals@xilinx.com
Message-ID: <20140411111000.GA28800@sirena.org.uk>
References: <1397198188-8602-1-git-send-email-harinik@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <1397198188-8602-1-git-send-email-harinik@xilinx.com>
X-Cookie: There is a fly on your nose.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] spi: core: Increase timeout value
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 11, 2014 at 12:06:28PM +0530, Harini Katakam wrote:
> The existing timeout value in wait_for_completion_timeout is
> calculated from the transfer length and speed with tolerance of 10msec.
> This is too low because this is used for error conditions such as
> hardware hang etc.

Applied, thanks.

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTR82FAAoJELSic+t+oim9Z/IP/iBaI4waLUagyfvZQr+pvbjR
0/SPeFko1XQ4zw6zsczxkfDwQHlHyUrsOvwQemGUlK6f97FxVm62FYbSfF+xkJ17
cfOU+nlj2AvdhOdVLXGn//1+N8EvBX37XtrBJDVSX895QPXsEPyEalPZAh3d5XpY
tYDWX7h4VVWYttOOiBg3Hb0kJCHHCo3vNSDD73dOFDwDbEuPC2DZflJZ/Lzm7Ja0
1GqiWdIcvr0Bz1bh4+yYcEypmltW2yNYeJSKjNxx1JRPU+LpFUbQrs9ze5MTTjVB
rxpSDdP4KtWgyFO7lBvsK/yU91vjvnakG567LfEhjuPkOzcM7/H9FYc5SlhrRk14
lek8J5xz+x9NcwA0fsmtR52bw2esSpyhMVK4aSjg4L7IPgpdNdla4Mzuy7+Ws3jD
4ezzYYDyDSNclJeFwFjjcUC3hSR486uoeOYFF4CQIpfYBTopXEMVyU2A0WXkMWkL
15r3omUvswCDAZ+nWptQ7BdSv25ITonBZVidDMusX4gSoKmidwDaFd3dYh6fxowe
puJVnaFLBRb863Xgaya4dKYG3erRZ1e6HHSbFnj1Q7//uZJKPpF73d6F2CkkKRJO
6vON4lIMoKjZn1J/S516jPM0Zkt+tbX2VO8nyVBA5dajN6bJZ24kMWCtsMp4fsqJ
jt+l+MqdmLxETH65eSfU
=3rOv
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
