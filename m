Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758440AbbA0OVN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 09:21:13 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:47552 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354AbbA0OVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 09:21:10 -0500
MIME-Version: 1.0
In-Reply-To: <1422339332-27498-2-git-send-email-chaotian.jing@mediatek.com>
References: <1422339332-27498-1-git-send-email-chaotian.jing@mediatek.com>
	<1422339332-27498-2-git-send-email-chaotian.jing@mediatek.com>
Date: Tue, 27 Jan 2015 15:21:10 +0100
Message-ID: <CACRpkdbncsDJ3pP0dETpho5+j+OVuaYr=YTsH8pAs7vuT_9OLw@mail.gmail.com>
Subject: Re: [PATCH 1/7] pinctrl: mediatek: emulate GPIO interrupt on both-edges
From: Linus Walleij <linus.walleij@linaro.org>
To: Chaotian Jing <chaotian.jing@mediatek.com>,
        Hongzhou Yang <hongzhou.yang@mediatek.com>
Cc: Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        srv_heupstream@mediatek.com, Sascha Hauer <kernel@pengutronix.de>,
        Mark Rutland <mark.rutland@arm.com>, Will Deacon <will.deacon@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        James Liao <jamesjj.liao@mediatek.com>,
        "Joe.C" <yingjoe.chen@mediatek.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        bin.zhang@mediatek.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 7:15 AM, Chaotian Jing
<chaotian.jing@mediatek.com> wrote:

> From: Yingjoe Chen <yingjoe.chen@mediatek.com>
>
> MTK EINT does not support generating interrupt on both edges.
> Emulate this by changing edge polarity while enable irq,
> set types and interrupt handling. This follows an example of
> drivers/gpio/gpio-mxc.c.
>
> Signed-off-by: Yingjoe Chen <yingjoe.chen@mediatek.com>
> Signed-off-by: Chaotian Jing <chaotian.jing@mediatek.com>

Hongzhu, if you're fine with this patch can you ACK it as maintainer
of the pinctrl driver so I can merge it immediately on top of your
drivern whenever we consider it finished (and if it applies still...)

Yours,
Linus Walleij
