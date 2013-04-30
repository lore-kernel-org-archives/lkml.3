Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759374Ab3D3Ahe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 20:37:34 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:50775 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759328Ab3D3Ahc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 20:37:32 -0400
Message-ID: <517F1249.4090906@linaro.org>
Date: Mon, 29 Apr 2013 17:37:30 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [patch 03/15] clocksource: Let timekeeping_notify return success/error
References: <20130425142452.908423538@linutronix.de> <20130425143435.696321912@linutronix.de>
In-Reply-To: <20130425143435.696321912@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2013 01:31 PM, Thomas Gleixner wrote:
> timekeeping_notify() can fail due cs->enable() failure. Though the
> caller does not notice and happily keeps the wrong clocksource as the
> current one.
>
> Let the caller know about failure, so the current clocksource will be
> shown correctly in sysfs.
>
> Signed-off-by: Thomas Gleixner<tglx@linutronix.de>

Acked-by: John Stultz <john.stultz@linaro.org>

thanks
-john

