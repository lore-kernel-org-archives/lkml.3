Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab3EJUJ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 16:09:57 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52673 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380Ab3EJUJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 16:09:56 -0400
Date: Fri, 10 May 2013 22:17:43 +0200
From: Borislav Petkov <bp@alien8.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: SyS symbol munging.
Message-ID: <20130510201743.GG22942@pd.tnic>
References: <20130510192417.GA4915@redhat.com>
 <20130510123510.78c066f177a7a8e5dd9ec7e4@linux-foundation.org>
 <20130510195500.GD23014@pd.tnic>
 <20130510200503.GM25399@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130510200503.GM25399@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 09:05:03PM +0100, Al Viro wrote:
> Note that both sys_something and SyS_something end up in vmlinux
> symbol table, refering to the same address. AFAICS, what matters is
> which one goes first. May be even linker-dependent...

Interesting.

So it could be that a change in the linker may have caused the SyS
things to go first and start appearing in stack traces, not necessarily
a change in the kernel...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
