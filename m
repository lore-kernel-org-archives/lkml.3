Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459Ab3KGHTX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 02:19:23 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:59580 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902Ab3KGHTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 02:19:14 -0500
Date: Wed, 6 Nov 2013 23:19:09 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: "Gupta, Pekon" <pekon@ti.com>
Cc: Wei Yongjun <weiyj.lk@gmail.com>, David Woodhouse <dwmw2@infradead.org>,
        Daniel Mack <zonque@gmail.com>,
        "avinashphilip@ti.com" <avinashphilip@ti.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Jingoo Han <jg1.han@samsung.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] mtd: nand: omap: fix error return code in
 omap_nand_probe()
Message-ID: <20131107071909.GB3805@norris.computersforpeace.net>
References: <CAPgLHd8V06KzBcPmFywSfNxM0q6=s86xn-AdLKeY9h5JZ_nP7g@mail.gmail.com>
 <001101ced6a8$a18a2c80$e49e8580$%han@samsung.com>
 <CAN8TOE9Eac0LDA+Ke_OCPc_AQGnyYB806pO8JP-qOB1Dr8N2pg@mail.gmail.com>
 <20980858CB6D3A4BAE95CA194937D5E73EA31818@DBDE04.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20980858CB6D3A4BAE95CA194937D5E73EA31818@DBDE04.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 06:06:25PM +0000, Pekon Gupta wrote:
> > From: Brian Norris [mailto:computersforpeace@gmail.com]
> > > On Thu, Oct 31, 2013 at 7:18 PM, Jingoo Han <jg1.han@samsung.com>
> > >> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> > >>
> > >> Fix to return a negative error code from the error handling
> > >> case instead of 0, as done elsewhere in this function.
> > >
> > > Commit message is right? :-(
> > 
> > It sounds OK by my reading. Unless you're having trouble parsing what
> > "as done elsewhere in this function" is being applied to. (IOW, is the
> > rest of the function returning a negative error code on the error
> > paths, or is it returning 0? Of course the answer is the former, but
> > it's possible to misread it.) If it helps, I can try to tweak the
> > wording a bit when applying this patch.
> > 
> > Pekon, can I get an Acked-by?
> > 
> Yes sure .. Sorry I was away from both mailbox and boards.

No problem.

> Acked-by: Pekon Gupta <pekon@ti.com>
> 
> And thanks much Wei Yongjun for fixing this .

Thanks. Pushed to l2-mtd.git with a slight tweak in the description.

Brian
