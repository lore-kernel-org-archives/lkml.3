Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbaBYX7E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 18:59:04 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51908 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaBYX7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 18:59:02 -0500
Date: Wed, 26 Feb 2014 08:58:56 +0900
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: gregkh@linuxfoundation.org, sameo@linux.intel.com, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Message-ID: <20140225235856.GL2927@sirena.org.uk>
References: <1393335952-28490-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eWbcAUUbgrfSEG1c"
Content-Disposition: inline
In-Reply-To: <1393335952-28490-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 121.174.50.227
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/4] regmap: Mark reg_defaults in regmap_multi_reg_write
 as const
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eWbcAUUbgrfSEG1c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 25, 2014 at 01:45:49PM +0000, Charles Keepax wrote:
> There should be no need for the writes supplied to this function to be
> edited by it so mark them as const.

Applied all, thanks.

--eWbcAUUbgrfSEG1c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTDS49AAoJELSic+t+oim95HQP/itifN5j4iiYIeyTm3tYupfv
mhYpNUgZ+PnN4Mr/yy4F5HkG/xp+C+hYhO8byD4RQtaADamL+VWK0GRmifiqp1Pq
KvHZp/gHv1bLWo74+AmI9yTjNu7gcq0ev+wvz445yj3oKo8P3rUGrfit3CfQXBfz
9hkffC5RTREeqQnlP1vRGveHdEUHxjpshbyjvC54wvG3EGt1zeZyoxDv7plInSyf
fpr4NrOJFz2khTY41ugpAyv7myWZCYVOPn4MSxLhOo098RLWmI4f6H1Up46HgVh0
1MCTDfb65f0fjiaVUmp268gv9almrvVFBoTiSRgLcXnPvi6AdgycWdha6WUYIhxY
2+eWHyyS0AB6wc5imbmdg5V+PaZunhkDoTBisb11b7TxXcAv664M1mcQZckBd5pi
59EO96PvVEdcD2HMJxhIf8iF1M13Ht9RoWhrwMLOzp/KSuyRcVLYwBzIF0nvPliv
W6geijE/zf4sGa30e787The8W6boGi1g+Z/3+16YDTQHaRoKy/tXMlED5VtLwCDX
c475GfoN5nCNvJYXeyqzy9Wpi5ZmykMtDiU40V5RtvvkKeL/VO3rhvkBgJ1hCKs/
Ba5ZW/NvvGJSS7RUWA4bBml/jlMa+HOAFSMTn1SOSDet8mIcfNkRnSz7oPw+nnsS
HEzDhmeUmv74OEOy4dy3
=t+0E
-----END PGP SIGNATURE-----

--eWbcAUUbgrfSEG1c--
