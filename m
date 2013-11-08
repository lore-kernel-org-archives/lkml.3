Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543Ab3KHFzn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 00:55:43 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:42996 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728Ab3KHFzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 00:55:42 -0500
X-AuditID: 9c93017d-b7b56ae0000066c1-8b-527c7cdc0c06
Date: Fri, 8 Nov 2013 14:55:40 +0900
From: Minchan Kim <minchan@kernel.org>
To: Phillip Lougher <phillip@squashfs.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] Squashfs: restructure squashfs_readpage()
Message-ID: <20131108055540.GB4038@bbox>
References: <1383855865-4683-1-git-send-email-phillip@squashfs.org.uk>
 <1383855865-4683-6-git-send-email-phillip@squashfs.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383855865-4683-6-git-send-email-phillip@squashfs.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 08:24:24PM +0000, Phillip Lougher wrote:
> Restructure squashfs_readpage() splitting it into separate
> functions for datablocks, fragments and sparse blocks.
> 
> Move the memcpying (from squashfs cache entry) implementation of
> squashfs_readpage_block into file_cache.c
> 
> This allows different implementations to be supported.
> 
> Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Reviewed-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
