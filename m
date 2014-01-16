Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbaAPNsK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:48:10 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55656 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbaAPNsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:48:05 -0500
Date: Thu, 16 Jan 2014 13:47:32 +0000
From: Mark Brown <broonie@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Marc C <marc.ceeeee@gmail.com>, Michal Simek <michal.simek@xilinx.com>,
        David Brown <davidb@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Christian Daudt <bcm@fixthebug.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matt Porter <matt.porter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Message-ID: <20140116134732.GB17314@sirena.org.uk>
References: <1389743333-16741-1-git-send-email-marc.ceeeee@gmail.com>
 <61E0E2A7-F7FC-4397-8E92-06CC409912B9@gmail.com>
 <52D72FCD.1030005@gmail.com>
 <201401161219.01038.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dc+cDN39EJAMEtIO"
Content-Disposition: inline
In-Reply-To: <201401161219.01038.arnd@arndb.de>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 7/7] ARM: brcmstb: dts: add a reference DTS for
 Broadcom 7445
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dc+cDN39EJAMEtIO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 16, 2014 at 12:19:00PM +0100, Arnd Bergmann wrote:

> 1. Other platforms also require the syscon driver to be active before
> the regular device driver probing starts. Michal Simek has the same
> issue in the zynq clock driver that you have for SMP initialization.
> We have talked about this with Mark Brown already, and I think we will
> find a solution for this in the end, but it's not as straightforward
> as I first hoped. We can probably use help in this area.

I thought the solution with deferring registration of the resource for
dev_get_regmap() until a proper device materialised seemed simple and
enough, did you folks run into any problems with that?  I had assumed a
patch was likely to materialise so wasn't worrying about it myself.

--dc+cDN39EJAMEtIO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS1+LxAAoJELSic+t+oim9idYP/R5g/BdN9pplOC0eJENE57/9
RM/O+ha4hUGA/NuInI3kolroeI+LO5qtaVpQo904kMmfFcg2EgwGEbv08r0OfflQ
k4xLxiuyiI5uxgsi8Gm1t9IwueJpQgPBvhdjkH87nuNlt34cDOzRh/0BJcIeV0hq
sAXHyU5DfdGmhnscvuACGchrII6Ohf6HoK/kUeZhAruYjOhvBREG5xacIuIp2Nh5
i5drd/qTm05uEzfVvIgxwFBzHfSy6mRqo0aH/h9dB9Sr0kZ/bfqXPe23rQawMN25
1Rp5803i66j9q/53pI8DboVCQBDMwfdukM/b8pz3ymsMeddCJqITxSNTmWBncSd2
bxGIPRIk6BhOcFMFCqDS1odpMd9YLD+b/Y/lcK8qaKqxwuqxnJeutE9FIlpBlvS3
EQH1OyOHznDy2ii2+HUDXJR75xds8dxQop60WXFCt97gwDvgBx9UkEMn0cJzg40X
vA2PJOP7ihfkP8YlOyG2GqvbpsEPDD7QcCBlsCCul34+Tnh3Gir88rZcIardOf8m
G0bdqsT2xlPH/5uwDNDyFwnL5rPuWHKRQ5Ctj8V1Q98935Rk5x04sNVK2yakZVr7
O2QIUAQrsgRgEXqwam51cn7Dl8Azj5hvJp/VnEXex1k8Q//VIXPLfDKdM6RkmskV
CRi0KzepKhSvdhLlY7jl
=x54h
-----END PGP SIGNATURE-----

--dc+cDN39EJAMEtIO--
