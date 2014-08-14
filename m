Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbaHNA0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 20:26:46 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:42080 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbaHNA0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 20:26:45 -0400
X-Original-SENDERIP: 10.177.222.156
X-Original-MAILFROM: minchan@kernel.org
Date: Thu, 14 Aug 2014 09:26:54 +0900
From: Minchan Kim <minchan@kernel.org>
To: Chao Yu <chao2.yu@samsung.com>
Cc: ngupta@vflare.org, linux-kernel@vger.kernel.org,
        "'Jerome Marchand'" <jmarchan@redhat.com>,
        "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] zram: fix incorrectly stat with failed_reads
Message-ID: <20140814002654.GH9227@bbox>
References: <009001cfb69a$a8470840$f8d518c0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <009001cfb69a$a8470840$f8d518c0$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 10:01:45AM +0800, Chao Yu wrote:
> Since we allocate a temporary buffer in zram_bvec_read to handle partial page
> operations in this commit 924bd88d703e53d30f393fac6117f8f1bc79aab6 (Staging:
> zram: allow partial page operations), our ->failed_reads value may be incorrect
> as we do not increase its value when failed to allocate the temporary buffer.
> 
> Let's fix this issue and correct the annotation of failed_reads.
> 
>  v2: clean codes of failed_{reads,writes} stat pointed out by Minchan Kim, and
> this cleanup also fix incorrectly stat when fail in zram_decompress_page.
> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>

Acked-by: Minchan Kim <minchan@kernel.org>

Thanks!

-- 
Kind regards,
Minchan Kim
