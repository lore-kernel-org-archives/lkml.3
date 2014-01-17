Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbaAQGxz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 01:53:55 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:63902 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbaAQGxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 01:53:52 -0500
X-AuditID: 9c93017d-b7b51ae000000e33-c5-52d8d37fddb2
Date: Fri, 17 Jan 2014 15:54:47 +0900
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 5/8] zram: remove zram stats code duplication
Message-ID: <20140117065447.GI26602@bbox>
References: <1389877936-15543-1-git-send-email-sergey.senozhatsky@gmail.com>
 <1389877936-15543-6-git-send-email-sergey.senozhatsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389877936-15543-6-git-send-email-sergey.senozhatsky@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 04:12:13PM +0300, Sergey Senozhatsky wrote:
> Introduce ZRAM_ATTR_RO macro that generates device_attribute
> and default ATTR show() function for existing atomic64_t zram
> stats.
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
