Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936524Ab3DHKTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:19:21 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:61315 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935527Ab3DHKTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 06:19:18 -0400
MIME-Version: 1.0
In-Reply-To: <20121217054240.GA13300@core.coreip.homeip.net>
References: <1353403339-11679-1-git-send-email-dmitry.torokhov@gmail.com>
	<1353403339-11679-3-git-send-email-dmitry.torokhov@gmail.com>
	<CAKohpomA=vSGuKfD-_zwiSnXGkqAQjtiVqxT2Po=D-LDA_FESg@mail.gmail.com>
	<20121216115756.GO14363@n2100.arm.linux.org.uk>
	<CAKohpok7Lh_ozuBFZdObpPRj0u_B-MNqgWjmaaSik3v4SmgJcw@mail.gmail.com>
	<20121216124013.GP14363@n2100.arm.linux.org.uk>
	<CAKohpom37Liqhz38YthaL9q+iFh4=iYHoUmrTOMq2=Ut-D0Dhg@mail.gmail.com>
	<20121217054240.GA13300@core.coreip.homeip.net>
Date: Mon, 8 Apr 2013 15:49:18 +0530
Message-ID: <CAKohponJ5n6Vr56nFJT7nXX5ByOCFHDET7-E_=xsfGK80X3jag@mail.gmail.com>
Subject: Re: [PATCH 2/3] CLK: uninline clk_prepare_enable() and clk_disable_unprepare()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 December 2012 11:12, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> They do not _have_ to be non-inline, I think we should simply drop the
> first 2 patches and I will refresh and ressend the 3rd one.

I haven't seen this patch since a long time? Any updates?
