Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbaEIH0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 03:26:15 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:38624 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbaEIH0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 03:26:13 -0400
Date: Fri, 9 May 2014 10:26:03 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [patch v2] Documentation/email-clients.txt: add a section about
 git
Message-ID: <20140509072603.GH26890@mwanda>
References: <536A5A1E.6070004@codeaurora.org>
 <20140508084412.GA20398@mwanda>
 <8738gjol2f.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8738gjol2f.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 09:24:56AM +0900, Namhyung Kim wrote:
> > +Git
> > +----------------------------------------------------------------------
> > +These days most developers use `git send-email` instead of regular
> > +email clients.  On the receiving end, maintainers use `git am` to
> > +apply the patches.
> > +
> > +If you are new to git then send your first patch to yourself.  Save it
> > +as raw text including all the headers.  Run `cat raw_email.txt | git am`
> > +and then review the changelog with `git log -p`.  When that works then
> 
> Also the -p option is not needed for just checking the changelog IMHO.
> If one needs to check the patch itself too, I think `git show` is
> slightly better since it only shows the single commit applied.
> 

I know you can leave the -p off but I wanted it on and I wanted the log
so they could see their patch and how the format compared to other
commits.

You guys are over thinking this.  It's not commands for all ages.  If
you type `cat patch.txt | git am` or if you type `git am < patch.txt`,
those are things I don't care about.

regards,
dan carpenter

