Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413Ab3EUICu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 04:02:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:11730 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751681Ab3EUICq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 04:02:46 -0400
X-IronPort-AV: E=Sophos;i="4.87,713,1363104000"; 
   d="scan'208";a="7321924"
Message-ID: <519B2993.4090409@cn.fujitsu.com>
Date: Tue, 21 May 2013 16:00:19 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: David Miller <davem@davemloft.net>, libo.chen@huawei.com,
        gregkh@linuxfoundation.org, samuel@sortiz.org,
        stern@rowland.harvard.edu, khc@pm.waw.pl, akpm@linux-foundation.org,
        balbi@ti.com, sarah.a.sharp@linux.intel.com,
        alexander.shishkin@linux.intel.com, brudley@broadcom.com,
        linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, lizefan@huawei.com
Subject: Re: [PATCH 00/19] driver:usb&net: add missing platform_driver owner
References: <1369104120-35552-1-git-send-email-libo.chen@huawei.com> <20130520.232619.964940909999914694.davem@davemloft.net> <20130521084108.1a585f32@skate>
In-Reply-To: <20130521084108.1a585f32@skate>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/21 16:01:19,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/21 16:01:24,
	Serialize complete at 2013/05/21 16:01:24
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2013 02:41 PM, Thomas Petazzoni wrote:

> Dear David Miller,
> 
> On Mon, 20 May 2013 23:26:19 -0700 (PDT), David Miller wrote:
>> From: Libo Chen <libo.chen@huawei.com>
>> Date: Tue, 21 May 2013 10:42:00 +0800
>>
>>> I find a lot of mistakes using struct platform_driver without owner.
>>> So I pick up some of them including usb and net modules
>>
>> Instead of doing it this way, which is obviously error prone and
>> easy to forget, make platform_driver_register() be a macro which
>> sets the module owner field then calls the real
>> __platform_driver_register().
> 
> Or, maybe make the existing module_platform_driver() macro do this?


But not all the modules use module_platform_driver() macro to replace the module init/exit.

Thanks,
Gu

> 
> Best regards,
> 
> Thomas


