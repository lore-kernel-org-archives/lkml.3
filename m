Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933065AbbANIRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:17:53 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:32436 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171AbbANIRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 03:17:49 -0500
Message-ID: <54B62609.7020002@huawei.com>
Date: Wed, 14 Jan 2015 16:17:13 +0800
From: "Yun Wu (Abel)" <wuyun.wu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Yijing Wang <wangyijing@huawei.com>,
        "Suravee Suthikulpanit" <Suravee.Suthikulpanit@amd.com>
Subject: Re: [PATCH v2 3/8] PCI/MSI: of: Add support for OF-provided msi_domain
References: <1420736772-11088-1-git-send-email-marc.zyngier@arm.com> <1420736772-11088-4-git-send-email-marc.zyngier@arm.com>
In-Reply-To: <1420736772-11088-4-git-send-email-marc.zyngier@arm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.24.136]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/9 1:06, Marc Zyngier wrote:

> In order to populate the PHB msi_domain, use the "msi-parent"
> attribute to lookup a corresponding irq domain. If found,
> this is our MSI domain.
> 
> This gets plugged into the core PCI code.
> 

Hi Marc,

Since the whole patch series based on the fact that non PCI type
buses will use MSI-like interrupts, would it be better if getting
this field settled during OF populating?

Regards,
	Abel

