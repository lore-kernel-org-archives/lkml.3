Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbaJMIgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 04:36:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52654 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbaJMIgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 04:36:18 -0400
Date: Mon, 13 Oct 2014 10:35:12 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: NeilBrown <neilb@suse.de>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 0/2 V3] Allow access to sysfs attributes without mem
 allocations.
Message-ID: <20141013083512.GA29706@kroah.com>
References: <20141013053733.19481.43981.stgit@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141013053733.19481.43981.stgit@notabene.brown>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2014 at 04:41:28PM +1100, NeilBrown wrote:
> Hi Greg,
>  please consider these two patches for a future release.
>  They now have
>    Reviewed-by: Tejun Heo <tj@kernel.org>
>  and I've addressed Tejun's final nits.
> 
>  Thanks Tejun for your review and comments.
> 
>  As soon as they appear in an -rc1, I'll submit updates to md to use
>  the new functionality for the -rc2.

It will have to wait until 3.19-rc1, I'll queue it up in my tree after
3.18-rc1 is out.  You can merge from my driver-core tree into yours if
you want to build off of it, as my tree will not be rebased.

thanks,

greg k-h
