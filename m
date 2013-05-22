Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab3EVBco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 21:32:44 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59509 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753003Ab3EVBcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 21:32:43 -0400
X-IronPort-AV: E=Sophos;i="4.87,718,1363104000"; 
   d="scan'208";a="7328816"
Message-ID: <519C1FA3.2020500@cn.fujitsu.com>
Date: Wed, 22 May 2013 09:30:11 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Libo Chen <clbchenlibo.chen@huawei.com>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        David Miller <davem@davemloft.net>, libo.chen@huawei.com,
        gregkh@linuxfoundation.org, samuel@sortiz.org,
        stern@rowland.harvard.edu, khc@pm.waw.pl, akpm@linux-foundation.org,
        balbi@ti.com, sarah.a.sharp@linux.intel.com,
        alexander.shishkin@linux.intel.com, brudley@broadcom.com,
        linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, lizefan@huawei.com
Subject: Re: [PATCH 00/19] driver:usb&net: add missing platform_driver owner
References: <1369104120-35552-1-git-send-email-libo.chen@huawei.com> <20130520.232619.964940909999914694.davem@davemloft.net> <20130521084108.1a585f32@skate> <519B2993.4090409@cn.fujitsu.com> <20130521110616.21eee053@skate> <519B418A.7060805@huawei.com>
In-Reply-To: <519B418A.7060805@huawei.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/22 09:31:11,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/22 09:31:17,
	Serialize complete at 2013/05/22 09:31:17
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2013 05:42 PM, Libo Chen wrote:

> On 2013/5/21 17:06, Thomas Petazzoni wrote:
>> Dear Gu Zheng,
>>
>> On Tue, 21 May 2013 16:00:19 +0800, Gu Zheng wrote:
>>
>>>> Or, maybe make the existing module_platform_driver() macro do this?
>>>
>>> But not all the modules use module_platform_driver() macro to replace the module init/exit.
>>
>> Then maybe it's a good opportunity to convert those ones to use
>> module_platform_driver() ?
>>
>> Thomas
>>
> 
>  In my opinion, not all modules can use module_platform_driver() macro to replace the module init/exit easily, like us3mc_init.
> 
>  Furthermore this work will touch various platforms and architectures, I am worried it is hard to *test* (compile and boot).

Agree. I stick to the way that David mentioned.

Thanks,
Gu

> 
>  What do you think?
> 
> 


