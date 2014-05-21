Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbaEUS5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 14:57:51 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34957 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbaEUS5u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 14:57:50 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [RFC PATCH] arm64: Add arch support for PCI
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <CACoXjcmJPHdkrGRng8oWosgo9V_pLDNYw5Z3R_yN6w_rUe=G8Q@mail.gmail.com>
Date: Wed, 21 May 2014 13:57:46 -0500
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7BIT
Message-Id: <805EF793-7CA2-4F4A-B7D2-0AF2582EFFAA@codeaurora.org>
References: <1382529163-31968-1-git-send-email-tinamdar@apm.com> <1382531997.14960.8.camel@mbp> <CACoXjcmJPHdkrGRng8oWosgo9V_pLDNYw5Z3R_yN6w_rUe=G8Q@mail.gmail.com>
To: Tanmay Inamdar <tinamdar@apm.com>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 21, 2013, at 7:38 AM, Tanmay Inamdar <tinamdar@apm.com> wrote:

> This patch adds the PCI(e) arch support in arm64. The files are
> based on PCI(e) support in 32bit arm.
> 
> 
> Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
> ---
> arch/arm64/Kconfig               |   19 ++
> arch/arm64/include/asm/dma.h     |   18 +
> arch/arm64/include/asm/pci.h     |   74 ++++
> arch/arm64/include/asm/pcibios.h |   98 ++++++
> arch/arm64/kernel/Makefile       |    1 +
> arch/arm64/kernel/pcibios.c      |  689 ++++++++++++++++++++++++++++++++++++++
> arch/arm64/mm/Makefile           |    2 +-
> arch/arm64/mm/iomap.c            |   31 ++
> drivers/pci/Makefile             |    1 +
> 9 files changed, 932 insertions(+), 1 deletion(-)
> 
> create mode 100644 arch/arm64/include/asm/dma.h
> create mode 100644 arch/arm64/include/asm/pci.h
> create mode 100644 arch/arm64/include/asm/pcibios.h
> create mode 100644 arch/arm64/kernel/pcibios.c
> create mode 100644 arch/arm64/mm/iomap.c

Do you mind reposting this, the version I can find on mailing list archives seems corrupt.  This is at least useful until we get something merged upstream for arm64 pci work.

thanks

- k


-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

