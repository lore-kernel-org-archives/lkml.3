Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261AbaJVH1z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 03:27:55 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:52653 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076AbaJVH1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 03:27:54 -0400
X-Original-SENDERIP: 10.177.220.156
X-Original-MAILFROM: minchan@kernel.org
Date: Wed, 22 Oct 2014 16:28:13 +0900
From: Minchan Kim <minchan@kernel.org>
To: karam.lee@lge.com
Cc: ngupta@vflare.org, linux-kernel@vger.kernel.org,
        matthew.r.wilcox@intel.com, jmarchan@redhat.com, seungho1.park@lge.com
Subject: Re: [PATCH v4 2/3] zram: change parameter from vaild_io_request()
Message-ID: <20141022072813.GG21620@bbox>
References: <1413961454-13479-1-git-send-email-karam.lee@lge.com>
 <1413961454-13479-3-git-send-email-karam.lee@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1413961454-13479-3-git-send-email-karam.lee@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 04:04:13PM +0900, karam.lee@lge.com wrote:
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
