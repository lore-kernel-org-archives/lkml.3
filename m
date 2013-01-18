Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab3ARVqj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 16:46:39 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:45679 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab3ARVqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 16:46:38 -0500
Date: Fri, 18 Jan 2013 13:46:26 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, ngupta@vflare.org, konrad.wilk@oracle.com,
        sjenning@linux.vnet.ibm.com, minchan@kernel.org
Subject: Re: [PATCH V2 0/5] staging: zcache: move new zcache code base from
 ramster
Message-ID: <20130118214626.GA11130@kroah.com>
References: <1358544267-9104-1-git-send-email-dan.magenheimer@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358544267-9104-1-git-send-email-dan.magenheimer@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 01:24:22PM -0800, Dan Magenheimer wrote:
> [V2: no code changes, patchset now generated via git format-patch -M]
> 
> Hi Greg --
> 
> With "old zcache" now removed, we can now move "new zcache" from its
> temporary home (in drivers/staging/ramster) to reclaim sole possession
> of the name "zcache".
> 
> (Note that [PATCH 2/5] is just a git mv.)
> 
> This patchset should apply cleanly to staging-next.

Very nice, now applied, thanks.

greg k-h
