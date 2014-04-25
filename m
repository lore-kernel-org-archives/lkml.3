Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbaDYTga (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 15:36:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49266 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbaDYTg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 15:36:28 -0400
Date: Fri, 25 Apr 2014 12:39:22 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: tj@kernel.org, lizefan@huawei.com, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCH] kernfs: move the last knowledge of sysfs out from kernfs
Message-ID: <20140425193922.GA32567@kroah.com>
References: <1397669058-31720-1-git-send-email-nasa4836@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397669058-31720-1-git-send-email-nasa4836@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 01:24:18AM +0800, Jianyu Zhan wrote:
> There is still one residue of sysfs remaining: the sb_magic
> SYSFS_MAGIC. However this should be kernfs user specific,
> so this patch moves it out. Kerrnfs user should specify their
> magic number while mouting.
> 
> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
> Acked-by: Tejun Heo <tj@kernel.org>
> ---
>  fs/kernfs/mount.c      | 11 ++++++-----
>  fs/sysfs/mount.c       |  4 +++-
>  include/linux/kernfs.h | 13 ++++++++-----
>  kernel/cgroup.c        |  4 +++-
>  4 files changed, 20 insertions(+), 12 deletions(-)

This doesn't apply to my tree, can you please redo it against
the driver-core-next branch and resend?

thanks,

greg k-h
