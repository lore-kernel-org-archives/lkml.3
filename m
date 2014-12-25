Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbaLYCLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 21:11:21 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:41675 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751651AbaLYCLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 21:11:19 -0500
X-Listener-Flag: 11101
Subject: Re: [PATCH v8 3/4] ARM: mediatek: Add sysirq in
 mt6589/mt8135/mt8127 dtsi
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Matthias Brugger <matthias.bgg@gmail.com>
CC: Jason Cooper <jason@lakedaemon.net>, Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        <srv_heupstream@mediatek.com>, <devicetree@vger.kernel.org>,
        <hc.yen@mediatek.com>, <yh.chen@mediatek.com>,
        <linux-kernel@vger.kernel.org>, Yijing Wang <wangyijing@huawei.com>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>, <nathan.chung@mediatek.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Grant Likely <grant.likely@linaro.org>, <eddie.huang@mediatek.com>,
        <yingjoe.chen@gmail.com>, <linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <1416902662-19281-4-git-send-email-yingjoe.chen@mediatek.com>
References: <1416902662-19281-1-git-send-email-yingjoe.chen@mediatek.com>
	 <1416902662-19281-4-git-send-email-yingjoe.chen@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Dec 2014 10:11:09 +0800
Message-ID: <1419473469.7238.0.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Matthias,

On Tue, 2014-11-25 at 16:04 +0800, Yingjoe Chen wrote:
> Add sysirq settings for mt6589/mt8135/mt8127
> This also correct timer interrupt flag. The old setting works
> because boot loader already set polarity for timer interrupt.
> Without intpol support, the setting was not changed so gic
> can get the irq correctly.
> 
> Signed-off-by: Yingjoe Chen <yingjoe.chen@mediatek.com>
> ---
>  arch/arm/boot/dts/mt6589.dtsi | 14 ++++++++++++--
>  arch/arm/boot/dts/mt8127.dtsi | 14 ++++++++++++--
>  arch/arm/boot/dts/mt8135.dtsi | 14 ++++++++++++--
>  3 files changed, 36 insertions(+), 6 deletions(-)

It seems this patch is not merged in 3.19-rc1. This do have dependency
on other patches, and all the other patches in this series are merged.

Is this planed to merge later or do we need to send additional pull
request for it?

Joe.C


