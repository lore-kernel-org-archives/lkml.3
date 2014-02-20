Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbaBTK7N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 05:59:13 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47211 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbaBTK7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 05:59:12 -0500
Date: Thu, 20 Feb 2014 19:59:03 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com,
        S Twiss <stwiss.opensource@diasemi.com>
Message-ID: <20140220105903.GU2669@sirena.org.uk>
References: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
 <1392886403-10640-2-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qb1vXcFCOjhasjwS"
Content-Disposition: inline
In-Reply-To: <1392886403-10640-2-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.156.234
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 02/23] regulator: da9210: Remove redundant error message
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qb1vXcFCOjhasjwS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 20, 2014 at 02:23:02PM +0530, Sachin Kamat wrote:
> kzalloc prints its own OOM message upon failure.

Applied, thanks.

--qb1vXcFCOjhasjwS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBd/0AAoJELSic+t+oim9aFAP/iKixn7IsWzzjIuDFb/jKlpa
GQ2S6MXoeLRr5NEqmXDwMpE6QdBpLQ1rz/J6XCyoVR98+FpZt5G6zMGKNATAl7uv
lhSrJW+8RjHR0fGlU/rzcHqslYsAA5aVZTuJN8ablzNshxregRHcxS4xaS6hneSQ
XRdEGTkBug0INAVp2ZH70zYGBZ/22eYnuOqfGyE6X505iSPlSdUwEWxNknj9ToXI
pNgg/U1xeh41P1Ze4TiwvBPY6tGQQTXrbViUGVQiNNZ/FT0faM6ss2q+F69d+PgB
+wsXrGFBYTGdHK4Ed4EVB0MK0jEwiYpa0P6I5jx2FV8zN9ADvlQM6W2KQesrctO5
AZwb5V5VgDSlPVH/wehBrkLRZGcEibMNJkQ3obZTvkPxFaFqxR94Xl6gRGjf8xtZ
s1sojiOzeqEFd7UaC4+e7z+H0wYJHUxomICRfTxayWOW+oAHaKIpZ3AKYzkt5P81
aSzPd3FJ6/mvJcopNZfDs19YEOwH15joC9vkXu9JdSOrLgrS9g3j0f3JMLB9pjqc
iqwp0fhUxNS5jS8ImW8UWIWDB/DTB+JV1NWbcKSVTiymODF4SzYs6vSwy97FH+++
aq75xTXitVw2OGotayFV0VBL6LV5fvzm7DfiSy/PPLuvA5iR37QhL/aBW58M5oRN
PqEei+9H5lhUXjx5+QZr
=OYgS
-----END PGP SIGNATURE-----

--qb1vXcFCOjhasjwS--
