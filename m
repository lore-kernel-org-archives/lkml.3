Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab3FEB2D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 21:28:03 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:51562 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab3FEB2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 21:28:00 -0400
Message-ID: <51AE9406.7080102@huawei.com>
Date: Wed, 5 Jun 2013 09:27:34 +0800
From: Libo Chen <libo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tomas Henzl <thenzl@redhat.com>
CC: <megaraidlinux@lsi.com>, <JBottomley@parallels.com>,
        Libo Chen <chenlibo.3@gmail.com>, <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <kashyap.desai@lsi.com>,
        <aradford@gmail.com>, Li Zefan <lizefan@huawei.com>,
        Santosh Y <santoshsy@gmail.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: Re: [PATCH v2] scsi: megaraid: check kzalloc
References: <519ECEF1.9060804@huawei.com> <519F3592.4090207@huawei.com> <51ADB484.3060404@huawei.com> <51ADDA24.7050609@redhat.com>
In-Reply-To: <51ADDA24.7050609@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/6/4 20:14, Tomas Henzl wrote:
> On 06/04/2013 11:33 AM, Libo Chen wrote:
>> we should check kzalloc, avoid to hit oops
>>
>> Change from v1:
>> - put kzalloc outside of mutex
>>
>> Signed-off-by: Libo Chen <libo.chen@huawei.com>
> 
> Your patch looks fine to me:
> Acked-by: Tomas Henzl <thenzl@redhat.com>
> 

your ack is very helpfull for me.

Thanks,

Libo

> Cheers,
> Tomas
> 
> 
> .
> 


