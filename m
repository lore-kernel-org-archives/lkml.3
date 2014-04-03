Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162564AbaDCIV3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 04:21:29 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:42952 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162503AbaDCIVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 04:21:25 -0400
Message-ID: <533D1A01.30304@gmail.com>
Date: Thu, 03 Apr 2014 10:21:21 +0200
From: Sherif <shehabaldin.sherif@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, silentquote@gmail.com
Subject: Re: [PATCH 7/9] driver: staging: wlan-ng: Fixed white spaces issues
References: <1396509209-3074-1-git-send-email-shehabaldin.sherif@gmail.com> <20140403074511.GY6991@mwanda>
In-Reply-To: <20140403074511.GY6991@mwanda>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes I see the error. I have tried to build the wlan-ng driver using make 
M=drivers/staging/wlan-ng/ but it built nothing, so I went one step up 
and built make M=drivers/staging/ as a whole and it built fine, I think 
I am missing something here, how do I specify this module for the build 
to test my changes?

On 04/03/2014 09:45 AM, Dan Carpenter wrote:
> On Thu, Apr 03, 2014 at 09:13:29AM +0200, Sherif Shehab Aldin wrote:
>>   static void hfa384x_usbctlx_resptimerfn(unsigned long data)
>>   {
>> -	hfa384x_t *hw = (hfa384x_t *) data;
>> +	hfa384x_t *hw = (hfa384x_t *)
>>   	unsigned long flags;
>>
>>   	spin_lock_irqsave(&hw->ctlxq.lock, flags);
>
> This breaks the build.
>
> regards,
> dan carpenter
>
