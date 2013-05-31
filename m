Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715Ab3EaBZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 21:25:26 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:40476 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab3EaBZS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 21:25:18 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Philippe Begnic <philippe.begnic.st@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1369658492-31358-1-git-send-email-philippe.begnic.st@gmail.com>
Cc: <linux-arm-kernel@lists.infradead.org>, Lee Jones <lee.jones@linaro.org>,
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        linux-kernel@vger.kernel.org, olivier.clergeaud@st.com,
        philippe.begnic.st@gmail.com, Philippe Begnic <philippe.begnic@st.com>
References: <1369658492-31358-1-git-send-email-philippe.begnic.st@gmail.com>
Message-ID: <20130531012509.21525.90187@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH 0/4] clk, mfd: u8540 clock tree definition
Date: Thu, 30 May 2013 18:25:09 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Philippe Begnic (2013-05-27 05:41:28)
> From: Philippe Begnic <philippe.begnic@st.com>
> 
> Create U8540 clock tree definitions for common clock framework
> 

The clock changes look good to me.  How did you want to merge the
patches?

Regards,
Mike

> Philippe Begnic (4):
>   clk: ux500: Pass clock base adresses in initcall for u8540 and u9540
>   mfd: db8500: Update register definition for u8540 clock
>   mfd: db8500: Update BML clock register for db8580
>   clk: ux500: Clocks definition for u8540
> 
>  arch/arm/mach-ux500/cpu.c                 |    6 +-
>  drivers/clk/ux500/u8540_clk.c             |  564 ++++++++++++++++++++++++++++-
>  drivers/clk/ux500/u9540_clk.c             |    4 +-
>  drivers/mfd/db8500-prcmu.c                |    1 +
>  drivers/mfd/dbx500-prcmu-regs.h           |    1 +
>  include/linux/mfd/abx500/ab8500-sysctrl.h |    4 +-
>  include/linux/mfd/dbx500-prcmu.h          |   12 +
>  include/linux/platform_data/clk-ux500.h   |    6 +-
>  8 files changed, 587 insertions(+), 11 deletions(-)
> 
> -- 
> 1.7.9.5
