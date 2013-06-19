Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419Ab3FSTuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 15:50:07 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44064 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756805Ab3FSTuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 15:50:05 -0400
Message-ID: <51C20B6B.8050303@codeaurora.org>
Date: Wed, 19 Jun 2013 12:50:03 -0700
From: Rohit Vaswani <rvaswani@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] drivers: gpio: msm: Fix the error condition for reading
 ngpio
References: <1371603747-27436-1-git-send-email-rvaswani@codeaurora.org> <1371603747-27436-3-git-send-email-rvaswani@codeaurora.org> <CACRpkdbYimoG1H4U8gKTN=jkX2S6_SK8jtfii2-kKWhQW58drQ@mail.gmail.com>
In-Reply-To: <CACRpkdbYimoG1H4U8gKTN=jkX2S6_SK8jtfii2-kKWhQW58drQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/19/2013 12:45 PM, Linus Walleij wrote:
> On Wed, Jun 19, 2013 at 3:02 AM, Rohit Vaswani <rvaswani@codeaurora.org> wrote:
>
>> of_property_read_u32 return 0 on success. The check was using a ! to
>> return error. Fix the if condition.
>>
>> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>
> I guess this is going through the MSM tree as well?
>
> Yours,
> Linus Walleij
Yes, going through MSM tree.

Thanks,
Rohit Vaswani

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, hosted by The Linux Foundation

