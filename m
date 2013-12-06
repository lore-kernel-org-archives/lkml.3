Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab3LFGLk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 01:11:40 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:45064 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab3LFGLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 01:11:37 -0500
MIME-Version: 1.0
In-Reply-To: <52A169D4.4060209@roeck-us.net>
References: <1386282527-14094-1-git-send-email-zwu.kernel@gmail.com>
	<1386282527-14094-4-git-send-email-zwu.kernel@gmail.com>
	<52A169D4.4060209@roeck-us.net>
Date: Fri, 6 Dec 2013 14:11:35 +0800
Message-ID: <CAEH94LjR2eVyut-2tXQ647Bi48HGJEpOULKtrcOeeLJGDh-Ttw@mail.gmail.com>
Subject: Re: [net-next PATCH 3/6] macvtap: remove the dead branch
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: netdev@vger.kernel.org, linux-kernel mlist <linux-kernel@vger.kernel.org>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 6, 2013 at 2:08 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> On 12/05/2013 02:28 PM, Zhi Yong Wu wrote:
>>
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>> ---
>>   drivers/net/macvtap.c |    2 --
>>   1 files changed, 0 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
>> index 9093004..d271fb4 100644
>> --- a/drivers/net/macvtap.c
>> +++ b/drivers/net/macvtap.c
>> @@ -779,8 +779,6 @@ static ssize_t macvtap_put_user(struct macvtap_queue
>> *q,
>>                         return -EINVAL;
>>
>>                 ret = macvtap_skb_to_vnet_hdr(skb, &vnet_hdr);
>> -               if (ret)
>> -                       return ret;
>>
> Assigning the function's return value to ret just to ignore it seems odd.
>
> Might make sense to change the function type to void.
Yes,  this is done in the next patch of this series.

>
> Guenter
>



-- 
Regards,

Zhi Yong Wu
