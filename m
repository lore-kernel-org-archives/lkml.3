Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831AbaHPWA1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 18:00:27 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39114 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaHPWA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 18:00:26 -0400
Date: Sat, 16 Aug 2014 17:00:15 -0500
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Rob Clark <robdclark@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140816220015.GA11357@sirena.org.uk>
References: <1407807429.8958.1.camel@phoenix>
 <20140812215515.GC17528@sirena.org.uk>
 <CAFRkauB493XsKvLi_B=rEUdrL84vGDOuEg3e_V+yGQp=QhXxiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
In-Reply-To: <CAFRkauB493XsKvLi_B=rEUdrL84vGDOuEg3e_V+yGQp=QhXxiw@mail.gmail.com>
X-Cookie: You will be divorced within a year.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 216.80.70.240
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] regulator: Add stub for devm_regulator_get_exclusive
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Aug 16, 2014 at 09:30:26PM +0800, Axel Lin wrote:

> Hi Mark,
> Even though not for this build fix, I think the patch is still good.
> Should I remove the build error message and resend the patch to you?

It's fine as-is, I was partly holding off because of -rc1 and partly
holding off to see what Rob said about the usage.  I'll probably apply
it at some point if I don't hear anythihing back but I really want to
either understand the usage or see it fixed.

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT79RsAAoJELSic+t+oim9QjMP/0FtiqoN1586nKaxBZV5ULhg
UsYF+Bi0Khqo49LDBjooVZhqxyhKD/xjKpR+/ZMZ+0YBSPC1HVgWUAfYhu9fghon
0ljRxrxjx9CUtyqzsjTp8RaDA5ff9gbzoZrZ3ikcYagLnY2p2QWlpZgtunl4Qm1C
qwMlrFX6aQUoo0DyiBBB1Nd1SD+cBA5MOj1YoBf9/l5knVpM7P+bvg864CwkNNi+
i5f3N7f6X/mTV8BrO24Q2VGDh2mYeNCnz4vUml2Pt32x+wNVw+FtEuryZMyHhP2b
bp10NqRCmNL9+KP5JOU/nYaj+Z9MhTLWMh5DTxMDcwxG6AUWaDJpu/bHt4zfMBM4
MssDRh/x9MyWZX+t7ldc0LZVPFs9+FWdTNk6HOuyrhqgyttSF8Da+dH+omYNs1p9
83RCRCklKFh+SEbkZZTX6f+19A5AYBvB2wp5VIj7hnlYGLW96Wn62L6XtGTskG0H
oz/im+/ih46AMbWkrts24wniJ9pzO3gdQB/5yDUOpmWvcP5BUScDywPM5YVtRFCI
GidUc99HV5DG+1kAns3xViR3HbyB2le1Z7uWeDRMh8Xx1N2ZOQ8n8pcc4FG4x844
Iesmcj+ZmEn7E/i2Dldc/tQN6AxbVbnU7sI1l70FCkWoc3dL3xUwRakXcJYTQezr
A0R0rV1Hurr6NDbVW+po
=1OqA
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
