Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab3AVGTi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 01:19:38 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:53766 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813Ab3AVGTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 01:19:36 -0500
Message-ID: <50FE2F71.5080503@ti.com>
Date: Tue, 22 Jan 2013 11:49:29 +0530
From: kishon <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: musb: core: Add missing newline character
References: <1358779955-4916-1-git-send-email-kishon@ti.com> <50FD7950.3010209@mvista.com>
In-Reply-To: <50FD7950.3010209@mvista.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 21 January 2013 10:52 PM, Sergei Shtylyov wrote:
> Hello.
>
> On 01/21/2013 05:52 PM, Kishon Vijay Abraham I wrote:
>
>> No functional change. Just added a missing newline character.
>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> ---
>>   drivers/usb/musb/musb_core.c |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>
>> diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
>> index f1c6c54..c534131 100644
>> --- a/drivers/usb/musb/musb_core.c
>> +++ b/drivers/usb/musb/musb_core.c
>> @@ -2301,7 +2301,7 @@ static int __init musb_init(void)
>>   	pr_info("%s: version " MUSB_VERSION ", "
>>   		"?dma?"
>>   		", "
>> -		"otg (peripheral+host)",
>> +		"otg (peripheral+host)\n",
>>   		musb_driver_name);
>>   	return platform_driver_register(&musb_driver);
>>   }
>
>     Refresh your tree, alike patch is already upstream. :-)

Cool. Missed that one.

Thanks
Kishon
