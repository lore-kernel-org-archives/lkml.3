Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644Ab3K1GEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 01:04:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55603 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab3K1GE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 01:04:28 -0500
Date: Wed, 27 Nov 2013 22:05:18 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com
Subject: Re: [PATCH v4 09/41] sysfs, kernfs: introduce
 kernfs_create_dir[_ns]()
Message-ID: <20131128060518.GA5291@kroah.com>
References: <1385245346-856-1-git-send-email-tj@kernel.org>
 <1385245346-856-10-git-send-email-tj@kernel.org>
 <20131123230704.GC29774@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131123230704.GC29774@mtj.dyndns.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 23, 2013 at 06:07:04PM -0500, Tejun Heo wrote:
> Introduce kernfs interface to manipulate a directory which takes and
> returns sysfs_dirents.
> 
> create_dir() is renamed to kernfs_create_dir_ns() and its argumantes
> and return value are updated.  create_dir() usages are replaced with
> kernfs_create_dir_ns() and sysfs_create_subdir() usages are replaced
> with kernfs_create_dir().  Dup warnings are handled explicitly by
> sysfs users of the kernfs interface.
> 
> sysfs_enable_ns() is renamed to kernfs_enable_ns().
> 
> This patch doesn't introduce any behavior changes.
> 
> v2: Dummy implementation for !CONFIG_SYSFS updated to return -ENOSYS.
> 
> v3: kernfs_enable_ns() added.
> 
> v4: Refreshed on top of "sysfs: drop kobj_ns_type handling, take #2"
>     so that this patch removes sysfs_enable_ns().

Care to go for v5?  This doesn't apply on my tree anymore, I'm pretty
sure due to the other fixes in fs/sysfs/dir.c.

I tried to do the merge myself, but I don't think I got it right at all,
so could you just check out my driver-core.git tree on the
driver-core-next branch and refresh this patch?

thanks so much, I've applied the other 8 patches in this series already,
they seem fine.

greg k-h
