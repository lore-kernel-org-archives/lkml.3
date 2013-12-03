Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab3LCG4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 01:56:52 -0500
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:28948
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751711Ab3LCG4t convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 01:56:49 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(z579ehz1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de097hz2dh109h2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h2184h21a6h2216h22d0h2336hbe9i1155h)
From: Li Xiubo <Li.Xiubo@freescale.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: Shawn Guo <Shawn.Guo@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
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
Subject: RE: [PATCHv6 4/4] Documentation: Add device tree bindings for
 Freescale FTM PWM.
Thread-Topic: [PATCHv6 4/4] Documentation: Add device tree bindings for
 Freescale FTM PWM.
Thread-Index: AQHO304Oa+l5Yof+m0uL31eeJzu+Zpo7Q+4AgAblB9A=
Date: Tue, 3 Dec 2013 06:56:44 +0000
Message-ID: <1DD289F6464F0949A2FCA5AA6DC23F828E38BB@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1384220218-12716-1-git-send-email-Li.Xiubo@freescale.com>
 <1384220218-12716-5-git-send-email-Li.Xiubo@freescale.com>
 <20131128213159.GE14689@mithrandir>
In-Reply-To: <20131128213159.GE14689@mithrandir>
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


> > +    "ftm0" (module clock),
> > +    "ftm0_counter" (counter clock),
> > +- clocks : Must contain a clock specifier for each entry in
> > +clock-names,
> > +  See clock/clock-bindings.txt for details of the property values.
> 
> Note that the order is significant here, at least from the way the driver
> currently implements this. You can probably make this more generic in the
> driver by using of_property_match_string() on the clock-names property to
> find the index of "ftm0_counter" and pass that index to the
> of_parse_phandle_with_args() function to cope with the situation where the
> device tree has the clocks in a different order.
> 

Yes, this's much better. As this is still under discussing, I will improve
about this after that.

And I will also revise other as you have piontet out.

--
Best Regards,


