Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbaJZBly (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 21:41:54 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:53407 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbaJZBlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 21:41:53 -0400
Date: Sun, 26 Oct 2014 10:41:43 +0900
From: Minchan Kim <minchan@kernel.org>
To: Weijie Yang <weijie.yang@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Dan Streetman'" <ddstreet@ieee.org>,
        "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Nitin Gupta'" <ngupta@vflare.org>, "'Linux-MM'" <linux-mm@kvack.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Weijie Yang'" <weijie.yang.kh@gmail.com>
Subject: Re: [PATCH 1/2] zram: make max_used_pages reset work correctly
Message-ID: <20141026014143.GA3328@gmail.com>
References: <000001cff035$c060dc60$41229520$%yang@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001cff035$c060dc60$41229520$%yang@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Oct 25, 2014 at 05:25:11PM +0800, Weijie Yang wrote:
> The commit 461a8eee6a ("zram: report maximum used memory") introduces a new
> knob "mem_used_max" in zram.stats sysfs, and wants to reset it via write 0
> to the sysfs interface.
> 
> However, the current code cann't reset it correctly, so let's fix it.

We wanted to reset it to current used total memory, not 0.

-- 
Kind regards,
Minchan Kim
