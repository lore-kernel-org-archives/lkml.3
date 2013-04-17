Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966500Ab3DQSi3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 14:38:29 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:44652 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966109Ab3DQSi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 14:38:27 -0400
Date: Wed, 17 Apr 2013 11:38:24 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Stephan von Krawczynski <skraw@ithnet.com>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: No serial since kernel 3.8
Message-ID: <20130417183824.GA2386@kroah.com>
References: <20130416162047.2f9b83fe.skraw@ithnet.com>
 <CAFLxGvykqMUHrmdZnzPXW7i3-ubcF6jv2fLYF3sYPkCtJDJZuA@mail.gmail.com>
 <20130416181006.6be492a8.skraw@ithnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130416181006.6be492a8.skraw@ithnet.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 06:10:06PM +0200, Stephan von Krawczynski wrote:
> On Tue, 16 Apr 2013 16:55:25 +0200
> richard -rw- weinberger <richard.weinberger@gmail.com> wrote:
> 
> > On Tue, Apr 16, 2013 at 4:20 PM, Stephan von Krawczynski
> > <skraw@ithnet.com> wrote:
> > > Hello,
> > >
> > > can some kind soul please explain how I can get my serial port back under
> > > kernel 3.8.X. Earlier kernels showed:
> > >
> > > Jan 10 13:57:18 mybox kernel: [    0.712829] serial8250: ttyS0 at I/O 0x3f8
> > > (irq = 4) is a 16550A
> > >
> > > But 3.8.4:
> > >
> > > Mar 26 10:39:14 admin kernel: [    0.603647] serial 00:0a: disabled
> > >
> > > Only kernel is replaced, no change in distro
> > > Is there some kernel boot parameter needed now?
> > > I tried 3.4.X and it works, even 3.7.X works...
> > 
> > So, 3.8.3 worked and 3.8.4 introduced a regression?
> > If so please confirm.
> > 
> > CC'ing gregkh, just in case...
> 
> No, neither 3.8.4 nor 3.8.3 worked. The last working version I know for sure is 3.7.6
> FYI: I don't load serial as a module

Can you run 'git bisect' between those kernels to track down the
offending commit?

thanks,

greg k-h
