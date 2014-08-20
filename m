Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbaHTPar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 11:30:47 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51121 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaHTPap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 11:30:45 -0400
Date: Wed, 20 Aug 2014 10:26:33 -0500
From: Mark Brown <broonie@kernel.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        a.zummo@towertech.it, mturquette@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, grant.likely@linaro.org, hl@rock-chips.com,
        huangtao@rock-chips.com, cf@rock-chips.com, zhangqing@rock-chips.com,
        xxx@rock-chips.com, dianders@chromium.org, heiko@sntech.de,
        olof@lixom.net, sonnyrao@chromium.org, dtor@chromium.org,
        javier.martinez@collabora.co.uk, kever.yang@rock-chips.com
Message-ID: <20140820152633.GX24407@sirena.org.uk>
References: <1408505248-23995-1-git-send-email-zyw@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uN3tURjgVTLfI0kr"
Content-Disposition: inline
In-Reply-To: <1408505248-23995-1-git-send-email-zyw@rock-chips.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 63.139.182.64
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/5] MFD: Add rk808 device tree bindings documentation
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uN3tURjgVTLfI0kr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 20, 2014 at 11:27:28AM +0800, Chris Zhong wrote:

> +- regulators: This is the list of child nodes that specify the regulator
> +  initialization data for defined regulators. Not all regulators for the given
> +  device need to be present. The definition for each of these nodes is defined
> +  using the standard binding for regulators found at
> +  Documentation/devicetree/bindings/regulator/regulator.txt.

You need to identify all the valid names for regulators on the device so
people know which string to use for which regulator.

--uN3tURjgVTLfI0kr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT9L4mAAoJELSic+t+oim9GTsP/jk9EGBnzzpqSNfJauIs4spT
oJXe+1MF8NggWdZg0HN75RZyf9v1qsssJmc946w5yjUI4ppbdbdyUn2BPSMY6oKk
Zdi/gXdWE5nK1XiH7TbleLq9yteVbpVDQljbQ2zhNaMfku+R950wd5KdWBtIk4zn
S9BYWUwh2JkI9dNie7l+ao8kL8/gx9/Bcv71tA6Y87YEkDVSmHfxND48rLTU5k3v
076ym04gyi9fzQVfMviIkn1BklLZ/xYstK0cfF7NRgdWDzrC1DKubTdGqYilaPYf
PIc57m1kF6fuARYR7zmyOSWfD41jwCTBSFkzcU7Fu57wq+vJxGKM1vFi0xXnt1FJ
u91NB7auha+DzVGqG0u0gxX1BagQc0r0e4AQASUvhNnOdhi+LN3NKzdtpHgK0b12
TBY1zoFTz+j4dgyrdARUyqkH2WC8VSTZxINDSfkdbZsc/JSWCE5TePkx73ECNF6/
iOwrHGQFyuj3snkusMPbFYkqCiPQ5je7Es1iOmpDbw0i+D4IH7quJTJwbTFcvnVe
z8QHQVaUEdYsoWMFeOm1bXo2I6X1BnMbhUwEhMwNUSv4mCmO1Pao3mJC7lUprAuB
5gKODGhT/w2I+ZcmB+XGPJigGSVQewegTke3q+0ZabAHG07crubuz9XD2pGw7rFG
DblZ7zpQ9qNWc1OGVNfe
=/UKv
-----END PGP SIGNATURE-----

--uN3tURjgVTLfI0kr--
