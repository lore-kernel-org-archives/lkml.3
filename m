Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbaCEJuU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 04:50:20 -0500
Received: from mail1.bemta14.messagelabs.com ([193.109.254.108]:9911 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752331AbaCEJuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 04:50:16 -0500
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-7.tower-194.messagelabs.com!1394013012!13920554!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>
To: Lee Jones <lee.jones@linaro.org>,
        "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>
Subject: RE: [PATCH Resend 2/2] mfd: da9055: Add DT binding documentation
 for PMIC
Thread-Topic: [PATCH Resend 2/2] mfd: da9055: Add DT binding documentation
 for PMIC
Thread-Index: AQHPOBwQQANILTjFQEuHGLJYPpcoYJrSQCbQ
Date: Wed, 5 Mar 2014 09:50:10 +0000
Message-ID: <2E89032DDAA8B9408CB92943514A03376BAD4D92@SW-EX-MBX01.diasemi.com>
References: <cover.1392286537.git.Adam.Thomson.Opensource@diasemi.com>
 <574af9f46ca08e66f6e9bda8ef3a51e7c5c5178b.1392286537.git.Adam.Thomson.Opensource@diasemi.com>
 <20140305023850.GN10579@lee--X1>
In-Reply-To: <20140305023850.GN10579@lee--X1>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.27.23]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s259pVo2013929

On Tue, 05 Mar 2014 02:40:38 +0000, Lee Jones wrote:

> > Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
> > Acked-by: Mark Brown <broonie@kernel.org>
> 
> As this has Mark's ack, I'd be happy to apply the patch if you correct
> a couple of nits.

Yep. No problem.

> > +Example:
> > +
> > +	pmic: da9055-pmic@5a {
> > +		compatible = "dlg,da9055-pmic";
> > +		reg = <0x5a>;
> > +		interrupt-parent = <&intc>;
> > +		interrupts = <5 0x8>;
> 
> I'd prefer if you used the #defines in:
>     dt-bindings/interrupt-controller/irq.h

Fine. Will do that.

> > +			buck2: BUCK2 {
> > +				regulator-min-microvolt = <925000>;
> > +				regulator-max-microvolt = <2500000>;
> > +			};
> 
> New line here.

Will remove it.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
