Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab3IPCts (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 22:49:48 -0400
Received: from mail-db8lp0184.outbound.messaging.microsoft.com ([213.199.154.184]:30432
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752361Ab3IPCtp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 22:49:45 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zz1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5hbe9i1155h)
From: Xiubo Li-B47053 <B47053@freescale.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Guo Shawn-R65073 <r65073@freescale.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "t.figa@samsung.com" <t.figa@samsung.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: RE: [PATCHv4 4/4] Documentation: Add device tree bindings for
 Freescale FTM PWM.
Thread-Topic: [PATCHv4 4/4] Documentation: Add device tree bindings for
 Freescale FTM PWM.
Thread-Index: AQHOsEcUJGsqFtbvB0meG1WvpYnSMpnEQjUAgANo3nA=
Date: Mon, 16 Sep 2013 02:49:06 +0000
Message-ID: <1DD289F6464F0949A2FCA5AA6DC23F82833236@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1379051922-4930-1-git-send-email-Li.Xiubo@freescale.com>
 <1379051922-4930-5-git-send-email-Li.Xiubo@freescale.com>
 <523392EA.6050909@wwwdotorg.org>
In-Reply-To: <523392EA.6050909@wwwdotorg.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.208.78]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +- fsl,pwm-counter-clk: The FTM PWM counter clock source, should be
> > +one of the
> > +  entries in clock-names.
> 
> So the IP block has 3 input clocks, and also a mux to select which one to
> use? That sounds slightly unusual, but possible.
> 
> If there is really only 1 clock input to the IP block, and the mux is
> part of some other module, then this binding should have only 1 entry in
> clocks.
> 

Yes, there are 3 input clocks that can be selectable, and the mux is inside the FTM IP block.


Thanks.

--
Best Regard,
Xiubo

