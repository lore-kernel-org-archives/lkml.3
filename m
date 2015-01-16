Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963AbbAPTC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 14:02:28 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49565 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756945AbbAPTCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 14:02:25 -0500
Date: Fri, 16 Jan 2015 20:02:22 +0100
From: Borislav Petkov <bp@alien8.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [patch 15/23] x86/ioapic: Add proper checks to
 setp/enable_IO_APIC()
Message-ID: <20150116190222.GP18880@pd.tnic>
References: <20150115210458.625399149@linutronix.de>
 <20150115211703.490719938@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150115211703.490719938@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 09:22:32PM -0000, Thomas Gleixner wrote:
> No point to have the same checks at every call site. Add them to the
> functions, so they can be called unconditionally.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
