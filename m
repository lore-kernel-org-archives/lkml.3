Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbaDCJlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 05:41:18 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50599 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbaDCJlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 05:41:14 -0400
Date: Thu, 3 Apr 2014 10:40:59 +0100
From: Mark Brown <broonie@kernel.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: gregkh@linuxfoundation.org, grant.likely@secretlab.ca, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org
Message-ID: <20140403094059.GR14763@sirena.org.uk>
References: <1396509127-23819-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DzFMwNuU1QL7hgxO"
Content-Disposition: inline
In-Reply-To: <1396509127-23819-1-git-send-email-peter.ujfalusi@ti.com>
X-Cookie: To make an enemy, do someone a favor.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RESEND] drivercore: deferral race condition fix
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DzFMwNuU1QL7hgxO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 03, 2014 at 10:12:07AM +0300, Peter Ujfalusi wrote:
> When the kernel is built with CONFIG_PREEMPT it is possible to reach a state
> when all modules loaded but some driver still stuck in the deferred list
> and there is a need for external event to kick the deferred queue to probe
> these drivers.

Acked-by: Mark Brown <broonie@linaro.org>

--DzFMwNuU1QL7hgxO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTPSynAAoJELSic+t+oim9DwoP/R0mL/nr+BnHv+F0EPFXuJxV
gbBXKRTyjMu+T5GZRagH0vq2dU4Nmsk6um5CuvtaY+ARYW8JLK9fB7lzYbA9LxzL
J1Fcxz6n8e4bgHAs4l6HXC1xt1/vxw5iwW53b6R0kXAqzaPwupB/GYOZi+eWIols
dtIxAptt7p/3ZFbsG7/TPBrkHjfu3ct1XvdedGzs6aUrqnKTdIoq3IVPjpwUipqh
zVvHEG7qIhWDpnJYdsEg6xOVT11ITmdmVXqOILWzKOzilFvwGUJIPRui0zUD0Aui
g/mJ5WEZRFmmEifnY6aH2XXvSWv0nB8Cse5W5lqrHraIM6F0HTH64UzoqMbjXT5L
jE7aeMcg+gRJpX72e+WV+JnkxCsJM4u7HZl+SPGjiS/NAmA6DixYyCm7Z4j6z8xN
kUfE8KQYWEL2hiwwIIF3tCVcKfrqS3Kemll9u08M6CGML2rvwh+9nKrYuJGz3VHm
QKp4Fxp8PjSCxiqW6KgorpB5+BMTJeEGz1fxuTIQur+yshkDSKlEXm4/aZZTasQL
zV3GjsYseen5tROrrngsLUtRfSHPNRVmLoBrYt79IpRkMDkPfORFAGeLKBVxl3xL
Gs4vlgCqhhUvPn3jFYkHx2MnI5cvPQ8h4g93B3cX7ccO5WXFnzx5nifdIEas/jNR
srKbuKbL3qzBQkgOAtwr
=ftJa
-----END PGP SIGNATURE-----

--DzFMwNuU1QL7hgxO--
