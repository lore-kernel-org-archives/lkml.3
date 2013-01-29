Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab3A2Jm7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 04:42:59 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:53476 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306Ab3A2Jm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 04:42:56 -0500
From: "Mohammed, Afzal" <afzal@ti.com>
To: Paul Walmsley <paul@pwsan.com>
CC: Russell King <linux@arm.linux.org.uk>, Tony Lindgren <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v2 1/4] ARM: OMAP2+: dpll: round rate to closest value
Thread-Topic: [PATCH v2 1/4] ARM: OMAP2+: dpll: round rate to closest value
Thread-Index: AQHN+V650qHIse4sHkK4E3rAfVNglZhZWhaAgACdMNCABhe6cA==
Date: Tue, 29 Jan 2013 09:42:39 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A93EA94FDD@DBDE01.ent.ti.com>
References: <cover.1358937533.git.afzal@ti.com>
 <871e6890897534b6c3669e252f23bef5ff1247b6.1358937533.git.afzal@ti.com>
 <alpine.DEB.2.00.1301250816010.471@utopia.booyaka.com>
 <C8443D0743D26F4388EA172BF4E2A7A93EA9388C@DBDE01.ent.ti.com>
In-Reply-To: <C8443D0743D26F4388EA172BF4E2A7A93EA9388C@DBDE01.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0T9h40W007111

Hi Paul,

On Fri, Jan 25, 2013 at 17:48:22, Mohammed, Afzal wrote:
> On Fri, Jan 25, 2013 at 13:48:11, Paul Walmsley wrote:

> > like MPU CPUFreq.  I'd suggest reverting 
> > 241d3a8dca239610d3d991bf58d4fe38c2d86fd5 or using a similar approach.

> As you prefer reverting the above commit, I will proceed so, hmm.. got

This patch or reverting the above mentioned commit is not required for
lcdc to be usable on am335x, instead please consider for inclusion
patches 3 & 4 of this series,

"ARM: OMAP2+: clock: DEFINE_STRUCT_CLK_FLAGS helper" and
"ARM: AM33XX: clock: SET_RATE_PARENT in lcd path"

Patches 3 & 4 are required to have a functional frame buffer driver
on am335x, also it may help drm driver for the lcdc ip in am335x to
be a platform independent one.

Regards
Afzal

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
