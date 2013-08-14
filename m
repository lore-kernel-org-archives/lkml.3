Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435Ab3HNHnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 03:43:37 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:52312 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759199Ab3HNHng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 03:43:36 -0400
Date: Wed, 14 Aug 2013 11:43:33 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@amacapital.net>,
        Pavel Emelyanov <xemul@parallels.com>, Matt Mackall <mpm@selenic.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Peter Zijlstra <peterz@infradead.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -mm] mm: Unify pte_to_pgoff and pgoff_to_pte helpers
Message-ID: <20130814074333.GM2869@moon>
References: <20130814070059.GJ2869@moon>
 <520B303D.2090206@zytor.com>
 <20130814072453.GK2869@moon>
 <520B3240.6030208@zytor.com>
 <20130814003336.0fb2a275.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130814003336.0fb2a275.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 12:33:36AM -0700, Andrew Morton wrote:
> > > B_it_F_ield_OP_eration, Peter I don't mind to use any other
> > > name, this was just short enough to type.
> > > 
> > 
> > I think it would be useful to have a comment what it means and what
> > v,r,m,l represent.

Sure, maybe simply better names as value, rshift, mask, lshift would
look more understandable. I'll try to use width for mask as well
(which reminds me BFEXT helpers Andrew mentioned in this thread).

> Can it be written in C with types and proper variable names and such
> radical stuff?

Could you elaborate? You mean inline helper or macro with type checks?
