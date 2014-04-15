Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbaDOD7G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 23:59:06 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:54971 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbaDOD7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 23:59:04 -0400
MIME-Version: 1.0
In-Reply-To: <20140414224815.GA1877@localhost.localdomain>
References: <6c3484ccb8220d0c58db1cbd9c929fc8d83005fd.1397492119.git.viresh.kumar@linaro.org>
	<20140414183838.GF11182@twins.programming.kicks-ass.net>
	<20140414224815.GA1877@localhost.localdomain>
Date: Tue, 15 Apr 2014 09:29:03 +0530
Message-ID: <CAKohpo=gDK7qtEiD1yOweh18PpvG1crWaAzhWWnLQuwWsbge2A@mail.gmail.com>
Subject: Re: [PATCH] sched/core: fix formatting issues in sched_can_stop_tick()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 April 2014 04:18, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> Right, I have a pending patch for that:

> https://git.kernel.org/cgit/linux/kernel/git/frederic/linux-dynticks.git/commit/?h=nohz/ipi&id=ca981d9f87fe0f113ad972098cfe181180b3675a

Cool!! I will rebase my patch over yours and resend.
