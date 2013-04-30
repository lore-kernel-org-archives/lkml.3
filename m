Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250Ab3D3Aej (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 20:34:39 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:47641 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab3D3Aei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 20:34:38 -0400
Message-ID: <517F119B.7090209@linaro.org>
Date: Mon, 29 Apr 2013 17:34:35 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [patch 02/15] clocksource: Always verify highres capability
References: <20130425142452.908423538@linutronix.de> <20130425143435.635040849@linutronix.de>
In-Reply-To: <20130425143435.635040849@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2013 01:31 PM, Thomas Gleixner wrote:
> If a clocksource has a (wrong) high rating, but can't be used as a
> timebase for oneshot tick mode, it is unconditionally selected even
> when the system is already in oneshot tick mode. This causes full
> system failure.
>
> Verify the clocksource selection against the oneshot mode.
>
> Signed-off-by: Thomas Gleixner<tglx@linutronix.de>

Acked-by: John Stultz <john.stultz@linaro.org>

thanks
-john

