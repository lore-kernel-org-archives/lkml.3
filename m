Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbbAWCNI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 21:13:08 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:41995 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755044AbbAWCNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 21:13:02 -0500
Message-ID: <54C1ADE3.9060606@huawei.com>
Date: Fri, 23 Jan 2015 10:11:47 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: Lior Amsalem <alior@marvell.com>, <linux-ia64@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, Nadav Haklai <nadavh@marvell.com>,
        =?ISO-8859-1?Q?Gregory_Cl=E9ment?= 
	<gregory.clement@free-electrons.com>,
        "Guan Xuetao" <gxt@mprc.pku.edu.cn>,
        Russell King <linux@arm.linux.org.uk>, <x86@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Rusty Russell <rusty@rustcorp.com.au>, <linux-m68k@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Liviu Dudau <liviu@dudau.co.uk>, "Tony Luck" <tony.luck@intel.com>,
        <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        <linux-alpha@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 23/30] PCI/mvebu: Use pci_common_init_dev() to simplify
 code
References: <1421800225-26230-1-git-send-email-wangyijing@huawei.com> <1421800225-26230-24-git-send-email-wangyijing@huawei.com> <20150122184000.63ba06bb@free-electrons.com>
In-Reply-To: <20150122184000.63ba06bb@free-electrons.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/23 1:40, Thomas Petazzoni wrote:
> Dear Yijing Wang,
> 
> On Wed, 21 Jan 2015 08:30:18 +0800, Yijing Wang wrote:
>> Mvebu_pcie_scan_bus() is not necessary, we could use
>> pci_common_init_dev() instead of pci_common_init(),
>> and pass the device pointer as the parent. Then
>> pci_scan_root_bus() will be called to scan the pci busses.
>>
>> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>> CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
>> CC: Jason Cooper <jason@lakedaemon.net>
> 
> While I'm fine with the change to pci_common_init_dev(), I am not so
> sure about the removal of mvebu_pcie_scan_bus(). I vaguely remember
> that we intentionally did not use the default function for a specific
> reason. Of course, this was a long time ago, and I don't remember the
> reason. I would have to take a bit of time to 1/ review the archives of
> the discussion surrounding the pcie-mvebu driver, and 2/ test your
> patch to validate it works fine on HW.

Hi Thomas, Thanks for your comments and help to test :)

> 
> Thanks!
> 
> Thomas
> 


-- 
Thanks!
Yijing

