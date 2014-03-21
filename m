Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967022AbaCUAyz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:54:55 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:45410 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965248AbaCUAyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:54:52 -0400
Message-ID: <532B9BE0.5050802@cogentembedded.com>
Date: Fri, 21 Mar 2014 04:54:40 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: =?UTF-8?B?Q8OpZHJpYyBDYWJlc3Nh?= <ced@ryick.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] coding style: fix line over 80 characters
References: <1395266697-8699-1-git-send-email-ced@ryick.net> <1395266697-8699-3-git-send-email-ced@ryick.net> <532B5ED1.8060406@cogentembedded.com>
In-Reply-To: <532B5ED1.8060406@cogentembedded.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2014 12:34 AM, Sergei Shtylyov wrote:

>> Signed-off-by: Cédric Cabessa <ced@ryick.net>
>> ---
>>   drivers/staging/usbip/vhci_hcd.c | 33 ++++++++++++++++++++++-----------
>>   1 file changed, 22 insertions(+), 11 deletions(-)

>> diff --git a/drivers/staging/usbip/vhci_hcd.c
>> b/drivers/staging/usbip/vhci_hcd.c
>> index f690668..1e84577 100644
>> --- a/drivers/staging/usbip/vhci_hcd.c
>> +++ b/drivers/staging/usbip/vhci_hcd.c
[...]
>> @@ -539,7 +546,9 @@ static int vhci_urb_enqueue(struct usb_hcd *hcd, struct
>> urb *urb,
>>
>>           default:
>>               /* NOT REACHED */
>> -            dev_err(dev, "invalid request to devnum 0 bRequest %u, wValue
>> %u\n", ctrlreq->bRequest,
>> +            dev_err(dev,
>> +                "invalid request to devnum 0 bRequest %u, wValue %u\n",
>> +                ctrlreq->bRequest,
>>                   ctrlreq->wValue);
>>               ret =  -EINVAL;
>>               goto no_need_xmit;
>> @@ -1060,7 +1069,9 @@ static int vhci_hcd_suspend(struct platform_device
>> *pdev, pm_message_t state)
>>       spin_unlock(&the_controller->lock);
>>
>>       if (connected > 0) {
>> -        dev_info(&pdev->dev, "We have %d active connection%s. Do not
>> suspend.\n", connected, (connected == 1 ? "" : "s"));
>> +        dev_info(&pdev->dev,
>> +             "We have %d active connection%s. Do not suspend.\n",
>> +             connected, (connected == 1 ? "" : "s"));
>>           ret =  -EBUSY;
>>       } else {
>>           dev_info(&pdev->dev, "suspend vhci_hcd");

>     Hm, I don't see checkpatch.pl complaints about these either in the
> 'usb-next' branch of Greg's tree.

    Sorry, I forgot about Greg's separate staging.git repo. The patch looks 
correct in this context.

WBR, Sergei

