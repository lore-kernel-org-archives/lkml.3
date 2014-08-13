Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbaHMPvw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 11:51:52 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33574 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279AbaHMPvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 11:51:50 -0400
Date: Wed, 13 Aug 2014 16:51:22 +0100
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140813155122.GX17528@sirena.org.uk>
References: <1407861868-20097-1-git-send-email-javier.martinez@collabora.co.uk>
 <1407861868-20097-7-git-send-email-javier.martinez@collabora.co.uk>
 <20140812172552.GU17528@sirena.org.uk>
 <53EA61B9.2070805@collabora.co.uk>
 <20140812212757.GY17528@sirena.org.uk>
 <53EB4CA0.3010006@collabora.co.uk>
 <20140813122910.GQ17528@sirena.org.uk>
 <53EB6954.3040207@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Mj/0swo4/Fjabs+K"
Content-Disposition: inline
In-Reply-To: <53EB6954.3040207@collabora.co.uk>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 6/6] ARM: dts: Add tps65090 FETs constraints
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Mj/0swo4/Fjabs+K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 13, 2014 at 03:34:12PM +0200, Javier Martinez Canillas wrote:

> Indeed. I'll change mmc_regulator_get_ocrmask() in MMC core then to use
> regulator_can_change_voltage() to detect if the regulator is a fixed one
> and call regulator_get_voltage() instead of list_voltage() in that case.

> Do you agree that this is the correct solution?

I would just fall back to get_voltage() if there are no voltages listed,
that seems more robust.

--Mj/0swo4/Fjabs+K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT64l2AAoJELSic+t+oim9tDIP/1+BkXGMNhigfK+dKTq25hr/
esf41/ND4jsM5betOXL17OGEX4wxDgXEOLn9r+rr1GtPjHvQOx9NHfM3g76wo0R4
UJTqGw4OFuYBHDcrgb8+RRgN4HX4BPd14BKnHoXZTnMlgNsx+XqRw2O0rcHPEvTF
vupSwukxS6IADZASiOLEwjhX5Xr/Fa8qtL5UVf2vSqVAbrchKHD1HH6CJQkg2/g5
C11pYokfG22ug0qa1Mw48q+Yo9i8nzDj3qorUXbdO/aPBpc4EO1AayKvqDJCFnKY
K+FB5JC908uJU+c3xDqQTL3qbwvhmJuCKAMghVjz13vRuDFQmZaKtCwhrG7IYWMs
dH33/CsdB/0vr/XoXF+XtSBq3j4uQrseKKl0NvWL7mVzGzKTznqybYPQjae9Hjn1
QiEIYOnfA8NDpJR1bVv2DfGFAYF3mGfsWO77HVZ3BMeWMKjLdv4Jn/7hl2HX8MgO
HEFdaJgLLaIize+3wwlWzEkn7yXTx0Ws5LglLF6Us/tQ7GU8w3HeYLC46flEo3GD
SMlTqoEOWtjeOgQgtXul/BRy7SSSP3rJd84aBzCM9uBibLfljvVMDMo9EpraKS9p
09qRx2PLNKDC6phzYaQQ4hBZOgbbJwgzgw38T2AOqQE0hev8XRO1ikjEm9xMF5Je
8td6xkSibUsiwUgrkGkW
=7UIM
-----END PGP SIGNATURE-----

--Mj/0swo4/Fjabs+K--
