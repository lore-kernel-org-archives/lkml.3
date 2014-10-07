Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbaJGOLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 10:11:20 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43067 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152AbaJGOLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 10:11:19 -0400
Date: Tue, 7 Oct 2014 16:11:13 +0200
From: Borislav Petkov <bp@alien8.de>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>
Subject: Re: [PATCH] Kbuild: Check for CONFIG_READABLE_ASM when building .s
 targets
Message-ID: <20141007141113.GH30146@pd.tnic>
References: <1412523154-25602-1-git-send-email-bp@alien8.de>
 <20141005155816.GB9377@pd.tnic>
 <20141007121356.GA18003@sepie.suse.cz>
 <20141007122707.GD30146@pd.tnic>
 <5433EE87.2090000@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5433EE87.2090000@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 03:45:43PM +0200, Michal Marek wrote:
> Such option would be best of course. BTW, do you know about make
> $file.lst to produce an 'annotated disassembly'?

Yep. Although I sometimes find it harder to parse than looking at
.loc-annotated asm and the c-source.

> The toplevel Makefile rule (where your patch adds the asm_target=$@
> variable) is only used for manual invocation. bounds.s and the like are
> handled by Makefile.build directly.

Ah ok, I'll keep that in mind next time. I was seeing the warning being
issued multiple times, thus the once-tracking.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
