Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbaIYNEF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 09:04:05 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40311 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbaIYNEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 09:04:02 -0400
Date: Thu, 25 Sep 2014 14:03:35 +0100
From: Mark Brown <broonie@kernel.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, subhransu.s.prusty@intel.com,
        linux-spi@vger.kernel.org
Message-ID: <20140925130335.GK27755@sirena.org.uk>
References: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
 <1411575342-31048-22-git-send-email-vinod.koul@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W2ydbIOJmkm74tJ2"
Content-Disposition: inline
In-Reply-To: <1411575342-31048-22-git-send-email-vinod.koul@intel.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.248.7
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 21/27] spi: omap2-mcspi: use
 pm_runtime_last_busy_and_autosuspend helper
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W2ydbIOJmkm74tJ2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 24, 2014 at 09:45:11PM +0530, Vinod Koul wrote:
> Use the new pm_runtime_last_busy_and_autosuspend helper instead of open
> coding the same code

Acked-by: Mark Brown <broonie@kernel.org>

though I have to say that the function name is rather spectacularly long
here.

--W2ydbIOJmkm74tJ2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUJBKmAAoJECTWi3JdVIfQ3JsIAIV5+JNPOGg6gJjmKBjWritA
ZZWkO6riCpOJdbjmoSxZ3WZVd0ahmlZjboCdsDpzgVgqu/9f2nlMBG/HmcRe12kX
bSMnh9NWZuRqc2+4xHBq5xKDkS4PNzl/K01IiRuFAHeH5uRL2nN+8b5uWq8oZ1oB
oOE+ztxw9Ga3WkQ0un3cpt8Rb961Y7AfWdDcz3Aey+Zzs5Z1V+LINDx9bv3QCFfp
j/rv8rVku8SXZNEnHyeIzK2PlvZVijGNtCrxGyiTL4vRQO1ghdnAABc+eH2PzF+U
1o9J+GePWUK0PBi0Cbj3ZyJvf4mJoG5gUQflTC6edbEnF5GuQIzBOqihIjR/7+o=
=weOe
-----END PGP SIGNATURE-----

--W2ydbIOJmkm74tJ2--
