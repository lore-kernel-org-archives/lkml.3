Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080AbaJMNNg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 09:13:36 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50684 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940AbaJMNNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 09:13:32 -0400
Date: Mon, 13 Oct 2014 15:12:40 +0200
From: Mark Brown <broonie@kernel.org>
To: Romain Perier <romain.perier@gmail.com>
Cc: devicetree@vger.kernel.org, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org, heiko@sntech.de, sameo@linux.intel.com,
        lee.jones@linaro.org, grant.likely@linaro.org, robh@kernel.org,
        sre@kernel.org, dbaryshkov@gmail.com, dwmw2@infradead.org,
        anton@enomsg.org, ldewangan@nvidia.com, linux-omap@vger.kernel.org,
        linux-tegra@vger.kernel.org
Message-ID: <20141013131240.GZ27755@sirena.org.uk>
References: <1412711104-15902-1-git-send-email-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TLkgL7PLGfOLXnur"
Content-Disposition: inline
In-Reply-To: <1412711104-15902-1-git-send-email-romain.perier@gmail.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH v2 1/4] regulator: Add helper function to get
 "poweroff-source" property
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TLkgL7PLGfOLXnur
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 07, 2014 at 07:45:01PM +0000, Romain Perier wrote:
> Several drivers create their own devicetree property when they register
> poweroff capabilities. This is for example the case for mfd, regulator

This seems fine from a code point of view but as discussed it's probably
better placed outside of the regulator API.  Making it a static inline
doesn't seem like a bad idea either.

--TLkgL7PLGfOLXnur
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUO8/IAAoJECTWi3JdVIfQmWwH/16Ow8sIBNQiRAw9ZnnUPFZY
Jiyl3de1Jmu+PpI94ECMbKpzX1IvrNAqGl70vHLaXv7yVrJFXaKPmdNKanL7NO2S
L6G3dTSxUwfYbeT1tBQrmgkfvLphagJgMRTrJhEwS7Fv4AZzMM74mcG9/Ev78mMq
4miYsujyFYa4aW+Xd1OdYFKaMlU1T4aPDwB3vvEJ12exXVUgjqdt8K+o/MtgRfeY
tVwk8mRu0J55kcpDW4LWHHSXitAafwgjXFmziG6QNXPCWX4Qa0z2cEg/zZ486XM+
5+JXWCn/suF54lHgGv4xpdysyRekfGofFnRC5uvRhp4ZwUp8jUPSswJI2EctEn8=
=TFS7
-----END PGP SIGNATURE-----

--TLkgL7PLGfOLXnur--
