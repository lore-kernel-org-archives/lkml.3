Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427AbbAPTE1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 14:04:27 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49634 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932301AbbAPTE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 14:04:26 -0500
Date: Fri, 16 Jan 2015 20:04:23 +0100
From: Borislav Petkov <bp@alien8.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [patch 21/23] x86/smpboot: Sanitize uniprocessor init
Message-ID: <20150116190423.GV18880@pd.tnic>
References: <20150115210458.625399149@linutronix.de>
 <20150115211703.987833932@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150115211703.987833932@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 09:22:42PM -0000, Thomas Gleixner wrote:
> The UP related setups for local apic are mangled into smp_sanity_check().
> 
> That results in duplicate calls to disable_smp() and makes the code
> hard to follow. Let smp_sanity_check() return dedicated values for the
> various exit reasons and handle them at the call site.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
