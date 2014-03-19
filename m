Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965011AbaCSMrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 08:47:43 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34016 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933597AbaCSMrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 08:47:39 -0400
Date: Wed, 19 Mar 2014 12:47:31 +0000
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140319124731.GD11706@sirena.org.uk>
References: <1395232378-26320-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k0qyr4WYEW/fdTc0"
Content-Disposition: inline
In-Reply-To: <1395232378-26320-1-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Turn the other cheek.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/1] regulator: max8660: Fix brace alignment
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k0qyr4WYEW/fdTc0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 19, 2014 at 06:02:58PM +0530, Sachin Kamat wrote:
> Move the "};" to next line as is the general coding practice.

Applied, thanks.

--k0qyr4WYEW/fdTc0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTKZHgAAoJELSic+t+oim9xSoP/2+LKENFHJ1iSMZp5+10fJbI
7aqKTVBj+MVw8YKqGFsrlJ00NI7GLtUttcopKtrlgiQvQDrisTPbykJdCkCU8vlI
TyyevuYSXqIR2DGY7gkj5MHD53X3hPwqJ8GxiicvbEs5X0pydN9dOwSW1cLP/mae
faIqLDynokk68MCnVtxeLajoIYha2dBQLmZrcxGTrjN4MEieBDq2AbEmWQaEfRUi
ssCTFebXW9CDseYIx4H/DqiwMQV7CIcgfRtp5O9tdu3JlhZNPFcHmiKM0c505BGZ
7NrND+GHLrSKFXUnq+NfKHuZ172Q/OGwpqpPdjD/lSuStkvF9UuLEC1PHvwtFCrj
usag+Pofu0edEgl3TK40wle9Lsegwh/QJjBFFnYudlbT63c8Lu5KNzTOk1f4+78/
VMqmDJfgM0ONuJGQ72lY3I920BPXSnz9bZZFXWRdb7hx8H/qwqEGtCwSEsI33pim
cp/MH7J23z4nY9hfdxe6e3azqnXE0BTi2nsY5eTSewZ72CiHdhgBVsV/lUAnuxnh
ZyDt8QQ5iLweD1+VP3iJF6R2Kf9LciAgnaHHhZSj2exKTbWio5Pg3JmE7RGolUpp
dzOwpQuJRZwdNQXLWVPOIBTpvpu4/7c12c8mkQqvRmayj6Af/wmEMDIw3SZDNMk/
+/NBtlBp65VmPZRhxjd4
=6SZs
-----END PGP SIGNATURE-----

--k0qyr4WYEW/fdTc0--
