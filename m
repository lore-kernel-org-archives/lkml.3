Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab3ARUrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 15:47:00 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:57956 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab3ARUq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 15:46:59 -0500
Date: Fri, 18 Jan 2013 12:46:55 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, ngupta@vflare.org, konrad.wilk@oracle.com,
        sjenning@linux.vnet.ibm.com, minchan@kernel.org
Subject: Re: [PATCH 2/5] staging: zcache: rename ramster to zcache
Message-ID: <20130118204655.GC4788@kroah.com>
References: <1358443597-9845-1-git-send-email-dan.magenheimer@oracle.com>
 <1358443597-9845-3-git-send-email-dan.magenheimer@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358443597-9845-3-git-send-email-dan.magenheimer@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 09:26:34AM -0800, Dan Magenheimer wrote:
> In staging, rename ramster to zcache
> 
> The original zcache in staging was a "demo" version, and this new zcache
> is a significant rewrite.  While certain disagreements were being resolved,
> both "old zcache" and "new zcache" needed to reside in the staging tree
> simultaneously.  In order to minimize code change and churn, the newer
> version of zcache was temporarily merged into the "ramster" staging driver
> which, prior to that, had at one time heavily leveraged the older version
> of zcache.  So, recently, "new zcache" resided in the ramster directory.
> 
> Got that? No? Sorry, temporary political compromises are rarely pretty.
> 
> The older version of zcache is no longer being maintained and has now
> been removed from the staging tree.  So now the newer version of zcache
> can rightfully reclaim sole possession of the name "zcache".
> 
> This patch is simply a manual:
> 
>   # git mv drivers/staging/ramster drivers/staging/zcache
> 
> so the actual patch diff has been left out.
> 
> Because a git mv loses history, part of the original description of
> the changes between "old zcache" and "new zcache" is repeated below:

git mv does not loose history, it can handle it just fine.

greg k-h
