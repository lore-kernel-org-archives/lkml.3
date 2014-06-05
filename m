Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbaFEBWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 21:22:32 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:64544 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbaFEBWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 21:22:31 -0400
Date: Wed, 4 Jun 2014 21:22:27 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v2] cgroup: don't destroy the default root
Message-ID: <20140605012227.GC14370@mtj.dyndns.org>
References: <538EDD4F.9010403@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538EDD4F.9010403@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 04:48:15PM +0800, Li Zefan wrote:
> The default root is allocated and initialized at boot phase, so we
> shouldn't destroy the default root when it's umounted, otherwise
> it will lead to disaster.
> 
> Just try mount and then umount the default root, and the kernel will
> crash immediately.
> 
> v2:
> - No need to check for CSS_NO_REF in cgroup_get/put(). (Tejun)
> - Better call cgroup_put() for the default root in kill_sb(). (Tejun)
> - Add a comment.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.16.

Thanks.

-- 
tejun
