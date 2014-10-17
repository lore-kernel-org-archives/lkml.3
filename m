Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbaJQHm7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 03:42:59 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:5169 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbaJQHm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 03:42:56 -0400
Message-ID: <5440C84E.6050408@huawei.com>
Date: Fri, 17 Oct 2014 15:42:06 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>
CC: Bjorn Helgaas <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Xinwei Hu <huxinwei@huawei.com>,
        Wuyun <wuyun.wu@huawei.com>, <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, <linux-arch@vger.kernel.org>,
        <arnab.basu@freescale.com>, <Bharat.Bhushan@freescale.com>,
        <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <xen-devel@lists.xenproject.org>, Joerg Roedel <joro@8bytes.org>,
        <iommu@lists.linux-foundation.org>, <linux-mips@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-s390@vger.kernel.org>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>,
        "Tony Luck" <tony.luck@intel.com>, <linux-ia64@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <sparclinux@vger.kernel.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Lucas Stach <l.stach@pengutronix.de>,
        David Vrabel <david.vrabel@citrix.com>,
        "Sergei Shtylyov" <sergei.shtylyov@cogentembedded.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Liviu Dudau <liviu@dudau.co.uk>
Subject: Re: [PATCH v3 21/27] Powerpc/MSI: Use MSI chip framework to configure
 MSI/MSI-X irq
References: <1413342435-7876-1-git-send-email-wangyijing@huawei.com>	 <1413342435-7876-22-git-send-email-wangyijing@huawei.com> <1413530600.21650.5.camel@concordia>
In-Reply-To: <1413530600.21650.5.camel@concordia>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/10/17 15:23, Michael Ellerman wrote:
> On Wed, 2014-10-15 at 11:07 +0800, Yijing Wang wrote:
>> Use MSI chip framework instead of arch MSI functions to configure
>> MSI/MSI-X irq. So we can manage MSI/MSI-X irq in a unified framework.
>>
>> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>> ---
>> Hi Michael,
>>    I dropped the Acked-by , because this version has a
>> lot changes compared to last. So, I guess you may want to check it again.
> 
> OK thanks.
> 
> Still looks OK and boots on one of my test systems that uses MSI.

Good!

> 
> Acked-by: Michael Ellerman <mpe@ellerman.id.au> (for powerpc)

Thanks very much!

Thanks!
Yijing.

> 
> 
> cheers
> 
> 
> 
> .
> 


-- 
Thanks!
Yijing

