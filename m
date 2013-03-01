Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751340Ab3CAROk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 12:14:40 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:58448 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab3CAROj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 12:14:39 -0500
Date: Fri, 1 Mar 2013 09:14:36 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Greg KH <gregkh@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@ftp.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        Laura Abbott <lauraa@codeaurora.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: [-rc7 regression] Buggy commit: "mm: use aligned zone start for
 pfn_to_bitidx calculation"
Message-ID: <20130301171436.GA24032@kroah.com>
References: <alpine.LFD.2.02.1302140012460.22263@ionos>
 <20130214144510.GC25282@gmail.com>
 <20130214145424.GA26071@gmail.com>
 <20130214150810.GA26095@gmail.com>
 <CAE9FiQXc=7+TMwbfd20YiHNfOHX_kUOzYcVm8-uaP2R_C_1RRg@mail.gmail.com>
 <20130215114425.GD26955@gmail.com>
 <20130215220615.GA1696@kroah.com>
 <20130216082954.GA18953@gmail.com>
 <20130301165043.GB5435@kroah.com>
 <CA+55aFzxbC_+FeKW8Kpnu3Kj=rpn94DXcjtr1Mw3OPXamVQ=hA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzxbC_+FeKW8Kpnu3Kj=rpn94DXcjtr1Mw3OPXamVQ=hA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 01, 2013 at 09:07:52AM -0800, Linus Torvalds wrote:
> On Fri, Mar 1, 2013 at 8:50 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > What ever happened with this?  Did something go into Linus's tree to
> > resolve this issue that I need to pull into a stable release?
> 
> This was fixed by commit 7c45512df987 ("mm: fix pageblock bitmap allocation").
> 
> And you already put it in, afaik.

Ah, ok, thanks for letting me know.

greg k-h
