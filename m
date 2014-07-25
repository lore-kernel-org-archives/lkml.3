Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934964AbaGYReh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 13:34:37 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54952 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932839AbaGYRee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 13:34:34 -0400
Date: Fri, 25 Jul 2014 18:34:00 +0100
From: Mark Brown <broonie@kernel.org>
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Paul Walmsley <pwalmsley@nvidia.com>, devicetree@vger.kernel.org
Message-ID: <20140725173400.GZ17528@sirena.org.uk>
References: <1405957142-19416-1-git-send-email-ttynkkynen@nvidia.com>
 <1405957142-19416-2-git-send-email-ttynkkynen@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w41lMVNXnOw3ZHPk"
Content-Disposition: inline
In-Reply-To: <1405957142-19416-2-git-send-email-ttynkkynen@nvidia.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 01/16] regmap: Add regmap_get_device
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--w41lMVNXnOw3ZHPk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 21, 2014 at 06:38:47PM +0300, Tuomas Tynkkynen wrote:
> Add a new function regmap_get_device to obtain the underlying struct
> device from a regmap.

I've applied this...

> +struct device *regmap_get_device(struct regmap *map)
> +{
> +	return map->dev;
> +}
> +

...plus a followup exporting the symbol so it can be used from modules.

--w41lMVNXnOw3ZHPk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT0pUFAAoJELSic+t+oim9+KAP/RQuuZn2h04DaqFGmgTxw3iw
8ZcctSQ/V5rJckcCGyGgmNeC7N3x3fIjCUc6rAf+sI4y7o8CoWvLvTE7Rlp9tIx9
pZ90IgiSOH8nz+N+RjBe4yk35pePuGN3bE+AtlLW3p7AOr47WX8RCtcAJ2pVKs5+
Qre9QFSAD09fLHKsiW1q0uSf6xWBBNgHpfMzPq003O0zRZvDp7xsGNH5Lz1VSSQg
NKln7o10n0DmD6nskitiaR3/26f8NEXDm726Bj9z5sothK9j4nz1DubxlPhqHmFl
EmTGxosU3+iNsxl+hEO5Z1tMpetk2MoWqb50qCCFGUVkhl/b98BBLgvr+zlNtTrz
QMnCs/l8QJ/tGt44sEKVutctcLnxU/tjnt+7OAcI9KbyvTOjqeS/ntvMebf3rUoC
ct3ZnRBPnQajAdjNSsXcgR5Xd+jsZEKk2hQPIgViR4ndPWvq33g5gdqRqWhMoxWx
66xuXBmoIvToJgmDYVZULk50r93887SY1tYw1txNa3TAyhRiHpGRtAll7wxoHAgz
PTdVkI771vLn8dyzftVzsj95KbHFQi3KKhacCYreUprTCTDxbd3U5ycjZ2kS5mOz
IOo2l2CjEzydolBiaP/N7Bcir2oCt0cUpGI84O8zcBJoGhKkoWosMcYbHdf/Glnp
GfNojqxnfKEYyBDvUR6L
=E4/F
-----END PGP SIGNATURE-----

--w41lMVNXnOw3ZHPk--
