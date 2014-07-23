Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929AbaGWKtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 06:49:20 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45709 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbaGWKtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 06:49:19 -0400
Date: Wed, 23 Jul 2014 12:49:17 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>
Subject: Re: STI architectural question (and lretq -- I'm not even kidding)
Message-ID: <20140723104917.GB23102@pd.tnic>
References: <CALCETrVx=cLZjgALizYKWATSjOvhmwPHQvOJRkMgdb=iNRNf8w@mail.gmail.com>
 <CA+55aFyefnFjmOs-QZhFn68-6+tWO30VqU6ipP6BzAra=xOaFg@mail.gmail.com>
 <CALCETrUjKXfwbWkUytMXLSmKROLBVY7tRYWPHnEC01Fj=aiTkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrUjKXfwbWkUytMXLSmKROLBVY7tRYWPHnEC01Fj=aiTkQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 06:33:02PM -0700, Andy Lutomirski wrote:
> Of course, this does nothing at all to protect us from #MC after sti
> on return from #MC to userspace, but I think we're screwed regardless
> -- we could just as easily get a second #MC before the sti. Machine
> check broadcast was the worst idea ever.

Please do not think that a raised #MC means the machine is gone. There
are MC errors which are reported with the exception mechanism and from
which we can and do recover, regardless of broadcasting or not.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
