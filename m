Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbaKYL1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:27:42 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:38770 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbaKYL1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 06:27:40 -0500
Message-ID: <547467A1.8000900@arm.com>
Date: Tue, 25 Nov 2014 11:27:29 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>
CC: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <Pawel.Moll@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "hc.yen@mediatek.com" <hc.yen@mediatek.com>,
        "srv_heupstream@mediatek.com" <srv_heupstream@mediatek.com>,
        "yh.chen@mediatek.com" <yh.chen@mediatek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Yijing Wang <wangyijing@huawei.com>, Rob Herring <robh+dt@kernel.org>,
        "nathan.chung@mediatek.com" <nathan.chung@mediatek.com>,
        "yingjoe.chen@gmail.com" <yingjoe.chen@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "eddie.huang@mediatek.com" <eddie.huang@mediatek.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 1/4] irqchip: gic: Support hierarchy irq domain.
References: <1416902662-19281-1-git-send-email-yingjoe.chen@mediatek.com> <1416902662-19281-2-git-send-email-yingjoe.chen@mediatek.com>
In-Reply-To: <1416902662-19281-2-git-send-email-yingjoe.chen@mediatek.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/11/14 08:04, Yingjoe Chen wrote:
> Add support to use gic as a parent for stacked irq domain.
> 
> Signed-off-by: Yingjoe Chen <yingjoe.chen@mediatek.com>

Looks good to me.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...
