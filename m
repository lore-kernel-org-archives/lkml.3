Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab3A1WmF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 17:42:05 -0500
Received: from relay1.sgi.com ([192.48.179.29]:37479 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754838Ab3A1WmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 17:42:04 -0500
Date: Mon, 28 Jan 2013 16:42:02 -0600
From: Ben Myers <bpm@sgi.com>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH]xfs: Fix xfs_swap_extents() after removal of
 xfs_flushinval_pages()
Message-ID: <20130128224202.GE27055@sgi.com>
References: <20130120102449.397b3f8b@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130120102449.397b3f8b@googlemail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 10:24:49AM +0100, Torsten Kaiser wrote:
> From: Torsten Kaiser <just.for.lkml@googlemail.com>
> 
> Commit fb59581404ab7ec5075299065c22cb211a9262a9 removed
> xfs_flushinval_pages() and changed its callers to use
> filemap_write_and_wait() and  truncate_pagecache_range() directly.
> 
> But in xfs_swap_extents() this change accidental switched the argument
> for 'tip' to 'ip'. This patch switches it back to 'tip'
> 
> Signed-off-by: Torsten Kaiser <just.for.lkml@googlemail.com>

Looks good.
Reviewed-by: Ben Myers <bpm@sgi.com>

Thanks Torsten!
