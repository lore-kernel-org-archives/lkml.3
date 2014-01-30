Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595AbaA3P12 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 10:27:28 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53015 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaA3P11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 10:27:27 -0500
Date: Thu, 30 Jan 2014 16:27:21 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: nicolas.pitre@linaro.org, mingo@redhat.com, tglx@linutronix.de,
        rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [RFC PATCH 1/3] cpuidle: split cpuidle_idle_call main function
 into functions
Message-ID: <20140130152721.GC5002@laptop.programming.kicks-ass.net>
References: <1391090962-15032-1-git-send-email-daniel.lezcano@linaro.org>
 <1391090962-15032-2-git-send-email-daniel.lezcano@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391090962-15032-2-git-send-email-daniel.lezcano@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 03:09:20PM +0100, Daniel Lezcano wrote:
> +EXPORT_SYMBOL(cpuidle_select);
> +EXPORT_SYMBOL(cpuidle_enter);
> +EXPORT_SYMBOL(cpuidle_reflect);

$ grep EXPORT_SYMBOL drivers/cpuidle/cpuidle.c
EXPORT_SYMBOL_GPL(cpuidle_pause_and_lock);
EXPORT_SYMBOL_GPL(cpuidle_resume_and_unlock);
EXPORT_SYMBOL_GPL(cpuidle_enable_device);
EXPORT_SYMBOL_GPL(cpuidle_disable_device);
EXPORT_SYMBOL_GPL(cpuidle_register_device);
EXPORT_SYMBOL_GPL(cpuidle_unregister_device);
EXPORT_SYMBOL_GPL(cpuidle_unregister);
EXPORT_SYMBOL_GPL(cpuidle_register);

