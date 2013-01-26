Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab3AZMtW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 07:49:22 -0500
Received: from mail.skyhub.de ([78.46.96.112]:58393 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395Ab3AZMtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 07:49:20 -0500
Date: Sat, 26 Jan 2013 13:52:08 +0100
From: Borislav Petkov <bp@alien8.de>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, arjan@linux.intel.com,
        jbeulich@suse.com, ling.ml@alipay.com, rostedt@goodmis.org,
        akpm@linux-foundation.org, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/asm] x86/defconfig: Turn on
 CONFIG_CC_OPTIMIZE_FOR_SIZE= y in the 64-bit defconfig
Message-ID: <20130126125208.GC21395@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, mingo@kernel.org,
	hpa@zytor.com, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, arjan@linux.intel.com,
	jbeulich@suse.com, ling.ml@alipay.com, rostedt@goodmis.org,
	akpm@linux-foundation.org, tglx@linutronix.de,
	linux-tip-commits@vger.kernel.org
References: <1359123061-6139-1-git-send-email-ling.ma@alipay.com>
 <tip-d94ffd677469ef729e9d6e968191872577a6119e@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <tip-d94ffd677469ef729e9d6e968191872577a6119e@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2013 at 04:25:57AM -0800, tip-bot for Ma Ling wrote:
> During the same  time (269.410275674 seconds) IPC from Os is
> 0.37, O2 is 0.36, Os improved performance 2.7%.
> 
> Signed-off-by: Ma Ling <ling.ml@alipay.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Jan Beulich <jbeulich@suse.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Link: http://lkml.kernel.org/r/1359123061-6139-1-git-send-email-ling.ma@alipay.com
> [ So, this is a bit symbolic as most people don't use the defconfig,
>   but the measurements are useful nevertheless so let's commit this
>   if there are no objections. ]

What about

commit 3a55fb0d9fe8e2f4594329edd58c5fd6f35a99dd
Author: Kirill Smelkov <kirr@mns.spb.ru>
Date:   Fri Nov 2 15:41:01 2012 +0400

    Tell the world we gave up on pushing CC_OPTIMIZE_FOR_SIZE

?

Reportedly, -Os generates suboptimal code in certain cases and we advise
against it with this patch.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
