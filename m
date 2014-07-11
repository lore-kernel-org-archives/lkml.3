Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbaGKOwV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:52:21 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:34646 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbaGKOwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:52:19 -0400
Date: Fri, 11 Jul 2014 15:52:12 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [patch 35/55] mfd: cros_ec_spi: Use ktime_get_ns()
Message-ID: <20140711145212.GG2954@lee--X1>
References: <20140711133623.530368377@linutronix.de>
 <20140711133708.263040802@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140711133708.263040802@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Replace the ever recurring:
> 	ts = ktime_get_ts();
> 	ns = timespec_to_ns(&ts);
> with
> 	ns = ktime_get_ns();
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Samuel Ortiz <sameo@linux.intel.com>

Only Sam?  How old is your version of MAINTAINERS?

Sam hasn't actively maintained MFD for over a year now.

Patch applied though, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
