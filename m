Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933324AbaFJUTw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:19:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39557 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932306AbaFJUTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 16:19:50 -0400
Date: Tue, 10 Jun 2014 13:23:38 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: Change in security maintainer for a few weeks
Message-ID: <20140610202338.GC20499@kroah.com>
References: <20140605183050.GA5054@kroah.com>
 <alpine.LRH.2.02.1406101517350.31746@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1406101517350.31746@tundra.namei.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 03:20:15PM +1000, James Morris wrote:
> On Thu, 5 Jun 2014, Greg KH wrote:
> 
> > Hi all,
> > 
> > James has had to step back from doing kernel work for a few weeks, so
> > I've offered to step up and handle the security patches to get shuttled
> > to Linus for merging for a while.
> > 
> > I'll take his git tree on kernel.org and push those to Linus for
> > 3.16-rc1, as those look like they have had proper testing in linux-next.
> > 
> > But there only seems to be 14 patches in there.  Are there pending
> > patches that people have been sending and need to get in besides those?
> > 
> 
> Thanks for stepping up.
> 
> I had to take urgent leave and was unable to access email until this week.
> 
> We really should have a co-maintainer for the security subsystem -- please 
> feel free to nominate someone.
> 
> There are several good candidates, including Serge, Kees and Paul Moore.

As Serge has done it in the past when you are on vacation, I suggest he
continue doing it.

thanks,

greg k-h
