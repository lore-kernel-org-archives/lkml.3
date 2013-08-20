Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746Ab3HTVn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 17:43:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38010 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385Ab3HTVn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 17:43:56 -0400
Date: Tue, 20 Aug 2013 14:43:55 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jan-Simon =?iso-8859-1?Q?M=F6ller?= <dl9pf@gmx.de>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] Remove braces to fix build for clang. No
 functional change otherwise.
Message-ID: <20130820214355.GA10949@kroah.com>
References: <1377031926-18436-1-git-send-email-dl9pf@gmx.de>
 <20130820212433.GA9856@kroah.com>
 <1729833.NqCHnaFaae@aragorn.auenland.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1729833.NqCHnaFaae@aragorn.auenland.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 11:26:01PM +0200, Jan-Simon Möller wrote:
> On Tuesday 20 August 2013 14:24:33 Greg Kroah-Hartman wrote:
> > On Tue, Aug 20, 2013 at 10:52:06PM +0200, dl9pf@gmx.de wrote:
> > > From: Jan-Simon Möller <dl9pf@gmx.de>
> > > 
> > > Author:  PaX Team <pageexec at freemail.hu>
> > > ML-Post:
> > > http://lists.cs.uiuc.edu/pipermail/llvm-commits/Week-of-Mon-20120507/1427
> > > 07.html URL:     http://llvm.linuxfoundation.org
> > > 
> > > Merge:   Jan-Simon Möller <dl9pf at gmx.de>
> > 
> > What am I supposed to do with these?
> > 
> > > Description:
> > >   Clang chokes on the notation "inl (%dx)" but works for "inl %dx"; GNU as
> > >   accepts both forms.
> > No need for "description", that's implied by the body of the changelog
> > text.  Also, you can wrap your lines :)
> > 
> > I'll clean this all up by hand, but please do this next time so I don't
> > have to.
> 
> Roger that - ignore it in the other 2 I just sent out.  c'n'p from the 
> existing commit msg. 
> Do you want all 3 w/o then ?

As the other two were not sent to me (I'm not a maintainer of those
areas of the kernel), I have no idea, sorry.

greg k-h
