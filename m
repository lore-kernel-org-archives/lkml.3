Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbaLVHrQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 02:47:16 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:53606 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750928AbaLVHrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 02:47:14 -0500
X-Listener-Flag: 11101
Subject: Re: [PATCH v2 0/4] clk: mediatek: Add common clock support for
 Mediatek MT8135.
From: James Liao <jamesjj.liao@mediatek.com>
To: Mike Turquette <mturquette@linaro.org>
CC: Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sascha Hauer <kernel@pengutronix.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        Yingjoe Chen <Yingjoe.Chen@mediatek.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        srv_heupstream <srv_heupstream@mediatek.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        HenryC Chen <HenryC.Chen@mediatek.com>
In-Reply-To: <1417675942-10502-1-git-send-email-jamesjj.liao@mediatek.com>
References: <1417675942-10502-1-git-send-email-jamesjj.liao@mediatek.com>
Content-Type: text/plain; charset="us-ascii"
Date: Mon, 22 Dec 2014 15:46:59 +0800
Message-ID: <1419234419.24116.7.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2014-12-04 at 14:52 +0800, James Liao wrote:
> This patchset contains the initial common clock support for Mediatek SoCs.
> Mediatek SoC's clock architecture comprises of various PLLs, dividers,
> muxes and clock gates.
> 
> This patchset also contains a basic clock support for Mediatek MT8135.
> 
> This driver is based on 3.18-rc1 + MT8135 basic support.
> 
> James Liao (4):
>   clk: dts: mediatek: add Mediatek MT8135 clock bindings
>   clk: mediatek: Add initial common clock support for Mediatek SoCs.
>   clk: mediatek: Add basic clocks for Mediatek MT8135.
>   dts: mediatek: Enable clock support for Mediatek MT8135.
> 

Hi,

Any comment for this patchset?


Best regards,
James


