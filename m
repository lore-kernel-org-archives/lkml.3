Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab3CKQZA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 12:25:00 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:41612 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab3CKQY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 12:24:58 -0400
Date: Mon, 11 Mar 2013 09:24:54 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH wq/for-3.9-fixes] workqueue: fix possible pool stall bug
 in wq_unbind_fn()
Message-ID: <20130311162454.GM24522@htj.dyndns.org>
References: <1362239729-6753-1-git-send-email-laijs@cn.fujitsu.com>
 <20130308231517.GS14556@mtj.dyndns.org>
 <513E01CB.7060103@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513E01CB.7060103@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Lai.

On Tue, Mar 12, 2013 at 12:09:47AM +0800, Lai Jiangshan wrote:
> Hi, Tejun,
> 
> Forgot to send a pull-request?
> Add CC Linus.

Ummm... I (and maintainers in general) don't send pull-request
whenever I queue a fix patch.  I usually let them sit in the tree for
some weeks before sending a pull-request to Linus, so that the fixes
get some exposure in -next and more of them can be aggregated.  As
workqueue is seeing high level of activity these days, it's likely
that we'll see more fixes coming out of it, and your fix while marked
for -stable isn't that urgent, so I'm gonna wait for some more weeks
before sending out pull request to Linus.

Thanks for checking tho.

-- 
tejun
