Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296AbaISRAZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 13:00:25 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:51898 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756002AbaISRAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 13:00:23 -0400
Date: Fri, 19 Sep 2014 10:00:20 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: linux-mtd@lists.infradead.org, Rashika Kheria <rashika.kheria@gmail.com>,
        linux-kernel@vger.kernel.org, Huang Shijie <shijie8@gmail.com>,
        Jiri Kosina <trivial@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "grmoore@altera.com" <grmoore@altera.com>,
        Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH v3 0/7] mtd: denali: A collection of trivial coding style
 fixes
Message-ID: <20140919170020.GF1193@ld-irv-0074>
References: <1410865465-17941-1-git-send-email-yamada.m@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410865465-17941-1-git-send-email-yamada.m@jp.panasonic.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 08:04:18PM +0900, Masahiro Yamada wrote:
> 
> 
> Masahiro Yamada (7):
>   mtd: denali: fix the format of comment blocks
>   mtd: denali: remove unnecessary variable initializations
>   mtd: denali: remove unnecessary casts
>   mtd: denali: change the type of iterators to int

I already merged these 4.

>   mtd: denali: remove a set-but-unused variable

This one was merged but you changed it (and falsely kept the
'Reviewed-by' tag). So I split it out into its own patch and dropped the
'Reviewed-by'.

>   mtd: denali: remove unnecessary parentheses
>   mtd: denali: fix indents and other trivial things

Applied a modified version of the last three, to l2-mtd.git. Feel free
to check my work, but git tells me that the end result is identical.

>  drivers/mtd/nand/denali.c | 558 +++++++++++++++++++++++++---------------------
>  1 file changed, 301 insertions(+), 257 deletions(-)
> 

Brian
