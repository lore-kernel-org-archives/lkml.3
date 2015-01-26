Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284AbbAZMUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 07:20:30 -0500
Received: from mail.skyhub.de ([78.46.96.112]:41764 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517AbbAZMU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 07:20:27 -0500
Date: Mon, 26 Jan 2015 13:20:17 +0100
From: Borislav Petkov <bp@alien8.de>
To: Joerg Roedel <joro@8bytes.org>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 3/3] x86, crash: Allocate enough low-mem when
 crashkernel=high
Message-ID: <20150126122017.GA1656@pd.tnic>
References: <1420555874-11506-1-git-send-email-joro@8bytes.org>
 <1420555874-11506-4-git-send-email-joro@8bytes.org>
 <20150123170243.GG22635@pd.tnic>
 <20150126121142.GG30345@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150126121142.GG30345@8bytes.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 01:11:42PM +0100, Joerg Roedel wrote:
> Well, there is no easy way. But we could collect information from the
> loaded drivers on boot about how many dma-memory they allocate and base
> our allocation on that.

That sounds like a nifty idea to me.

> Or we solve it in user-space by some more cleverness in creating the
> kernel command-line for crashkernel=high.

I'd say, we should try to do as much as possible automatically.

> But besides that, I think the first two patches of this set make sense
> anyway. I understand that the third one is debatable.

Right, but since they fix a real problem, maybe we should take them now
until a better fix is done? Yes, no?

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
