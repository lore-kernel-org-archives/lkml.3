Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbbAPKzp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 05:55:45 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39218 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbbAPKzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 05:55:43 -0500
Date: Fri, 16 Jan 2015 11:55:41 +0100
From: Borislav Petkov <bp@alien8.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [patch 03/23] x86/apic: Move x2apic code to one place
Message-ID: <20150116105540.GC18880@pd.tnic>
References: <20150115210458.625399149@linutronix.de>
 <20150115211702.445212133@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150115211702.445212133@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 09:22:12PM -0000, Thomas Gleixner wrote:
> Having several disjunct pieces of code for x2apic support makes
> reading the code unnecessarily hard. Move it to one ifdeffed section.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
