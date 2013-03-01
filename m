Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456Ab3CAO6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 09:58:18 -0500
Received: from mail.skyhub.de ([78.46.96.112]:51049 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709Ab3CAO6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 09:58:17 -0500
Date: Fri, 1 Mar 2013 15:58:06 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Joern Engel <joern@logfs.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/9] printk: add CON_ALLDATA console flag
Message-ID: <20130301145805.GC30938@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jeff Moyer <jmoyer@redhat.com>, Joern Engel <joern@logfs.org>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <1362087602-8979-1-git-send-email-joern@logfs.org>
 <1362087602-8979-4-git-send-email-joern@logfs.org>
 <x49obf32mvo.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <x49obf32mvo.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 01, 2013 at 09:52:27AM -0500, Jeff Moyer wrote:
> > For consoles like netconsole and blockconsole the loglevel filtering
> > really doesn't make any sense.  If a line gets printed at all, please
> > send it down to that console, no questions asked.
> 
> Could you please explain this a bit further?  Why wouldn't you want to
> allow the admin to filter log messages to the block or network console?
> This doesn't make a whole lot of sense to me, and in fact could cause
> problems for netconsole now that you're potentially sending a ton more
> traffic over the wire.

Let's reverse the question: why would the admin ever want to filter
messages to debugging consoles like netconsole or blockconsole?

When running a debugging session, you generally want to see *all*
messages.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
