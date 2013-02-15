Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab3BOSRK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 13:17:10 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:54266 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988Ab3BOSRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 13:17:08 -0500
Date: Fri, 15 Feb 2013 10:17:06 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        sjenning@linux.vnet.ibm.com, rcj@linux.vnet.ibm.com
Subject: Re: [PATCH] Compile bug-fixes to zcache (v4).
Message-ID: <20130215181706.GA11261@kroah.com>
References: <20130214172926.GA17343@kroah.com>
 <1360950824-11032-1-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360950824-11032-1-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 12:53:40PM -0500, Konrad Rzeszutek Wilk wrote:
> > Then why not just redo that one patch, and send it to me, and then
> > rebase all of the other patches on top of it?  That way I can accept the
> > "fix the complier warnings" patch now, and the rest can wait.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Hey Greg,
> 
> Please see these four patches which fix compile warnings.
> 
> They are also available at
>  git://git.kernel.org/pub/scm/linux/kernel/git/konrad/mm.git stable/for-greg-3.9
> 
> if you prefer doing a git pull. The branch and this patchset are all
> based on git commit 0bcc0429bdb9f7cca3b7ab1f905b0d47031c03e0
> "staging: zcache: add TODO file"

Sorry, I don't do git pulls for staging drivers.

> Please pull or git am as you see fit.

All now applied, thanks.

greg k-h
