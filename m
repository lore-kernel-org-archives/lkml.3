Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759058AbaIOWgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:36:15 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43842 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475AbaIOWgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:36:11 -0400
Date: Mon, 15 Sep 2014 15:35:54 -0700
From: Mark Brown <broonie@kernel.org>
To: Gyungoh Yoo <gyungoh@gmail.com>
Cc: lgirdwood@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Gyungoh Yoo <jack.yoo@skyworksinc.com>
Message-ID: <20140915223554.GF7960@sirena.org.uk>
References: <20140813190423.GI17528@sirena.org.uk>
 <1409539218-5571-1-git-send-email-jack.yoo@skyworksinc.com>
 <1409539218-5571-3-git-send-email-jack.yoo@skyworksinc.com>
 <20140901103158.GO29327@sirena.org.uk>
 <20140905015507.GA2636@jack-ThinkPad-T520>
 <20140906143828.GJ2601@sirena.org.uk>
 <20140911052230.GA3764@jack-ThinkPad-T520>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sSItSBGmKTsofcL9"
Content-Disposition: inline
In-Reply-To: <20140911052230.GA3764@jack-ThinkPad-T520>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 70.35.38.154
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2.2 2/2] dt-bindings: Adding compatible attribute for
 SKY81452 regulator
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sSItSBGmKTsofcL9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 11, 2014 at 02:22:30PM +0900, Gyungoh Yoo wrote:

> By the way,
> I knew that compatible string is used for binding a driver.
> http://devicetree.org/Device_Tree_Usage#Understanding_the_compatible_Property

> And, from kernel 3.6, MFD core has a mechanism for binding of_node
> to the driver with of_compatible.

> Can I have a question about if it is possible to assign compatible string
> for binding driver independently with reusability?

Look at a driver like the wm831x regulator drivers - they don't have
device tree but they're reusing a driver for an IP with the base
register for the IP being specified in the MFD.  If convering to DT it
might be reasonable to specify this in device tree, though it's marginal
since the part name in the core is also good enough.

--sSItSBGmKTsofcL9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUF2nJAAoJECTWi3JdVIfQegsH/2/ppVmIycPsbjD/N2vkWvBN
h2cYcGtOt8JSqpYH8f1wEFPLsGE89yELk6+Z6Z9MjjGNgKF+Uia1vp3+o1kvnO3f
7SbWk0lkOfHbZueveYbVtLsHXGkuIC85JZ2TJHbRvOe8uGo5OjcgKqXqyPv9zzbf
Z8YyNhPaqfhXkeE4/67BaHUVnwRBCCy+RrjMpTxKHePLSMOV3oSW1BIH4eUi06vc
J4+iunuYRo/BGqnPis4qR+t+sD+hwJkFqbgD6A8yjm0F7Jl2YSmltLygK6pSnrlU
GZEf5v0bb1rLlxPMCRWjqycWWcr+/nNjb2qAnq3JMw9yNtcGl51mNlVlH2qXFik=
=9hT+
-----END PGP SIGNATURE-----

--sSItSBGmKTsofcL9--
