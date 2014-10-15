Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbaJOCgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 22:36:54 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46771 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871AbaJOCgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 22:36:50 -0400
Date: Tue, 14 Oct 2014 22:36:41 -0400 (EDT)
Message-Id: <20141014.223641.1750858832286185881.davem@davemloft.net>
To: wangyijing@huawei.com
Cc: bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, huxinwei@huawei.com, wuyun.wu@huawei.com,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linux-arch@vger.kernel.org, arnab.basu@freescale.com,
        Bharat.Bhushan@freescale.com, x86@kernel.org, arnd@arndb.de,
        tglx@linutronix.de, konrad.wilk@oracle.com,
        xen-devel@lists.xenproject.org, joro@8bytes.org,
        iommu@lists.linux-foundation.org, linux-mips@linux-mips.org,
        benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, sebott@linux.vnet.ibm.com,
        tony.luck@intel.com, linux-ia64@vger.kernel.org,
        sparclinux@vger.kernel.org, cmetcalf@tilera.com, ralf@linux-mips.org,
        l.stach@pengutronix.de, david.vrabel@citrix.com,
        sergei.shtylyov@cogentembedded.com, mpe@ellerman.id.au,
        thierry.reding@gmail.com, thomas.petazzoni@free-electrons.com,
        liviu@dudau.co.uk
Subject: Re: [PATCH v3 25/27] Sparc/MSI: Use MSI chip framework to
 configure MSI/MSI-X irq
From: David Miller <davem@davemloft.net>
In-Reply-To: <1413342435-7876-26-git-send-email-wangyijing@huawei.com>
References: <1413342435-7876-1-git-send-email-wangyijing@huawei.com>
	<1413342435-7876-26-git-send-email-wangyijing@huawei.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Oct 2014 19:36:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yijing Wang <wangyijing@huawei.com>
Date: Wed, 15 Oct 2014 11:07:13 +0800

> Use MSI chip framework instead of arch MSI functions to configure
> MSI/MSI-X irq. So we can manage MSI/MSI-X irq in a unified framework.
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>

Acked-by: David S. Miller <davem@davemloft.net>
