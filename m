Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716Ab3KSIR4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 03:17:56 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:52397 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab3KSIRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 03:17:55 -0500
X-AuditID: 9c93017e-b7ba2ae00000088c-10-528b1eb28657
Date: Tue, 19 Nov 2013 17:18:20 +0900
From: Minchan Kim <minchan@kernel.org>
To: Phillip Lougher <phillip@squashfs.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] Squashfs: Check stream is not NULL in
 decompressor_multi.c
Message-ID: <20131119081820.GY4407@bbox>
References: <1384406059-28567-1-git-send-email-phillip@squashfs.org.uk>
 <1384406059-28567-5-git-send-email-phillip@squashfs.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384406059-28567-5-git-send-email-phillip@squashfs.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 05:14:19AM +0000, Phillip Lougher wrote:
> Fix static checker complaint that stream is not checked in
> squashfs_decompressor_destroy().
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>

Thanks for handling my fault.

Reviewd-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
