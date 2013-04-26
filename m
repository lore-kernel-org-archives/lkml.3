Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840Ab3DZITX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 04:19:23 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:33777 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758577Ab3DZITU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 04:19:20 -0400
Date: Fri, 26 Apr 2013 10:19:15 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Li Fei <fei.li@intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        chuansheng.liu@intel.com, tomoki.sekiyama.qu@hitachi.com,
        suresh.b.siddha@intel.com, joe@perches.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: eliminate irq_mis_count counted in arch_irq_stat
Message-ID: <20130426081915.GA1450@gmail.com>
References: <1366962971.32469.4.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366962971.32469.4.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Fei <fei.li@intel.com> wrote:

> 
> With current implementation, kstat_cpu(cpu).irqs_sum is also
> increased in case of irq_mis_count increment.
> So there is no need to count irq_mis_count in arch_irq_stat,
> otherwise irq_mis_count will be counted twice in the sum of
> /proc/stat.
> 
> Signed-off-by: Liu Chuansheng <chuansheng.liu@intel.com>
> Signed-off-by: Li Fei <fei.li@intel.com>

The patch looks good, but this is not a valid signoff sequence. If Liu 
Chuansheng wrote this patch then his From: line should be included. If he 
acked it, then it should be added as Acked-by.

Thanks,

	Ingo
