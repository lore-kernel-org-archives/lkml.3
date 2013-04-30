Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759784Ab3D3BBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 21:01:38 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:59782 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759449Ab3D3BBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 21:01:37 -0400
Message-ID: <517F17EE.1010402@linaro.org>
Date: Mon, 29 Apr 2013 18:01:34 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [patch 08/15] clocksource: Let clocksource_unregister() return
 success/error
References: <20130425142452.908423538@linutronix.de> <20130425143436.029915527@linutronix.de>
In-Reply-To: <20130425143436.029915527@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2013 01:31 PM, Thomas Gleixner wrote:
> The unregister call can fail, if the clocksource is the current one
> and there is no replacement clocksource available. It can also fail,
> if the clocksource is the watchdog clocksource and I'm not going to
> provide support for this.
>
> Signed-off-by: Thomas Gleixner<tglx@linutronix.de>
Acked-by: John Stultz <john.stultz@linaro.org>

thanks
-john

