Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab3DRSj4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 14:39:56 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:52605 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776Ab3DRSjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 14:39:54 -0400
Date: Thu, 18 Apr 2013 11:39:50 -0700
From: Tejun Heo <tj@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        Li Zefan <lizefan@huawei.com>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH 25/28] proc: Supply an accessor to get the process ID
 associated with some proc files [RFC]
Message-ID: <20130418183950.GJ9897@mtj.dyndns.org>
References: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
 <20130416182730.27773.88726.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130416182730.27773.88726.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, David.

On Tue, Apr 16, 2013 at 07:27:30PM +0100, David Howells wrote:
> +struct pid *get_proc_pid(const struct inode *inode)
> +{
> +	return PROC_I(inode)->pid;
> +}

Maybe we can add /** comment explaining what this is about?  Other
than that, it looks fine to me.  It probably would be best to route
this through -mm given it touches /proc too, so cc Andrew on the next
posting?

Thanks.

-- 
tejun
