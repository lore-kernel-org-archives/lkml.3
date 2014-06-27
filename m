Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220AbaF0Ron (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 13:44:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42972 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbaF0Rol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 13:44:41 -0400
Date: Fri, 27 Jun 2014 10:48:52 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] kernfs: introduce kernfs_pin_sb()
Message-ID: <20140627174852.GA1653@kroah.com>
References: <53AD18D0.3090100@huawei.com>
 <53AD18F8.4050501@huawei.com>
 <20140627150141.GB4044@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140627150141.GB4044@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 11:01:41AM -0400, Tejun Heo wrote:
> On Fri, Jun 27, 2014 at 03:10:48PM +0800, Li Zefan wrote:
> > kernfs_pin_sb() tries to get a refcnt of the superblock.
> > 
> > This will be used by cgroupfs.
> 
> Greg, this is pretty much cgroup specific due to the way cgroup
> dynamically manages multiple hierarchies.  Can I route this through
> cgroup/for-3.16-fixes w/ stable cc'd?

Please do:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
