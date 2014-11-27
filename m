Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506AbaK0NbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 08:31:18 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:57277 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751223AbaK0NbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 08:31:16 -0500
X-Listener-Flag: 11101
Subject: Re: [PATCH v8 3/4] ARM: mediatek: Add sysirq in
 mt6589/mt8135/mt8127 dtsi
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Matthias Brugger <matthias.bgg@gmail.com>
CC: Jason Cooper <jason@lakedaemon.net>, Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        <devicetree@vger.kernel.org>, <hc.yen@mediatek.com>,
        <srv_heupstream@mediatek.com>, <yh.chen@mediatek.com>,
        <linux-kernel@vger.kernel.org>, Grant Likely <grant.likely@linaro.org>,
        Yijing Wang <wangyijing@huawei.com>, Rob Herring <robh+dt@kernel.org>,
        <nathan.chung@mediatek.com>, <yingjoe.chen@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>, <eddie.huang@mediatek.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <1416902662-19281-4-git-send-email-yingjoe.chen@mediatek.com>
References: <1416902662-19281-1-git-send-email-yingjoe.chen@mediatek.com>
	 <1416902662-19281-4-git-send-email-yingjoe.chen@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Nov 2014 21:31:12 +0800
Message-ID: <1417095072.12707.29.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-25 at 16:04 +0800, Yingjoe Chen wrote:
> Add sysirq settings for mt6589/mt8135/mt8127
> This also correct timer interrupt flag. The old setting works
> because boot loader already set polarity for timer interrupt.
> Without intpol support, the setting was not changed so gic
> can get the irq correctly.

Hi Matthias,

I think this patch should go through you. Would you take a look at this
patch? Also, mt8135/mt8127 uart support[1] depends on this, should we
send it again?

Thanks.

Joe.C

[1]
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-October/296147.html


