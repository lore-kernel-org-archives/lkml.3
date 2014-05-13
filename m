Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967AbaEMJlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:41:18 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38064 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932715AbaEMJlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:41:13 -0400
Message-ID: <5371E8B7.8000103@linaro.org>
Date: Tue, 13 May 2014 10:41:11 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        agross@quicinc.com,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v1 01/11] ARM: amba: Add Qualcomm vendor ID.
References: <1398759492-12970-1-git-send-email-srinivas.kandagatla@linaro.org>	<1398759542-13017-1-git-send-email-srinivas.kandagatla@linaro.org> <CACRpkdZyEAkJUGC5x6CY65-g97jfyg-TMDoe8JxDMexVx5usSA@mail.gmail.com>
In-Reply-To: <CACRpkdZyEAkJUGC5x6CY65-g97jfyg-TMDoe8JxDMexVx5usSA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Linus W,

On 13/05/14 08:16, Linus Walleij wrote:
> On Tue, Apr 29, 2014 at 10:19 AM,  <srinivas.kandagatla@linaro.org> wrote:
>
>> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>>
>> This patch adds Qualcomm amba vendor Id to the list. This ID is used in mmci
>> driver.
>>
>> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> (...)
>> +       AMBA_VENDOR_QCOM = 0x51,
>
> Yeah it's a "Q", like 0x41 is "A" for ARM. You could as well mention
> this in the commit message.
>
Sounds good, I will fix it in next version and send it to Russell's 
patch tracker.


--srini
> And you can probably just put this patch into Russell's patch tracker
> already.
>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>
> Yours,
> Linus Walleij
>
