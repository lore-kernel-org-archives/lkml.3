Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125AbaJ1QFe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 12:05:34 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:41421 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062AbaJ1QF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 12:05:27 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkda6ebV51bPeyn6qsR97CdeV6nSTTsJmHmrcj-C0OXyDEw@mail.gmail.com>
References: <1413862894-2623-1-git-send-email-zyw@rock-chips.com>
	<1413863011-2736-1-git-send-email-zyw@rock-chips.com>
	<CACRpkda6ebV51bPeyn6qsR97CdeV6nSTTsJmHmrcj-C0OXyDEw@mail.gmail.com>
Date: Tue, 28 Oct 2014 09:05:26 -0700
X-Google-Sender-Auth: 5qO3yKWe1r87kXdiIDoYaHnApso
Message-ID: <CAD=FV=V2jEdZN0T54OezG5WTgEijN33EYUeuUXk8LCiTvhxn0w@mail.gmail.com>
Subject: Re: [PATCH v3 2/6] pinctrl: rockchip: save and restore gpio6_c6
 pinmux in suspend/resume
From: Doug Anderson <dianders@chromium.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Chris Zhong <zyw@rock-chips.com>, Heiko Stuebner <heiko@sntech.de>,
        Mike Turquette <mturquette@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
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

Linus,

On Tue, Oct 28, 2014 at 8:52 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Tue, Oct 21, 2014 at 5:43 AM,  <zyw@rock-chips.com> wrote:
>
>> From: Chris Zhong <zyw@rock-chips.com>
>>
>> Save and restore the gpio6_c6 pinmux setting, since Maskrom of RK3288
>> would modify it to sdmmc0_det, so it need to be restored to the correct
>> setting after resume from Maskrom.
>>
>> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
>> ---
>>
>> Changes in v3: None
>> Changes in v2: None
>
> Heiko, ping on this too.

There's a newer version with his review (v5).  For this series see:

pinctrl: rockchip: save and restore gpio6_c6 pinmux in suspend/resume
https://patchwork.kernel.org/patch/5160781/ -

pinctrl: rockchip: add suspend/resume functions
https://patchwork.kernel.org/patch/5160761/
