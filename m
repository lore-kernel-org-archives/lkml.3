Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbaDEMF0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 08:05:26 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:39170 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbaDEMFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 08:05:24 -0400
MIME-Version: 1.0
In-Reply-To: <533FAE29.4080209@intel.com>
References: <20140404031928.GC11828@localhost>
	<CAKohponbGFFo+W7X24e4h3ub2L8Tkb89eP6_F17CRYELk0yeRQ@mail.gmail.com>
	<533E635F.9050803@intel.com>
	<CAKohpon+THY2NXEEOcWRbmrpfQUZYbHfO+Lw=D9TaJWk+_-J2g@mail.gmail.com>
	<533F86D4.10007@intel.com>
	<CAKohpokStOgdO-KFn8hcyV+neaNCvHLSG9od=qyi2-4rV62DRw@mail.gmail.com>
	<533FAE29.4080209@intel.com>
Date: Sat, 5 Apr 2014 17:35:24 +0530
Message-ID: <CAKohpo=F=wmy=x_v8WYMuUEUO+K=_JSUwhAr28vUPm_yHr0K6g@mail.gmail.com>
Subject: Re: WARNING: CPU: 0 PID: 1935 at kernel/timer.c:1621 migrate_timer_list()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Jet Chen <jet.chen@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 April 2014 12:48, Jet Chen <jet.chen@intel.com> wrote:
> Your patch fixes it!

Thanks for all your efforts on reporting/testing this patch.. I have
sent the final patch to list.
