Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259AbaALREG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 12:04:06 -0500
Received: from mail.skyhub.de ([78.46.96.112]:38233 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbaALRED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 12:04:03 -0500
Date: Sun, 12 Jan 2014 18:03:54 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Qiaowei Ren <qiaowei.ren@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] x86, mpx: extend siginfo structure to include bound
 violation information
Message-ID: <20140112170354.GC3655@pd.tnic>
References: <1389518403-7715-1-git-send-email-qiaowei.ren@intel.com>
 <1389518403-7715-5-git-send-email-qiaowei.ren@intel.com>
 <20140112093013.GB3664@pd.tnic>
 <52D2C791.2030802@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52D2C791.2030802@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 12, 2014 at 08:49:21AM -0800, H. Peter Anvin wrote:
> I saw a previous version of the code that did that, and it really
> didn't work out well -- it ended up being more complex and slower.

I suspected as much.

But, we still probably should use the generic struct insn, insn_field,
etc and act on them in mpx.c instead of defining our own mpx_insn,
mpx_insn_field, X86_MODRM_MOD, etc in the header which are more or less
copied from insn.h, right?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
