Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbaIYXBt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 19:01:49 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:61684 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbaIYXBr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 19:01:47 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Stephen Rothwell <sfr@canb.auug.org.au>, "Kukjin Kim" <kgene@kernel.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <20140924155336.6e64b952@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Javier Martinez Canillas'" <javier.martinez@collabora.co.uk>,
        "'Bartlomiej Zolnierkiewicz'" <b.zolnierkie@samsung.com>
References: <20140924110836.209bc8e2@canb.auug.org.au>
 <00fb01cfd7a4$45eb4a50$d1c1def0$@kernel.org>
 <20140924155336.6e64b952@canb.auug.org.au>
Message-ID: <20140925230124.19023.33551@quantum>
User-Agent: alot/0.3.5
Subject: Re: linux-next: build failure after merge of the samsung tree
Date: Thu, 25 Sep 2014 16:01:24 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Rothwell (2014-09-23 22:53:36)
> Hi Kukjin,
> 
> On Wed, 24 Sep 2014 12:04:36 +0900 Kukjin Kim <kgene@kernel.org> wrote:
> >
> > > After merging the samsung tree, today's linux-next build (arm multi_v7_defconfig)
> > > failed like this:
> > > 
> > > arch/arm/boot/dts/exynos5250-snow.dts:13:46: fatal error: dt-bindings/clock/maxim,max77686.h: No such
> > > file or directory
> > >  #include <dt-bindings/clock/maxim,max77686.h>
> > >                                               ^
> > > 
> > + Mike
> > 
> > Hmm... I think, inclusion of the header file should be included in Mike's clk
> > tree...What's wrong?
> 
> Mike's clk tree is included in linux-next well after your tree ... and
> does Mike's tree get included in the arm-soc tree like your does?  So,
> clearly you can't build this tree on its own?

I saw in another thread that Kukjin merged the clk tree into his -next
branch. Is there anything left to do on this one?

Regards,
Mike

> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
