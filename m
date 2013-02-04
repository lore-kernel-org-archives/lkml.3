Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab3BDLcJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:32:09 -0500
Received: from linux-sh.org ([111.68.239.195]:54931 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754242Ab3BDLcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:32:06 -0500
Date: Mon, 4 Feb 2013 20:30:44 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: <linux-kernel@vger.kernel.org>, <uclinux-dist-devel@blackfin.uclinux.org>,
        <linux-hexagon@vger.kernel.org>, <linux-ia64@vger.kernel.org>,
        <linux-mips@linux-mips.org>, <linux-parisc@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-sh@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, "Thomas Gleixner" <tglx@linutronix.de>,
        Mike Frysinger <vapier@gentoo.org>, Fenghua Yu <fenghua.yu@intel.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH RESEND 1/1] arch Kconfig: remove references to IRQ_PER_CPU
Message-ID: <20130204113043.GB12216@linux-sh.org>
References: <1359972583-17134-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359972583-17134-1-git-send-email-james.hogan@imgtec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 10:09:43AM +0000, James Hogan wrote:
> The IRQ_PER_CPU Kconfig symbol was removed in the following commit:
> 
> Commit 6a58fb3bad099076f36f0f30f44507bc3275cdb6 ("genirq: Remove
> CONFIG_IRQ_PER_CPU") merged in v2.6.39-rc1.
> 
> But IRQ_PER_CPU wasn't removed from any of the architecture Kconfig
> files where it was defined or selected. It's completely unused so remove
> the remaining references.
> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Mike Frysinger <vapier@gentoo.org>
> Cc: Fenghua Yu <fenghua.yu@intel.com>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
> Cc: Helge Deller <deller@gmx.de>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Acked-by: Tony Luck <tony.luck@intel.com>
> Acked-by: Richard Kuo <rkuo@codeaurora.org>

Acked-by: Paul Mundt <lethal@linux-sh.org>
