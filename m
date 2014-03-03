Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbaCCWb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 17:31:26 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:57193 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbaCCWbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 17:31:24 -0500
Date: Mon, 3 Mar 2014 17:31:19 -0500
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] cpuset: use rcu_read_lock() to protect task_cs()
Message-ID: <20140303223119.GA26523@mtj.dyndns.org>
References: <53144223.6000302@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53144223.6000302@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2014 at 04:49:39PM +0800, Li Zefan wrote:
> We no longer use task_lock() to protect tsk->cgroups.
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied to for-3.15 (do we need this for 3.14-fixes?).

Thanks.

-- 
tejun
