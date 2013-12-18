Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab3LRDi0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 22:38:26 -0500
Received: from nasmtp01.atmel.com ([192.199.1.246]:26617 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751465Ab3LRDiY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 22:38:24 -0500
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Mark Brown <broonie@kernel.org>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "vpalatin@chromium.org" <vpalatin@chromium.org>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCH 3/3 v2] ARM: dts: sama5d3xcm: add the regulator device
 node
Thread-Topic: [PATCH 3/3 v2] ARM: dts: sama5d3xcm: add the regulator device
 node
Thread-Index: AQHO+upDybADKfGWgU6rO2AhovoUCppXzcgAgAF6jYA=
Date: Wed, 18 Dec 2013 03:15:10 +0000
Message-ID: <B256D81BAE5131468A838E5D7A24364172F1839C@penmbx01>
References: <1387258597-21866-1-git-send-email-wenyou.yang@atmel.com>
 <1387258597-21866-4-git-send-email-wenyou.yang@atmel.com>
 <20131217123818.GV3185@sirena.org.uk>
In-Reply-To: <20131217123818.GV3185@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.5.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

> -----Original Message-----
> From: Mark Brown [mailto:broonie@kernel.org]
> Sent: Tuesday, December 17, 2013 8:38 PM
> To: Yang, Wenyou
> Cc: lgirdwood@gmail.com; linux-kernel@vger.kernel.org;
> grant.likely@linaro.org; rob.herring@calxeda.com; linux-
> doc@vger.kernel.org; vpalatin@chromium.org; Ferre, Nicolas;
> plagnioj@jcrosoft.com; linux-arm-kernel@lists.infradead.org;
> devicetree@vger.kernel.org
> Subject: Re: [PATCH 3/3 v2] ARM: dts: sama5d3xcm: add the regulator
> device node
> 
> On Tue, Dec 17, 2013 at 01:36:37PM +0800, Wenyou Yang wrote:
> 
> > +						vcc_1v8_reg: DCDC_REG1 {
> > +							regulator-name = "DCDC_REG1";
> 
> The whole point of naming the regulators is to help users read kernel
> diagnostic output so the should normally be named after the supply in
> the schematic.  If you're using the name of the supply on the PMIC you
> can just omit it since that's the default anyway and it's not adding
> extra information.  Use something like VCC_1V8.
Thanks a lot.
Change regulator-name with VCC_1V8, VCC_1V2 ... which named after the supply in the schematic.


Best Regards,
Wenyou Yang
