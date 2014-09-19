Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311AbaISVZg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 17:25:36 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:34955 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757831AbaISVZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 17:25:34 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: "suravee.suthikulpanit\@amd.com" <suravee.suthikulpanit@amd.com>
Cc: Mark Rutland <Mark.Rutland@arm.com>,
        "jason\@lakedaemon.net" <jason@lakedaemon.net>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, Liviu Dudau <Liviu.Dudau@arm.com>,
        "tglx\@linutronix.de" <tglx@linutronix.de>,
        "Harish.Kasiviswanathan\@amd.com" <Harish.Kasiviswanathan@amd.com>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci\@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc\@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree\@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/2 V7] irqchip: gic: Add support for multiple MSI for ARM64
In-Reply-To: <1411006486-17513-2-git-send-email-suravee.suthikulpanit@amd.com>
	(suravee's message of "Thu, 18 Sep 2014 03:14:45 +0100")
Organization: ARM Ltd
References: <1411006486-17513-1-git-send-email-suravee.suthikulpanit@amd.com>
	<1411006486-17513-2-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Fri, 19 Sep 2014 22:25:18 +0100
Message-ID: <8638bnpakh.fsf@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18 2014 at 03:14:45 AM, "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com> wrote:
> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
>
> This patch implelments the ARM64 version of arch_setup_msi_irqs(),
> which does not return 1 for when PCI_CAP_ID_MSI and nvec > 1.
>
> Cc: Mark Rutland <Mark.Rutland@arm.com>
> Cc: Marc Zyngier <Marc.Zyngier@arm.com>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Catalin Marinas <Catalin.Marinas@arm.com>
> Cc: Will Deacon <Will.Deacon@arm.com>
> Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny.
