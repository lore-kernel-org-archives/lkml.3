Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643Ab3KWW0F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 17:26:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35551 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756384Ab3KWWZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 17:25:57 -0500
Date: Sat, 23 Nov 2013 14:26:34 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH v3.13-rc1 1/2] sysfs: handle duplicate removal attempts
 in sysfs_remove_group()
Message-ID: <20131123222634.GA4419@kroah.com>
References: <20131123183508.GA28162@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131123183508.GA28162@mtj.dyndns.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 23, 2013 at 01:35:08PM -0500, Tejun Heo wrote:
> Hello, Greg.
> 
> These are two patches to fix sysfs bugs which are present in rc1 and
> posted previously.  Both deal with spurious triggering of warnings.
> The patches are available in the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-sysfs-fixes
> 
> The original patches are
> 
>  http://lkml.kernel.org/g/1384866598-19716-1-git-send-email-mika.westerberg@linux.intel.com
>  http://lkml.kernel.org/g/20131117021736.GA9302@mtj.dyndns.org
> 
> I'll base further sysfs/kernfs patches on top of the above branch.

Both now applied, thanks.

greg k-h
