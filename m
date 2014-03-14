Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303AbaCNRPU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 13:15:20 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:28287 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756272AbaCNRPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 13:15:15 -0400
Date: Fri, 14 Mar 2014 17:14:57 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v7 3/3] arm64: Add architecture support for PCI
Message-ID: <20140314171457.GK18126@arm.com>
References: <1394811258-1500-1-git-send-email-Liviu.Dudau@arm.com>
 <1394811258-1500-4-git-send-email-Liviu.Dudau@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394811258-1500-4-git-send-email-Liviu.Dudau@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 03:34:18PM +0000, Liviu Dudau wrote:
> --- /dev/null
> +++ b/arch/arm64/kernel/pci.c
[...]
> +int pci_register_io_range(phys_addr_t address, resource_size_t size)
[...]
> +unsigned long pci_address_to_pio(phys_addr_t address)
[...]
> +void pcibios_fixup_bus(struct pci_bus *bus)
[ actually most of this file ]

Maybe it was raised before already but can we have __weak generic
definitions of these functions? They don't seem to be arm64 specific in
any way.

-- 
Catalin
