Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab3FGOTs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 10:19:48 -0400
Received: from 1wt.eu ([62.212.114.60]:36152 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754290Ab3FGOTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 10:19:45 -0400
Date: Fri, 7 Jun 2013 16:19:38 +0200
From: Willy Tarreau <w@1wt.eu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [ 027/184] ring-buffer: Fix race between integrity check and
Message-ID: <20130607141938.GE19006@1wt.eu>
References: <20130604172131.427118554@1wt.eu> <1370614020.9844.62.camel@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370614020.9844.62.camel@gandalf.local.home>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 10:07:00AM -0400, Steven Rostedt wrote:
> On Tue, 2013-06-04 at 19:21 +0200, Willy Tarreau wrote:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> >  readers
> > 
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > commit 9366c1ba13fbc41bdb57702e75ca4382f209c82f upstream.
> 
> This isn't the right commit (thanks to Ben for bringing this to my
> attention).
> 
> That this commit SHA1 matches the change log but not the change.
> According to git blame, the change below is from:
> 
> 54f7be5b831254199522523ccab4c3d954bbf576
> ring-buffer: Fix NULL pointer if rb_set_head_page() fails

Ah yes indeed, thank you for bringing this up, Steve.

Willy

