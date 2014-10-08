Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbaJHCXG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 22:23:06 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:14163 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751280AbaJHCXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 22:23:03 -0400
Date: Tue, 7 Oct 2014 22:23:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [GIT PULL] ring-buffer: Fix infinite spin in reading buffer
Message-ID: <20141007222300.1e236e13@gandalf.local.home>
In-Reply-To: <20141005234943.GB23078@kroah.com>
References: <20141003162043.6817a486@gandalf.local.home>
	<20141005234943.GB23078@kroah.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Oct 2014 16:49:43 -0700
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

  
> >     Fixes: 651e22f2701b "ring-buffer: Always reset iterator to reader page"
> >     Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Next time, please also add a Cc: stable...  here so that my tools pick
> it up automatically.

Sure. I was a bit confused by exactly how to do that as it was a fix to
something that went to stable but wasn't in the original release.

But thinking about it now, I guess a Cc: stable without a version would
have sufficed. I'm too much in the habit of always adding a version and
didn't know what to add for this change as it was for 3.17-rcX. I guess
I just thought too hard about what to do.

-- Steve
