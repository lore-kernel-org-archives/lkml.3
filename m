Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960AbaEPR0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 13:26:42 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:35520 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757735AbaEPR0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 13:26:40 -0400
MIME-Version: 1.0
In-Reply-To: <CAOqmu81Np91-GRe-GndjE2FnbGA-xttvu64gr=h9FaNpbBSoBw@mail.gmail.com>
References: <1400231366-1221-1-git-send-email-inderpal.s@samsung.com>
	<CAKohponY6Nn5kYGyps2SLm5uBbH1JWuJBpzzVD=QOc=oM7crAg@mail.gmail.com>
	<CAOqmu82GQ2qsm0c7fq8n5ovR7+4j5t_Y3=03S=nWtR+bH3yhdg@mail.gmail.com>
	<CAKohpokCBbL1OkxB3rh0Pr3yqiG1H6UsZgD-WQTRvihxJt1-Qw@mail.gmail.com>
	<CAOqmu81Np91-GRe-GndjE2FnbGA-xttvu64gr=h9FaNpbBSoBw@mail.gmail.com>
Date: Fri, 16 May 2014 22:56:39 +0530
Message-ID: <CAKohpomoXs+ybYvDa8_NdXqT7T4xqgtbbtEHp2CR1T=f6GVbNA@mail.gmail.com>
Subject: Re: [PATCH] PM / OPP: Implement free_opp_table function
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Inderpal Singh <inderpal.s@samsung.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 May 2014 22:54, Inderpal Singh <inderpal.s@samsung.com> wrote:
> by the time "pos = list_entry_rcu(pos->member.
> next, typeof(*pos), member)" is executed, the pos would have been
> freed in the loop.

Oops!!
