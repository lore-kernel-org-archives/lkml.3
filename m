Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688AbbAPLPp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 06:15:45 -0500
Received: from mail.skyhub.de ([78.46.96.112]:40258 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbbAPLPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 06:15:44 -0500
Date: Fri, 16 Jan 2015 12:15:42 +0100
From: Borislav Petkov <bp@alien8.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [patch 04/23] x86/ioapic: Check x2apic really
Message-ID: <20150116111542.GE18880@pd.tnic>
References: <20150115210458.625399149@linutronix.de>
 <20150115211702.541280622@linutronix.de>
 <20150116111019.GD18880@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150116111019.GD18880@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 12:10:19PM +0100, Borislav Petkov wrote:
> Bah, let's get rid of this knob completely (ontop of your patch):

... or, maybe I should look at the next patch first :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
