Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab3LSPb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:31:59 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55691 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab3LSPb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:31:57 -0500
Date: Thu, 19 Dec 2013 08:31:54 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3 v2] Use lockless lists for smp_call_function_single()
Message-ID: <20131219153154.GI30200@kernel.dk>
References: <1387387418-10005-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387387418-10005-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18 2013, Jan Kara wrote:
>   Hello,
> 
>   these three patches make smp_call_function_single() use lockless lists and
> cleanup abuse of csd.list in the block layer. I have some use for lockless
> smp_call_function_single() in printk code and that's why I've picked up
> Christoph's patch. Jens, can you have a look at the series please?
> 
> Changes since v1:
> * Reordered patches to a more sensible order.

Thanks Jan, I'll throw this into the testing mix for 3.14. Will be a
little delayed over christmas, with holidays and family visiting.

-- 
Jens Axboe

