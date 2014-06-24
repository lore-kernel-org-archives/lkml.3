Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbaFXKeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 06:34:19 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55492 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbaFXKeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 06:34:17 -0400
Date: Tue, 24 Jun 2014 11:33:36 +0100
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: addy ke <addy.ke@rock-chips.com>, "heiko@sntech.de" <heiko@sntech.de>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "huangtao@rock-chips.com" <huangtao@rock-chips.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "yzq@rock-chips.com" <yzq@rock-chips.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "kever.yang@rock-chips.com" <kever.yang@rock-chips.com>,
        "zyw@rock-chips.com" <zyw@rock-chips.com>,
        "xjq@rock-chips.com" <xjq@rock-chips.com>,
        "zhenfu.fang@rock-chips.com" <zhenfu.fang@rock-chips.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "cf@rock-chips.com" <cf@rock-chips.com>,
        "hj@rock-chips.com" <hj@rock-chips.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Message-ID: <20140624103336.GG23300@sirena.org.uk>
References: <1403582324-9485-1-git-send-email-addy.ke@rock-chips.com>
 <1403582324-9485-2-git-send-email-addy.ke@rock-chips.com>
 <20140624101802.GE5856@leverpostej>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Sw7tCqrGA+HQ0/zt"
Content-Disposition: inline
In-Reply-To: <20140624101802.GE5856@leverpostej>
X-Cookie: But it does move!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] documentation: add rockchip spi documentation
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Sw7tCqrGA+HQ0/zt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 24, 2014 at 11:18:02AM +0100, Mark Rutland wrote:
> On Tue, Jun 24, 2014 at 04:58:43AM +0100, addy ke wrote:

> > +- Board Specific Portion:
> > +
> > +	&spi0 {
> > +		status = "okay";
> > +		spi_test@00 {
> > +			compatible = "rockchip,spi_test";

> Huh?

I expect that's just intended as an example of how to set up a device
and they're doing something like use a driver that generates known
patterns.  We'd normally omit such examples from the binding document
since it's generic and covered well enough elsehwere.

--Sw7tCqrGA+HQ0/zt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTqVP8AAoJELSic+t+oim9768P/2wmhn+zUELR+Afyz9m7T1uS
F0B7iV9hm3LD98h96hGeaqax8XVEreR8E5DiF0pMxxkkalMsJetT0hXcU2edvM/k
UuE9lYAX6ExcxlWjDpHF+2pZHPqjHH6s1cU4nOthZY/uBaQdVLS+WadU7Ng+JkYN
0/udpOY53so3g93zMFNtpcAha4oOBMyBnwz3JmITfRvRPG/nzyPLA0hiGxPShdk8
4ha3e18Tk/vvMFQzIWI5XcDE4L0hB7+fCkElXs5nJfDGhGA/U/0IFMmXcupVXLMM
W4xXfQcfxEhWTCvCw4j/T0of36PNwvJnFMu0Djdq3VxAz9+2bQ1ZTAQMEbn+xPHg
KwzLE1ESBJUhn8i8IM7PeliHjdu7AJ/IfNNCAFAqTLBeUR5/rnUtIT4D7Fj0pyiK
LdfmIVwDjM0S4O5XTbOKVY0zWh/3JQFjr15wYTaNswLfqfNDBO2AVlT3biry7tn2
InVk+efm+MFzg/SDVa8gnYEjghf0R09GtjVmSE6pl55HKlSountDkF3roMwZMdsi
PyRZPxjCKt5GaoQt38S7OKyh6oCa9nnWO4onnpMoZWBt8f3eSTNJneZuY1N1TUQR
hWsVYRmGakHjwSDMOVOEKFL8DnfaGI/a2E8NDO7OK9AzD3Y8XQyIQt8tgQbNZoCE
WduhD98mr656/bTmqlMh
=Haop
-----END PGP SIGNATURE-----

--Sw7tCqrGA+HQ0/zt--
