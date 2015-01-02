Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640AbbABKQO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 05:16:14 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:33866 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbbABKQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 05:16:12 -0500
MIME-Version: 1.0
In-Reply-To: <1419473469.7238.0.camel@mtksdaap41>
References: <1416902662-19281-1-git-send-email-yingjoe.chen@mediatek.com>
	<1416902662-19281-4-git-send-email-yingjoe.chen@mediatek.com>
	<1419473469.7238.0.camel@mtksdaap41>
Date: Fri, 2 Jan 2015 11:16:10 +0100
Message-ID: <CABuKBeKj_+-7r-bUe_vuDdyE2V-uugfZ03dMwcbaqnNz8fLEXA@mail.gmail.com>
Subject: Re: [PATCH v8 3/4] ARM: mediatek: Add sysirq in mt6589/mt8135/mt8127 dtsi
From: Matthias Brugger <matthias.bgg@gmail.com>
To: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        srv_heupstream <srv_heupstream@mediatek.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        HC Yen <hc.yen@mediatek.com>,
        =?UTF-8?B?WUggQ2hlbiAo6Zmz5pix6LGqKQ==?= <yh.chen@mediatek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Rob Herring <robh+dt@kernel.org>,
        Nathan Chung <nathan.chung@mediatek.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        huang eddie <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

2014-12-25 3:11 GMT+01:00 Yingjoe Chen <yingjoe.chen@mediatek.com>:
>
> Hi Matthias,
>
> On Tue, 2014-11-25 at 16:04 +0800, Yingjoe Chen wrote:
>> Add sysirq settings for mt6589/mt8135/mt8127
>> This also correct timer interrupt flag. The old setting works
>> because boot loader already set polarity for timer interrupt.
>> Without intpol support, the setting was not changed so gic
>> can get the irq correctly.
>>
>> Signed-off-by: Yingjoe Chen <yingjoe.chen@mediatek.com>
>> ---
>>  arch/arm/boot/dts/mt6589.dtsi | 14 ++++++++++++--
>>  arch/arm/boot/dts/mt8127.dtsi | 14 ++++++++++++--
>>  arch/arm/boot/dts/mt8135.dtsi | 14 ++++++++++++--
>>  3 files changed, 36 insertions(+), 6 deletions(-)
>
> It seems this patch is not merged in 3.19-rc1. This do have dependency
> on other patches, and all the other patches in this series are merged.
>
> Is this planed to merge later or do we need to send additional pull
> request for it?

This patch got somehow lost, sorry for that. I apply it for v3.20.

>
> Joe.C
>
>



-- 
motzblog.wordpress.com
