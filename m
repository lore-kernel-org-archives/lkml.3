Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513AbaDQPaC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:30:02 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:57347 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbaDQP3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:29:38 -0400
Date: Thu, 17 Apr 2014 11:29:32 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: add __WQ_FREEZING and remove POOL_FREEZING
Message-ID: <20140417152932.GN15326@htj.dyndns.org>
References: <20130421012925.GA19097@mtj.dyndns.org>
 <1395741364-19489-1-git-send-email-laijs@cn.fujitsu.com>
 <20140416195109.GD22569@htj.dyndns.org>
 <534F193F.2070600@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534F193F.2070600@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 07:58:55AM +0800, Lai Jiangshan wrote:
> > Why are we removing the above?  Can't we still test __WQ_FREEZING as
> > we're holding wq->mutex?  I don't really mind removing the
> > optimization but the patch description at least has to explain what's
> > going on.
> 
> This part was in other old patch: https://lkml.org/lkml/2013/4/3/756
> I admit the changelogs(old patch&this) are bad.
> But I still consider it would be better if we split it to two patches:
> (https://lkml.org/lkml/2013/4/3/748 & https://lkml.org/lkml/2013/4/3/756)
> 
> There are different aims in the patches.
> 
> Any thinks? And sorry for I didn't keep to push the patches at that time.

Yeah, I think I like the changes.  Please split them and send with
proper descriptions.

Thanks.

-- 
tejun
