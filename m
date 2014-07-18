Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762553AbaGRWqp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 18:46:45 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:62071 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756571AbaGRWqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 18:46:44 -0400
Date: Fri, 18 Jul 2014 18:46:41 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: wake regular worker if need_more_worker()
 when rescuer leave the pool
Message-ID: <20140718224641.GA5739@htj.dyndns.org>
References: <1405493796-26169-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405493796-26169-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 02:56:36PM +0800, Lai Jiangshan wrote:
> We don't need to wake up regular worker when nr_running==1,
> so need_more_worker() is sufficient here.
> 
> And need_more_worker() gives us better readability due to the name of
> "keep_working()" implies the rescuer should keep working now but
> the rescuer is actually leaving.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Applied to wq/for-3.17.

Thanks.

-- 
tejun
