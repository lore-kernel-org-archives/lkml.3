Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726Ab3KSIKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 03:10:10 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:42719 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab3KSIKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 03:10:05 -0500
X-AuditID: 9c93017d-b7b24ae000002834-0e-528b1cdb2257
Date: Tue, 19 Nov 2013 17:10:29 +0900
From: Minchan Kim <minchan@kernel.org>
To: Phillip Lougher <phillip@squashfs.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] Squashfs: Generalise paging handling in the
 decompressors (V3)
Message-ID: <20131119081029.GW4407@bbox>
References: <1384406059-28567-1-git-send-email-phillip@squashfs.org.uk>
 <1384406059-28567-3-git-send-email-phillip@squashfs.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384406059-28567-3-git-send-email-phillip@squashfs.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 05:14:17AM +0000, Phillip Lougher wrote:
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
> V3: slightly optimise code in page_actor.h
> 
> Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Reviewed-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
