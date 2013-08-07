Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333Ab3HGSlS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 14:41:18 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58875 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085Ab3HGSlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 14:41:17 -0400
Date: Wed, 7 Aug 2013 20:41:14 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Jason Baron <jbaron@akamai.com>
Subject: Re: [PATCH 4/4] x86/jump-label: Show where and what was wrong on
 errors
Message-ID: <20130807184114.GK17920@pd.tnic>
References: <20130807164934.149920591@goodmis.org>
 <20130807165114.147890467@goodmis.org>
 <20130807172044.GC18272@pd.tnic>
 <1375896786.6848.14.camel@gandalf.local.home>
 <20130807173744.GD18272@pd.tnic>
 <1375897584.6848.15.camel@gandalf.local.home>
 <5202892F.7010804@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5202892F.7010804@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 10:51:43AM -0700, H. Peter Anvin wrote:
> A bigger issue is probably if panic-on-bug should be the default, with
> !panic being an opt-in debugging option.

Yes, it might make sense although embedded wants to disable CONFIG_BUG
on systems which cannot report errors:

  │ CONFIG_BUG:
  │
  │ Disabling this option eliminates support for BUG and WARN, reducing
  │ the size of your kernel image and potentially quietly ignoring
  │ numerous fatal conditions. You should only consider disabling this
  │ option for embedded systems with no facilities for reporting errors.
  │ Just say Y.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
