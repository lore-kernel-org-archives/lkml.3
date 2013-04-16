Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341Ab3DPJs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 05:48:56 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50158 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881Ab3DPJsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 05:48:55 -0400
Date: Tue, 16 Apr 2013 11:48:52 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] x86, FPU: Fix FPU initialization
Message-ID: <20130416094852.GA5332@pd.tnic>
References: <20130412053234.GB3887@gmail.com>
 <f3a4fce2-090e-4a08-b05c-0281a95e8943@email.android.com>
 <20130412094724.GA2368@pd.tnic>
 <20130412112628.GB2368@pd.tnic>
 <20130415100858.GB18024@gmail.com>
 <20130415101734.GB26524@pd.tnic>
 <20130415101825.GD18024@gmail.com>
 <20130415155415.GB12144@pd.tnic>
 <20130415220406.GD12144@pd.tnic>
 <20130416092528.GF9569@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130416092528.GF9569@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 11:25:28AM +0200, Ingo Molnar wrote:
> I've got limited extra capacity right now - but if Peter rebases
> tip:x86/cpu or you send a pullable update of tip:x86/cpu I can stick
> it into -tip testing and yell if it goes wrong.
>

Ok, I'll do that in a second.

Btw, another heads-up: you know how I'm regularly testing
Linus+tip/master - well, I started seeing some strange lockups on my
workstation with -rc7 + tip from two days ago. And the box wouldn't
resume properly, the last line it would print is:

"Disabling non-boot CPUs ..."

and then hang. I've backed-out tip/master and it seems to work so it has
to be some interaction caused by something in tip. I haven't been able
to put my finger on it though but I'll watch it and try to trigger it on
my other boxes.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
