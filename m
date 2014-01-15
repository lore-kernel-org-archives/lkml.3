Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbaAOBve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 20:51:34 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:65242 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbaAOBvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 20:51:31 -0500
X-AuditID: 9c93016f-b7b1aae000000f15-59-52d5e9a17084
Date: Wed, 15 Jan 2014 10:52:17 +0900
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] zram: drop `init_done' struct zram member
Message-ID: <20140115015217.GG1992@bbox>
References: <1389692260-4421-1-git-send-email-sergey.senozhatsky@gmail.com>
 <1389692260-4421-2-git-send-email-sergey.senozhatsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389692260-4421-2-git-send-email-sergey.senozhatsky@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 12:37:38PM +0300, Sergey Senozhatsky wrote:
> Introduce init_done() helper function which allows us to drop
> `init_done' struct zram member. init_done() uses the fact that
> ->init_done == 1 equals to ->meta != NULL.
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
