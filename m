Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531Ab3GLBtt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 21:49:49 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:11549 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932503Ab3GLBtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 21:49:47 -0400
Message-ID: <51DF60AB.6040405@huawei.com>
Date: Fri, 12 Jul 2013 09:49:31 +0800
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
References: <1373356564-21668-1-git-send-email-wangyijing@huawei.com>  <1373357261.1633.4.camel@x61.thuisdomein> <51DE2C98.5030803@huawei.com> <1373537953.9708.25.camel@x61.thuisdomein>
In-Reply-To: <1373537953.9708.25.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/7/11 18:19, Paul Bolle wrote:
> Yijing,
> 
> On Thu, 2013-07-11 at 11:55 +0800, Yijing Wang wrote:
>> Can you provide the lspci -vvv and lspci -xxxx info messages ?
>> I want to confirm your hardware information which cause your resume error.
>> You can get these messages in any kernel version, that's ok.
> 
> Would it be sufficient to send that information just for the two pcie
> ports on my laptop, and the wireless card that is present in one of
> those two ports?
> 

If you can provide both the lspci -vvv and lspci -xxxx info before suspend
and after resume, it's better.

> And would it be OK to send that information off list?

OK~


Thanks!
Yijing.


> 
>> When you suspend and resume the system, the wireless card is always
>> present in pcie slot, right?
> 
> Yes. I actually wouldn't even know how to remove it. I only discovered
> my wireless card was in a pcie slot because of the error messages at
> resume (which started a few releases ago, I think v3.7).
> 
> 
> Paul Bolle
> 
> 
> .
> 


-- 
Thanks!
Yijing

