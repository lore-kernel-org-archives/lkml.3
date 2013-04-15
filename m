Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab3DOKRq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 06:17:46 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40295 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392Ab3DOKRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 06:17:44 -0400
Date: Mon, 15 Apr 2013 12:17:34 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] x86, FPU: Fix FPU initialization
Message-ID: <20130415101734.GB26524@pd.tnic>
References: <20130410161122.GI6857@pd.tnic>
 <20130410212950.GA6899@pd.tnic>
 <20130411120952.GA18879@gmail.com>
 <51670E51.6020106@zytor.com>
 <20130411202328.GA15955@pd.tnic>
 <20130412053234.GB3887@gmail.com>
 <f3a4fce2-090e-4a08-b05c-0281a95e8943@email.android.com>
 <20130412094724.GA2368@pd.tnic>
 <20130412112628.GB2368@pd.tnic>
 <20130415100858.GB18024@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130415100858.GB18024@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 12:08:58PM +0200, Ingo Molnar wrote:
> It gave me the impression of memory corruption - but impressions can
> deceive ;-)
>
> Anyway, not sure I can test/bisect it this week - merge window
> preparations and all that.

Ok, and also, in your oops, it said 3.9.0-rc6+ but tip:x86/cpu is
v3.9-rc5-11-g3019653a5758 so could it be a different kernel or some
strange interaction with some other code. I'll run your config with
tip:x86/cpu on my AMD box here to see whether I can repro on real hw.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
