Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab3LDVZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 16:25:38 -0500
Received: from www.linutronix.de ([62.245.132.108]:39164 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809Ab3LDVZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 16:25:34 -0500
Date: Wed, 4 Dec 2013 22:25:30 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vinayak Kale <vkale@apm.com>
cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        will.deacon@arm.com, patches@apm.com, jcm@redhat.com,
        sboyd@codeaurora.org, marc.zyngier@arm.com,
        Chris Smith <chris.smith@st.com>
Subject: Re: [PATCH V7 1/2] genirq: Add an accessor for IRQ_PER_CPU flag
In-Reply-To: <1386151791-4881-2-git-send-email-vkale@apm.com>
Message-ID: <alpine.DEB.2.02.1312042223310.30673@ionos.tec.linutronix.de>
References: <1386151791-4881-1-git-send-email-vkale@apm.com> <1386151791-4881-2-git-send-email-vkale@apm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Dec 2013, Vinayak Kale wrote:

> This patch adds an accessor function for IRQ_PER_CPU flag.
> The accessor function is useful to determine whether an IRQ is percpu or not.
> 
> This patch is based on an older patch posted by Chris Smith here [1].
> There is a minor change w.r.t. Chris's original patch: The accessor function
> is renamed as 'irq_is_percpu' instead of 'irq_is_per_cpu'.
> 
> [1]: http://lkml.indiana.edu/hypermail/linux/kernel/1207.3/02955.html
> 
> Signed-off-by: Chris Smith <chris.smith@st.com>
> Signed-off-by: Vinayak Kale <vkale@apm.com>
> Acked-by: Will Deacon <will.deacon@arm.com>

For the genirq part:
    Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

Please take that through the SoC tree which carries the actual user of
this.

Thanks,

	tglx
