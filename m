Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab3L1Owj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 09:52:39 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37698 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399Ab3L1Owh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 09:52:37 -0500
Date: Sat, 28 Dec 2013 14:52:09 +0000
From: Mark Brown <broonie@kernel.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20131228145209.GF31886@sirena.org.uk>
References: <1387831563-13535-1-git-send-email-sboyd@codeaurora.org>
 <1387831563-13535-5-git-send-email-sboyd@codeaurora.org>
 <20131224125443.GC30815@sirena.org.uk>
 <20131226194133.GJ31766@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W0QGcccuECrPGiFB"
Content-Disposition: inline
In-Reply-To: <20131226194133.GJ31766@codeaurora.org>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 4/7] mfd: ssbi: Add regmap read/write helpers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W0QGcccuECrPGiFB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 26, 2013 at 11:41:33AM -0800, Stephen Boyd wrote:
> On 12/24, Mark Brown wrote:

> > Not a big deal but could these just be inlined in the headers?

> Sure, I can do that if I need to resend? The only benefit I see
> is two less symbols exported.

It also means that everything will be marginally faster since there
will be one less level of function call but yeah, there's little
practical benefit - it's a stylistic thing rather than a practical one.

--W0QGcccuECrPGiFB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSvuWWAAoJELSic+t+oim9mHAQAIk7bMt/BUviwkbwvA7RtwP8
3Ixu5FwP3wEEU+rFwoHvOuX1wMVtcuwIyOb7qCFUA04xtWFg9sR7BFKJ/ancVOvF
rIl3v2jjdj9KTBqbL3jHLrW2WG+3+I2O8HHACAR+R+N6LlwTMDAlCS9DdSStVv2z
bW5Z2DEevHCqQQvTLtPxtAGmtd4qwK4oLMkaDUCryK7fC10KfRgAKedfg46Nb5fM
pruUY+AO6ij27iNKpp8wBGad5Xujy4N65vhGUTpqtCWDCGAhjy2PCOC2Q1nzJBYN
oOFtpWhFsQe2ZnHOLLGJnruMRtbq40N3TodrDxqbD0JCwP7N1qnrCk+CoXeL5nFu
UBKYPhSwIp7F5Q+1LuwlD0i/D7J5sBWqXPeO66lxzgHvYg+DFfcldG9ef3875Pvy
Hg7axvItlajRscWSmJ/Xbl3UgjLeyrSxftTjSOgakL/i/yshjPrdSZ8InidluH0A
oL+G8KqtgQS8VcCq94dnPlht0SU8cqOJsXL2H4/v4M9W7Me4JJAg5DZ3BXRe77KW
PlAjBUi2SaROfIxRT3zQ9xsvNxfKfJdxD28cX2Xt0HlwoYuGEz+sqLmG7Z4NpSQu
A6Fo5g2pk7SWB82tkVG3qMvrzHYLwXPmGz6I5PGxq1yfn4x0w2lQi2uxPdpKJEro
AS8IDhITeNCwGPlvCE8M
=LMyE
-----END PGP SIGNATURE-----

--W0QGcccuECrPGiFB--
