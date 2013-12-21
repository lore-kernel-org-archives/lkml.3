Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab3LUQaE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 11:30:04 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51442 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063Ab3LUQaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 11:30:02 -0500
Date: Sat, 21 Dec 2013 09:30:00 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Matias Bjorling <m@bjorling.me>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] null_blk: documentation, defaults and mapping
Message-ID: <20131221163000.GE13340@kernel.dk>
References: <1387581061-25987-1-git-send-email-m@bjorling.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387581061-25987-1-git-send-email-m@bjorling.me>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 21 2013, Matias Bjorling wrote:
> Hi,
> 
> These three patches cover:
> 
> * Incorporated the feedback from Randy Dunlap into documentation.
>   Can be merged with the previous documentation commit (6824518).
> * Set use_per_node_hctx to false per default to save resources.
> * Allow submit_queues and use_per_node_hctx to be used simultanesly.
>   If the submit_queues is a multiple of nr_online_nodes, its trivial. Simply map
>   them to the nodes. For example: 8 submit queues are mapped as node0[0,1],
>   node1[2,3], ...
>   If uneven, we are left with an uneven number of submit_queues that must be
>   mapped. These are mapped toward the first node and onward. E.g. 5
>   submit queues mapped onto 4 nodes are mapped as node0[0,1], node1[2], ...

Thanks, applied.

-- 
Jens Axboe

