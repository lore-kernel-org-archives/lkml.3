Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060AbbAPOTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 09:19:21 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37997 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563AbbAPOTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 09:19:19 -0500
Date: Fri, 16 Jan 2015 15:19:17 +0100
From: Borislav Petkov <bp@alien8.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [patch 08/23] x86/x2apic: Clarify remapping mode for x2apic
 enablement
Message-ID: <20150116141917.GI18880@pd.tnic>
References: <20150115210458.625399149@linutronix.de>
 <20150115211702.876012628@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150115211702.876012628@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 09:22:21PM -0000, Thomas Gleixner wrote:
> Rename the argument of try_to_enable_x2apic() so the purpose becomes
> more clear.
> 
> Make the pr_warning more consistent and avoid the double print of
> "disabling".
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
