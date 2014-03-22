Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843AbaCVUox (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 16:44:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:56017 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaCVUot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 16:44:49 -0400
Date: Sat, 22 Mar 2014 21:44:24 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Laura Abbott <lauraa@codeaurora.org>
cc: Russell King <linux@arm.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Tony Luck <tony.luck@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux390@de.ibm.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [RESEND][PATCH 1/2] lib/scatterlist: Make ARCH_HAS_SG_CHAIN an
 actual Kconfig
In-Reply-To: <1395512032-20575-2-git-send-email-lauraa@codeaurora.org>
Message-ID: <alpine.DEB.2.02.1403222142560.18573@ionos.tec.linutronix.de>
References: <1395512032-20575-1-git-send-email-lauraa@codeaurora.org> <1395512032-20575-2-git-send-email-lauraa@codeaurora.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Mar 2014, Laura Abbott wrote:

> Rather than have architectures #define ARCH_HAS_SG_CHAIN in an architecture
> specific scatterlist.h, make it a proper Kconfig option and use that
> instead. At same time, remove the header files are are now mostly
> useless and just include asm-generic/scatterlist.h.
> 
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Fenghua Yu <fenghua.yu@intel.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: Fenghua Yu <fenghua.yu@intel.com>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>

For the x86 part:

Acked-by: Thomas Gleixner <tglx@linutronix.de>
