Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932676AbaIRPb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 11:31:28 -0400
Received: from mout.web.de ([212.227.15.14]:53315 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932225AbaIRPbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 11:31:24 -0400
Message-ID: <541AFABF.1070800@web.de>
Date: Thu, 18 Sep 2014 17:31:11 +0200
From: Fjodor Schelichow <schelichow@web.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>,
        Maximilian Eschenbacher <maximilian@eschenbacher.email>
CC: linux-kernel@vger.kernel.org, valentina.manea.m@gmail.com,
        shuah.kh@samsung.com, gregkh@linuxfoundation.org,
        Dominik Paulus <dominik.paulus@fau.de>,
        Johannes Stadlinger <johannes.stadlinger@fau.de>,
        Tobias Polzer <tobias.polzer@fau.de>, i4passt@lists.cs.fau.de
Subject: Re: [PATCH 17/18] usbip: Increment version number to 1.2.1
References: <1410910735-27929-1-git-send-email-maximilian@eschenbacher.email> <1410910735-27929-18-git-send-email-maximilian@eschenbacher.email> <201409171951.34150.vda.linux@googlemail.com>
In-Reply-To: <201409171951.34150.vda.linux@googlemail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:dDm/16AuwFLNhpo0VHx0C4n9rKksc9RgUT+GD35E7yMkGbcurL7
 6NNYXI9Za3MEQ8IA3Ix6SHdz6yYi0KDNT3Rr7H59kQYL4GR2a9alyMCo8R8ky+zFrCGDLLy
 uy0ccj1QUKsR0xdmWeGbMkMps6cySWwXEUrpqV2iIqUpCgKeT55JBd6GLgJPoResHgiapFa
 qY/ml6ZeoKAVi8q4kgNuw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2014 07:51 PM, Denys Vlasenko wrote:
> On Wednesday 17 September 2014 01:38, Maximilian Eschenbacher wrote:
>> From: Dominik Paulus <dominik.paulus@fau.de>
>> diff --git a/drivers/usb/usbip/usbip_common.h b/drivers/usb/usbip/usbip_common.h
>> index 6831d99..a5f416e 100644
>> --- a/drivers/usb/usbip/usbip_common.h
>> +++ b/drivers/usb/usbip/usbip_common.h
>> @@ -32,7 +32,7 @@
>>   #include <uapi/linux/usbip.h>
>>   #include <linux/kfifo.h>
>>
>> -#define USBIP_VERSION "1.0.0"
>> +#define USBIP_VERSION "1.2.1"
>
> You can use UTS_RELEASE instead - it would handle the task of identifying
> the version of running code as good, or better, than a subsystem-specific
> version id.
> For one, as this patch attests, subsystem-specific ids tend to become stale...
>
After a some discussion we decided to change it according to your 
suggestion. Thanks for that!

regards
Fjodor
