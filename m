Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbaJTJbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 05:31:38 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:57226 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbaJTJbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 05:31:37 -0400
X-Original-SENDERIP: 10.177.220.156
X-Original-MAILFROM: minchan@kernel.org
Date: Mon, 20 Oct 2014 18:31:49 +0900
From: Minchan Kim <minchan@kernel.org>
To: karam.lee@lge.com
Cc: ngupta@vflare.org, linux-kernel@vger.kernel.org,
        matthew.r.wilcox@intel.com, jmarchan@redhat.com, seungho1.park@lge.com
Subject: Re: [PATCH v2 2/3] zram: change parameter from vaild_io_request()
Message-ID: <20141020093149.GB5330@bbox>
References: <1413190542-23960-1-git-send-email-karam.lee@lge.com>
 <1413190542-23960-3-git-send-email-karam.lee@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1413190542-23960-3-git-send-email-karam.lee@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2014 at 05:55:41PM +0900, karam.lee@lge.com wrote:
> From: "karam.lee" <karam.lee@lge.com>
> 
> This patch changes parameter of valid_io_request for common usage.
> The purpose of valid_io_request() is to determine if bio request is
> valid or not.
> This patch use  I/O start address and size instead of a BIO parameter
> for common usage.
> 
> Signed-off-by: karam.lee <karam.lee@lge.com>
Acked-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
