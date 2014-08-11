Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbaHKIMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 04:12:24 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:18861 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750720AbaHKIMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 04:12:22 -0400
Message-ID: <53E87ADA.6040204@arm.com>
Date: Mon, 11 Aug 2014 09:12:10 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
CC: Mark Rutland <Mark.Rutland@arm.com>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Harish.Kasiviswanathan@amd.com" <Harish.Kasiviswanathan@amd.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 0/4] irqchip: gic-v2m: Rework GICv2m Initialization
References: <1407539836-9768-1-git-send-email-suravee.suthikulpanit@amd.com>
In-Reply-To: <1407539836-9768-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suravee,

On 09/08/14 00:17, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> 
> This patch set reworks the GICv2m initialization based on Marc Zyngier
> review comments.
> 
> * Rebase to git://git.infradead.org/users/jcooper/linux.git irqchip/gic-v2m
> 
> Suravee Suthikulpanit (1):
>   irqchip/gic-v2m: Restructure the initalization code for v2m
> 
>  Documentation/devicetree/bindings/arm/gic.txt |  37 +++++++--
>  drivers/irqchip/irq-gic-v2m.c                 | 115 +++++++++-----------------
>  drivers/irqchip/irq-gic.c                     |  30 +++----
>  drivers/irqchip/irq-gic.h                     |  10 +--
>  4 files changed, 91 insertions(+), 101 deletions(-)
> 

While I appreciate that you're trying to reduce the amount of stuff we
review, it is actually much easier to look at the patch series as a
whole, rather then as a diff against the previous version.

Please squash this into your original series and repost it with a log of
what has changed in the cover letter.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
