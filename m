Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbaFCE0L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 00:26:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45510 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbaFCE0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 00:26:09 -0400
Date: Mon, 2 Jun 2014 21:26:05 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Jianyu Zhan <nasa4836@gmail.com>
Subject: Re: 3.15 regression: wrong cgroup magic
Message-ID: <20140603042605.GC14668@kroah.com>
References: <CALCETrXbpiqwY=qyPcNWn2zX=vehXzBbxDG725egM9T2Ox2KTA@mail.gmail.com>
 <538D2261.70406@huawei.com>
 <20140603012211.GE19855@htj.dyndns.org>
 <CA+55aFx=TG25jPohWZ5xbYs4DcOTUQnCPA8G_fZZouNEfSoZ3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx=TG25jPohWZ5xbYs4DcOTUQnCPA8G_fZZouNEfSoZ3A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 06:30:20PM -0700, Linus Torvalds wrote:
> On Mon, Jun 2, 2014 at 6:22 PM, Tejun Heo <tj@kernel.org> wrote:
> >
> > Linus, can you please cherry-pick the commit?
> 
> I'd much rather see it go through the proper channels than go ahead
> and cherry-pick from some branch that hasn't even been sent to me yet.
> The whole "you have to send things to me for me to take them" policy
> is not new, I don't want to start taking stuff that the
> authors/maintainers haven't actively sent my way.
> 
> That said, I suspect that Greg didn't expect this to actually matter
> (the commit message certainly doesn't make it sound like anything that
> people would notice), so the reason it is in -next is likely that
> nobody thought it was a regression.

Yes, I did not realize it at all, otherwise I would have sent it to you
earlier.

> Of course, Greg could just send it to me for my next branch (since the
> merge window for 3.16 is already open) and tell me that it's also
> stable material for 3.15. At _that_ point I'll happily cherry-pick it
> intpo master...

Ok, I'll go make up a pull request tonight for that.

thanks,

greg k-h
