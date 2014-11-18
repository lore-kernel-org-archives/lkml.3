Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbaKRAzj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 19:55:39 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:13034 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347AbaKRAzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 19:55:38 -0500
Message-ID: <546A98F5.8080506@huawei.com>
Date: Tue, 18 Nov 2014 08:55:17 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "huxinwei@huawei.com" <huxinwei@huawei.com>,
        Wuyun <wuyun.wu@huawei.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Tony Luck <tony.luck@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Liviu Dudau <liviu@dudau.co.uk>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: Re: [RFC PATCH 14/16] arm/PCI: Introduce pci_get_domain_nr()
References: <1416219710-26088-1-git-send-email-wangyijing@huawei.com> <1416219710-26088-15-git-send-email-wangyijing@huawei.com> <20141117120839.GA22241@e102568-lin.cambridge.arm.com>
In-Reply-To: <20141117120839.GA22241@e102568-lin.cambridge.arm.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020203.546A9907.01BC,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 1a967165ce9d28c1ad258551ff912487
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>  
>> -	bus->domain_nr = domain;
>> +void pci_bus_assign_domain_nr(struct pci_bus *bus, struct device *parent)
>> +{
>> +	bus->domain_nr = pci_get_domain_nr(parent);
>>  }
>>  #endif
> 
> This code is superseded by the last patches I sent to move the domain
> assignment to PCI core code.
> 
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-November/301220.html

OK, I will update it based the latest one.

> 
> Lorenzo
> 
> 
> .
> 


-- 
Thanks!
Yijing

