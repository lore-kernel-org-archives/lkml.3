Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab3EaRKP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 13:10:15 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:46930 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652Ab3EaRKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 13:10:11 -0400
Date: Fri, 31 May 2013 12:10:07 -0500
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: old version of trace-cmd broken on 3.10 kernel
Message-ID: <20130531171007.GD2910@sbohrermbp13-local.rgmadvisors.com>
References: <20130531165026.GC2910@sbohrermbp13-local.rgmadvisors.com>
 <1370019935.26799.53.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370019935.26799.53.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 01:05:35PM -0400, Steven Rostedt wrote:
> On Fri, 2013-05-31 at 11:50 -0500, Shawn Bohrer wrote:
> > Not sure if this is a big deal or not.  I've got an old version of
> > trace-cmd. It was built from git on 2012-09-12 but sadly I didn't
> > stash away the exact commit hash.  Anyway this version works fine on a
> > 3.4 kernel but on a 3.10-rc3 kernel it no longer works.  I just pulled
> > the latest trace-cmd from git and it works fine on the 3.10 kernel so
> > maybe this isn't an issue, but I don't typically expect applications
> > to break with a kernel upgrade.
> > 
> > When I run the old version on 3.10.0-rc3 I get the following output:
> 
> Yep, in 3.10 I fixed a long standing bug in the splice code, that when
> fixed, the old trace-cmd would fail.
> 
> I made a fix to all the stable releases of trace-cmd and posted it to
> LKML back on March 1st.
> 
> https://lkml.org/lkml/2013/3/1/596

Thanks Steve,

I'll just update my trace-cmd version.  It is about time for an update
anyway.

Thanks,
Shawn
