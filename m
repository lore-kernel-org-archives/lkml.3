Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbaGKKL7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 06:11:59 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:55039 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbaGKKL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 06:11:58 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-4b-53bfb86b55dd
Message-id: <53BFB84A.900@samsung.com>
Date: Fri, 11 Jul 2014 12:11:22 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@samsung.com>,
        open list <linux-kernel@vger.kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sachin Kamat <spk.linux@gmail.com>
Subject: Re: [PATCH 1/1] MAINTAINERS: Update Samsung pin control entry
References: <1405069190-13986-1-git-send-email-sachin.kamat@samsung.com>
 <CAK5sBcFXo3YVeJ7U94f9_UuAuzCwmeOdCCJTE8D8pZEZfaOZbg@mail.gmail.com>
In-reply-to: <CAK5sBcFXo3YVeJ7U94f9_UuAuzCwmeOdCCJTE8D8pZEZfaOZbg@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsVy+t/xy7rZO/YHG8x7aWkxZ/0aNospf5Yz
	WVzeNYfN4sqlU2wWLV/PsTiweuycdZfd4861PWweJ2b8ZvHo27KK0ePzJrkA1igum5TUnMyy
	1CJ9uwSujMvb7Au6OSuuT1/G3sC4kL2LkZNDQsBE4ti1O4wQtpjEhXvr2boYuTiEBJYySiy/
	sg7K+cwo0T31K1gHr4CaxPPJ89hAbBYBVYkXr1+A2WxA8c8Nj8BsfgEtiTVN11m6GDk4RAUi
	JB5fEIJoFZT4MfkeC4gtIhAuserQV7DFzAK1Ekt3zmMFsYUF3CRaP55ghdjbzyjRMfETM0iC
	UyBYYvnlI8wQDeoSk+YtgrLlJTavecs8gVFwFpIds5CUzUJStoCReRWjaGppckFxUnquoV5x
	Ym5xaV66XnJ+7iZGSKB/2cG4+JjVIUYBDkYlHl6N2t3BQqyJZcWVuYcYJTiYlUR4n9TvDxbi
	TUmsrEotyo8vKs1JLT7EyMTBKdXAmLHHWnGb7J+i+bPjLUTLxLonfQ8/Espa/mG6+54975bf
	rA99yX7+bpKltICpaVTIAT1bXfUAS8VNucy5VvX5YlWGnzf3cDyqcPzh8qPAsLJa9TNX3bEI
	X2te/deihq03vwullNfM0mnJP7gsQ9a0qnr7BA1X9ve6C/b2ThH37vz8ssFJ5YMSS3FGoqEW
	c1FxIgDCsFG9UgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.07.2014 11:57, Sachin Kamat wrote:
> + Tomasz
> 
> Sorry for missing the maintainer himself :)
> 
> On Fri, Jul 11, 2014 at 2:29 PM, Sachin Kamat <sachin.kamat@samsung.com> wrote:
>> Update to reflect the recent file movement to a sub-directory.
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>
>> ---
>>  MAINTAINERS |    4 +---
>>  1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index e3a517635eb4..898cf76f8837 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -6943,9 +6943,7 @@ M:        Thomas Abraham <thomas.abraham@linaro.org>
>>  L:     linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>>  L:     linux-samsung-soc@vger.kernel.org (moderated for non-subscribers)
>>  S:     Maintained
>> -F:     drivers/pinctrl/pinctrl-exynos.*
>> -F:     drivers/pinctrl/pinctrl-s3c*
>> -F:     drivers/pinctrl/pinctrl-samsung.*
>> +F:     drivers/pinctrl/samsung/
>>
>>  PIN CONTROLLER - ST SPEAR
>>  M:     Viresh Kumar <viresh.linux@gmail.com>
>> --
>> 1.7.9.5
>>
> 

Acked-by: Tomasz Figa <t.figa@samsung.com>

--
Best regards,
Tomasz
