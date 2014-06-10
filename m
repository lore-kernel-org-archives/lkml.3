Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbaFJFTB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 01:19:01 -0400
Received: from tundra.namei.org ([65.99.196.166]:36757 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400AbaFJFTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 01:19:00 -0400
Date: Tue, 10 Jun 2014 15:20:15 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Greg KH <gregkh@linuxfoundation.org>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: Change in security maintainer for a few weeks
In-Reply-To: <20140605183050.GA5054@kroah.com>
Message-ID: <alpine.LRH.2.02.1406101517350.31746@tundra.namei.org>
References: <20140605183050.GA5054@kroah.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jun 2014, Greg KH wrote:

> Hi all,
> 
> James has had to step back from doing kernel work for a few weeks, so
> I've offered to step up and handle the security patches to get shuttled
> to Linus for merging for a while.
> 
> I'll take his git tree on kernel.org and push those to Linus for
> 3.16-rc1, as those look like they have had proper testing in linux-next.
> 
> But there only seems to be 14 patches in there.  Are there pending
> patches that people have been sending and need to get in besides those?
> 

Thanks for stepping up.

I had to take urgent leave and was unable to access email until this week.

We really should have a co-maintainer for the security subsystem -- please 
feel free to nominate someone.

There are several good candidates, including Serge, Kees and Paul Moore.


- James
-- 
James Morris
<jmorris@namei.org>
