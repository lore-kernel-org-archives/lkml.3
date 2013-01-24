Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab3AXJBO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 04:01:14 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:43868 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab3AXJBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 04:01:09 -0500
Message-ID: <5100F839.6000009@ti.com>
Date: Thu, 24 Jan 2013 11:00:41 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: <sameo@linux.intel.com>, <linux@arm.linux.org.uk>, <sshtylyov@mvista.com>,
        <tony@atomide.com>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>, <kishon@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <bjorn@mork.no>
Subject: Re: [PATCH v9 20/20] mdf: omap-usb-host: get rid of build warning
References: <1358937492-8129-1-git-send-email-rogerq@ti.com> <1358937492-8129-21-git-send-email-rogerq@ti.com> <20130123233617.9205.88295@quantum>
In-Reply-To: <20130123233617.9205.88295@quantum>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2013 01:36 AM, Mike Turquette wrote:
> Quoting Roger Quadros (2013-01-23 02:38:12)
>> Fixes the below build warning when driver is built-in.
>>
>> drivers/mfd/omap-usb-host.c:750:12: warning:
>> ‘usbhs_omap_remove’ defined but not used [-Wunused-function]
>>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>> Reviewed-by: Felipe Balbi <balbi@ti.com>
> 
> Hi Roger,
> 
> I just noticed that $SUBJECT says "mdf" instead of "mfd" ;)
> 

Thanks Mike. I've fixed it in the pull request and i'll mail a patch as well.

cheers,
-roger.

> 
>> ---
>>  drivers/mfd/omap-usb-host.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
>> index b21ca76..6b5edf6 100644
>> --- a/drivers/mfd/omap-usb-host.c
>> +++ b/drivers/mfd/omap-usb-host.c
>> @@ -791,7 +791,7 @@ static struct platform_driver usbhs_omap_driver = {
>>                 .owner          = THIS_MODULE,
>>                 .pm             = &usbhsomap_dev_pm_ops,
>>         },
>> -       .remove         = __exit_p(usbhs_omap_remove),
>> +       .remove         = usbhs_omap_remove,
>>  };
>>  
>>  MODULE_AUTHOR("Keshava Munegowda <keshava_mgowda@ti.com>");
>> -- 
>> 1.7.4.1
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

