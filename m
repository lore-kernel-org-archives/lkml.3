Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001AbbAPTCw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 14:02:52 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49579 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756988AbbAPTCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 14:02:50 -0500
Date: Fri, 16 Jan 2015 20:02:47 +0100
From: Borislav Petkov <bp@alien8.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [patch 16/23] x86/apic: Sanitize ioapic handling
Message-ID: <20150116190247.GQ18880@pd.tnic>
References: <20150115210458.625399149@linutronix.de>
 <20150115211703.569830549@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150115211703.569830549@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 09:22:34PM -0000, Thomas Gleixner wrote:
> We have proper stubs for the IOAPIC=n case and the setup/enable
> function have the required checks inside now. Remove the ifdeffery and
> the copy&pasted conditionals.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
