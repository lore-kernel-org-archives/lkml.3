Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551AbaDXHzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 03:55:40 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:44448 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaDXHzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 03:55:38 -0400
MIME-Version: 1.0
In-Reply-To: <1398325667-27060-2-git-send-email-daniel.sangorrin@toshiba.co.jp>
References: <1398325667-27060-1-git-send-email-daniel.sangorrin@toshiba.co.jp>
	<1398325667-27060-2-git-send-email-daniel.sangorrin@toshiba.co.jp>
Date: Thu, 24 Apr 2014 13:25:38 +0530
Message-ID: <CAKohpomUg+gtL+1_qT05qWTh4qygSGU4HnqPLq8dM0=AmzY8+Q@mail.gmail.com>
Subject: Re: [PATCH] timer_stats: add core information to event counters
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Daniel Sangorrin <daniel.sangorrin@toshiba.co.jp>
Cc: Thomas Gleixner <tglx@linutronix.de>, Randy Dunlap <rdunlap@infradead.org>,
        John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 April 2014 13:17, Daniel Sangorrin <daniel.sangorrin@toshiba.co.jp> wrote:
> Add information specifying the CPU core where timer callbacks (events)
> were executed to the output of /proc/timer_stats.
>
> Signed-off-by: Daniel Sangorrin <daniel.sangorrin@toshiba.co.jp>
> Signed-off-by: Yoshitake Kobayashi <yoshitake.kobayashi@toshiba.co.jp>
> ---
>  Documentation/timers/timer_stats.txt | 41 ++++++++++++++++++++----------------
>  kernel/time/timer_stats.c            | 20 ++++++++++--------
>  2 files changed, 34 insertions(+), 27 deletions(-)

Nice and useful work.

Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
