Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198Ab3BFUNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 15:13:06 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:49103 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758032Ab3BFUNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 15:13:00 -0500
Date: Wed, 6 Feb 2013 12:12:57 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        David Woodhouse <dwmw2@infradead.org>, Michal Marek <mmarek@suse.cz>,
        "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] config: fix make kvmconfig
In-Reply-To: <CAOJsxLFy7K0cY-8SH4dXs=agYqCN8wW0eC2tQxFxfV8cf7uWqg@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1302061209450.18172@chino.kir.corp.google.com>
References: <1356040315.3198.51.camel@shinybook.infradead.org> <tip-ffee0de411fd4f74f3b788892eeb075abbf26c52@git.kernel.org> <alpine.DEB.2.00.1212252222450.24528@chino.kir.corp.google.com> <1356564746.7010.56.camel@shinybook.infradead.org> <50DB9FA5.6070704@infradead.org>
 <alpine.DEB.2.02.1302041002430.6063@chino.kir.corp.google.com> <20130204184436.GA13256@gmail.com> <alpine.DEB.2.02.1302041053330.6063@chino.kir.corp.google.com> <20130204191408.GA32081@kroah.com> <20130204191334.GB14837@gmail.com>
 <CAOJsxLFy7K0cY-8SH4dXs=agYqCN8wW0eC2tQxFxfV8cf7uWqg@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2013, Pekka Enberg wrote:

> > Yeah, that's a good idea - I think Pekka can apply that change
> > just fine to help anyone doing merges - I don't think kconfig
> > treats it as a fatal error.
> 
> Applied, thanks guys!
> 

Adding Stephen to the cc.

What's the endgame for kvmtool/next?  The patch that this fixes has been 
sitting in linux-next for over 15 months and hasn't been pulled by Linus, 
yet some find it to be quite useful.

Is it a permanent addition to linux-next, is there a route to mainline, 
or something else?
