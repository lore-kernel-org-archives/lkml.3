Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab3LSPLE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:11:04 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55061 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926Ab3LSPLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:11:01 -0500
Date: Thu, 19 Dec 2013 08:10:58 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Matias Bjorling <m@bjorling.me>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] null_blk: documentation, refactor and warning
Message-ID: <20131219151058.GE30200@kernel.dk>
References: <1387370504-30853-1-git-send-email-m@bjorling.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387370504-30853-1-git-send-email-m@bjorling.me>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18 2013, Matias Bjorling wrote:
> Hi Jens,
> 
> I took the liberty to write up some documentation for the blk_null driver.
> 
> Additionally, factored the init code paths to use the standard error return
> codes. Shuffled some code to aid sharing between the block-layer instantiations.
> And at last added a warning when submit_queues parameter is ignored.

Thanks Matias, applied! We still need a patch to not default to per-node
hctx, though. And to be more clever when submit_queues is given and
per-node is true.

-- 
Jens Axboe

