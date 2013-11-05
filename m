Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab3KEG34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 01:29:56 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:48014 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab3KEG3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 01:29:54 -0500
MIME-Version: 1.0
In-Reply-To: <20131031161603.GB9587@lee--X1>
References: <1383202124-1775-1-git-send-email-tushar.behera@linaro.org>
	<1383202124-1775-4-git-send-email-tushar.behera@linaro.org>
	<20131031161603.GB9587@lee--X1>
Date: Tue, 5 Nov 2013 11:59:54 +0530
Message-ID: <CAHbNUh2GRv3bQD30PtBcoW9-K8PFm4FYWUNXBQEDUH-iVb_JOw@mail.gmail.com>
Subject: Re: [PATCH 3/4] mfd: sec-core: Add cells for S5M8767-clocks
From: Tushar Behera <tushar.behera@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Patch Tracking <patches@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 October 2013 21:46, Lee Jones <lee.jones@linaro.org> wrote:
> On Thu, 31 Oct 2013, Tushar Behera wrote:
>
>> S5M8767 chip has 3 crystal oscillators running at 32KHz. These are
>> supported by s2mps11-clk driver.
>>
>> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
>> CC: Lee Jones <lee.jones@linaro.org>
>> ---
>>  drivers/mfd/sec-core.c |    4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
>> index 34c18fb..020b86b 100644
>> --- a/drivers/mfd/sec-core.c
>> +++ b/drivers/mfd/sec-core.c
>> @@ -56,7 +56,9 @@ static struct mfd_cell s5m8767_devs[] = {
>>               .name = "s5m8767-pmic",
>>       }, {
>>               .name = "s5m-rtc",
>> -     },
>> +     }, {
>> +             .name = "s5m8767-clk",
>> +     }
>>  };
>>
>>  static struct mfd_cell s2mps11_devs[] = {
>
> Acked-by: Lee Jones <lee.jones@linaro.org>
>

Thanks.

> I'd prefer to take this patch in via the MFD tree once you have
> support from the other maintainers for the set.
>

Ok. I will let you know once I get the clock patches through.

-- 
Tushar Behera
