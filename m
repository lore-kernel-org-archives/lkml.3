Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab3HOXUw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 19:20:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43913 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab3HOXUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 19:20:50 -0400
Date: Thu, 15 Aug 2013 16:22:26 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Khalid Aziz <khalid.aziz@oracle.com>, aarcange@redhat.com,
        hannes@cmpxchg.org, mgorman@suse.de, riel@redhat.com,
        minchan@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [RFC PATCH] Fix aio performance regression for database caused
 by THP
Message-ID: <20130815232226.GA5661@kroah.com>
References: <1376590389.24607.33.camel@concerto>
 <20130815141616.6cf60a354b9a92214ac0c246@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130815141616.6cf60a354b9a92214ac0c246@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 02:16:16PM -0700, Andrew Morton wrote:
> I tagged this for a -stable backport.  To allow time for review and
> testing I'll plan to merge the patch into 3.12-rc1, so it should
> materialize in 3.11.x (and hopefully earlier) stable kernels after that.
> 
> To facilitate backporting the patch could have been quite a bit
> smaller, with some simple restructuring.  It applies OK to 3.10, but
> not 3.9.  Hopefully that's good enough...

3.9 is end-of-life, and I do not know anyone who is wishing to try to
keep it going, so don't worry about it anymore.  3.10 is great to have
if possible.

thanks,

greg k-h
