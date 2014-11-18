Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbaKRLVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 06:21:33 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48200 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbaKRLVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 06:21:31 -0500
Date: Tue, 18 Nov 2014 11:20:56 +0000
From: Mark Brown <broonie@kernel.org>
To: Gyungoh Yoo <gyungoh@gmail.com>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, jg1.han@samsung.com,
        cooloney@gmail.com, lgirdwood@gmail.com, jack.yoo@skyworksinc.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, robh+dt@kernel.org, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        pawel.moll@arm.com, heiko@sntech.de, jason@lakedaemon.net,
        shawn.guo@freescale.com, treding@nvidia.com, florian.vaussard@epfl.ch,
        trivial@kernel.org, linux@roeck-us.net, andrew@lunn.ch,
        jic23@kernel.org
Message-ID: <20141118112056.GA14734@sirena.org.uk>
References: <1416213190-20935-1-git-send-email-jack.yoo@skyworksinc.com>
 <1416213190-20935-8-git-send-email-jack.yoo@skyworksinc.com>
 <20141117141836.GA2722@sirena.org.uk>
 <20141118080451.GA3319@jack-ThinkPad-T520>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
In-Reply-To: <20141118080451.GA3319@jack-ThinkPad-T520>
X-Cookie: You will be surprised by a loud noise.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 81.128.185.34
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RESUBMIT PATCH v7 7/9] regulator: sky81452: Modify Device Tree
 structure
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 18, 2014 at 05:04:51PM +0900, Gyungoh Yoo wrote:
> On Mon, Nov 17, 2014 at 02:18:36PM +0000, Mark Brown wrote:

> > Don't open code this, use regulators_node and of_match as previously
> > advised.

> I think I had a misunderstanding.
> But I have no idea about regulators_node and of_match.
> Could you let me know more about them?

They are fields in regulator_desc, there are documentation and examples
in current mainline - take a look at that and ask questions if it is
unclear.

--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUayuXAAoJECTWi3JdVIfQaI4H/18xMT7GlZXmWY/mB6VXNSAZ
j9t+XEI2DhBIdebvpsIftI1e/aOA4j/FU0LAPhXxQNBza5+Ty1HmbeazGQfOdfsZ
8At5veBZ4kblIg+JhdRHdvBwD3EFGFqMnDrR5nQOqFoOuD7JfMb6mi8fVsxkRiFk
1mU1X9Xr/eS/mqG9A6JmevR/hwoN5ts4vY/vVQHWXAJquw1ADW1H9BbxYgZKx4xr
gOkNG4+kdrolzf1Gi3zPkWZTS2t0A99Fiji/IDYeXcpnQxCK2IDJ8VO2dvHdEzJO
TqxBGHO2DMibo7PkvsW0siWi4fm3Y2iRXsWFayVbmHbJEvUuhQCv9iPcTiMYCOA=
=K0/E
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
