Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624AbaLKTPs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 14:15:48 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:55643 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739AbaLKTPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 14:15:46 -0500
Date: Thu, 11 Dec 2014 14:15:38 -0500 (EST)
Message-Id: <20141211.141538.912268168491944997.davem@davemloft.net>
To: brouer@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cl@linux.com, linux-api@vger.kernel.org, eric.dumazet@gmail.com,
        hannes@stressinduktion.org, alexander.duyck@gmail.com,
        ast@plumgrid.com, paulmck@linux.vnet.ibm.com,
        mathieu.desnoyers@efficios.com, rostedt@goodmis.org
Subject: Re: [RFC PATCH 1/3] lib: adding an Array-based Lock-Free (ALF)
 queue
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141210141512.31779.96487.stgit@dragon>
References: <20141210141332.31779.56391.stgit@dragon>
	<20141210141512.31779.96487.stgit@dragon>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 11 Dec 2014 11:15:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Wed, 10 Dec 2014 15:15:26 +0100

> +static inline int
> +alf_mp_enqueue(const u32 n;
> +	       struct alf_queue *q, void *ptr[n], const u32 n)
> +{
 ...
> +/* Main Multi-Consumer DEQUEUE */
> +static inline int
> +alf_mc_dequeue(const u32 n;
> +	       struct alf_queue *q, void *ptr[n], const u32 n)
> +{

I would seriously consider not inlining these.
