Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933217AbaIPAgo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 20:36:44 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:61430 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932918AbaIPAgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 20:36:41 -0400
Date: Mon, 15 Sep 2014 17:36:20 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: linux-mtd@lists.infradead.org, Rashika Kheria <rashika.kheria@gmail.com>,
        linux-kernel@vger.kernel.org, Huang Shijie <shijie8@gmail.com>,
        Jiri Kosina <trivial@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "grmoore@altera.com" <grmoore@altera.com>,
        Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH v2 0/7] mtd: denali: A collection of trivial coding style
 fixes
Message-ID: <20140916003620.GA1193@ld-irv-0074>
References: <1410228117-14820-1-git-send-email-yamada.m@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1410228117-14820-1-git-send-email-yamada.m@jp.panasonic.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 11:01:50AM +0900, Masahiro Yamada wrote:
> Changes in v2:
>   - Join quotes strings into a single line
> 
> Masahiro Yamada (7):
>   mtd: denali: fix the format of comment blocks
>   mtd: denali: remove unnecessary variable initializations
>   mtd: denali: remove unnecessary casts
>   mtd: denali: change the type of iterators to int
>   mtd: denali: remove a set-but-unused variable
>   mtd: denali: remove unnecessary parentheses
>   mtd: denali: fix indents and other trivial things
> 
>  drivers/mtd/nand/denali.c | 562 +++++++++++++++++++++++++---------------------
>  1 file changed, 303 insertions(+), 259 deletions(-)

Pushed patches 1 to 5 to l2-mtd.git. Thanks!

Patch 6 has a conflict with another fix already in l2-mtd.git. Can you
rebase and resend?

BTW, my automatic build tests show that there's at least one other
'unused' warning left, in case you want to tackle it too:

    drivers/mtd/nand/denali.c: In function ‘denali_read_page_raw’:
    drivers/mtd/nand/denali.c:1221:11: warning: variable ‘irq_status’ set but not used [-Wunused-but-set-variable]
          uint32_t irq_status;

Brian
