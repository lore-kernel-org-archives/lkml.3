Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284AbaJVH1i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 03:27:38 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:55494 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbaJVH1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 03:27:37 -0400
X-Original-SENDERIP: 10.177.220.156
X-Original-MAILFROM: minchan@kernel.org
Date: Wed, 22 Oct 2014 16:28:01 +0900
From: Minchan Kim <minchan@kernel.org>
To: karam.lee@lge.com
Cc: ngupta@vflare.org, linux-kernel@vger.kernel.org,
        matthew.r.wilcox@intel.com, jmarchan@redhat.com, seungho1.park@lge.com
Subject: Re: [PATCH v4 1/3] zram: remove bio parameter from zram_bvec_rw().
Message-ID: <20141022072801.GF21620@bbox>
References: <1413961454-13479-1-git-send-email-karam.lee@lge.com>
 <1413961454-13479-2-git-send-email-karam.lee@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1413961454-13479-2-git-send-email-karam.lee@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 04:04:12PM +0900, karam.lee@lge.com wrote:
> From: "karam.lee" <karam.lee@lge.com>
> 
> This patch removes an unnecessary parameter(bio)
> from zram_bvec_rw() and zram_bvec_read().
> zram_bvec_read() doesn't use a bio parameter, so remove it.
> zram_bvec_rw() calls a read/write operation not using bio, so a rw parameter
> replaces a bio parameter.
> 
> Signed-off-by: karam.lee <karam.lee@lge.com>
Acked-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
