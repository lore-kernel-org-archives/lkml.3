Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339AbbANELm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 23:11:42 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:60229 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbbANELl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 23:11:41 -0500
Date: Wed, 14 Jan 2015 13:11:38 +0900
From: Simon Horman <horms@verge.net.au>
To: weiyj_lk@163.com
Cc: Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] clk: shmobile: fix sparse NULL pointer warning
Message-ID: <20150114041138.GA16198@verge.net.au>
References: <1421198183-17417-1-git-send-email-weiyj_lk@163.com>
 <20150114040910.GC14661@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150114040910.GC14661@verge.net.au>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 01:09:10PM +0900, Simon Horman wrote:
> On Wed, Jan 14, 2015 at 09:16:23AM +0800, weiyj_lk@163.com wrote:
> > From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> > 
> > Fixes the following sparse warnings:
> > 
> > drivers/clk/shmobile/clk-sh73a0.c:57:17: warning:
> >  Using plain integer as NULL pointer
> > 
> > Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Acked-by: Simon Horman <horms+renesas@verge.net.au>

Sorry for the miss-fire there.

As the patch that added this problem is queue up in my tree
I will add this patch there.
