Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121AbaE1R0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 13:26:24 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44384 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153AbaE1R0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 13:26:23 -0400
Date: Wed, 28 May 2014 19:26:18 +0200
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [RFC][PATCH] tracing: Print nasty banner when trace_printk() is
 in use
Message-ID: <20140528172618.GB17220@pd.tnic>
References: <20140528131440.2283213c@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140528131440.2283213c@gandalf.local.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 01:14:40PM -0400, Steven Rostedt wrote:
> Here's the banner:
> 
>  ****************************************
>  ** NOTICE NOTICE NOTICE NOTICE NOTICE **
>  ** trace_printk() being used.         **
>  ** Allocating extra memory for it     **
>  ****************************************
> 
> Hmm, maybe I should add "Not for production use" to scare people even
> more?

Yes, and at least some swearing - this is the linux kernel for
chrissake. Or are you gone soft too?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
