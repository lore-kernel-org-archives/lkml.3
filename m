Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933272Ab3E1HoZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 03:44:25 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:49252 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933188Ab3E1HoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 03:44:24 -0400
Message-ID: <51A45FFD.8050200@huawei.com>
Date: Tue, 28 May 2013 15:42:53 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, <stern@rowland.harvard.edu>,
        <linux-arm-kernel@lists.infradead.org>, Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH] module: use a macro instead of platform_driver_register
References: <51A040D2.20708@huawei.com> <20130525122240.GC3746@kroah.com>
In-Reply-To: <20130525122240.GC3746@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/5/25 20:22, Greg KH wrote:
> On Sat, May 25, 2013 at 12:40:50PM +0800, Libo Chen wrote:
>>
>> I found a lot of mistakes using struct platform_driver without owner
>> so I make a macro instead of the function platform_driver_register.
>> It can set owner in it, then guys don`t care about module owner again.
>>
>> Signed-off-by: Libo Chen <libo.chen@huawei.com>
> 
> Nice job, that's the better way to fix this, I'll queue it up for 3.11.
> 

Thank Gu, Thomas, David and yours suggestions!

Regards

Libo

> thanks,
> 
> greg k-h
> 
> .
> 


