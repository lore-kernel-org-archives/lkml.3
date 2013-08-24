Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab3HXD4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 23:56:08 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:56259 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754107Ab3HXD4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 23:56:06 -0400
Date: Sat, 24 Aug 2013 11:53:42 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Mike Turquette <mturquette@linaro.org>
CC: "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "gregory.clement@free-electrons.com" 
	<gregory.clement@free-electrons.com>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        "ezequiel.garcia@free-electrons.com" 
	<ezequiel.garcia@free-electrons.com>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] clk: mvebu: add missing iounmap
Message-ID: <20130824115342.675b3a6b@xhacker>
In-Reply-To: <20130823212950.8231.90154@quantum>
References: <1377225242-5854-1-git-send-email-jszhang@marvell.com>
	<1377225242-5854-4-git-send-email-jszhang@marvell.com>
	<20130823212950.8231.90154@quantum>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Fri, 23 Aug 2013 14:29:50 -0700
Mike Turquette <mturquette@linaro.org> wrote:

> Quoting Jisheng Zhang (2013-08-22 19:34:01)
> > Add missing iounmap to setup error path.
> > 
> > Change-Id: I4371569d14d7026aa9f90d7cd53f669d365fe26a
> 
> Please remove Change-Id's from the commit message for upstream patch
> submissions in the future. I can remove this one, this time.
> 
> I've taken the patch into clk-next.
> 

Thanks for kindly reminding. I'll take care of this in the future.

Best Regards,
Jisheng
