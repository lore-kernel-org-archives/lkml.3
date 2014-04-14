Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788AbaDNVpc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:45:32 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:38754 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755108AbaDNVp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:45:29 -0400
Date: Mon, 14 Apr 2014 17:45:26 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-3.16] cgroup: implement unified hierarchy,
 v2
Message-ID: <20140414214526.GC1863@htj.dyndns.org>
References: <1397511430-2673-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397511430-2673-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 05:36:58PM -0400, Tejun Heo wrote:
> The patchset is on top of cgroup/for-3.15 01a971406177 ("cgroup: Use
> RCU_INIT_POINTER(x, NULL) in cgroup.c") and also available in the
> following git branch.

Oops, obviously, the patchset is on top of

 v3.15-rc1 c9eaa447e77e ("Linux 3.15-rc1")

Thanks.

-- 
tejun
