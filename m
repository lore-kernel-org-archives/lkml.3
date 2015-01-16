Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbbAPS6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 13:58:16 -0500
Received: from mail.skyhub.de ([78.46.96.112]:32910 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756866AbbAPS6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 13:58:13 -0500
Date: Fri, 16 Jan 2015 19:58:10 +0100
From: Borislav Petkov <bp@alien8.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [patch 09/23] x86/x2apic: Add proper state tracking
Message-ID: <20150116185810.GJ18880@pd.tnic>
References: <20150115210458.625399149@linutronix.de>
 <20150115211702.955392443@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150115211702.955392443@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 09:22:22PM -0000, Thomas Gleixner wrote:
> Having 3 different variables to track the state is just silly and
> error prone. Add a proper state tracking variable which covers the
> three possible states: ON/OFF/DISABLED.
> 
> We cannot use x2apic_mode for this as this would require to change all
> users of x2apic_mode with explicit comparisons for a state value
> instead of treating it as boolean.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
