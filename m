Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025AbbAPTDI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 14:03:08 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49583 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757009AbbAPTDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 14:03:04 -0500
Date: Fri, 16 Jan 2015 20:03:01 +0100
From: Borislav Petkov <bp@alien8.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [patch 17/23] x86/smpboot: Cleanup ioapic handling
Message-ID: <20150116190301.GR18880@pd.tnic>
References: <20150115210458.625399149@linutronix.de>
 <20150115211703.650280684@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150115211703.650280684@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 09:22:35PM -0000, Thomas Gleixner wrote:
> smpboot is very creative with the ways to disable ioapic.
> 
> smpboot_clear_io_apic() smpboot_clear_io_apic_irqs() and
> disable_ioapic_support() serve a similar purpose.
> 
> smpboot_clear_io_apic_irqs() is the most useless of all
> functions as it clears a variable which has not been setup yet.

Useful stuff that.

> Aside of that it has the same ifdef mess and conditionals around the
> ioapic related code, which can now be removed.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Vehemently-Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
