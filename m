Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab3BRRcY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 12:32:24 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:39119 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756484Ab3BRRcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 12:32:22 -0500
Date: Mon, 18 Feb 2013 09:32:18 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH] cgroup: fail if monitored file and event_control are in
 different cgroup
Message-ID: <20130218173218.GH17414@htj.dyndns.org>
References: <5121C68F.1000309@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5121C68F.1000309@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2013 at 02:13:35PM +0800, Li Zefan wrote:
> If we pass fd of memory.usage_in_bytes of cgroup A to cgroup.event_control
> of cgroup B, then we won't get memory usage notification from A but B!
> 
> What's worse, if A and B are in different mount hierarchy, we'll end up
> accessing NULL pointer!
> 
> Disallow this kind of invalid usage.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.9.

Thanks.

-- 
tejun
