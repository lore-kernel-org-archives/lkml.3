Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152AbaCEEe2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 23:34:28 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56027 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098AbaCEEeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 23:34:25 -0500
Date: Wed, 5 Mar 2014 12:29:42 +0800
From: Mark Brown <broonie@kernel.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tomasz Figa <t.figa@samsung.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <20140305042942.GI13126@sirena.org.uk>
References: <1393862536-9842-1-git-send-email-tomasz.figa@gmail.com>
 <1393862536-9842-8-git-send-email-tomasz.figa@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wnLTWEf+vlzHZaR9"
Content-Disposition: inline
In-Reply-To: <1393862536-9842-8-git-send-email-tomasz.figa@gmail.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 202.175.88.218
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 07/11] ARM: s3c64xx: pm: Add device tree based power
 domain instantiation
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wnLTWEf+vlzHZaR9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 03, 2014 at 05:02:12PM +0100, Tomasz Figa wrote:
> This patch adds support for registering power domains of S3C64xx SoCs
> and binding devices to them using device tree.

Reviwed-by: Mark Brown <broonie@linaro.org>

--wnLTWEf+vlzHZaR9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTFqgzAAoJELSic+t+oim9WLwP/i/8m2yce1QLOExnHDB6KqUa
cZw4C95w5NIe2zNQSI7Zc8Y5wUDRuB81Nn9yS8mfIHYRfY05TzBmcynvMbd2Kzhk
JvrJXHG0htw/z3nlz1G3QhoJXY3mvXaYo9FavUou+quPk/KpHk/Er/KF75UMIgkD
KE+QzwKQVMQbYF8Aej7R6s7dzRZuSFLQ9nn/R78TebYZTTyOVrrwSQmChKsaykNZ
ZrhV1oIR2JuwCzZy6OlRTmx0PppdubisCSLCSOKSfRDdCxxI72yTJVD/Eo1R6BUZ
Gzdxx+DJy/jM9s/HUinSyE8DWq7JOKX4JfZzkljenQFEXfP7L4/IbWBQceQqLaEo
FSdmH7gZJ+fCsn0nerrPxUyx7u6encA4O5N9NHf1NuVRneBQTK8/RrpcQsUVqeca
SOsRz6nrNRIuQ/fYSmegBRUHfle6CQ6nLlfXXTQ17cXRsrrGTvMrPTwcrFcJDG0O
mZjOvVUxfr1QQ/KgS4DPS06rklfWRuM4ef2lorcsq8z7wppQ/Tv7k6GWG8mg4lQy
Y1inW0MYBhStViktjrTyr7iwreZyTWnhg9WLpg+VZs2OegES2ASFwJEXwT9gMV24
UoCkMsii7AL8/pr8PzkT5Fu9ajpmyUpL3nscctWfaFWIFbh0Ni9mvHps25go1Ov1
oz4apur0jSWP8FSZ7fJr
=fu/N
-----END PGP SIGNATURE-----

--wnLTWEf+vlzHZaR9--
