Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbaGPJ5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 05:57:16 -0400
Received: from www.linutronix.de ([62.245.132.108]:54995 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbaGPJ5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 05:57:13 -0400
Date: Wed, 16 Jul 2014 11:57:10 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        John Stultz <john.stultz@linaro.org>
Subject: firewire: CLOCK_MONOTONIC_RAW exposure
Message-ID: <alpine.DEB.2.10.1407161151450.24854@nanos>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan,

I wonder why firewire exposed CLOCK_MONOTONIC_RAW to user space.

What's the purpose of that? CLOCK_MONOTONIC_RAW is the raw time based
on the initial frequency setup of the clocksource. That can be quite
off from the NTP corrected frequency which is exposed by
CLOCK_MONOTONIC.

If there is no real good reason, I'd really like to remove that.

Thanks,

	tglx

