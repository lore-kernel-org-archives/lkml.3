Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760724AbaCUP4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 11:56:40 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57557 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753133AbaCUP4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 11:56:36 -0400
Date: Fri, 21 Mar 2014 16:56:33 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
Subject: Re: [PATCH 1/5] clk: berlin: add support for berlin plls
Message-ID: <20140321155633.GF6443@piout.net>
References: <1395402220-23503-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1395402220-23503-2-git-send-email-alexandre.belloni@free-electrons.com>
 <532C355C.3090606@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <532C355C.3090606@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/03/2014 at 13:49:32 +0100, Sebastian Hesselbarth wrote :
> On 03/21/2014 12:43 PM, Alexandre Belloni wrote:
> >diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
> >index a367a9831717..4a2602737c27 100644
> >--- a/drivers/clk/Makefile
> >+++ b/drivers/clk/Makefile
> >@@ -29,6 +29,7 @@ obj-$(CONFIG_ARCH_VT8500)		+= clk-vt8500.o
> >  obj-$(CONFIG_COMMON_CLK_WM831X)		+= clk-wm831x.o
> >  obj-$(CONFIG_COMMON_CLK_XGENE)		+= clk-xgene.o
> >  obj-$(CONFIG_COMMON_CLK_AT91)		+= at91/
> >+obj-$(CONFIG_ARCH_BERLIN)		+= berlin/
> >  obj-$(CONFIG_ARCH_HI3xxx)		+= hisilicon/
> >  obj-$(CONFIG_COMMON_CLK_KEYSTONE)	+= keystone/
> 
> I'll have a look at clk/Makefile later myself, but alphabetic ordering
> seems to be broken by ARCH_HI3xxx already. Anyway, we shouldn't just
> add another violator.
> 

BTW,  don't think there is any issue here, the Makefile states:
# please keep this section sorted lexicographically by file/directory path name



-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
