Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab3JJJDH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 05:03:07 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37869 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753982Ab3JJJDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 05:03:04 -0400
Date: Thu, 10 Oct 2013 11:03:00 +0200
From: Borislav Petkov <bp@alien8.de>
To: David Miller <davem@davemloft.net>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de, mingo@kernel.org,
        peterz@infradead.org, hpa@linux.intel.com, williams@redhat.com,
        akpm@linux-foundation.org
Subject: Re: [RFC][PATCH] x86: Lazy disabling of interrupts
Message-ID: <20131010090300.GB9929@pd.tnic>
References: <20131009144150.108f7041@gandalf.local.home>
 <20131010001153.1f171bff@gandalf.local.home>
 <20131010.001939.1669180620160012783.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131010.001939.1669180620160012783.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 12:19:39AM -0400, David Miller wrote:
> From: Steven Rostedt <rostedt@goodmis.org>
> Date: Thu, 10 Oct 2013 00:11:53 -0400
> 
> > 
> > I'm replying to my email to see if that helps make it to LKML. If it
> > doesn't, I'm sorry for the noise to all I Cc'd.
> 
> The problem is the:
> 
> H.PeterAnvin
> 
> in the CC list, you can't have a name with the "." charater it appear in
> email headers unless the string is surrounded by double quotes.  Otherwise
> it's a syntax error.

That's strange - I see

"H. Peter Anvin" <hpa@linux.intel.com>

in the CC list here. Did something get mangled on the way or is Claws
acting outlook-like?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
