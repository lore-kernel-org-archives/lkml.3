Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbaGOPMY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 11:12:24 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:54938 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaGOPMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 11:12:18 -0400
Date: Tue, 15 Jul 2014 11:12:15 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: alloc struct worker on its local node
Message-ID: <20140715151215.GA19570@htj.dyndns.org>
References: <1405416264-11611-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405416264-11611-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 05:24:15PM +0800, Lai Jiangshan wrote:
> When the create_worker() is called from non-manager, the struct worker
> is allocated from the node of the caller which may be different from the
> node of pool->node.
> 
> So we add a node ID argument for the alloc_worker() to ensure the
> struct worker is allocated from the preferable node.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

I renamed @nid to @node as everything else in that file is using @node
for node id.

Applied to wq/for-3.17.

Thanks.

-- 
tejun
