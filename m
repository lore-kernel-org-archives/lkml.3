Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab3EQEcc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 00:32:32 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:14628 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab3EQEcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 00:32:31 -0400
Message-ID: <5195B2BB.3040602@huawei.com>
Date: Fri, 17 May 2013 12:31:55 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Libo Chen <libo.chen@huawei.com>, <stern@rowland.harvard.edu>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <akpm@linux-foundation.org>, <lizefan@huawei.com>,
        Libo Chen <chenlibo.3@gmail.com>
Subject: Re: [PATCH 4/4] usb: tilegx: fix memleak when create hcd fail
References: <1368075491-38728-1-git-send-email-libo.chen@huawei.com> <1368075491-38728-5-git-send-email-libo.chen@huawei.com> <20130517003428.GA10235@kroah.com>
In-Reply-To: <20130517003428.GA10235@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 2013/5/17 8:34, Greg KH wrote:
> On Thu, May 09, 2013 at 12:58:11PM +0800, Libo Chen wrote:
>> From: Libo Chen <chenlibo.3@gmail.com>
>>
>> When usb_create_hcd fail, we should call gxio_usb_host_destroy
>>
>> Signed-off-by: Libo Chen <libo.chen@huawei.com>
>> ---
>>  drivers/usb/host/ohci-tilegx.c |    7 +++++--
>>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> This patch doesn't apply at all, care to refresh it?
> 
> thanks,
> 
> greg k-h
> 
> .

this patch has been merged to upstream by Chris Metcalf <cmetcalf@tilera.com>.
(commit: abab8761d095e0805879df48a8ba6ea7f8b31c5e)

thanks,
Libo


> 


