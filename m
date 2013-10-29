Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050Ab3J2W3w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 18:29:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39448 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab3J2W3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 18:29:51 -0400
Date: Tue, 29 Oct 2013 15:29:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com
Subject: Re: Subject: [PATCHSET driver-core-next] sysfs: separate out kernfs,
 part #1
Message-ID: <20131029222950.GA9612@kroah.com>
References: <1382629780-10006-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382629780-10006-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 11:49:06AM -0400, Tejun Heo wrote:
> Hello,
> 
> This patchset contains 34 patches to separate out core sysfs features
> into kernfs.  kernfs exclusively deals with sysfs_dirent, which will
> be later renamed to kernfs_node, and kernfs_ops.  sysfs becomes a
> wrapping layer over sysfs which interfaces kobject and
> [bin_]attribute.
> 
> The goal of these changes is to allow other users to make use of the
> core features of sysfs instead of rolling their own pseudo filesystem
> implementation which usually fails to deal with issues with file
> shutdowns, locking separation from vfs layer and so on.  This patchset
> refactors sysfs and separates out most core functionalities to kernfs;
> however, the mount code hasn't been updated yet and it can't be used
> by other users yet.  The patchset is pretty big already and the two
> steps can be separated relatively well, so I think this is a good
> split point.

I've applied the first 6 patches here, as they only did cleanup stuff.
As it's late in the development cycle (i.e. 3.12 is going to be out in
days), I'd prefer to wait on the rest until 3.13-rc1 is out so that it
gets lots of testing in linux-next.

So, I'll hold off on the rest of these until then, ok?

thanks,

greg k-h
