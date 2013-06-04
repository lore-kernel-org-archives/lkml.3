Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759203Ab3FDGZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 02:25:24 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35829 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755438Ab3FDGZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 02:25:21 -0400
From: "J, KEERTHY" <j-keerthy@ti.com>
To: Stephen Warren <swarren@wwwdotorg.org>, Lee Jones <lee.jones@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "wim@iguana.be" <wim@iguana.be>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "Kristo, Tero" <t-kristo@ti.com>, Ian Lartey <ian@slimlogic.co.uk>
Subject: RE: [PATCH] mfd: DT bindings for the palmas family MFD
Thread-Topic: [PATCH] mfd: DT bindings for the palmas family MFD
Thread-Index: AQHOYFQdmRK78L3sG0+rK4Xnj9z9npkjg8WAgABqGACAASl9YA==
Date: Tue, 4 Jun 2013 06:24:45 +0000
Message-ID: <DC88CAD03C0052499C1907B327FC63229E8AFE@DBDE04.ent.ti.com>
References: <1370261333-5121-1-git-send-email-j-keerthy@ti.com>
 <20130603141851.GG3370@gmail.com> <51ACFECA.10209@wwwdotorg.org>
In-Reply-To: <51ACFECA.10209@wwwdotorg.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r546PUYZ013733



> -----Original Message-----
> From: Stephen Warren [mailto:swarren@wwwdotorg.org]
> Sent: Tuesday, June 04, 2013 2:09 AM
> To: Lee Jones
> Cc: J, KEERTHY; linux-kernel@vger.kernel.org; linux-
> doc@vger.kernel.org; devicetree-discuss@lists.ozlabs.org;
> broonie@opensource.wolfsonmicro.com; rob.herring@calxeda.com;
> rob@landley.net; mturquette@linaro.org; sameo@linux.intel.com;
> wim@iguana.be; lgirdwood@gmail.com; gg@slimlogic.co.uk; Kristo, Tero;
> Ian Lartey
> Subject: Re: [PATCH] mfd: DT bindings for the palmas family MFD
> 
> On 06/03/2013 08:18 AM, Lee Jones wrote:
> > On Mon, 03 Jun 2013, J Keerthy wrote:
> >> Add the various binding files for the palmas family of chips. There
> >> is a top level MFD binding then a seperate binding for regulators IP
> blocks on chips.
> 
> >> diff --git a/Documentation/devicetree/bindings/mfd/palmas.txt
> >> b/Documentation/devicetree/bindings/mfd/palmas.txt
> 
> >> +Example:
> >> +
> >> +palmas {
> >
> > Should this be 'palmas@48 {', as it has an address?
> 
> It's common to only include the unit-address (@48) if it's needed to
> make the node name unique (i.e. if you had multiple palmas devices).

Yeah. We generally have one Palmas device.

> 
> >> diff --git
> >> a/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
> >> b/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
> 
> > See: Documentation/devicetree/bindings/regulator/gpio-regulator.txt
> >
> >> +	       ti,sleep-mode - mode to adopt in pmic sleep 0 - off, 1 -
> auto,
> >> +	       2 - eco, 3 - forced pwm
> >
> > I've seen lots of sleep-mode properties, can't we define a generic
> > one?
> 
> Isn't it HW-specific?

Yeah. Hence it is ti,sleep-mode.

Regards,
Keerthy
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
