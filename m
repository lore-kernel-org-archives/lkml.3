Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030951Ab3HIUAX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 16:00:23 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:42130 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030899Ab3HIUAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 16:00:22 -0400
Message-ID: <52054A49.6000008@gmail.com>
Date: Sat, 10 Aug 2013 01:30:09 +0530
From: Kumar Gaurav <kumargauravgupta3@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: davem@davemloft.net, jiri@resnulli.us, gregkh@linuxfoundation.org,
        yongjun_wei@trendmicro.com.cn, konszert@marvell.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 17/17] net:ethernet:lantiq_etop.c: Removed deprecated
 IRQF_DISABLED
References: <1376072759-11814-1-git-send-email-kumargauravgupta3@gmail.com> <52054527.8080907@cogentembedded.com>
In-Reply-To: <52054527.8080907@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 August 2013 01:08 AM, Sergei Shtylyov wrote:
> Hello.
>
> On 08/09/2013 10:25 PM, Kumar Gaurav wrote:
>
>> Removed IRQF_DISABLED as it is deprecated and fixed a coding style issue
>> of more than 80 chars on single line by sliting the line in two.
>
>    That's clearly a material for 2 separate patches.
>
>> Signed-off-by: Kumar Gaurav <kumargauravgupta3@gmail.com>
>> ---
>>   drivers/net/ethernet/lantiq_etop.c |    8 +++++---
>>   1 file changed, 5 insertions(+), 3 deletions(-)
>
>> diff --git a/drivers/net/ethernet/lantiq_etop.c 
>> b/drivers/net/ethernet/lantiq_etop.c
>> index bfdb0686..04c3a82 100644
>> --- a/drivers/net/ethernet/lantiq_etop.c
>> +++ b/drivers/net/ethernet/lantiq_etop.c
> [...]
>> @@ -653,7 +653,9 @@ ltq_etop_init(struct net_device *dev)
>>       if (err)
>>           goto err_netdev;
>>
>> -    /* Set addr_assign_type here, ltq_etop_set_mac_address would 
>> reset it. */
>> +    /* Set addr_assign_type here,
>> +     *ltq_etop_set_mac_address would reset it.
>
>    You forgot space after * here.
>
> WBR, Sergei
>
Okay i'll be sending them in separate and correcting a space issue as told.
thanks

Regards
Kumar Gaurav
