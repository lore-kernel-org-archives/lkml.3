Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933281AbaHYOul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 10:50:41 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:52015 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932911AbaHYOui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 10:50:38 -0400
Date: Mon, 25 Aug 2014 10:50:35 -0400
From: Tejun Heo <tj@kernel.org>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup: fix a typo in comment.
Message-ID: <20140825145035.GB21688@htj.dyndns.org>
References: <1408966072-2142-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408966072-2142-1-git-send-email-yangds.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 07:27:52PM +0800, Dongsheng Yang wrote:
> There is no function named cgroup_enable_task_cg_links().
> Instead, the correct function name in this comment should
> be cgroup_enabled_task_cg_lists().
> 
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>

Applied to cgroup/for-3.18.

Thanks.

-- 
tejun
