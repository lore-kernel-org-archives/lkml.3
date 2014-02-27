Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbaB0OlG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 09:41:06 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:49639 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaB0OlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 09:41:04 -0500
Date: Thu, 27 Feb 2014 09:40:56 -0500
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 2/2] cpuset: fix a race condition in
 __cpuset_node_allowed_softwall()
Message-ID: <20140227144056.GB19178@htj.dyndns.org>
References: <530F1117.1020605@huawei.com>
 <530F1138.2090903@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530F1138.2090903@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 06:19:36PM +0800, Li Zefan wrote:
> It's not safe to access task's cpuset after releasing task_lock().
> Holding callback_mutex won't help.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.14-fixes.

Thanks.

-- 
tejun
