Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab3IWGs0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 02:48:26 -0400
Received: from sauhun.de ([89.238.76.85]:51244 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335Ab3IWGsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 02:48:24 -0400
Date: Mon, 23 Sep 2013 08:48:16 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Kim Phillips <kim.phillips@linaro.org>
Cc: linux-samsung-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: s3c2410: fix clk_disable/clk_unprepare warnings
Message-ID: <20130923064816.GA3051@katana>
References: <20130917113153.41b0305d6892170ba8e1ecf7@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
In-Reply-To: <20130917113153.41b0305d6892170ba8e1ecf7@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 17, 2013 at 11:31:53AM -0500, Kim Phillips wrote:
> commit d16933b33914a6dff38a4ecbe8edce44a17898e8 "i2c: s3c2410: Move
> location of clk_prepare_enable() call in probe function" refactored
> clk_enable and clk_disable calls yet neglected to remove the
> clk_disable_unprepare call in the module's remove().

Applied to for-current, thanks!


--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSP+QwAAoJEBQN5MwUoCm2mEsQAKEpcOn4TWEgAqqmdZfmoerp
W4j7k2MyF/JtFz9f2ynwtjdslutSIwHVrPv0eS6xxclIzhuEupOQ+yBSd4wQbogU
9KpZlds621VEpGT15DDlbjkF2Dgr0BHvaHWl7Efu5R61KNLFsdnf8QIElTfDJvXx
OLoXFnLqhNC+wpAwZgrPYGYi3lUyrf73k8eY1ofe2oMe3bTFzMSewE9+5MivgNkG
wEuJ063QZqlULIBEGUZOggQQ03YGjfxbGsDTGo+hOeWGgHu92Zu3IMm+omc4KbEz
4CYyyS96OW9aQbQPaS2jVevnHkjtxkyjk36oCkwFbQpYSqhZWGkzqgzBB6K+QQhf
yYCLZicrQgPXkfaB33W+2yRR4dBoob/xiHLn9C0hJSpxsrqViOWTN3HmnkTiFHpx
HS0mlkkfE45x08i1nWam+7ylWjZAFkGHiLBoAj5aC4CBR+XMU1aE/XwJboY9kUOT
AXliVuF/RQHNbT7zROXHNkftvOaAqcYzGqjR21aZZZJB/Qu+zTZrpTKDSilejECf
rEw5f1Gc2BOoxAQAikN3VCVkJHe2lKjVoe2k7GMchWMfJD+6gjn/eC3ox7Q2FIdv
BOSJS1FdkYkcfHijJBWHod2HNFw4ZrU/EeltBpsnFzhLnPECmaIjH/jaXDvDMmcV
RZkipqux0nM4s62DVb8n
=CgPl
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
