Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbaLDHPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 02:15:55 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:49114 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750992AbaLDHPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 02:15:53 -0500
X-Listener-Flag: 11101
Subject: Re: [PATCH v2 0/4] clk: mediatek: Add common clock support for
 Mediatek MT8135.
From: James Liao <jamesjj.liao@mediatek.com>
To: Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Mike Turquette <mturquette@linaro.org>
CC: srv_heupstream <srv_heupstream@mediatek.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Eddie Huang =?euc-kr?Q?=28=FC=DC=F2=AA=CB=F8=29?= 
	<eddie.huang@mediatek.com>,
        HenryC Chen =?iso-2022-jp?Q?=28=1B=24BDD7z9k=1B=28B=29?= 
	<HenryC.Chen@mediatek.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        Yingjoe Chen =?iso-2022-jp?Q?=28=1B=24BDD1Q=3D=27=1B=28B=29?= 
	<Yingjoe.Chen@mediatek.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <1417675942-10502-1-git-send-email-jamesjj.liao@mediatek.com>
References: <1417675942-10502-1-git-send-email-jamesjj.liao@mediatek.com>
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 4 Dec 2014 15:15:49 +0800
Message-ID: <1417677349.31427.26.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 2014-12-04 at 14:52 +0800, James Liao wrote:
> This patchset contains the initial common clock support for Mediatek SoCs.
> Mediatek SoC's clock architecture comprises of various PLLs, dividers,
> muxes and clock gates.
> 
> This patchset also contains a basic clock support for Mediatek MT8135.
> 
> This driver is based on 3.18-rc1 + MT8135 basic support.
> 

Changein v2:
- Re-ordered patchset. Fold include/dt-bindings and DT document in 1st
patch.



