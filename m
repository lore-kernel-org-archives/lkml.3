Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759976AbaCTVCA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 17:02:00 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:51587 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759782AbaCTVB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 17:01:58 -0400
Date: Thu, 20 Mar 2014 23:58:05 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [PATCH] zram: include linux/err.h
Message-ID: <20140320205804.GA442@swordfish>
References: <201403151040.09139.arnd@arndb.de>
 <20140319013946.GF13475@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140319013946.GF13475@bbox>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (03/19/14 10:39), Minchan Kim wrote:
> On Sat, Mar 15, 2014 at 10:40:08AM +0100, Arnd Bergmann wrote:
> > The zram driver uses the ERR_PTR macro defined in <linux/err.h>
> > and relies on this header to be included implicitly through
> > other headers, which is not (always) the case on the ARM architecture.
> > 
> > Adding an explicit #include allows us to build the driver in
> > all configurations.
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> Regardless of resend fixing another part Sergey asked,
> 
> Acked-by: Minchan Kim <minchan@kernel.org>
> 

Andrew, could you please apply this one? I'll send a patch
to also include err.h in zram_drv shortly.

	-ss

> Thanks!
> 
> 
> -- 
> Kind regards,
> Minchan Kim
> 
