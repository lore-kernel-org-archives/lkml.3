Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831Ab3L3Met (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 07:34:49 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52628 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681Ab3L3Mes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 07:34:48 -0500
Date: Mon, 30 Dec 2013 12:34:40 +0000
From: Mark Brown <broonie@kernel.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20131230123440.GT31886@sirena.org.uk>
References: <1387831563-13535-1-git-send-email-sboyd@codeaurora.org>
 <1387831563-13535-6-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PUHnpEUN0SLOjcm5"
Content-Disposition: inline
In-Reply-To: <1387831563-13535-6-git-send-email-sboyd@codeaurora.org>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 5/7] mfd: pm8921: Use ssbi regmap
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PUHnpEUN0SLOjcm5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 23, 2013 at 12:46:01PM -0800, Stephen Boyd wrote:
> Use a regmap so that the pm8xxx read/write APIs can be removed
> once all consumer drivers are converted.

Reviewed-by: Mark Brown <broonie@linaro.org>

--PUHnpEUN0SLOjcm5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSwWhdAAoJELSic+t+oim9qHcQAI51dJ/rFcDgMmqFHnZFINAV
ypRgUe+2m72QY9KFEPvcxy80vr+bU4qlv7hwWB/c2FZvpH0ugzipCDK1cWnkmzoY
n0w8rmqhvUrvv8FgKhnGqIsxiqr97aVgMU0U2+rYMi+/nvfPMSfQIR/Z56iWS/0W
s003Zp0FZC9XByErg+BIeJiLgYeS82NMMVpKP2bneL/S7o1dGWHQIIGVhxUqlOdp
nHWFk7mNv4oU2ueBZCbs8vvcDULHT8m9Pf/1Nn7MbC3sS+BwtRumbEbvW6Mzx3kn
XVUBAkuhTrns597SKexdnPrX5x55BDlUoQQvMflv+Ug/Zas5SFz0lVysPrUN93W7
uqqhA8WK7aqDfHi39bTK4eCYgs6zqWdWPWWaN7TsEuMlq2pSY9uWDNFWopxfPbnS
x+BaFFaToCwKRsQ+LqTAodEaB9WOVHB+npOfkKxGgRnIuxybFz3W/M+LYpk4N+D9
6va3L1uxZINgs8ReEnY9eLai9QCiKz2Iy3+CuxSt1hkhZHawawvG97ine+5H+oe9
2fVFSsdFbnosC4pdg9KneorGnGi0S+5eaJy6863HzZfbpuwfl9sb8LGkxXVgu684
Urxm3fhp9THnHZqGVNrLjyCZZjNMn3dLDlEx/GH68YENadSnjLJv/H3Os+5BNST8
PfQaYcMZoKIrZQ45uhyw
=aECT
-----END PGP SIGNATURE-----

--PUHnpEUN0SLOjcm5--
