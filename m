Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933709AbaGWWIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 18:08:11 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:44770 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933386AbaGWWIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 18:08:10 -0400
Message-ID: <53D03246.6060408@linaro.org>
Date: Wed, 23 Jul 2014 15:08:06 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
CC: Nicolas Pitre <nico@fluxnic.net>, Colin Cross <ccross@google.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v3] clocksource: document some basic timekeeping concepts
References: <1404978747-20869-1-git-send-email-linus.walleij@linaro.org>
In-Reply-To: <1404978747-20869-1-git-send-email-linus.walleij@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2014 12:52 AM, Linus Walleij wrote:
> This adds some documentation about clock sources, clock events,
> the weak sched_clock() function and delay timers that answers
> questions that repeatedly arise on the mailing lists.
>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Nicolas Pitre <nico@fluxnic.net>
> Cc: Colin Cross <ccross@google.com>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Queued for 3.17. Thanks!
-john

