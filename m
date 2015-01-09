Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235AbbAIVRS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 16:17:18 -0500
Received: from mail113-251.mail.alibaba.com ([205.204.113.251]:55480 "EHLO
	us-alimail-mta1.hst.scl.en.alidc.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750772AbbAIVRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 16:17:17 -0500
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07422295|-1;FP=0|0|0|0|0|-1|-1|-1;HT=r41f05020;MF=gang.chen@sunrus.com.cn;PH=DS;RN=6;RT=6;SR=0;
Message-ID: <54B046F0.8030808@sunrus.com.cn>
Date: Sat, 10 Jan 2015 05:24:00 +0800
From: Chen Gang S <gang.chen@sunrus.com.cn>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        holzheu@linux.vnet.ibm.com, linux-s390@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] s390: include: timex: Use macro CLOCK_STORE_SIZE instead
 of hard code number
References: <54A55954.6000002@sunrus.com.cn>	<20150102094625.GA4059@osiris>	<54A76584.6020700@sunrus.com.cn>	<20150105095948.0612e7bc@mschwide>	<54AD4677.6040009@sunrus.com.cn> <20150107163617.190b5992@mschwide>
In-Reply-To: <20150107163617.190b5992@mschwide>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/7/15 23:36, Martin Schwidefsky wrote:
> On Wed, 07 Jan 2015 22:45:11 +0800
> Chen Gang S <gang.chen@sunrus.com.cn> wrote:
> 
>> On 01/05/2015 04:59 PM, Martin Schwidefsky wrote:
>>> On Sat, 03 Jan 2015 11:44:04 +0800
>>> Chen Gang <gang.chen@sunrus.com.cn> wrote:
>>>
>>>>
>>>> Thank you for your work.
>>>>
>>>> In honest, originally, I was not sure whether it would cause bug (do not
>>>> know gcc would generic incorrect code for it). :-)
>>>
>>> Even if the code happened to be correct it does not matter. The intention
>>> of the sizeof() has been to get to the correct 16, not 8. The fix is
>>> fine as it is.
>>>
>>
>> Excuse me, my English is not quite well, I am not quite sure about what
>> you said (might misunderstand what you said), so I provide the related
>> information below for confirmation, please check, thanks.
>>
>> sizeof(clk) is for a pointer, not for an array (for C language, it
>> treats array parameter as a pointer), the related demo is below:
> 
> And your patch fixes this problem. My comment was in regard to the
> impact of the original bug. As the typeof construct is used to
> prevent the compiler from over-optimizing, the code can come out
> correct even if the bug is present.
> 

OK, thank you for your reply.

In honest, I still not quite understand your meaning, I guess it is only
because of my poor English, and it doesn't matter for others members, so
not need additional reply for it (but welcome reply).

For details (please check, if still interest):

  > And your patch fixes this problem. My comment was in regard to the
  > impact of the original bug.

    I can understand the 2 contents above.

  >                             As the typeof construct is used to
  > prevent the compiler from over-optimizing,

    I can understand, yeah, typeof() is useful for declaring an array.

  >                                            the code can come out
  > correct even if the bug is present.
  > 

    Sorry, I can not understand: I know every words, and it seems I can
    understand the whole sentence, but for me, it seems have a conflict
    meaning with the original sentences.


Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
