Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856Ab3A1J0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 04:26:35 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:48300 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985Ab3A1JZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 04:25:54 -0500
From: "Mohammed, Afzal" <afzal@ti.com>
To: Mike Turquette <mturquette@linaro.org>, Paul Walmsley <paul@pwsan.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: RE: RE: [PATCH v2 1/4] ARM: OMAP2+: dpll: round rate to closest
 value
Thread-Topic: RE: [PATCH v2 1/4] ARM: OMAP2+: dpll: round rate to closest
 value
Thread-Index: AQHN+V650qHIse4sHkK4E3rAfVNglZhZWhaAgACdMNCAAE4pAIAEKvHQ
Date: Mon, 28 Jan 2013 09:25:41 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A93EA9446B@DBDE01.ent.ti.com>
References: <cover.1358937533.git.afzal@ti.com>
 <871e6890897534b6c3669e252f23bef5ff1247b6.1358937533.git.afzal@ti.com>
 <alpine.DEB.2.00.1301250816010.471@utopia.booyaka.com>
 <C8443D0743D26F4388EA172BF4E2A7A93EA9388C@DBDE01.ent.ti.com>
 <20130125222032.10623.47200@quantum>
In-Reply-To: <20130125222032.10623.47200@quantum>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0S9QXMj000563

Hi Mike,

On Sat, Jan 26, 2013 at 03:50:32, Mike Turquette wrote:

> Is MULT_ROUND_UP doing the right thing for you in the clk_divider code?
> What is the clock rate requested of the parent PLL?  I just want to make
> sure that we're doing the right thing in the basic divider code.

Actually MULT_ROUND_UP made my life difficult earlier, and finally came up
with this solution instead of removing it.

It was something like 60000000 requested of PLL, for i = 1, but for other
values, it was something like 60000001, 60000002 etc.

Even if round rate rounds, I thought removing MULT_ROUND_UP would be ok,
couldn't spend time to understand fully rational behind it, and as it was
in generic code, kept away from doing it.

Regards
Afzal

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
