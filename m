Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330Ab3HGRhs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 13:37:48 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54264 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757023Ab3HGRhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 13:37:47 -0400
Date: Wed, 7 Aug 2013 19:37:44 +0200
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Jason Baron <jbaron@akamai.com>
Subject: Re: [PATCH 4/4] x86/jump-label: Show where and what was wrong on
 errors
Message-ID: <20130807173744.GD18272@pd.tnic>
References: <20130807164934.149920591@goodmis.org>
 <20130807165114.147890467@goodmis.org>
 <20130807172044.GC18272@pd.tnic>
 <1375896786.6848.14.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1375896786.6848.14.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 01:33:06PM -0400, Steven Rostedt wrote:
> Right, and this code keeps the same logic as it was before. If it was
> disabled by CONFIG_EXPERT, it stays disabled, but at least you get to
> see a warning that your kernel may be corrupt now :-)

Don't we really want to panic instead of running a corrupt kernel? IOW,
to change the logic to panic unconditionally because the image in memory
has been violated and not in a good way, at that :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
