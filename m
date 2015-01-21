Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbbAUFjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 00:39:52 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:56288 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750791AbbAUFju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 00:39:50 -0500
X-Listener-Flag: 11101
Subject: Re: [PATCH v5 0/5] Add Mediatek SoC Pinctrl/GPIO/EINT driver for
 MT8135.
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Hongzhou Yang <hongzhou.yang@mediatek.com>
CC: Rob Herring <robh+dt@kernel.org>, Linus Walleij <linus.walleij@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sascha Hauer <kernel@pengutronix.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <dandan.he@mediatek.com>,
        <alan.cheng@mediatek.com>, <toby.liu@mediatek.com>,
        <maoguang.meng@mediatek.com>, <eddie.huang@mediatek.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrsoft.com>
In-Reply-To: <1421818097-9281-1-git-send-email-hongzhou.yang@mediatek.com>
References: <1421818097-9281-1-git-send-email-hongzhou.yang@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Jan 2015 13:39:46 +0800
Message-ID: <1421818786.11671.75.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-21 at 13:28 +0800, Hongzhou Yang wrote:
> This is v5 of add Mediatek SoC Pinctrl/GPIO/EINT driver for MT8135.
> It is based on Joe.C' basic device tree support.
> See http://lists.infradead.org/pipermail/linux-arm-kernel/2014-October/296093.html

Hi,

A little correction.
I just talked to Hongzhou, this series is based on 3.19-rc1 instead of
my old patch. Sorry for the confusion.

Joe.C


