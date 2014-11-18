Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbaKRMmD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 07:42:03 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:49076 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774AbaKRMmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 07:42:00 -0500
Message-ID: <546B3E7D.4030800@huawei.com>
Date: Tue, 18 Nov 2014 20:41:33 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linuxppc-dev@lists.ozlabs.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Liviu Dudau <liviu@dudau.co.uk>, Tony Luck <tony.luck@intel.com>,
        "Russell King" <linux@arm.linux.org.uk>, <linux-pci@vger.kernel.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Xinwei Hu <huxinwei@huawei.com>,
        "Thierry Reding" <thierry.reding@gmail.com>,
        <Suravee.Suthikulpanit@amd.com>, <linux-ia64@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Wuyun <wuyun.wu@huawei.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 07/16] PCI: Separate pci_host_bridge creation out
 of pci_create_root_bus()
References: <1416219710-26088-1-git-send-email-wangyijing@huawei.com> <1936415.emTbbPeHqx@wuerfel> <546B3124.7070206@huawei.com> <2911754.xsk2IUfQFO@wuerfel>
In-Reply-To: <2911754.xsk2IUfQFO@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>> We need, some platforms pass NULL pointer as host bridge parent.
>>>
>>> But those don't have to use the new pci_create_host_bridge() function,
>>> right?
>>
>> As I mentioned in another reply, I hope all pci host drivers could use
>> pci_create_host_bridge(), keep different PCI scan interfaces in PCI core
>> make things become complex.
> 
> Doing this for all platforms that have PCI support would be a lot of
> work though, I think it's better to focus on having a the best interface
> for the majority of users.

Yes.

> 
> 	Arnd
> 
> .
> 


-- 
Thanks!
Yijing

