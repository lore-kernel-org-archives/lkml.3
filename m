Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222AbaK1MGo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 07:06:44 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33382 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750895AbaK1MGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 07:06:42 -0500
Date: Fri, 28 Nov 2014 12:06:36 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: James Liao <jamesjj.liao@mediatek.com>
Cc: Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Mike Turquette <mturquette@linaro.org>,
        "srv_heupstream@mediatek.com" <srv_heupstream@mediatek.com>,
        "srv_jamesjj.liao@mediatek.com" <srv_jamesjj.liao@mediatek.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        "eddie.huang@mediatek.com" <eddie.huang@mediatek.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Vladimir Murzin <Vladimir.Murzin@arm.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        "Joe.C" <yingjoe.chen@mediatek.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/4] clk: Add INFRA and PERI clocks for Mediatek MT8135.
Message-ID: <20141128120636.GD25883@leverpostej>
References: <1417174490-6845-1-git-send-email-jamesjj.liao@mediatek.com>
 <1417174490-6845-3-git-send-email-jamesjj.liao@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417174490-6845-3-git-send-email-jamesjj.liao@mediatek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 11:34:48AM +0000, James Liao wrote:
> This patch adds clock gates support for Mediatek SoCs, and adds clocks of
> INFRA sys and PERI sys for MT8135.
> 
> Signed-off-by: James Liao <jamesjj.liao@mediatek.com>
> ---
>  drivers/clk/mediatek/Makefile          |   2 +-
>  drivers/clk/mediatek/clk-gate.c        | 151 +++++++++++++++++++
>  drivers/clk/mediatek/clk-gate.h        |  48 ++++++
>  drivers/clk/mediatek/clk-mt8135.c      | 260 +++++++++++++++++++++++++++++++++
>  include/dt-bindings/clock/mt8135-clk.h |  62 ++++++++

Please fold the include/dt-bindings changes into the DT documentation
patch, and put that earlier in the series.

Mark.
