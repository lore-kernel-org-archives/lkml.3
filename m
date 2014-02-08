Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751228AbaBHALp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 19:11:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60375 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbaBHALo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 19:11:44 -0500
Date: Fri, 7 Feb 2014 16:12:54 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET v2 driver-core-next] kernfs: prepare for cgroup's
 kernfs conversion
Message-ID: <20140208001254.GA31648@kroah.com>
References: <1391454557-32376-1-git-send-email-tj@kernel.org>
 <20140207184320.GD12815@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140207184320.GD12815@htj.dyndns.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 01:43:20PM -0500, Tejun Heo wrote:
> Hello,
> 
> On Mon, Feb 03, 2014 at 02:09:07PM -0500, Tejun Heo wrote:
> >  0001-kernfs-invoke-dir_ops-while-holding-active-ref-of-th.patch
> >  0002-kernfs-rename-kernfs_dir_ops-to-kernfs_syscall_ops.patch
> >  0003-kernfs-implement-kernfs_syscall_ops-remount_fs-and-s.patch
> >  0004-kernfs-add-missing-kernfs_active-checks-in-directory.patch
> >  0005-kernfs-allow-nodes-to-be-created-in-the-deactivated-.patch
> >  0006-kernfs-implement-kernfs_ops-atomic_write_len.patch
> >  0007-kernfs-add-kernfs_open_file-priv.patch
> >  0008-kernfs-implement-kernfs_node_from_dentry-kernfs_root.patch
> >  0009-kernfs-implement-kernfs_get_parent-kernfs_name-path-.patch
> >  0010-kernfs-add-CONFIG_KERNFS.patch
> 
> 0009 updated to v2 and a new patch added between 0009 and 0010.  Both
> are for dummy definition related issues for !CONFIG_SYSFS.  The git
> tree has been updated accordingly.

Ok, I should have now applied all of these, and hopefully in the correct
order.  If I got anything wrong, please let me know.

thanks,

greg k-h
