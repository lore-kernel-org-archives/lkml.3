Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523AbaAMKnK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 05:43:10 -0500
Received: from mail.skyhub.de ([78.46.96.112]:50371 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbaAMKnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 05:43:08 -0500
Date: Mon, 13 Jan 2014 11:43:06 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ren Qiaowei <qiaowei.ren@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] x86, mpx: extend siginfo structure to include bound
 violation information
Message-ID: <20140113104306.GD5388@pd.tnic>
References: <1389518403-7715-1-git-send-email-qiaowei.ren@intel.com>
 <1389518403-7715-5-git-send-email-qiaowei.ren@intel.com>
 <20140112093013.GB3664@pd.tnic>
 <52D2C791.2030802@zytor.com>
 <20140112170354.GC3655@pd.tnic>
 <52D358EA.8090800@intel.com>
 <52D3A243.5060409@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52D3A243.5060409@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 04:22:27PM +0800, Ren Qiaowei wrote:
> >I tried to use generic structure and macro, but many members of generic
> >struct insn are not used for MPX,

I think that's ok - there are a lot of examples in the kernel where only
a subset of the struct members are used by a particular functionality.

> Because only struct insn_field and several macros may be replaced
> with generic version, I guess it maybe be confused easily to include
> generic insn header. What do you think about it?

Yes, I think the idea is to use and, if needed, extend the generic
functionality instead of growing our own here and there for obvious
benefits.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
