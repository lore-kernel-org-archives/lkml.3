Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbaIVBRX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 21:17:23 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:36179 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbaIVBRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 21:17:22 -0400
Date: Mon, 22 Sep 2014 10:15:56 +0900
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: Brian Norris <computersforpeace@gmail.com>
Subject: Re: [PATCH v3 0/7] mtd: denali: A collection of trivial coding style fixes
Cc: linux-mtd@lists.infradead.org, Rashika Kheria <rashika.kheria@gmail.com>,
        linux-kernel@vger.kernel.org, Huang Shijie <shijie8@gmail.com>,
        Jiri Kosina <trivial@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "grmoore@altera.com" <grmoore@altera.com>,
        Josh Triplett <josh@joshtriplett.org>
In-Reply-To: <20140919170020.GF1193@ld-irv-0074>
References: <1410865465-17941-1-git-send-email-yamada.m@jp.panasonic.com> <20140919170020.GF1193@ld-irv-0074>
X-BkSecure-Plugin: BkSecure.dll Ver 1, 2, 7, 0
Message-Id: <20140922101555.0A05.AA925319@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.64.06 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brian,


On Fri, 19 Sep 2014 10:00:20 -0700
Brian Norris <computersforpeace@gmail.com> wrote:

> On Tue, Sep 16, 2014 at 08:04:18PM +0900, Masahiro Yamada wrote:
> > 
> > 
> > Masahiro Yamada (7):
> >   mtd: denali: fix the format of comment blocks
> >   mtd: denali: remove unnecessary variable initializations
> >   mtd: denali: remove unnecessary casts
> >   mtd: denali: change the type of iterators to int
> 
> I already merged these 4.
> 
> >   mtd: denali: remove a set-but-unused variable
> 
> This one was merged but you changed it (and falsely kept the
> 'Reviewed-by' tag). So I split it out into its own patch and dropped the
> 'Reviewed-by'.
> 
> >   mtd: denali: remove unnecessary parentheses
> >   mtd: denali: fix indents and other trivial things
> 
> Applied a modified version of the last three, to l2-mtd.git. Feel free
> to check my work, but git tells me that the end result is identical.


Everything looks good.
Many thanks!!


Best Regards
Masahiro Yamada

