Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112AbaGAVlM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 17:41:12 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:45715 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbaGAVlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 17:41:10 -0400
Date: Tue, 1 Jul 2014 17:41:06 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org,
        "Jason J. Herne" <jjherne@linux.vnet.ibm.com>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH 2/2] workqueue: stronger test in process_one_work()
Message-ID: <20140701214106.GJ12459@htj.dyndns.org>
References: <1401780809-12331-1-git-send-email-laijs@cn.fujitsu.com>
 <1401780809-12331-2-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401780809-12331-2-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 03:33:28PM +0800, Lai Jiangshan wrote:
> When POOL_DISASSOCIATED is cleared, the running worker's local CPU should
> be the same as pool->cpu without any exception even during cpu-hotplug.
> 
> This fix changes "(proposition_A && proposition_B && proposition_C)"
> to "(proposition_B && proposition_C)", so if the old compound proposition
> is true, the new one must be true too. so this fix will not hide any
> possible bug which can be hit by old test.
> 
> CC: Jason J. Herne <jjherne@linux.vnet.ibm.com>
> CC: Sasha Levin <sasha.levin@oracle.com>
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Oops, thought I applied them.

Applied to wq/for-3.17 w/ minor updates.

Thanks.

-- 
tejun
