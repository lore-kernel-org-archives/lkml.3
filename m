Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab3GKD4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 23:56:19 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:36627 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574Ab3GKD4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 23:56:17 -0400
Message-ID: <51DE2C98.5030803@huawei.com>
Date: Thu, 11 Jul 2013 11:55:04 +0800
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

>> 	We should do nothing in pciehp_resume, but we call
>> pciehp_enable_slot(), so some uncomfortable messages show like above.
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
   Can you provide the lspci -vvv and lspci -xxxx info messages ?
I want to confirm your hardware information which cause your resume error.
You can get these messages in any kernel version, that's ok.

When you suspend and resume the system, the wireless card is always present in pcie slot, right?


Thanks!
Yijing.



> 
> 
> .
> 


-- 
Thanks!
Yijing

