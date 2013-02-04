Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab3BDNMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 08:12:16 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50010 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277Ab3BDNMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 08:12:14 -0500
Date: Mon, 4 Feb 2013 14:11:08 +0100
From: Jens Axboe <axboe@kernel.dk>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, bfields@fieldses.org, skinsbursky@parallels.com,
        ebiederm@xmission.com, jmorris@namei.org
Subject: Re: [PATCH 08/62] block/loop: convert to idr_alloc()
Message-ID: <20130204131108.GT10105@kernel.dk>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
 <1359854463-2538-9-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359854463-2538-9-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02 2013, Tejun Heo wrote:
> Convert to the much saner new idr interface.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> ---
> This patch depends on an earlier idr changes and I think it would be
> best to route these together through -mm.  Please holler if there's
> any objection.  Thanks.

Acked-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

