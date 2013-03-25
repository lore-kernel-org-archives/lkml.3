Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689Ab3CYIub (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 04:50:31 -0400
Received: from ozlabs.org ([203.10.76.45]:43043 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755436Ab3CYIu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 04:50:27 -0400
From: Michael Neuling <mikey@neuling.org>
To: Andi Kleen <ak@linux.intel.com>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        x86@kernel.org
Subject: Re: [PATCH 01/29] tsx: Add generic noop macros for RTM intrinsics
In-reply-to: <20130325081928.GT19692@tassilo.jf.intel.com>
References: <1364001923-10796-1-git-send-email-andi@firstfloor.org> <1364001923-10796-2-git-send-email-andi@firstfloor.org> <30418.1364182745@ale.ozlabs.ibm.com> <20130325081928.GT19692@tassilo.jf.intel.com>
Comments: In-reply-to Andi Kleen <ak@linux.intel.com>
   message dated "Mon, 25 Mar 2013 01:19:28 -0700."
X-Mailer: MH-E 8.2; nmh 1.5; GNU Emacs 23.4.1
Date: Mon, 25 Mar 2013 19:50:25 +1100
Message-ID: <15098.1364201425@ale.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@linux.intel.com> wrote:

> > RTM == restricted transactional memory.  I don't understand why it's
> > "restricted" and why any other architecture else would call it that and
> 
> It's restricted as in there is no guarantee that a transaction ever succeeds
> and always needs a fallback path. My understanding is that this is true for 
> PPC too, but not necessarily zSeries.

Yes, ppc is limited in this way too.  We just didn't call it a silly
name, although we do have the TEXASR register for TM status to make up
for it.  :-)

Mikey

> 
> > hence why Linux should call it that?
> > 
> > Can we just call it TM for transactional memory?  Each arch can then
> > have their own implementation and call it what they want.
> 
> I don't think the name will stop them to do anything.
> 
> If people feel strongly about it can change it, but it's not
> actually making a real difference.
> 
> -Andi
> -- 
> ak@linux.intel.com -- Speaking for myself only
> 
