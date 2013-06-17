Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab3FQROb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:14:31 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:38990 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab3FQRO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:14:29 -0400
Message-ID: <51BF43F4.9000007@codeaurora.org>
Date: Mon, 17 Jun 2013 10:14:28 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] gpio: msm-v1: Remove errant __devinit to fix compile
References: <1370373600-31921-1-git-send-email-sboyd@codeaurora.org> <CACRpkdZ5x3q9tn3J5_mQj-nJ_wO3HWgX5DTMQdMzF3mUDrAieQ@mail.gmail.com>
In-Reply-To: <CACRpkdZ5x3q9tn3J5_mQj-nJ_wO3HWgX5DTMQdMzF3mUDrAieQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/13 22:54, Linus Walleij wrote:
> On Tue, Jun 4, 2013 at 9:20 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>
>> Commit 7bce696 (gpio: Make gpio-msm-v1 into a platform driver,
>> 2013-03-04) was based on an older kernel where __devinit still
>> existed. Remove the erroneous __devinit marking.
>>
>> Cc: David Brown <davidb@codeaurora.org>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> Patch applied.
>
>

Thanks. It looks like David picked this up and sent it off to arm-soc
last week. Cc'ing Olof for awareness of a possible duplicate.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

