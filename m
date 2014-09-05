Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbaIEVtd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 17:49:33 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43591 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751508AbaIEVtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 17:49:31 -0400
X-Sasl-enc: iRMEBVNWLoATF+iS58riF+lmhevrAXIgMTvd4xgXmwQ2 1409953770
Date: Fri, 5 Sep 2014 14:49:30 -0700
From: Greg KH <greg@kroah.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Li Zefan <lizefan@huawei.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [kernel.org PATCH] Li Zefan is now the 3.4 stable maintainer
Message-ID: <20140905214930.GD30221@kroah.com>
References: <20140826230858.GA29970@kroah.com>
 <20140827045938.GA28282@roeck-us.net>
 <540813A5.7020704@huawei.com>
 <20140904183953.GA28599@roeck-us.net>
 <54096C8D.8000008@huawei.com>
 <5409C19C.4030901@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5409C19C.4030901@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 06:58:52AM -0700, Guenter Roeck wrote:
> On 09/05/2014 12:55 AM, Li Zefan wrote:
> >>>>Li,
> >>>>
> >>>>it would be great if you can send me information about your -stable queue,
> >>>>ie how you maintain it and where it is located. This will enable me to
> >>>>continue testing the stable queue for the 3.4 kernel.
> >>>>
> >>>
> >>>Thanks for testing LTS kernels!
> >>>
> >>>This is my 3.4.y git tree:
> >>>
> >>>https://git.kernel.org/cgit/linux/kernel/git/lizf/linux-3.4.y.git/
> >>>
> >>>And this is the patch queue:
> >>>
> >>>https://git.kernel.org/cgit/linux/kernel/git/lizf/linux-3.4.y-queue.git/
> >>>
> >>>I use quilt. When I've added some patches to 3.4.y, I'll update this
> >>>queue. The patches and series file are under /patches. Currently there's
> >>>already a patch in the queue.
> >>>
> >>>When I release a new version, I'll clean up the queue by removing all
> >>>the files under /patches.
> >>>
> >>>Hope this is all the information you need. Please tell me if you need
> >>>me to slightly adjust my workflow so it's easier for you.
> >>
> >>It almost works.
> >>
> >>Problem is that the pending patch got converted to use <cr><lf> instead of
> >>just <lf> as common in Linux. When I try to apply it with "git quiltimport",
> >>it bails out with "trailing whitespace" errors. "git am" with the individual
> >>patch works fine for some reason, though.
> >>
> >>I can try to find a workaround, but it would be better to have the file in
> >>linux file format to start with. Would that be possible ?
> >>
> >
> >Yeah, I've fixed it. I'll run dos2unix for every patch file.
> >
> 
> Yes, it now works. Wonder how it comes that the patch in Greg's patch tree
> didn't have the problem. Any idea ?

What patch in my tree has dos line endings?  None should...

thanks,

greg k-h
