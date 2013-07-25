Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab3GYKLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 06:11:41 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:56653
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755486Ab3GYKLg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 06:11:36 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI9371I542I4015Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097hz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dhbe9i1155h)
From: Gong Yibin-B38343 <B38343@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "s.trumtrar@pengutronix.de" <s.trumtrar@pengutronix.de>
Subject: RE: [PATCH v5] regulator: pfuze100: add pfuze100 regulator driver
Thread-Topic: [PATCH v5] regulator: pfuze100: add pfuze100 regulator driver
Thread-Index: AQHOiRnVcUZVp8GUf0Smiqqh95Bdhpl1LGVg
Date: Thu, 25 Jul 2013 10:11:30 +0000
Message-ID: <95EEB29E288F544BAED903CDEA0C4C060111CF75@039-SN1MPN1-005.039d.mgd.msft.net>
References: <1374723198-9716-1-git-send-email-b38343@freescale.com>
 <20130725093209.GX9858@sirena.org.uk>
In-Reply-To: <20130725093209.GX9858@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.252.106]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, I will.

-----Original Message-----
From: Mark Brown [mailto:broonie@kernel.org] 
Sent: Thursday, July 25, 2013 5:32 PM
To: Gong Yibin-B38343
Cc: shawn.guo@linaro.org; grant.likely@linaro.org; rob.herring@calxeda.com; rob@landley.net; lgirdwood@gmail.com; devicetree-discuss@lists.ozlabs.org; linux-doc@vger.kernel.org; linux-kernel@vger.kernel.org; s.trumtrar@pengutronix.de
Subject: Re: [PATCH v5] regulator: pfuze100: add pfuze100 regulator driver

On Thu, Jul 25, 2013 at 11:33:18AM +0800, Robin Gong wrote:
> Add pfuze100 regulator driver.

Applied, thanks.  Fixing the language about the regulators being a property would be good, please send a followup for that.

