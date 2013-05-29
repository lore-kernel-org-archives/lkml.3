Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759458Ab3E2CsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 22:48:24 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:41670 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759366Ab3E2CsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 22:48:22 -0400
Message-ID: <51A56C48.5000501@huawei.com>
Date: Wed, 29 May 2013 10:47:36 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, Li Zefan <lizefan@huawei.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] usb: omap2430: fix memleak in err case
References: <5192E650.3070303@huawei.com> <519C3BD1.6050307@huawei.com> <51A4EC0A.2060506@cogentembedded.com>
In-Reply-To: <51A4EC0A.2060506@cogentembedded.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/5/29 1:40, Sergei Shtylyov wrote:
> Hello.
> 
> On 22-05-2013 7:30, Libo Chen wrote:
> 
>> when omap_get_control_dev faild, we should release related platform_device
> 
>> * Changelog from v1:
>>     * fix spell: s/fail/fails/, s/relational/related/ , thank Sergei <sergei.shtylyov@cogentembedded.com>
> 
>    It seems you've actually replaced "fail" with "faild", not "fails".

sorry for my weak spell.


thanks again,

Libo


> 
>> Signed-off-by: Libo Chen <libo.chen@huawei.com>
>> ---
>>   drivers/usb/musb/omap2430.c |    3 ++-
>>   1 files changed, 2 insertions(+), 1 deletions(-)
> 
> WBR, Sergei
> 
> 
> 


