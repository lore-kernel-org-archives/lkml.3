Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533Ab3BSLY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 06:24:28 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:36015 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab3BSLY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 06:24:26 -0500
From: "Mohammed, Afzal" <afzal@ti.com>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Nicolas Pitre <nico@linaro.org>, Will Deacon <will.deacon@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, "Nori, Sekhar" <nsekhar@ti.com>,
        "Syed Mohammed, Khasim" <khasim@ti.com>
Subject: RE: [PATCH, RFC 0/8] ARM: AM43 (OMAP2+) boot support
Thread-Topic: [PATCH, RFC 0/8] ARM: AM43 (OMAP2+) boot support
Thread-Index: AQHODcwskq1EWMr09keU4I6SYOFnppiAmqAAgABsi3A=
Date: Tue, 19 Feb 2013 11:24:01 +0000
Message-ID: <C8443D0743D26F4388EA172BF4E2A7A93EAA8776@DBDE01.ent.ti.com>
References: <cover.1361186097.git.afzal@ti.com> <51234F5C.6050500@ti.com>
In-Reply-To: <51234F5C.6050500@ti.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r1JBOVVU029174

Hi Santosh,

On Tue, Feb 19, 2013 at 15:39:32, Shilimkar, Santosh wrote:

> After looking at the specs, you don't need the SMP mode since ACP
> isn't being used.

> TWD use for AM437x is also limited because these times stops in
> low power sates and there you will need broad-cast mechanism which
> again more of SMP machine feature.
> 
> So I suggest to use the wakeup timer(GPT1) clock-event instead
> of local timer for the mentioned reason.

Ok, all your remaining comments are w.r.t SMP and usage of TWD
as clock event.

I am not that familiar with SMP things, upon starting on AM43,
observing the fact that it is an SMP with one core configuration
and that as per ARM MP Core TRM it can have local timer, I saw
it as a ray of hope to get Kernel booting early without hwmod,
and I jumped on that idea which I feel was natural. Without
spending too much time on it, though of taking feedback on this
approach, resulting this rfc.

Let me understand more on SMP, TWD, and explore possibility
of using GPT1 instead of TWD for clock event.

>From the beginning I wondered on seeing that as per ARM TRM's
Cortex-A9 can be MP core with 1-4 core (instead of 2-4), while
another uniprocessor A9 configuration is present.

Regards
Afzal

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
