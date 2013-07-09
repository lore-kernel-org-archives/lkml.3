Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab3GIIS2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 04:18:28 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:25705 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab3GIISZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 04:18:25 -0400
Message-ID: <51DBC73E.7080401@huawei.com>
Date: Tue, 9 Jul 2013 16:18:06 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Bjorn Helgaas <bhelgaas@google.com>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, Rafael <rjw@sisk.pl>,
        Hanjun Guo <guohanjun@huawei.com>, <jiang.liu@huawei.com>,
        Oliver Neukum <oneukum@suse.de>, Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: Re: [PATCH 2/2] PCI,pciehp: avoid add a device already exist during
 pciehp_resume
References: <1373356564-21668-1-git-send-email-wangyijing@huawei.com> <1373357261.1633.4.camel@x61.thuisdomein>
In-Reply-To: <1373357261.1633.4.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> In this case, we can improve it a little by add a guard
>> if (!list_empty(bus->devices)).
> 
> Great!
> 
> I'm currently trying to bisect another problem, but hope to test this
> patch (and the preceding patch it apparently needs) in a few days.
> Please feel free to prod me if you think testing is needed but I'm
> taking to long to report back.

Hi Paul,
   Thank you for helping test. Because I have no machine to test this case,
so your test report is very important, it can help us going in the right way
to solve this problem.

Thanks!
Yijing.

> 
> 
> .
> 


-- 
Thanks!
Yijing

