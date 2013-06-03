Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab3FCIPN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 04:15:13 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:49631 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab3FCIPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 04:15:10 -0400
Date: Mon, 3 Jun 2013 09:15:04 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Philippe Begnic <philippe.begnic.st@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        linux-arm-kernel@lists.infradead.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        linux-kernel@vger.kernel.org, olivier.clergeaud@st.com,
        Philippe Begnic <philippe.begnic@st.com>, sameo@linux.intel.com
Subject: Re: [PATCH 0/4] clk, mfd: u8540 clock tree definition
Message-ID: <20130603081504.GB3370@gmail.com>
References: <1369658492-31358-1-git-send-email-philippe.begnic.st@gmail.com>
 <20130531012509.21525.90187@quantum>
 <20130531065532.GA10355@gmail.com>
 <20130531191437.21525.40759@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130531191437.21525.40759@quantum>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 May 2013, Mike Turquette wrote:

> Quoting Lee Jones (2013-05-30 23:55:32)
> > On Thu, 30 May 2013, Mike Turquette wrote:
> > 
> > > Quoting Philippe Begnic (2013-05-27 05:41:28)
> > > > From: Philippe Begnic <philippe.begnic@st.com>
> > > > 
> > > > Create U8540 clock tree definitions for common clock framework
> > > > 
> > > 
> > > The clock changes look good to me.  How did you want to merge the
> > > patches?
> > 
> > You may as well take them through your tree Mike.
> > 
> 
> Sure I can take them but it would be best to wait for an Ack from Samuel
> for the MFD parts, if only so that we are coordinated.

You don't need it. Apply with mine instead:

Acked-by: Lee Jones <lee.jones@linaro.org>

> > > > Philippe Begnic (4):
> > > >   clk: ux500: Pass clock base adresses in initcall for u8540 and u9540
> > > >   mfd: db8500: Update register definition for u8540 clock
> > > >   mfd: db8500: Update BML clock register for db8580
> > > >   clk: ux500: Clocks definition for u8540
> > > > 
> > > >  arch/arm/mach-ux500/cpu.c                 |    6 +-
> > > >  drivers/clk/ux500/u8540_clk.c             |  564 ++++++++++++++++++++++++++++-
> > > >  drivers/clk/ux500/u9540_clk.c             |    4 +-
> > > >  drivers/mfd/db8500-prcmu.c                |    1 +
> > > >  drivers/mfd/dbx500-prcmu-regs.h           |    1 +
> > > >  include/linux/mfd/abx500/ab8500-sysctrl.h |    4 +-
> > > >  include/linux/mfd/dbx500-prcmu.h          |   12 +
> > > >  include/linux/platform_data/clk-ux500.h   |    6 +-
> > > >  8 files changed, 587 insertions(+), 11 deletions(-)
> > > > 
> > 

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
