Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbaEVPkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 11:40:06 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:63261 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbaEVPkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 11:40:01 -0400
Date: Thu, 22 May 2014 11:39:57 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: rename first_worker() to first_idle_worker()
Message-ID: <20140522153957.GE5065@htj.dyndns.org>
References: <1400748247-14131-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400748247-14131-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 04:44:07PM +0800, Lai Jiangshan wrote:
> first_worker() actually returns the first idle workers, the name
> first_idle_worker() which is self-commnet will be better.
> 
> All the callers of first_worker() expect it returns an idle worker,
> the name first_idle_worker() with "idle" notation makes reviewers happier.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Applied to wq/for-3.16.

Thanks.

-- 
tejun
