Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230Ab3ITP4A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 11:56:00 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56903 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab3ITPz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 11:55:58 -0400
Date: Fri, 20 Sep 2013 16:55:17 +0100
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, sameo@linux.intel.com,
        linus.walleij@linaro.org, akpm@linux-foundation.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        rtc-linux@googlegroups.com, rob.herring@calxeda.com,
        mark.rutland@arm.com, pawel.moll@arm.com, swarren@wwwdotorg.org,
        rob@landley.net, ijc+devicetree@hellion.org.uk,
        grant.likely@linaro.org, Florian Lobmaier <florian.lobmaier@ams.com>
Message-ID: <20130920155517.GM21013@sirena.org.uk>
References: <1379680214-9143-1-git-send-email-ldewangan@nvidia.com>
 <1379680214-9143-3-git-send-email-ldewangan@nvidia.com>
 <20130920123930.GB2185@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Gtf2ElYKiUa3nI7m"
Content-Disposition: inline
In-Reply-To: <20130920123930.GB2185@lee--X1>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 86.153.71.95
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V2 2/5] mfd: add support for AMS AS3722 PMIC
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Gtf2ElYKiUa3nI7m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 20, 2013 at 01:39:30PM +0100, Lee Jones wrote:

> Personally I think the device should have sub-nodes. It's how  we
> dealt with our DB8500 and AB8500 and it works very well. At the end of
> the day these all-in-one chips do house very different devices. I see
> no harm in describing them that way. I'm sure other OSes can make use
> of the sub-devices in similar ways.

For some bits of the device it makes sense - the regulators are a good
example with this device - but for others it's more questionable if the
Linux division of the device into subsystems is general enough (or even
static for Linux - like this one where there's the 32kHz clock being
handled by the RTC driver binding in the last patch posted).

--Gtf2ElYKiUa3nI7m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSPG/bAAoJELSic+t+oim9GcwP/2YR89cmAKw4CmB1/WQ5tuLe
CJUjpFTtJLhfB3t7QpdCcZ20+lsSJcdZTu4IwESgyR71EeKYWTVMYBRzJjfChXxD
5CIQRyObBOOStdjaS0BJGyUuSfj9rJFwxZYY6sKaUJpo9CHM/KfIn5WQkPU0lq1y
iy+QtETSNWdZ/OcE2hReAQvH/YvM1re9QAxXeyotompLU2hWlA0aLlDtXCElzTvx
+rbkJtyPQyc1nSLKcY+XVwYMsmsA8Fot1D1x5D1TutINH620v1+BsdiJCARiWyOB
Ph4EyZAtQs2PrUDckym7ZWYvVDeCMFldZfcaaE28YfDUpY85fQ0JtVUM4HZ5ZC10
g/N34IXY4JvbCH3MWil0cTJJo6hCF/2P6B+rBSb3NZbjIq2ibzxuZMITyWwLjqyc
Q4SGl/RmkXPGpdiTnxe7ZP0mDXiE8UnUV/PY6Fw1JK6hkdQ9KPZlZ6t59FYgSpHF
+1i7iBu0j04L49Ko/M5OPTHhUicumxOR0dKLsMc1t7uGtdCk9Vfdgu3FYnw9FgMG
b9l6Pq1smdIqnMuYj8pmBAAPxTfpgCzGCyo1ZHINmNCvCXzNXcByg6nZ/1UtzCy7
s5XtjFCdtrMLb7DtVlvvPOWZrv5cBE++M0rulBKCqYIgwFD7ZgcySMqr2ucTUqxh
ZSZdElbmOPa++LNAwraR
=2K1t
-----END PGP SIGNATURE-----

--Gtf2ElYKiUa3nI7m--
