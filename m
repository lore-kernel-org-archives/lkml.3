Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab3FDL0a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 07:26:30 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49698 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab3FDL02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 07:26:28 -0400
From: "Mohammed, Afzal" <afzal@ti.com>
To: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        "Rob Herring" <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
Subject: RE: [PATCH v2 00/14] ARM: OMAP2+: AM43x initial support
Thread-Topic: [PATCH v2 00/14] ARM: OMAP2+: AM43x initial support
Thread-Index: AQHOWudac+Tmm+qC2EOmKn8k0W9MJZklci1w
Date: Tue, 4 Jun 2013 11:25:45 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A93EB14140@DBDE04.ent.ti.com>
References: <cover.1369658705.git.afzal@ti.com>
In-Reply-To: <cover.1369658705.git.afzal@ti.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r54BQZ60016075

Hi Tony,

On Mon, May 27, 2013 at 20:03:27, Mohammed, Afzal wrote:

> This series adds initial support for AM43x based SoC's. To boot
> AM43x, in addition to these patches, PRCM support is also needed,
> which would be posted later as a separate series. DT sources doesn't
> have "ti,hwmod" entry - this would be added along with PRCM support.
> 
> AM43x SoC's are based on ARM Cortex-A9 with one core. AM43x is similar
> to AM335x in it's peripheral capabilities, except a few additional
> ones, with many of the peripheral register mapping's similar. AM43x
> has a sync timer, which is being used as clocksource. Clockevent used
> is 1ms dmtimer.
> 
> SoC has PL310 L2 cache, support for it would be added later.
> 
> soc_is_am43xx() is introduced to handle AM43x specific details and
> soc_is_am437x() is a subclass of it - first member of the class.
> 
> AM43x is currently in pre-silicon stage and currently there are no
> public documents.
> 
> This has been tested on a pre-silicon platform that emulates AM43x SoC
> with additional changes on top of this.
> 
> AM335x based board (AM335x EVM) has been verfied to boot as earlier
> with this series.
> 
> Baseline: v3.10-rc3
> Dependency: "ARM: OMAP3+: am33xx id: Add new am33xx specific function to check dev_feature"
> 		by Vaibhav Hiremath <hvaibhav@ti.com>

If you have any comments on this series please let me know, else if
you are okay with this, please consider patches 1-10 for inclusion
in the coming merge window.

Patch 14/14 has been taken by Benoit and patches 11-13 are to be
dropped (as per discussion in 11/14 thread)

Regards
Afzal

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
