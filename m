Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbaIEW15 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 18:27:57 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:45317 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbaIEW1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 18:27:55 -0400
Date: Fri, 5 Sep 2014 15:27:50 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg KH <greg@kroah.com>
Cc: Li Zefan <lizefan@huawei.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [kernel.org PATCH] Li Zefan is now the 3.4 stable maintainer
Message-ID: <20140905222750.GA19219@roeck-us.net>
References: <20140826230858.GA29970@kroah.com>
 <20140827045938.GA28282@roeck-us.net>
 <540813A5.7020704@huawei.com>
 <20140904183953.GA28599@roeck-us.net>
 <54096C8D.8000008@huawei.com>
 <5409C19C.4030901@roeck-us.net>
 <20140905214930.GD30221@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140905214930.GD30221@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 02:49:30PM -0700, Greg KH wrote:
> > >>
> > >>Problem is that the pending patch got converted to use <cr><lf> instead of
> > >>just <lf> as common in Linux. When I try to apply it with "git quiltimport",
> > >>it bails out with "trailing whitespace" errors. "git am" with the individual
> > >>patch works fine for some reason, though.
> > >>
> > >>I can try to find a workaround, but it would be better to have the file in
> > >>linux file format to start with. Would that be possible ?
> > >>
> > >
> > >Yeah, I've fixed it. I'll run dos2unix for every patch file.
> > >
> > 
> > Yes, it now works. Wonder how it comes that the patch in Greg's patch tree
> > didn't have the problem. Any idea ?
> 
> What patch in my tree has dos line endings?  None should...
> 
The patch in your tree is fine. The same patch in Li's tree
had the problem, though he fixed it now.

Guenter
