Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbaGVPjJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 11:39:09 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:62319 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbaGVPjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 11:39:06 -0400
Date: Tue, 22 Jul 2014 11:39:02 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: use nr_node_ids instead of wq_numa_tbl_len
Message-ID: <20140722153902.GI13851@htj.dyndns.org>
References: <1406005540-12174-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406005540-12174-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 01:05:40PM +0800, Lai Jiangshan wrote:
> They are the same and nr_node_ids is provided by the memory subsystem.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Applied to wq/for-3.17.

Thanks.

-- 
tejun
