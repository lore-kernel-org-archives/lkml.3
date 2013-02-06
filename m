Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823Ab3BFBk6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 20:40:58 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:63344 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836Ab3BFBk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 20:40:56 -0500
Date: Tue, 5 Feb 2013 17:42:59 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] zsmalloc: Add Kconfig for enabling PTE method
Message-ID: <20130206014259.GC816@kroah.com>
References: <1359937421-19921-1-git-send-email-minchan@kernel.org>
 <20130204185146.GA31284@kroah.com>
 <20130205000854.GC2610@blaptop>
 <20130205192520.GA8441@kroah.com>
 <20130206011721.GE11197@blaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130206011721.GE11197@blaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 10:17:21AM +0900, Minchan Kim wrote:
> > > > Did you test this?  I don't see the new config value you added actually
> > > > do anything in this code.  Also, if I select it incorrectly on ARM, or
> > > 
> > > *slaps self*
> > 
> > Ok, so I'll drop this patch now.  As for what to do instead, I have no
> > idea, sorry, but the others should.
> 
> Okay. Then, let's discuss further.
> The history we introuced copy-based method is due to portability casused by
> set_pte and __flush_tlb_one usage in young zsmalloc age. They are gone now
> so there isn't issue any more. But we found copy-based method is 3 times faster
> than pte-based in VM so I expect you guys don't want to give up it for just
> portability. Of course,
> I can't give up pte-based model as you know well, it's 6 times faster than
> copy-based model in ARM.
> 
> Hard-coding for some arch like now isn't good and Kconfig for selecting choice
> was rejected by Greg as you can see above.

I rejected your patch because it did not do anything, why would I accept
it?

What would you have done in my situation?

It's not an issue of "portability" or "speed" or anything other than
"the patch you sent was obviously not correct."

greg k-h
