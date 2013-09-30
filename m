Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab3I3VBu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 17:01:50 -0400
Received: from one.firstfloor.org ([193.170.194.197]:53753 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663Ab3I3VBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 17:01:49 -0400
Date: Mon, 30 Sep 2013 23:01:47 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Eric Wong <normalperson@yhbt.net>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 09/11] epoll: Remove unnecessary error path
Message-ID: <20130930210147.GD6931@two.firstfloor.org>
References: <1380572952-30729-1-git-send-email-andi@firstfloor.org>
 <1380572952-30729-10-git-send-email-andi@firstfloor.org>
 <20130930205906.GA13646@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130930205906.GA13646@dcvr.yhbt.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > @@ -1276,15 +1276,6 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
> >  	 */
> >  	revents = ep_item_poll(epi, &epq.pt);
> 
> ep_item_poll calls f_op->poll, which calls poll_wait().
> poll_wait() will call ep_ptable_queue_proc.

Thanks. Good point.
-Andi
