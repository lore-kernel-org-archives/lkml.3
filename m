Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566Ab3LKVWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 16:22:38 -0500
Received: from mail-yh0-f42.google.com ([209.85.213.42]:44879 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab3LKVWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 16:22:37 -0500
Date: Wed, 11 Dec 2013 16:22:32 -0500
From: Tejun Heo <tj@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com, kay@vrfy.org
Subject: Re: [PATCHSET driver-core-next] kernfs: implement kernfs_dir_ops
Message-ID: <20131211212232.GD7683@mtj.dyndns.org>
References: <1386795780-23324-1-git-send-email-tj@kernel.org>
 <20131211211907.GA20491@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131211211907.GA20491@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Greg.

On Wed, Dec 11, 2013 at 01:19:07PM -0800, Greg KH wrote:
> Very cool, will this let us move configfs to use kernfs as well?  That's
> one of the reasons that the two filesystems couldn't be merged in the
> past from what I remember.

I haven't looked into the details but configfs would need hooks for
more operations - file creation and all; however, those should be
trivial.  kernfs doesn't care what those operations do at all.  All it
needs to do is just routing the invocations through the callbacks.

Thanks.

-- 
tejun
