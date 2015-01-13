Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbbAMPXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:23:18 -0500
Received: from sauhun.de ([89.238.76.85]:35728 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865AbbAMPXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:23:14 -0500
Date: Tue, 13 Jan 2015 16:23:05 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-i2c@vger.kernel.org,
        Jean Delvare <jdelvare@suse.de>,
        Xudong Chen <xudong.chen@mediatek.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        YH Chen <yh.chen@mediatek.com>, Liguo Zhang <Liguo.Zhang@mediatek.com>,
        Nathan Chung <nathan.chung@mediatek.com>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        linux-arm-kernel@lists.infradead.org, srv_heupstream@mediatek.com,
        linux-kernel@vger.kernel.org, Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v3 0/2] ARM: mediatek: Add driver for Mediatek I2C
 controller
Message-ID: <20150113152305.GJ7660@katana>
References: <1416821928-11453-1-git-send-email-xudong.chen@mediatek.com>
 <20141124121555.GG3733@katana>
 <1417096856.12707.59.camel@mtksdaap41>
 <20141127164536.GC5667@katana>
 <1418352022.4994.44.camel@mtksdaap41>
 <20150106133753.GA3754@katana>
 <20150113095725.GC1059@katana>
 <1421162154.27675.75.camel@mtksdaap41>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Tu8ztk+XgTAiG9Id"
Content-Disposition: inline
In-Reply-To: <1421162154.27675.75.camel@mtksdaap41>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Tu8ztk+XgTAiG9Id
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> I think the quirks can describe our HW limitation without issue.
> We are porting our i2c driver base on that. Will let you know the test
> result.

Great news, thanks for the update :)


--Tu8ztk+XgTAiG9Id
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtThZAAoJEBQN5MwUoCm2Dm0P/1BJsmDfwpOOM+Kv8wPJZpF0
STtTmxmTmkIpd7hCibmrite+EWPjBgYc4SMdkAaJCazdEAbsX+7lKZN80508rx6O
MaaNZXJayhjbVtQIfWhZocatlWRaJ2OtDMfsvyVMjUTKiupn6mspa2AechYJz3qJ
Wa3/DI/N9CXC5udnRr67bhnlqEce7IDfTmYJ8T76bySAp+XgP2IQY3TGYlqtTJNd
0eQ+UdzGpln/pYrOIW0DzW5J8gGe+19dAxV1GJE/BpvmcQQ/3JzCVQCEDWTdYz8p
/NdUsi/aRm86+VhetSGwnxD1vrtMCG2fZJm6/d9FTL+uDUC9nXBBxbbi3SWLmxcU
QXT/4JERJ0cMlcRcJ/JNEjKyRGwavBXL3p5hNuqLbKPR+G/82E4N3MWtrEzZ/Ard
tP4T2SQYqVOhn0mr2S61+oQauExCX+4sLnfprRE9ZcDcpltHnJgs/gFDorXqzy5Z
RsDU25srBeFTv8/R0ucThxDHg04qCoxQ4hmZqJ1N06KzSuN/VQMbwQ095Rtkk8HG
lNHUEqTtqgP4BdjbAR+HvU9H44rKZalFtuKIDdNuP49hfauzYHqR9AjtmZoQknh1
mNZ4APyjzq3TWUR6/UuDLIzfhFXD/YQjHE9mgjj4QqCID5ecFuxcCrHnE041W98s
uMew4dmHpJHvm8z8Qtf4
=Nsyh
-----END PGP SIGNATURE-----

--Tu8ztk+XgTAiG9Id--
