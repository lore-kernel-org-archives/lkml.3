Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751766Ab3JUTMO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 15:12:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39062 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab3JUTMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 15:12:13 -0400
Date: Mon, 21 Oct 2013 13:12:11 -0600
From: Jens Axboe <axboe@kernel.dk>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] blk-mq: zero out ctx_map during initialization
Message-ID: <20131021191211.GA14598@kernel.dk>
References: <x491u3ecxs0.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x491u3ecxs0.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21 2013, Jeff Moyer wrote:
> Hi,
> 
> ctx_map may contain random garbage, leading to (potentially chronic but
> harmless) false positives in blk_mq_hctx_has_pending.
> 
> Note: I have not observed this in practice, just by code inspection.

It's the prudent thing to do in any case. Applied.

-- 
Jens Axboe

