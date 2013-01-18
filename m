Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab3ARUqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 15:46:23 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:49906 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab3ARUqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 15:46:22 -0500
Date: Fri, 18 Jan 2013 12:46:17 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, ngupta@vflare.org, konrad.wilk@oracle.com,
        sjenning@linux.vnet.ibm.com, minchan@kernel.org
Subject: Re: [PATCH 0/5] staging: zcache: move new zcache code base from
 ramster
Message-ID: <20130118204617.GB4788@kroah.com>
References: <1358443597-9845-1-git-send-email-dan.magenheimer@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358443597-9845-1-git-send-email-dan.magenheimer@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 09:26:32AM -0800, Dan Magenheimer wrote:
> Hi Greg --
> 
> With "old zcache" now removed, we can now move "new zcache" from its
> temporary home (in drivers/staging/ramster) to reclaim sole possession
> of the name "zcache".
> 
> Note that [PATCH 2/5] will require a manual:
> 
> # git mv drivers/staging/ramster drivers/staging/zcache

Ick, no, use git to generate the patch with rename style, and it will
create the tiny patch that does this which I can then apply (-M is the
option you want to 'git format-patch').

Care to resend this in that format so that I can apply this properly?

thanks,

greg k-h
