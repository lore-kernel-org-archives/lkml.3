Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbaJ1BuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 21:50:00 -0400
Received: from mail-yh0-f44.google.com ([209.85.213.44]:60496 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbaJ1Bt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 21:49:59 -0400
MIME-Version: 1.0
In-Reply-To: <1413822343-1972-1-git-send-email-daniel.lezcano@linaro.org>
References: <1413822343-1972-1-git-send-email-daniel.lezcano@linaro.org>
Date: Mon, 27 Oct 2014 21:49:58 -0400
X-Google-Sender-Auth: WwH4ogkHQaPERp4fsupGliwD-wU
Message-ID: <CAJvTdK=t4QssQAOwAYqs_B0xZhFjknaY_UwC8o7nKLryr8LmvA@mail.gmail.com>
Subject: Re: [PATCH 1/5] sched: idle: cpuidle: Check the latency req before idle
From: Len Brown <lenb@kernel.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linaro-kernel@lists.linaro.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks fine, Daniel.

cheers,
-Len

Reviewed-by: Len Brown <len.brown@intel.com>
