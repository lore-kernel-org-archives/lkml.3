Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbbAAT0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 14:26:33 -0500
Received: from down.free-electrons.com ([37.187.137.238]:34104 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751754AbbAAT0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 14:26:32 -0500
Date: Thu, 1 Jan 2015 20:26:24 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch: arm: mm: ioremap:  Remove unused function
Message-ID: <20150101202624.25df9f6d@free-electrons.com>
In-Reply-To: <1420139451-2671-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1420139451-2671-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Organization: Free Electrons
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Rickard Strandqvist,

On Thu,  1 Jan 2015 20:10:51 +0100, Rickard Strandqvist wrote:
> Remove the function pci_ioremap_set_mem_type() that is not used anywhere.
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Hum, I was supposed to use this in arch/arm/mach-mvebu/ to make sure
that PCI I/O regions are mapped strongly-ordered. We're indeed doing it
for PCI mem regions, but we never did it for PCI I/O regions. I
remember there has been some discussions about this, but I don't
remember the outcome, and whether it has affected the fact that mapping
PCI I/O regions strongly-ordered for mach-mvebu was never merged.

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
