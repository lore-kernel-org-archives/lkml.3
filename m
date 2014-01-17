Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178AbaAQGtQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 01:49:16 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51400 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbaAQGrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 01:47:43 -0500
X-AuditID: 9c930179-b7c84ae000000e38-42-52d8d20d4678
Date: Fri, 17 Jan 2014 15:48:36 +0900
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 3/8] zram: remove good and bad compress stats
Message-ID: <20140117064836.GG26602@bbox>
References: <1389877936-15543-1-git-send-email-sergey.senozhatsky@gmail.com>
 <1389877936-15543-4-git-send-email-sergey.senozhatsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389877936-15543-4-git-send-email-sergey.senozhatsky@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 04:12:11PM +0300, Sergey Senozhatsky wrote:
> Remove `good' and `bad' compressed sub-requests stats. RW request may
> cause a number of RW sub-requests. zram used to account `good' compressed
> sub-queries (with compressed size less than 50% of original size), `bad'
> compressed sub-queries (with compressed size greater that 75% of original
> size), leaving sub-requests with compression size between 50% and 75% of
> original size not accounted and not reported. zram already accounts each
> sub-request's compression size so we can calculate real device compression
> ratio.
> 

Most important thing is that we have accounted them but have not used
so it doesn't break anything and we could add them again if someone need them
later. :)

> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

Acked-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
