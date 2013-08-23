Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab3HWOq5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 10:46:57 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49384 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427Ab3HWOq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 10:46:56 -0400
Date: Fri, 23 Aug 2013 15:46:47 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH 0/40] ARM: ux500: Convert to Device Tree only platform
Message-ID: <20130823144647.GD19107@lee--X1>
References: <1377260620-18829-1-git-send-email-lee.jones@linaro.org>
 <CACRpkda8qaNa09OLzsrK2KXzaFx-nwWr0pJpehN5qWtuKTORsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkda8qaNa09OLzsrK2KXzaFx-nwWr0pJpehN5qWtuKTORsA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Aug 2013, Linus Walleij wrote:

> On Fri, Aug 23, 2013 at 2:23 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > I started by taking out simple, unimportant pieces, then finalised by
> > removing the critical booting components required for booting with
> > ATAGs. After this patch-set the ux500 will only boot with Device Tree
> > enabled. DT boot appears to be unaffected by the work, tested on
> > Snowball.
> 
> Overall a very nice pice-by-piece approach, thanks!
> 
> We need to CLK DT stuff sorted out and applied first though.
> 
> I think we can just go ahead and start applying first the clk DT
> and then this as a first take for v3.13 after the merge window.
> (It's way too late for v3.12.)

Sure. Sounds like a good approach.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
