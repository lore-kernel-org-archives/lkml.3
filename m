Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515Ab3GLByS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 21:54:18 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:37171 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932327Ab3GLByR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 21:54:17 -0400
Message-ID: <51DF6150.8010401@huawei.com>
Date: Fri, 12 Jul 2013 09:52:16 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Bjorn Helgaas <bhelgaas@google.com>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, Rafael <rjw@sisk.pl>,
        Hanjun Guo <guohanjun@huawei.com>, <jiang.liu@huawei.com>
Subject: Re: [PATCH -v2 0/3] Use PCIe DSN to improve pciehp_resume
References: <1373535825-49972-1-git-send-email-wangyijing@huawei.com> <1373552385.1349.2.camel@x61.thuisdomein>
In-Reply-To: <1373552385.1349.2.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/7/11 22:19, Paul Bolle wrote:
> On Thu, 2013-07-11 at 17:43 +0800, Yijing Wang wrote:
>> v1->v2: Modify pci_get_dsn to pci_device_serial_number,
>> 	    power off slot before remove the old device during resume to avoid
>> 		old .remove() method to touch new hardware.
>> 		Fix other typo and fail check problems.
>> 		Split the list_empty() guard into new patch.
>> 		
>>
>> Yijing Wang (3):
>>   PCI: introduce PCIe Device Serial Number Capability support
>>   PCI,pciehp: avoid add a device already exist before suspend during
>>     resume
>>   PCI,pciehp: use PCIe DSN to identify device change during suspend
>>
>>  drivers/pci/hotplug/pciehp_core.c |   54 ++++++++++++++++++++++++++++++++++--
>>  drivers/pci/pci.c                 |   27 ++++++++++++++++++
>>  drivers/pci/probe.c               |    2 +
>>  include/linux/pci.h               |    3 ++
>>  4 files changed, 83 insertions(+), 3 deletions(-)
> 
> Series applies cleanly to v3.10 (but there was a small problem with 3/3,
> which I'll mention in a reply to that patch). Compiles without warning.
> Those two errors on every resume are now gone!

I will check patch 3/3, Paul, Do you wireless card support Device Serial Number ?
You can confirm it by lspci -vvv.

> 
> Thanks.
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

