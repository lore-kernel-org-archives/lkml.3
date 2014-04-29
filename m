Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933848AbaD2RIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 13:08:23 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49494 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932529AbaD2RIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 13:08:21 -0400
Date: Tue, 29 Apr 2014 10:07:42 -0700
From: Mark Brown <broonie@kernel.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Anton Vorontsov <anton@enomsg.org>, olof@lixom.net,
        Sachin Kamat <sachin.kamat@linaro.org>, ajaykumar.rs@samsung.com,
        linux-samsung-soc@vger.kernel.org, lee.jones@linaro.org,
        Simon Glass <sjg@chromium.org>, Michael Spang <spang@chromium.org>,
        Sean Paul <seanpaul@chromium.org>, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org
Message-ID: <20140429170742.GE15125@sirena.org.uk>
References: <1398268565-4789-3-git-send-email-dianders@chromium.org>
 <1398268565-4789-6-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gMR3gsNFwZpnI/Ts"
Content-Disposition: inline
In-Reply-To: <1398268565-4789-6-git-send-email-dianders@chromium.org>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 209.133.115.210
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RESEND PATCH v3 5/5] regulator: tps65090: Make FETs more
 reliable by adding retries
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gMR3gsNFwZpnI/Ts
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 23, 2014 at 08:56:05AM -0700, Doug Anderson wrote:
> An issue was discovered with tps65090 where sometimes the FETs
> wouldn't actually turn on when requested (they would report
> overcurrent).  The most problematic FET was the one used for the LCD

Applied, thanks.

--gMR3gsNFwZpnI/Ts
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTX9xbAAoJELSic+t+oim9t5kP/10HC8UNSZEcnCzDi21HphdQ
ZZD8p2OTDdvpmGY77KSeZeIVGASd9twrnBZQpx91Iw4z3SZpPfMmcmCnd38G8EYi
cRJcGJKOK/GnX0WmPfzarz1yGK4lR1FJ2Q5ftacXle4nZre3mJtdUZy7kFbPwEuv
yShOJvvp435MKv9GoJ1BNuCUCrEIPyLGqDbZOuAY5JcwIxbCPG5XJiAfWqHcFrsJ
Lok3vN6F+rBeVUp7uqvzt5y80FPAmuW14tE9Ig9eIecabQEoAl2mfcTtToXfXIgJ
NsphoeQFaARROFRUA36CbTuDZDpjQJm5PHkd1kwRjhZnZd35wbbJdov+erUo1BkT
OSajHmo0EM1KbQSEhaLbwpA9jRKWJ9zSPl1a0kQg4buglle4UzuwNHu+y33S/ohC
1yja43I91hekJenH8jXEhfsLuvso89+mq0ebpXJIl/KtHDIq5OF6wUUF8S5u6jI1
ordSRBqNedVZhkg/QPzeQmk+yc8/U46lcXL3PBEiYGXYQ/F77diMK+n4nOkL+ct6
8adQvTTd7FeV2Pi9zqrNgbqmf+RwE9JCIsO5hmb8DKbgnTl4x4N158WWWvFG5Xmb
UiHYiwDx3lK42dbL8KVN3j0hyrWf1zofGKDP1uDZgWu+mCmyncS/3d6rOQgzAPpH
wYlt/DqgA+1JqCkeIcz6
=PNW9
-----END PGP SIGNATURE-----

--gMR3gsNFwZpnI/Ts--
