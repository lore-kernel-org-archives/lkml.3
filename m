Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331AbaDOPTW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 11:19:22 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:54019 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaDOPTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 11:19:20 -0400
MIME-Version: 1.0
In-Reply-To: <20140415122554.GA2438@localhost.localdomain>
References: <1395940862-31428-1-git-send-email-fweisbec@gmail.com>
	<534D02B0.1000801@cn.fujitsu.com>
	<20140415122554.GA2438@localhost.localdomain>
Date: Tue, 15 Apr 2014 23:19:19 +0800
X-Google-Sender-Auth: x0T0HOTxvtMM-cN9r0ddV0CXC20
Message-ID: <CACvQF50XLZTs8cS+gEqh+D11PMSv_t6QzfJO+=jNW=o2O65--A@mail.gmail.com>
Subject: Re: [PATCH] workqueue: allow changing attributions of ordered workqueue
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Kevin Hilman <khilman@linaro.org>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> So IUUC this is to allow registering ordered workqueue as WQ_SYSFS? But I think

Making ordered workqueue's attributions changeable was listed in my TODO list.
I found it may help for you, so I prioritized it.
Never mind, I will push my patch separated if you don't need it.

> we are going to follow Tejun's suggestion to have a low level cpumask which defines
> the limit for all unbound workqueues. This indeed tremendously simplifies everyting.
> I'll post the series soon.

It sounds feasible. I look forward to your patches

>
> But maybe I'm missing other requirements that are fixed by your patch?
>
> Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
