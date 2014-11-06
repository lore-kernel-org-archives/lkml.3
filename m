Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384AbaKFAtj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 19:49:39 -0500
Received: from www.linutronix.de ([62.245.132.108]:40086 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbaKFAti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 19:49:38 -0500
Date: Thu, 6 Nov 2014 01:49:21 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
cc: Jiang Liu <jiang.liu@linux.intel.com>, marc.zyngier@arm.com,
        mark.rutland@arm.com, jason@lakedaemon.net, Catalin.Marinas@arm.com,
        Will.Deacon@arm.com, liviu.dudau@arm.com,
        Harish.Kasiviswanathan@amd.com, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [V10 PATCH 2/2] irqchip: gicv2m: Add supports for ARM GICv2m
 MSI(-X)
In-Reply-To: <545ABF6C.1000308@amd.com>
Message-ID: <alpine.DEB.2.11.1411060146050.24960@nanos>
References: <1415052977-26036-1-git-send-email-suravee.suthikulpanit@amd.com> <1415052977-26036-3-git-send-email-suravee.suthikulpanit@amd.com> <5458CE31.3040404@linux.intel.com> <545ABB4C.8010103@amd.com> <545ABF6C.1000308@amd.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2014, Suravee Suthikulanit wrote:
> On 11/5/2014 6:05 PM, Suravee Suthikulanit wrote:
> > - Overall, it seems that msi_domain_alloc() could be quite different
> > across architectures. Would it be possible to declare this function as
> > weak, and allow arch to override (similar to arch_setup_msi_irq)?
> 
> Actually, declaring "msi_domain_ops" as non-static, and allow other code to
> override the .alloc and .free?

Why do you want to do that?

Thanks,

	tglx
