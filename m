Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490AbaKDAzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 19:55:12 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36344 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaKDAzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 19:55:08 -0500
Date: Tue, 4 Nov 2014 00:53:29 +0000
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
Message-ID: <20141104005329.GA3815@sirena.org.uk>
References: <1414393369-31583-1-git-send-email-jack.yoo@skyworksinc.com>
 <1414739322-12487-1-git-send-email-jack.yoo@skyworksinc.com>
 <1414739322-12487-8-git-send-email-jack.yoo@skyworksinc.com>
 <20141031164418.GC18557@sirena.org.uk>
 <20141104004333.GA2965@jack-ThinkPad-T520>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="edESjMboOAwUFn6i"
Content-Disposition: inline
In-Reply-To: <20141104004333.GA2965@jack-ThinkPad-T520>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RESUBMIT PATCH v6 7/8] regulator: sky81452: Add compatible
 string for device binding
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--edESjMboOAwUFn6i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 04, 2014 at 09:43:34AM +0900, Gyungoh Yoo wrote:
> On Fri, Oct 31, 2014 at 04:44:18PM +0000, Mark Brown wrote:

> > This doesn't apply against current code and depends on the MFD symbol
> > rename - can you please check what's going on here?

> Are you talking about 'sky81452-regulator'?
> I am sorry I don't understand. Can you explain in more detail?

No, I mean the Kconfig change.

> > It would make sense to split the Kconfig symbol rename into a separate
> > patch to ease merging, it doesn't seem obviously related to the driver
> > change and should probably be in the same patch as the MFD symbol rename
> > for bisetion.

> becuase the symbol in the modfied MFD does not match with the
> merged regulator driver, it was hard to split the patch.

I'm having a hard time understanding why it is difficult to split the
two changes - they are in completely separate files.

--edESjMboOAwUFn6i
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUWCOIAAoJECTWi3JdVIfQK2kH/3A2hGV39X3qo6WiZJA/id51
8866trNV5Cr1Yxo59oTslu8XKgK8yfqQNh5fHqKYVWZJ5ryYL7NbDmlVLc1cFbbx
zYnpZ/IX4hYFNbaaPA0RyeH50F/EtrYhJuab4ppPdrnVgnpeXn+DSANUlswnt97c
cgE0B6aOkEM/Jdm1FMYSiKgW4mlVAjkZOxF06d2OAlqimxir7a+RdTk/nKTyA+Jk
8GMrTEn6Lw2oMsQ0TFYP3/+EVMeLlzG8uTnbGldHvv17B8TjwPx8KFqD9UIXEvCQ
TC0D6sM8h1AqIU85XYjmQMayrBvORMKmWlhceuRpcKc3gDoX9WSwR3+ouYQrKIs=
=7luX
-----END PGP SIGNATURE-----

--edESjMboOAwUFn6i--
