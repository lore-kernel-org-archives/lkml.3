Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096AbaEMQRK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 12:17:10 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:33836 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaEMQRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 12:17:04 -0400
Date: Tue, 13 May 2014 12:17:01 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, vgoyal@redhat.com,
        axboe@kernel.dk, hannes@cmpxchg.org, mhocko@suse.cz,
        arozansk@redhat.com
Subject: Re: [PATCHSET cgroup/for-3.16] cgroup: implement cftype->write()
Message-ID: <20140513161701.GA1866@htj.dyndns.org>
References: <1399380266-3324-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399380266-3324-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 08:44:21AM -0400, Tejun Heo wrote:
> Hello,
> 
> This patchset implements a new cftype operation ->write() and replace
> ->write_string() and ->trigger() with it.  ->write() is similar to
> ->write_string() but maps directly to the kernfs write operation and
> has access to all available context information including the
> associated kernfs_open_file, which will make things like implementing
> kernfs active protection manipulation easier.
> 
> ->write_string() becomes redundant and ->trigger() has always been
> spurious.  This patch replaces all users of the two methods to
> ->write() and remove them.
> 
> This patchset contains the following five patches.
> 
>  0001-cgroup-implement-cftype-write.patch
>  0002-cgroup-replace-cftype-write_string-with-cftype-write.patch
>  0003-cgroup-replace-cftype-trigger-with-cftype-write.patch
>  0004-cgroup-convert-tasks-and-cgroup.procs-handle-to-use-.patch
>  0005-cgroup-remove-cgroup-control_kn.patch

Applied to cgroup/for-3.16.

Thanks.

-- 
tejun
