Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbbAZTMH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 14:12:07 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35040 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbbAZTMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 14:12:05 -0500
Date: Mon, 26 Jan 2015 19:11:56 +0000
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20150126191156.GD21293@sirena.org.uk>
References: <1422072072.17456.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="kRoubgraN86rDphl"
Content-Disposition: inline
In-Reply-To: <1422072072.17456.1.camel@phoenix>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: qcom_rpm: Don't update vreg->uV/mV if
 rpm_reg_write fails
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kRoubgraN86rDphl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 24, 2015 at 12:01:12PM +0800, Axel Lin wrote:
> Ensure get_voltage return correct voltage if set_voltage fails.

Applied, thanks.

--kRoubgraN86rDphl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUxpF7AAoJECTWi3JdVIfQikUH/R5EezjFrYUyWb+pKcD9hCMw
YgP0GzwzhW3Fzrj6NNSTQNiS82+7T2tbIGs+/PBxJ04VRWtVJzkX7ED0W2F1c0J8
EKraek5qL0pGCYuiG0m+5BF+VALuxrXrfo5s5md+lw/G4KZ8b2o0csMQG6LJp7fk
c1eTJ2XabGRKHiMbx58wBbm5Ct9BnGbyetz1oYnpOXywodDvfMFae0ZK0ga0GUAC
lLCL16dOOpKlBhs2YYyjcGWnl9XEW8CZaawmxvTmBYCS5/8Ue6TR0/K40+Aif7ND
mOhayesmqH3TONNafAKuWN5x9XWYm+UOSV46eowgMwcXMZdaoE3jJNJ6GSUofIY=
=PtSY
-----END PGP SIGNATURE-----

--kRoubgraN86rDphl--
