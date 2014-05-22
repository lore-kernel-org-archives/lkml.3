Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbaEVKdE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 06:33:04 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36233 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbaEVKdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 06:33:01 -0400
Date: Thu, 22 May 2014 11:32:49 +0100
From: Mark Brown <broonie@kernel.org>
To: Keerthy <j-keerthy@ti.com>
Cc: linux-omap@vger.kernel.org, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        lee.jones@linaro.org
Message-ID: <20140522103249.GF12304@sirena.org.uk>
References: <1400750310-20925-1-git-send-email-j-keerthy@ti.com>
 <1400750310-20925-2-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cMWh+RWXYx/XmBad"
Content-Disposition: inline
In-Reply-To: <1400750310-20925-2-git-send-email-j-keerthy@ti.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: palmas: Reemove open coded functions with
 helper functions
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cMWh+RWXYx/XmBad
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 22, 2014 at 02:48:29PM +0530, Keerthy wrote:
> Reemove open coded functions with helper functions.

Applied, thanks - nice cleanup.

--cMWh+RWXYx/XmBad
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTfdJOAAoJELSic+t+oim9FU4P/1ebmg9jUXzOlU8k3ioFwv4Y
55LoAepypCvfgyBPrWAkiiShaDuISGjVJ5r9lEMlbumHmbhTxpyXn6nF2btg9RKf
QjZJ+abDta0MCzgg5Y7lDeWpy+FwijAcgh6qIPBwKEnoMjWrNJzwypX6vUvzxKqU
KIqVlEOYw1egpcMmF+wK4zBXcVkmkyMjkueeMJkfk45iILoYZUMJ7A/ceSYq9WXk
GrR5y093cIGdaRRmSyB2eGFkm8IOCRrFL7UFInmA3jHkhO1cOPZnDbdsrUOZEBMY
DIWk5rWhsPkFvQ0ncAlfr4vgoV9ALSm80CeAiUZ011G/BQr1EpBhfEwRdqgeDO/M
BAqgUsHc9rHgMyDDONxO+OPoqjPq8PJwrzkLedz51CEW3Rm9RG/epklV/FEDfeqt
X9GuvISyAdyk9Ta2DiAcw7lTAPVE40T1ECtvo9RSQY7uBjdLchpUoGS+VhRWN0SM
2f+eITkQ4UohAITFIPg4ZKCtdxIlQQaeZI2aWMngzQMXjevBDWw7pgBIGE5uQ1TK
u1UvX+2qd4IgH/Gk6Dj1cNBhsxT7+gmiVwrdPPCOeg7MBtDj0Pwrp09xFm8dN+NK
N03wYyBNilgFn4DO+8keGnfGzBHFbcvQ3t5h82A2BQOcXfm04ST93spo8pbo/rl4
aqbhf0TIb3XJYFv7T+k3
=ggKl
-----END PGP SIGNATURE-----

--cMWh+RWXYx/XmBad--
