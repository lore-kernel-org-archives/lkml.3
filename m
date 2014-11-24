Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbaKXPRl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 10:17:41 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36848 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbaKXPRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 10:17:39 -0500
Date: Mon, 24 Nov 2014 15:15:27 +0000
From: Mark Brown <broonie@kernel.org>
To: Alban Bedel <alban.bedel@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Message-ID: <20141124151527.GC7712@sirena.org.uk>
References: <1416834123-23139-1-git-send-email-alban.bedel@avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uh9ZiVrAOUUm9fzH"
Content-Disposition: inline
In-Reply-To: <1416834123-23139-1-git-send-email-alban.bedel@avionic-design.de>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/4] devicetree: add a binding for a regulator that
 constrains its supply
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uh9ZiVrAOUUm9fzH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 24, 2014 at 02:02:00PM +0100, Alban Bedel wrote:

> +Constrained Supply Regulator
> +
> +This binding allow creating a virtual regulator that constrain its
> +supply to provides the requested voltage. This is to allow using
> +simple drivers that don't explicitly request a voltage on boards
> +that have adjustable hardware regulators.
> +
> +Required properties:
> +- compatible : Must be "regulator-constrained-supply".
> +- vin-supply : phandle to the parent supply/regulator node

Reading this description I'm at a loss to explain what this is intended
to achieve - it's obviously not describing hardware which is a rather
large alarm bell and I don't really understand why the constraints
wouldn't be set on the parent regulator.

--uh9ZiVrAOUUm9fzH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUc0uPAAoJECTWi3JdVIfQQZEH/1zCEnN2ttR//WYqwwaJa92Z
IfsafQt4Wn6BZxWaRQ5hajGLL12y/Vv9nqW1oRtE4PfbMDO+SbntYwmbvO1/jcmJ
tegnirXYAiNNPWpz77R8M4ZYzGCje19rqH35gVduDXp20grg03tqYTci2IxEnjjK
b7a4vy/HsAR/orZF8KLf2kV6WuDoxcOPo47+ADOkQVfsDff2ctt1I0Bai98nWVTO
7BSeXocGnbE1M+sduhKD9Bf4SwjbFzpHWQjBOZWGlHXmrAFp+C8zOFjazRbC11JT
yW+aN2Fz+OrEK9Bu2dyodyTGqV+QSNuxDHneM+tHcier2XT7gGircPFc1sLvJA0=
=29wA
-----END PGP SIGNATURE-----

--uh9ZiVrAOUUm9fzH--
