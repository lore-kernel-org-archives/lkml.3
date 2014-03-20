Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759921AbaCTUiX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 16:38:23 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:56405 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759730AbaCTUiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 16:38:22 -0400
Message-ID: <532B5FC7.8000707@cogentembedded.com>
Date: Fri, 21 Mar 2014 00:38:15 +0300
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

    In fact, it does complain but says:

WARNING: quoted string split across lines

     So, it looks like your patch is against the wrong tree.

WBR, Sergei

