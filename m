Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259AbaCEE3O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 23:29:14 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55959 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756706AbaCEE3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 23:29:09 -0500
Date: Wed, 5 Mar 2014 12:28:59 +0800
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
Message-ID: <20140305042859.GH13126@sirena.org.uk>
References: <1393862536-9842-1-git-send-email-tomasz.figa@gmail.com>
 <1393862536-9842-5-git-send-email-tomasz.figa@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4/KhLkEx1OUQso4T"
Content-Disposition: inline
In-Reply-To: <1393862536-9842-5-git-send-email-tomasz.figa@gmail.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 202.175.88.218
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 04/11] ARM: s3c64xx: pm: Use name field of
 generic_pm_domain
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4/KhLkEx1OUQso4T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 03, 2014 at 05:02:09PM +0100, Tomasz Figa wrote:
> This patch removes name field from private s3c64xx_pm_domain struct and
> moves domain name to dedicated field of generic_pm_domain struct.

Reviwed-by: Mark Brown <broonie@linaro.org>

--4/KhLkEx1OUQso4T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTFqgIAAoJELSic+t+oim9+7cP/jf0iPyndTfqETpaqBomYQ4H
sF3uDnEpsuxyYGQ1qx3vmJNYpddB7l+/CUutjZxq9XIfnMlEFMT3KOPC56C8wOdt
2jMUUX6KYqjfCHiIITAs/ohgzHc15Myf9118LQzD8GqkdpYCkgynmDu8fsjTvh55
AcfHGRCGE7F1FW6gUm01m2nNzR2cIuzCWw5ds0fflXiZz0riuDxOnoixvupLwf1+
oc2os9nPfMzorzN4JA39m9lWtdNDKXXcjtCR9UFrLLN77PSi2bINRNXB6P4IgdNV
R14IkTpzA74zYSIelJWZt1Mer2r0RR8FfQkzXQ+6GEW4twNZfYE30AUeP923kwhW
4DldoWd091R9wujJVbCex7uUl+siFPXQh9fzmhrLoevhJkSMp7gRPg35MhtMitsW
Whab3WQd2ukFXK1GCE1K9f/mH3emzjLiXMnZoWtghlJsHJwVKyX0wDXcW/T5+A4E
qZmN7paJgLXLEIo0wp0aAgZIyzvgIcfpjzTVCFeXm3foG3sdQNXgbgOmzKV5ioQ8
lv19twIqsy8DwqaROX/gSMOMQASFn9btVHNERWOsBn7dA2Cckuf79E48NSKtufUz
lmWFBPJTQVevGwim2Tr0zuKgFVFTykny0Iz2GPDLQ//YPCWmtDWOlZS4NvnnGP5k
V7WwRhiPa1rRrQOohaj8
=DEuw
-----END PGP SIGNATURE-----

--4/KhLkEx1OUQso4T--
