Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab3KKLqC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 06:46:02 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:64485 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059Ab3KKLpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 06:45:54 -0500
Date: Mon, 11 Nov 2013 12:45:51 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Marek Majkowski <marek@cloudflare.com>, Jiri Slaby <jslaby@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Wrong symbol resolved for RIP on OOPS/BUG
Message-ID: <20131111114551.GA19720@gmail.com>
References: <1383767997-20765-1-git-send-email-marek@cloudflare.com>
 <20131107075448.GA31926@gmail.com>
 <527BBEDD.60407@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527BBEDD.60407@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 11/06/2013 11:54 PM, Ingo Molnar wrote:
> > 
> > There's a recent commit from Jiri Slaby that I think tries to address the 
> > same problem:
> > 
> >   8d4c812a3e5f x86/dumpstack: Fix printk_address for direct addresses
> > 
> > You can find it in the -tip tree:
> > 
> >   git remote add tip git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git
> > 
> 
> The only difference seems to be in the handling of the "reliable" flag.
> 
> I am wondering if we shouldn't promote this patch to urgent/stable, 
> though, since misleading oops messages could be very disruptive.

Sure, no objections.

Thanks,

	Ingo
