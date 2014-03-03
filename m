Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbaCCWqO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 17:46:14 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:35255 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbaCCWqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 17:46:13 -0500
Date: Mon, 3 Mar 2014 17:46:09 -0500
From: Tejun Heo <tj@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: kernfs: possible deadlock between of->mutex and mmap_sem
Message-ID: <20140303224609.GF26523@mtj.dyndns.org>
References: <53113485.2090407@oracle.com>
 <20140303223933.GC26523@mtj.dyndns.org>
 <531505E4.8020802@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <531505E4.8020802@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2014 at 05:44:52PM -0500, Sasha Levin wrote:
> >>I'll send a patch to fix it some time next week unless someone beats me to it :)
> >
> >How are you planning to fix it?  Prolly the right thing to do would be
> >caching atomic_write_len in open_file and copy data before grabbing
> >any locks.
> 
> I've actually didn't have a plan when I wrote that, was just
> planning on putting effort into it.

I'll prolly work on it tomorrow unless you beat me to it. :)

Thanks.

-- 
tejun
