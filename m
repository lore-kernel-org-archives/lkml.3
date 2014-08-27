Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936141AbaH0XJM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 19:09:12 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:45326 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935728AbaH0XJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 19:09:10 -0400
MIME-Version: 1.0
In-Reply-To: <20140827214706.GO2663@linux.vnet.ibm.com>
References: <1409172220-2804-1-git-send-email-bobby.prani@gmail.com> <20140827214706.GO2663@linux.vnet.ibm.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Wed, 27 Aug 2014 19:08:37 -0400
Message-ID: <CAJhHMCB2bCYXkE6yrygKx=k46n4SN+iDtJR+N14CcYu5LRFLEQ@mail.gmail.com>
Subject: Re: [PATCH] rcu: Make nocb leader kthreads process pending callbacks
 after spawning
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>,
        Amit Shah <amit.shah@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 5:47 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>
> Thank you, Pranith, queued.  I have also backported to v3.17-rc2,
> and am testing both.  A sneak preview of the backport is shown below,
> please let me know if you see any problems with it.  (The reason for
> the backport is to submit to 3.17 as a fix for a regression.)
>

Looks good to me!

--
Pranith
