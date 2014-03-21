Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbaCUWWv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 18:22:51 -0400
Received: from top.free-electrons.com ([176.31.233.9]:59258 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750917AbaCUWWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 18:22:46 -0400
Date: Fri, 21 Mar 2014 23:22:43 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>, Jimmy Xu <zmxu@marvell.com>,
        Jisheng Zhang <jszhang@marvell.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
Subject: Re: [PATCH v2 1/5] clk: berlin: add support for berlin plls
Message-ID: <20140321222243.GK6443@piout.net>
References: <1395432521-11055-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1395432521-11055-2-git-send-email-alexandre.belloni@free-electrons.com>
 <532CAD99.4060307@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <532CAD99.4060307@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/03/2014 at 22:22:33 +0100, Sebastian Hesselbarth wrote :
> On 03/21/2014 09:08 PM, Alexandre Belloni wrote:
> >This drivers allows to provide DT clocks for the cpu and system PLLs found on
> >Marvell Berlin SoCs.
> 
> Alexandre,
> 
> as mentioned on IRC, I now had a closer look on it. Some minor
> remarks below. Sorry, I didn't mention them earlier.
> 

To clarify things, I'll just resend patch 1 and you are ready to take
2-5, fixing up the remaining comments as soon as Mike takes it ?


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
