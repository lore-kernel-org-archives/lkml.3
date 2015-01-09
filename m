Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306AbbAIUme (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 15:42:34 -0500
Received: from sauhun.de ([89.238.76.85]:50221 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbbAIUmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 15:42:33 -0500
Date: Fri, 9 Jan 2015 21:42:26 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Feng Kan <fkan@apm.com>
Cc: patches <patches@apm.com>, jassisingbrar@gmail.com,
        =devicetree@vger.kernel.org, linux-i2c@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Hieu Le <hnle@apm.com>
Subject: Re: [PATCH 4/6] i2c: busses: add SLIMpro I2C device driver on APM
 X-Gene platform
Message-ID: <20150109204225.GA1904@katana>
References: <1412726809-7525-1-git-send-email-fkan@apm.com>
 <1412726809-7525-5-git-send-email-fkan@apm.com>
 <20141111203237.GB6443@katana>
 <CAL85gmB172hgTCHUQ=sshAAYjOwpNKc=YdovjfTFXfnW7LJTLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
In-Reply-To: <CAL85gmB172hgTCHUQ=sshAAYjOwpNKc=YdovjfTFXfnW7LJTLQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> > I guess this is a driver for embedded? If so, please sort it properly.
> Sorry, having let this dangle for  a while.  I will fix up comments and submit
> another version. I can move this to embedded, however Xgene is
> suppose to be a server class chip.

Then simply leave it as is :)


--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUsD0xAAoJEBQN5MwUoCm2/CYP/RCdgX9RgmB07zp/2tMmSDtR
oBcl3rA+8bEPIYUjmCE3RlkgUMAJwHec67jquwpzi4qxWwwmDPMZVaEeIvQNnS7B
tHCv0b8O2Gu6Sws4vkr/XgSn6Dn/LbmwsGb3kGYCXGxX5C9KrzNiSyJjcmUsdUSA
EOVriPvXXIuU5Yf1Y6sw07vTod+rJqrEuPZa2iPJ6E0z3561p8atZhf63+AJTfo7
fIz3IBxd0oVIuHqLI3WICbJPobkb1kz66ZIBqMr8OM9maAPv0rNlIwgEgHRoRNxn
3dClmmHRwWkBSoeKIBxgXSseXZ+LPst/2RPFstyGTiFPDq0D54hItXEAgo1Hjeuu
JkpkA96BQV4V0gm1Qp5RLDMXk+MjNMkXpM7j1i91UD2NodGBG42bf6JHd5JdJim4
sRyWfHrntt/b+m5vHTBE606pGKWTbpXaNuthoUS33HMOjDeylK1J8zBhM2bnohYE
gzGJsDGgt3rdQefKRRuChuzFv5OxpT3milBkyQVspKxl74NsfT6mvPo2jRlz94Sb
GEoT/yjipF4HL+VC1gPD25V4/AP9SV8UwBRViNEGoE3BPhCFGqTwNjdp2sWix2JI
FJBuMpRxN8cs7M3HX3Buvh0xKKd6xSkjbKYyjRRlLA136BUoIlVspL6vWUKChPnW
xNfXhcXP2JV0wlRWCbWk
=bvDf
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
