Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740AbaIDHzN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 03:55:13 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54202 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932210AbaIDHzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 03:55:11 -0400
Date: Thu, 4 Sep 2014 09:54:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Borislav Petkov <bp@alien8.de>,
        =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Christopher Barry <christopher.r.barry@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: OT: Open letter to the Linux World
Message-ID: <20140904075453.GK3190@worktop.ger.corp.intel.com>
References: <20140812153812.2923046a@monolith.infinux.org>
 <20140812202129.GA20344@home.goodmis.org>
 <yw1xr40l2whi.fsf@unicorn.mansr.com>
 <20140813082756.GB2923@twins.programming.kicks-ass.net>
 <20140813090013.GA20581@pd.tnic>
 <53F242D1.4050506@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F242D1.4050506@ahsoftware.de>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 08:15:45PM +0200, Alexander Holler wrote:
> 
> Hmm, a sane and maintainable solution would use C++ with which people don't
> have to manually build lists or hashes for every structure like in the
> kernel (generic programming done right). So you won't find much kernel
> developers there. ;)
> 

Troll a lot do you? ;-)

While I like C++ (and quite a number of kernel people can in fact write
C++ no problem) we can have a long debate about whether the STL is in
fact 'done right' :-)

Also, I don't think init (as in PID-1) should be a large program, and
therefore writing it in C would be entirely reasonable.
