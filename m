Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288AbaIRCcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 22:32:47 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:53848 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389AbaIRCcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 22:32:46 -0400
Date: Thu, 18 Sep 2014 11:31:35 +0900
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: Brian Norris <computersforpeace@gmail.com>
Subject: Re: [PATCH v3 0/7] mtd: denali: A collection of trivial coding style fixes
Cc: Jiri Kosina <trivial@kernel.org>, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        linux-mtd@lists.infradead.org,
        "grmoore@altera.com" <grmoore@altera.com>,
        Huang Shijie <shijie8@gmail.com>
In-Reply-To: <20140917171308.GC1193@ld-irv-0074>
References: <1410865465-17941-1-git-send-email-yamada.m@jp.panasonic.com> <20140917171308.GC1193@ld-irv-0074>
X-BkSecure-Plugin: BkSecure.dll Ver 1, 2, 7, 0
Message-Id: <20140918113135.70D0.AA925319@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.64.06 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brian,



On Wed, 17 Sep 2014 10:13:08 -0700
Brian Norris <computersforpeace@gmail.com> wrote:

> On Tue, Sep 16, 2014 at 08:04:18PM +0900, Masahiro Yamada wrote:
> > 
> > 
> > Masahiro Yamada (7):
> >   mtd: denali: fix the format of comment blocks
> >   mtd: denali: remove unnecessary variable initializations
> >   mtd: denali: remove unnecessary casts
> >   mtd: denali: change the type of iterators to int
> >   mtd: denali: remove a set-but-unused variable
> >   mtd: denali: remove unnecessary parentheses
> >   mtd: denali: fix indents and other trivial things
> 
> This series still doesn't apply to l2-mtd.git.
> 
> Brian


I resent the last three patches as v3.

v3 5/7 mtd: denali: remove a set-but-unused variable
v3 6/7 mtd: denali: remove unnecessary parentheses
v3 7/7 mtd: denali: fix indents and other trivial things


I confirmed they are applicable onto
commit 93e3c8adf6fcf2204ca334237b92c7f8cdafce6f
of l2-mtd.git



You said as follow:

On Mon, 15 Sep 2014 22:07:32 -0700
Brian Norris <computersforpeace@gmail.com> wrote:

> > Is there a chance for me to resend 5/7 to include this fix?
> > Or is it too late?
> 
> Just send a new patch, please.


That's why I sent a new patch (v3 5/7) to replace
commit 55ab9ec99bbfb4450dfa9bc0fd9e2c5052f4c3f7


Did I do wrong?



Best Regards
Masahiro Yamada

