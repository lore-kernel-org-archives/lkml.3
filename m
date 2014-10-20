Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbaJTJaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 05:30:20 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:54308 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbaJTJaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 05:30:17 -0400
X-Original-SENDERIP: 10.177.220.156
X-Original-MAILFROM: minchan@kernel.org
Date: Mon, 20 Oct 2014 18:30:34 +0900
From: Minchan Kim <minchan@kernel.org>
To: karam.lee@lge.com
Cc: ngupta@vflare.org, linux-kernel@vger.kernel.org,
        matthew.r.wilcox@intel.com, jmarchan@redhat.com, seungho1.park@lge.com
Subject: Re: [PATCH v2 1/3] zram: remove bio parameter from zram_bvec_rw().
Message-ID: <20141020093034.GA5330@bbox>
References: <1413190542-23960-1-git-send-email-karam.lee@lge.com>
 <1413190542-23960-2-git-send-email-karam.lee@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1413190542-23960-2-git-send-email-karam.lee@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2014 at 05:55:40PM +0900, karam.lee@lge.com wrote:
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

- 
Kind regards,
Minchan Kim
