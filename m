Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab3EUJv5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 05:51:57 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:13179 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab3EUJvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 05:51:55 -0400
Message-ID: <519B418A.7060805@huawei.com>
Date: Tue, 21 May 2013 17:42:34 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: Gu Zheng <guz.fnst@cn.fujitsu.com>, David Miller <davem@davemloft.net>,
        <libo.chen@huawei.com>, <gregkh@linuxfoundation.org>,
        <samuel@sortiz.org>, <stern@rowland.harvard.edu>, <khc@pm.waw.pl>,
        <akpm@linux-foundation.org>, <balbi@ti.com>,
        <sarah.a.sharp@linux.intel.com>, <alexander.shishkin@linux.intel.com>,
        <brudley@broadcom.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <lizefan@huawei.com>
Subject: Re: [PATCH 00/19] driver:usb&net: add missing platform_driver owner
References: <1369104120-35552-1-git-send-email-libo.chen@huawei.com> <20130520.232619.964940909999914694.davem@davemloft.net> <20130521084108.1a585f32@skate> <519B2993.4090409@cn.fujitsu.com> <20130521110616.21eee053@skate>
In-Reply-To: <20130521110616.21eee053@skate>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/5/21 17:06, Thomas Petazzoni wrote:
> Dear Gu Zheng,
> 
> On Tue, 21 May 2013 16:00:19 +0800, Gu Zheng wrote:
> 
>>> Or, maybe make the existing module_platform_driver() macro do this?
>>
>> But not all the modules use module_platform_driver() macro to replace the module init/exit.
> 
> Then maybe it's a good opportunity to convert those ones to use
> module_platform_driver() ?
> 
> Thomas
> 

 In my opinion, not all modules can use module_platform_driver() macro to replace the module init/exit easily, like us3mc_init.

 Furthermore this work will touch various platforms and architectures, I am worried it is hard to *test* (compile and boot).

 What do you think?

