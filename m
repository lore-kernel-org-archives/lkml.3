Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbaAPA57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 19:57:59 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:59271 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbaAPA5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 19:57:55 -0500
X-AuditID: 9c93016f-b7b1aae000000f15-f3-52d72e912aa3
Date: Thu, 16 Jan 2014 09:58:44 +0900
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 4/4] zram: report failed read and writes stats
Message-ID: <20140116005844.GN1992@bbox>
References: <1389780977-18949-1-git-send-email-sergey.senozhatsky@gmail.com>
 <1389780977-18949-5-git-send-email-sergey.senozhatsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389780977-18949-5-git-send-email-sergey.senozhatsky@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 01:16:17PM +0300, Sergey Senozhatsky wrote:
> zram accounted but did not report numbers of failed read
> and write queries. make these stats available as failed_reads
> and failed_writes attrs.
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
