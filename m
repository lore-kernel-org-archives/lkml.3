Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbaGMJT3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 05:19:29 -0400
Received: from mail.kernel.org ([198.145.19.201]:52358 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469AbaGMJTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 05:19:23 -0400
Message-ID: <53C24FA1.609@kernel.org>
Date: Sun, 13 Jul 2014 10:21:37 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
CC: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 40/55] iio: Use ktime_get_real_ns()
References: <20140711133623.530368377@linutronix.de> <20140711133708.668617691@linutronix.de>
In-Reply-To: <20140711133708.668617691@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/14 14:44, Thomas Gleixner wrote:
> No idea why iio needs wall clock based time stamps, but we can avoid
> the timespec conversion dance by using the new interfaces.
>
> Signed-off-by: Thomas Gleixner<tglx@linutronix.de>
> Cc: Jonathan Cameron<jic23@kernel.org>
Acked-by: Jonathan Cameron <jic23@kernel.org>
