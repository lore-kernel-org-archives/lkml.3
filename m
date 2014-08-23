Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568AbaHWO6v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 10:58:51 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57080 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbaHWO6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 10:58:49 -0400
Date: Sat, 23 Aug 2014 09:57:37 -0500
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
Message-ID: <20140823145737.GJ24407@sirena.org.uk>
References: <1408791890-17328-1-git-send-email-zyw@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nnmy4NBWOJNeUHwN"
Content-Disposition: inline
In-Reply-To: <1408791890-17328-1-git-send-email-zyw@rock-chips.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 208.59.64.2
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 4/5] Regulator: RK808: Add regulator driver for RK808
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nnmy4NBWOJNeUHwN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Aug 23, 2014 at 07:04:50PM +0800, Chris Zhong wrote:
> The regulator module consists of 4 DCDCs, 8 LDOs and 2 switches.
> The output voltages are configurable and are meant to supply power
> to the main processor and other components

To repeat what I said on your previous posting: this driver has already
been applied, if there are any changes required please send incremental
patches against what is in the tree.

--nnmy4NBWOJNeUHwN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT+KveAAoJELSic+t+oim9UWIP/RSS2tR8pzsmhs80DGkmfrn3
z2DBXCyGWbwhiinyj2B8aj6NtWJ9PS/QYjiG7RkISggWyS/+6FgL0crQnvCpyNTR
wIdb1W7uC9R73LiKqpPg3T0mTbCXAraQyMOBmDrBMA2va9hogwtXvQuncwm1iY0P
C9GWJIUXvVhSbKWbv+7ISW67PEYRhHqpGkwFkPfWlZxpgPAtovbpnKg+5DhyvWo3
WUVfUkY2udANH0I2gZQLxfT5TkBEPoXaJxodhWlP275GIoIvJuMFCGYf4jrVKgc2
sPoCK3iKQvKNC5jrCWsfO1eLfkJGwzf8ZM1FzDneH+o6apBXnzwvacsxbrkiYyW2
ZUKnEuYqlnad38heTSzeWZ5gSaCqtUKbssqr9p3hmmMlTV8D8bAjkHSgq3mMxSj+
pvrciwX6DR5HGuwPn2NGSZuvby4wh4f4QJFPdtaLSy8aSq2mGKnH+HFPGvj2kmRQ
8jK6/0pOXmNrGciBYq1lEgnXguTzAgsklCmKrJMpAfHv/opUp+5CypfGbjph2Key
ktN9ICH9PUCwSVBN3EpQwM7RhI6eXh6hiwHAYGag9Npziy42yK1rU1iGy59zOpQ2
ctP7LbTriOFux/goET4L7+wRX9VMZIJZxG9qxp6SUzD4JVZbNXkWuVxXII8hQOvW
zyXQjGomQIqkvm+vdaAl
=bBta
-----END PGP SIGNATURE-----

--nnmy4NBWOJNeUHwN--
