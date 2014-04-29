Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965381AbaD2WWQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 18:22:16 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50959 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933083AbaD2WWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 18:22:15 -0400
Date: Tue, 29 Apr 2014 15:21:31 -0700
From: Mark Brown <broonie@kernel.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        Jean Delvare <jdelvare@suse.de>, Guenter Roeck <linux@roeck-us.net>,
        lm-sensors@lm-sensors.org, Liam Girdwood <lgirdwood@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Mike Turquette <mturquette@linaro.org>
Message-ID: <20140429222131.GO15125@sirena.org.uk>
References: <1398707877-22596-1-git-send-email-pawel.moll@arm.com>
 <1398707877-22596-3-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Vy1A5eXR7jld12ZH"
Content-Disposition: inline
In-Reply-To: <1398707877-22596-3-git-send-email-pawel.moll@arm.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 12.104.145.3
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 02/10] mfd: vexpress: Convert custom func API to regmap
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Vy1A5eXR7jld12ZH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 28, 2014 at 06:57:49PM +0100, Pawel Moll wrote:

> Components of the Versatile Express platform (configuration
> microcontrollers on motherboard and daughterboards in particular)
> talk to each other over a custom configuration bus. They
> provide miscellaneous functions (from clock generator control
> to energy sensors) which are represented as platform devices

Acked-by: Mark Brown <broonie@linaro.org>

--Vy1A5eXR7jld12ZH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTYCXkAAoJELSic+t+oim9meEQAJISu52vfboXBUHxI1ipL4jT
tjCvzAx1VLcVlUgWjuxwdIMYhszOQwjvp8j5/KFJ3LmZ4G7b99PlZAhMUeaDkD0G
IY15zj/yPelhUuMhLMwFCJrO4AXM3FltAhpxDf+RKsWPEpMzJ3rT4aR0/Fl/dXQ3
QsNGSKUi3RknT+fXoYb0Kr2GDJxIgi9fty/aIsNG7nZA4OqB3tex9w/8uPf1rN6G
g21ryh7YAp6o3r2146S9kiY0dYxByLRJ1pDHJYoRcOzh9YZwNIQFsQACCXhVzoP7
WiA4h8e76AW327/Fe78X7AEHQ+jfdP9wcWC7OYfRySukwzsO8QpFX6gsrYU0p2Vj
fpPDLiTtd6V0bSm2G8pMxrcAZq3YJKd4mN0lO4zaKitrdAvUD4AxbASt6ODFzMxp
ejQk+mZdBO5/gl9uE6B8aK+RqDQ6hPICVWo7O4UMMkBITfLxG5XX8XUmKBoTS4sC
SZ9cnxBJlwbCgavRpylR9qx0GLxzC6spfp8hmerJRvc84T1VBM3Ef61uvmC5naBV
eTFs6lr1FD/uih11n29WCwDNmaF4N2Mw6R3ezuC7oW/DaadIk44p1yE0opr/3o5f
w+IgUgz7bOfLFvKUefiA6LefigY3llgHG4zBXxCBgkraaFIFIn5mertQH5qeWvF2
m9LFUk74mADNNTKUsNq1
=kkiV
-----END PGP SIGNATURE-----

--Vy1A5eXR7jld12ZH--
