Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbaIZUDb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 16:03:31 -0400
Received: from mail.kernel.org ([198.145.19.201]:52040 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754111AbaIZUDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 16:03:30 -0400
MIME-Version: 1.0
In-Reply-To: <1411760732-14102-1-git-send-email-khilman@kernel.org>
References: <1411760732-14102-1-git-send-email-khilman@kernel.org>
Date: Fri, 26 Sep 2014 13:03:26 -0700
Message-ID: <CAMAWPa-WMkb_rJZ_XBCd3+pTtu5-SwN7F-0pNs3SrsokDDH5sA@mail.gmail.com>
Subject: Re: [PATCH] sched/nohz: add debugfs control over sched_tick_max_deferment
From: Kevin Hilman <khilman@kernel.org>
To: Kevin Hilman <khilman@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

On Fri, Sep 26, 2014 at 12:45 PM, Kevin Hilman <khilman@kernel.org> wrote:
> From: Kevin Hilman <khilman@linaro.org>
>
> Allow debugfs override of sched_tick_max_deferment in order to ease
> finding/fixing the remaining issues with full nohz.
>
> The value to be written is in jiffies, and -1 means the max deferment
> is disabled (scheduler_tick_max_deferment() returns KTIME_MAX.)
>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Kevin Hilman <khilman@linaro.org>

This is just an attempt to revive and hopefully finalize the
discussion started a while back[1].

Kevin

[1] https://lkml.org/lkml/2014/1/14/914
