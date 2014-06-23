Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751290AbaFWEoi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 00:44:38 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:61028 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaFWEoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 00:44:37 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.10.1406221533300.5170@nanos>
References: <1403393357-2070-1-git-send-email-fweisbec@gmail.com>
	<1403393357-2070-5-git-send-email-fweisbec@gmail.com>
	<alpine.DEB.2.10.1406221533300.5170@nanos>
Date: Mon, 23 Jun 2014 10:14:36 +0530
Message-ID: <CAKohpokBrCbYpw+VZ3oQMhdXkLC7ozXX7S1xGLtyk463Or-B5w@mail.gmail.com>
Subject: Re: [PATCH 4/5] hrtimer: Kick lowres dynticks targets on timer enqueue
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 June 2014 19:06, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Sun, 22 Jun 2014, Frederic Weisbecker wrote:

>> +             wake_up_nohz_cpu(base->cpu_base->cpu);
>
> The timer is queued on new_base not on base.

Oops, thanks for spotting this bug. Will be fixed in next version.
