Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab3HZF77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 01:59:59 -0400
Received: from [216.32.180.189] ([216.32.180.189]:32942 "EHLO
	co1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755334Ab3HZF74 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 01:59:56 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz98dI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5hbe9i1155h)
From: Xiubo Li-B47053 <B47053@freescale.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: Guo Shawn-R65073 <r65073@freescale.com>,
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
Subject: RE: [PATCH 2/4] ARM: dts: Add Freescale ftm pwm node for VF610.
Thread-Topic: [PATCH 2/4] ARM: dts: Add Freescale ftm pwm node for VF610.
Thread-Index: AQHOnhw9lED2fDbMIUSF1DXJFUOpg5mihb+AgAR/5QA=
Date: Mon, 26 Aug 2013 05:58:41 +0000
Message-ID: <1DD289F6464F0949A2FCA5AA6DC23F827E420C@039-SN2MPN1-012.039d.mgd.msft.net>
References: <1377054462-6283-1-git-send-email-Li.Xiubo@freescale.com>
 <1377054462-6283-3-git-send-email-Li.Xiubo@freescale.com>
 <20130823091309.GH3535@ulmo>
In-Reply-To: <20130823091309.GH3535@ulmo>
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

Hi Thierry,


> Subject: Re: [PATCH 2/4] ARM: dts: Add Freescale ftm pwm node for VF610.
> 
> On Wed, Aug 21, 2013 at 11:07:40AM +0800, Xiubo Li wrote:
> > Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> > ---
> >  arch/arm/boot/dts/vf610.dtsi | 83
> > +++++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 82 insertions(+), 1 deletion(-)
> 
> Please also pay attention to the correct capitalization in the subject
> here. "FTM" and "PWM". Furthermore this could probably use more than a
> single line as patch description.
> 

Yes, I will revise it in v2.



Thanks very much.

--
Best Regards.
Xiubo


