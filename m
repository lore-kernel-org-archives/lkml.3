Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751394AbaK1PVx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 10:21:53 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:37050 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbaK1PVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 10:21:51 -0500
MIME-Version: 1.0
In-Reply-To: <54788AC3.9090808@cogentembedded.com>
References: <1417182662-7405-1-git-send-email-ricardo.ribalda@gmail.com>
 <1417182662-7405-7-git-send-email-ricardo.ribalda@gmail.com> <54788AC3.9090808@cogentembedded.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Fri, 28 Nov 2014 16:21:29 +0100
Message-ID: <CAPybu_1R+L91kGTG1sHhKiChd3v7=wa70v2VWDrQ-TH1FYyxSQ@mail.gmail.com>
Subject: Re: [PATCH 06/17] net2280: Remove restart_dma inline function definition
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Chen <peter.chen@freescale.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

Thanks for reviewing. I will fix it and resend it on the next version
of the patchset to avoid spamming the ML

I guess it is ok to add your Reviewed-by

Thanks!


On Fri, Nov 28, 2014 at 3:46 PM, Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
> Hello.
>
> On 11/28/2014 04:50 PM, Ricardo Ribalda Delgado wrote:
>
>> restart_dma is not used before it is declaration. Therefore we can
>
>
>    s/it is/its/.
>
>> remove this definition.
>
>
>    You're removing the declaration, not definition.
>
>> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
>> ---
>>   drivers/usb/gadget/udc/net2280.c | 2 --
>>   1 file changed, 2 deletions(-)
>
>
>> diff --git a/drivers/usb/gadget/udc/net2280.c
>> b/drivers/usb/gadget/udc/net2280.c
>> index 0340462..e8c36db 100644
>> --- a/drivers/usb/gadget/udc/net2280.c
>> +++ b/drivers/usb/gadget/udc/net2280.c
>> @@ -1043,8 +1043,6 @@ dma_done(struct net2280_ep *ep,   struct
>> net2280_request *req, u32 dmacount,
>>         done(ep, req, status);
>>   }
>>
>> -static void restart_dma(struct net2280_ep *ep);
>> -
>>   static void scan_dma_completions(struct net2280_ep *ep)
>>   {
>>         /* only look at descriptors that were "naturally" retired,
>
>
> WBR, Sergei
>



-- 
Ricardo Ribalda
