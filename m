Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbaJ1QXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 12:23:20 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:58417 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbaJ1QXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 12:23:18 -0400
MIME-Version: 1.0
In-Reply-To: <1413933557-25684-1-git-send-email-zyw@rock-chips.com>
References: <1413933461-25602-1-git-send-email-zyw@rock-chips.com>
	<1413933557-25684-1-git-send-email-zyw@rock-chips.com>
Date: Tue, 28 Oct 2014 17:23:17 +0100
Message-ID: <CACRpkdZhQpCS+S-EA_ehjrpj=uS7bnb4L_OohbnBw5sXfGgaeA@mail.gmail.com>
Subject: Re: [PATCH v4 1/6] pinctrl: rockchip: add suspend/resume functions
From: Linus Walleij <linus.walleij@linaro.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: Heiko Stuebner <heiko@sntech.de>, Mike Turquette <mturquette@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Doug Anderson <dianders@chromium.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-rockchip@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 1:19 AM, Chris Zhong <zyw@rock-chips.com> wrote:

> From: Chris <zyw@rock-chips.com>
>
> support suspend/resume of pinctrl, it allows handling sleep mode
> for hogged pins in pinctrl
>
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>

Looks good but I'm delegating to Heiko to collect and review patches
on the Rockchip pin control driver.

I will point out if I see something immediately disturbing.

Yours,
Linus Walleij
