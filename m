Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab3IJINH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 04:13:07 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:55048
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753280Ab3IJINC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 04:13:02 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(z551biz98dI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5hbe9i1155h)
From: Xiubo Li-B47053 <B47053@freescale.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
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
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Lu Jingchang-B35083 <B35083@freescale.com>
Subject: RE: [PATCHv3 1/4] pwm: Add Freescale FTM PWM driver support
Thread-Topic: [PATCHv3 1/4] pwm: Add Freescale FTM PWM driver support
Thread-Index: AQHOqtj4x7mE/zXQK02bYMa5ShaBn5m+jrwAgAAV7YA=
Date: Tue, 10 Sep 2013 08:12:07 +0000
Message-ID: <1DD289F6464F0949A2FCA5AA6DC23F8281470E@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1378454907-22728-1-git-send-email-Li.Xiubo@freescale.com>
 <1378454907-22728-2-git-send-email-Li.Xiubo@freescale.com>
 <20130910065146.GA30088@pengutronix.de>
In-Reply-To: <20130910065146.GA30088@pengutronix.de>
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

> Subject: Re: [PATCHv3 1/4] pwm: Add Freescale FTM PWM driver support
> 
> On Fri, Sep 06, 2013 at 04:08:24PM +0800, Xiubo Li wrote:
> > The FTM PWM device can be found on Vybrid VF610 Tower and Layerscape
> LS-1 SoCs.
> >
> > +
> > +static int fsl_pwm_probe(struct platform_device *pdev) {
> > +	int ret = 0;
> > +	struct fsl_pwm_chip *fpc;
> > +	struct resource *res;
> > +
> > +	fpc = devm_kzalloc(&pdev->dev, sizeof(*fpc), GFP_KERNEL);
> 
> You don't have to output a message when kzalloc fails, but still you
> should check for the result and return an error if necessary.
> 
Okey, I will.

--
Xiubo

