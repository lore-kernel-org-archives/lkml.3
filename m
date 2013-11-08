Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab3KHF37 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 00:29:59 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:57473 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab3KHF34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 00:29:56 -0500
X-AuditID: 9c93017e-b7c9fae00000057d-94-527c76d3e6ae
Date: Fri, 8 Nov 2013 14:29:55 +0900
From: Minchan Kim <minchan@kernel.org>
To: Phillip Lougher <phillip@squashfs.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] Squashfs: Generalise paging handling in the
 decompressors (V2)
Message-ID: <20131108052955.GA4038@bbox>
References: <1383855865-4683-1-git-send-email-phillip@squashfs.org.uk>
 <1383855865-4683-5-git-send-email-phillip@squashfs.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383855865-4683-5-git-send-email-phillip@squashfs.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 08:24:23PM +0000, Phillip Lougher wrote:
> Further generalise the decompressors by adding a page handler
> abstraction.  This adds helpers to allow the decompressors
> to access and process the output buffers in an implementation
> independant manner.
> 
> This allows different types of output buffer to be passed
> to the decompressors, with the implementation specific
> aspects handled at decompression time, but without the
> knowledge being held in the decompressor wrapper code.
> 
> This will allow the decompressors to handle Squashfs
> cache buffers, and page cache pages.
> 
> This patch adds the abstraction and an implementation for
> the caches.
> 
> V2: also update the code in decompressor_multi*.c

Thanks!

> 
> Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Reviewed-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
