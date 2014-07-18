Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762667AbaGRW5X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 18:57:23 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:52958 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873AbaGRW5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 18:57:21 -0400
Date: Fri, 18 Jul 2014 18:57:18 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1 V2] workqueue: unfold start_worker() into
 create_worker()
Message-ID: <20140718225718.GE5739@htj.dyndns.org>
References: <1405008074-11031-1-git-send-email-laijs@cn.fujitsu.com>
 <1405310716-12270-1-git-send-email-laijs@cn.fujitsu.com>
 <1405310716-12270-2-git-send-email-laijs@cn.fujitsu.com>
 <53C5D557.8040702@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C5D557.8040702@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry about the delay.

On Wed, Jul 16, 2014 at 09:28:55AM +0800, Lai Jiangshan wrote:
> On 07/14/2014 12:05 PM, Lai Jiangshan wrote:
> > Simply unfold the code of start_worker() into create_worker() and
> > remove the original start_worker() and create_and_start_worker().
> > 
> > The only trade-off is the introduced overhead that the pool->lock
> > is released and re-grabbed after the newly worker is started.
> > The overhead is acceptable since the manager is slow path.
> 
> Hi, TJ
> 
> Will you accept this trade-off and the patch?
> If so, I will rebase this patch without any dependence on other patch.

Yeap, that's fine.

Thanks!

-- 
tejun
