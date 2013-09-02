Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007Ab3IBCTs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 22:19:48 -0400
Received: from [213.199.154.188] ([213.199.154.188]:58998 "EHLO
	db8outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757097Ab3IBCTq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 22:19:46 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz1432I168aJzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5hbe9i1155h)
From: Xiubo Li-B47053 <B47053@freescale.com>
To: Kumar Gala <galak@kernel.crashing.org>
CC: Guo Shawn-R65073 <r65073@freescale.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: RE: [PATCH 4/4] Documentation: Add device tree bindings for
 Freescale FTM PWM
Thread-Topic: [PATCH 4/4] Documentation: Add device tree bindings for
 Freescale FTM PWM
Thread-Index: AQHOnhwezjS9uM7qaEqpBdTwwEdnOZmuL2UAgAOU2vA=
Date: Mon, 2 Sep 2013 02:18:19 +0000
Message-ID: <1DD289F6464F0949A2FCA5AA6DC23F827F480B@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1377054462-6283-1-git-send-email-Li.Xiubo@freescale.com>
 <1377054462-6283-5-git-send-email-Li.Xiubo@freescale.com>
 <5EFBF478-CFCC-4E66-A279-25F4A338B05B@kernel.crashing.org>
In-Reply-To: <5EFBF478-CFCC-4E66-A279-25F4A338B05B@kernel.crashing.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.208.56]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: Re: [PATCH 4/4] Documentation: Add device tree bindings for
> Freescale FTM PWM
> 
> Should have at least something w/regards to a commit message.
> 

I have sent a V2 patch and have added it.


> > +  used to encode the polarity of PWM output. Set bit 0 of the third
> > +in PWM
> > +  specifier to 1 for inverse polarity & set to 0 for normal polarity.
> > +- fsl,pwm-clk-ps: the ftm0 pwm clock's prescaler, divide-by 2^n(n = 0
> ~ 7).
> > +- fsl,pwm-cpwm: Center-Aligned PWM (CPWM) mode.
> 
> Should describe this in more detail, what does the value actually mean
> for what modes there are?
> 

It's maybe a very useful feature for FTM core, but for PWM is not.
This isn't needed any more for PWM, and in V2 patch I have removed CPWM mode.

> > +- fsl,pwm-number: the number of PWM devices, and is must equal to the
> > +number
> > +  of "fsl,pwm-channels".
> 
> If they must be equal why do we need both?
> 

I have replaced both of them too in V2.

> > +- fsl,pwm-channels: the channels' order which is be used for pwm in
> > +ftm0
> > +  module, and they must be one or some of 0 ~ 7, because the ftm0
> > +only has
> > +  8 channels can be used.
> > +- for very channel, the revlatived the pinctrl should be at least two
> > +state
> 
> revlatived?
> 

This too.

--
Best Regards.
Xiubo


