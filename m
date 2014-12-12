Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760006AbaLLPoK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 10:44:10 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:48066 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665AbaLLPoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 10:44:08 -0500
MIME-Version: 1.0
In-Reply-To: <1418396066-31360-1-git-send-email-julien.chauveau@neo-technologies.fr>
References: <1418396066-31360-1-git-send-email-julien.chauveau@neo-technologies.fr>
Date: Fri, 12 Dec 2014 16:44:06 +0100
Message-ID: <CABgxDoKKjwDf8+OuWiTjzpbGonshZ0fHXXMvSkJi1Z1U_7AsNA@mail.gmail.com>
Subject: Re: [PATCH] clk: rockchip: add CLK_IGNORE_UNUSED flag to fix USB Host
From: Romain Perier <romain.perier@gmail.com>
To: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
Cc: Heiko Stuebner <heiko@sntech.de>, Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "moderated list:ARM/Rockchip SoC..." 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "open list:COMMON CLK FRAMEWORK" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2014-12-12 15:54 GMT+01:00 Julien CHAUVEAU
<julien.chauveau@neo-technologies.fr>:
> This patch adds CLK_IGNORE_UNUSED flag to hclk_usb_peri, hclk_usbotg0 and hclk_usbotg1
> because these clocks must remain enabled to use the USB controllers in host mode.
>
> This fixes a regression introduced by patch "clk: rockchip: disable unused clocks"
> https://lkml.kernel.org/g/1415092270-24932-1-git-send-email-kever.yang@rock-chips.com

Could you refer the commit id instead ? something like "commit <ID>
("title of the corresponding commit")  (and use scripts/checkpatch.pl
on your patch to be sure that the commit form is okay).


I confirm the regression.

Romain
