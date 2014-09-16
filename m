Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbaIPCNK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 22:13:10 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:33768 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807AbaIPCNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 22:13:08 -0400
Date: Tue, 16 Sep 2014 11:11:58 +0900
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: Brian Norris <computersforpeace@gmail.com>
Subject: Re: [PATCH v2 0/7] mtd: denali: A collection of trivial coding style fixes
Cc: linux-mtd@lists.infradead.org, Rashika Kheria <rashika.kheria@gmail.com>,
        linux-kernel@vger.kernel.org, Huang Shijie <shijie8@gmail.com>,
        Jiri Kosina <trivial@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "grmoore@altera.com" <grmoore@altera.com>,
        Josh Triplett <josh@joshtriplett.org>
In-Reply-To: <20140916003620.GA1193@ld-irv-0074>
References: <1410228117-14820-1-git-send-email-yamada.m@jp.panasonic.com> <20140916003620.GA1193@ld-irv-0074>
X-BkSecure-Plugin: BkSecure.dll Ver 1, 2, 7, 0
Message-Id: <20140916111154.58F0.AA925319@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.64.06 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brian,




On Mon, 15 Sep 2014 17:36:20 -0700
Brian Norris <computersforpeace@gmail.com> wrote:

> On Tue, Sep 09, 2014 at 11:01:50AM +0900, Masahiro Yamada wrote:
> > Changes in v2:
> >   - Join quotes strings into a single line
> > 
> > Masahiro Yamada (7):
> >   mtd: denali: fix the format of comment blocks
> >   mtd: denali: remove unnecessary variable initializations
> >   mtd: denali: remove unnecessary casts
> >   mtd: denali: change the type of iterators to int
> >   mtd: denali: remove a set-but-unused variable
> >   mtd: denali: remove unnecessary parentheses
> >   mtd: denali: fix indents and other trivial things
> > 
> >  drivers/mtd/nand/denali.c | 562 +++++++++++++++++++++++++---------------------
> >  1 file changed, 303 insertions(+), 259 deletions(-)
> 
> Pushed patches 1 to 5 to l2-mtd.git. Thanks!
> 
> Patch 6 has a conflict with another fix already in l2-mtd.git. Can you
> rebase and resend?


Sorry for my ignorance, but where can I find l2-mtd.git?

In my understanding, the subsystem repositories should be documented
in MAINTAINERS, so I looked for it but just found
T:    git git://git.infradead.org/linux-mtd.git.
I do not think it is the one you mentioned.



> BTW, my automatic build tests show that there's at least one other
> 'unused' warning left, in case you want to tackle it too:
> 
>     drivers/mtd/nand/denali.c: In function ‘denali_read_page_raw’:
>     drivers/mtd/nand/denali.c:1221:11: warning: variable ‘irq_status’ set but not used [-Wunused-but-set-variable]
>           uint32_t irq_status;
> 

You are right.
(What is odd enough is this warning was not displayed on my build test.
I do not know why.)

Is there a chance for me to resend 5/7 to include this fix?
Or is it too late?


Best Regards
Masahiro Yamada

