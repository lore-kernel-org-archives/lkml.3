Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbaIDSkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 14:40:06 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:53183 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbaIDSkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 14:40:04 -0400
Date: Thu, 4 Sep 2014 11:39:53 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Li Zefan <lizefan@huawei.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [kernel.org PATCH] Li Zefan is now the 3.4 stable maintainer
Message-ID: <20140904183953.GA28599@roeck-us.net>
References: <20140826230858.GA29970@kroah.com>
 <20140827045938.GA28282@roeck-us.net>
 <540813A5.7020704@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540813A5.7020704@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 03:24:21PM +0800, Li Zefan wrote:
> Hi Guenter,
> 
> Sorry for my late reply.
> 
> On 2014/8/27 12:59, Guenter Roeck wrote:
> > On Tue, Aug 26, 2014 at 04:08:58PM -0700, Greg KH wrote:
> >> Li has agreed to continue to support the 3.4 stable kernel tree until
> >> September 2016.  Update the releases.html page on kernel.org to reflect
> >> this.
> >>
> > Li,
> > 
> > it would be great if you can send me information about your -stable queue,
> > ie how you maintain it and where it is located. This will enable me to
> > continue testing the stable queue for the 3.4 kernel.
> > 
> 
> Thanks for testing LTS kernels!
> 
> This is my 3.4.y git tree:
> 
> https://git.kernel.org/cgit/linux/kernel/git/lizf/linux-3.4.y.git/
> 
> And this is the patch queue:
> 
> https://git.kernel.org/cgit/linux/kernel/git/lizf/linux-3.4.y-queue.git/
> 
> I use quilt. When I've added some patches to 3.4.y, I'll update this
> queue. The patches and series file are under /patches. Currently there's
> already a patch in the queue.
> 
> When I release a new version, I'll clean up the queue by removing all
> the files under /patches.
> 
> Hope this is all the information you need. Please tell me if you need
> me to slightly adjust my workflow so it's easier for you.

It almost works.

Problem is that the pending patch got converted to use <cr><lf> instead of
just <lf> as common in Linux. When I try to apply it with "git quiltimport",
it bails out with "trailing whitespace" errors. "git am" with the individual
patch works fine for some reason, though.

I can try to find a workaround, but it would be better to have the file in
linux file format to start with. Would that be possible ?

Alternatively, does anyone know how to apply files in DOS format (lines
terminated with cr/lf) using quiltimport ?

Thanks,
Guenter
