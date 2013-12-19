Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155Ab3LSB1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 20:27:53 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:60140 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab3LSB1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 20:27:51 -0500
Message-ID: <52B24B95.8010004@codeaurora.org>
Date: Wed, 18 Dec 2013 17:27:49 -0800
From: Rohit Vaswani <rvaswani@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Bjorn Andersson <Bjorn.Andersson@sonymobile.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Subject: Re: [PATCH 1/2] gpio: msm: Fix irq mask/unmask by writing bits instead
 of numbers
References: <1386717544-478-1-git-send-email-sboyd@codeaurora.org> <CACRpkdY8W8tGVH-Os5neeFfHWjojdB5fBbjgWcsWkiMyJj=YAA@mail.gmail.com>
In-Reply-To: <CACRpkdY8W8tGVH-Os5neeFfHWjojdB5fBbjgWcsWkiMyJj=YAA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2013 11:02 AM, Linus Walleij wrote:
> On Wed, Dec 11, 2013 at 12:19 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>
>> We should be writing bits here but instead we're writing the
>> numbers that correspond to the bits we want to write. Fix it by
>> wrapping the numbers in the BIT() macro. This fixes gpios acting
>> as interrupts.
>>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> I've applied this for fixes and tagged for stable.
> Björn, Rohit: OK?
>
> Yours,
> Linus Walleij
Acked-by: Rohit Vaswani <rvaswani@codeaurora.org>

Thanks,
Rohit Vaswani

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, hosted by The Linux Foundation

