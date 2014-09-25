Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbaIYMUB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 08:20:01 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:56388 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbaIYMUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 08:20:00 -0400
Message-ID: <5424086C.1070901@cogentembedded.com>
Date: Thu, 25 Sep 2014 16:19:56 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Stefan Agner <stefan@agner.ch>, shawn.guo@freescale.com,
        kernel@pengutronix.de, daniel.lezcano@linaro.org, tglx@linutronix.de
CC: bpringlemeir@nbsps.com, linux-kernel@vger.kernel.org,
        jingchang.lu@freescale.com, festevam@gmail.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/3] clocksource: vf_pit_timer: Support shutdown mode
References: <1411575610-20895-1-git-send-email-stefan@agner.ch> <1411575610-20895-2-git-send-email-stefan@agner.ch>
In-Reply-To: <1411575610-20895-2-git-send-email-stefan@agner.ch>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 9/24/2014 8:20 PM, Stefan Agner wrote:

> In order to avoid waking up the system in a low power mode, the
> clocksource should not generate interrupts anymore. Disable the PIT
> timer interrupt when changing into the CLOCK_EVT_MODE_SHUTDOWN mode.

> Signed-off-by: Stefan Agner <stefan@agner.ch>
> ---
>   drivers/clocksource/vf_pit_timer.c | 5 +++++
>   1 file changed, 5 insertions(+)

> diff --git a/drivers/clocksource/vf_pit_timer.c b/drivers/clocksource/vf_pit_timer.c
> index a918bc4..eb354b4 100644
> --- a/drivers/clocksource/vf_pit_timer.c
> +++ b/drivers/clocksource/vf_pit_timer.c
> @@ -89,10 +89,15 @@ static int pit_set_next_event(unsigned long delta,
>   static void pit_set_mode(enum clock_event_mode mode,
>   				struct clock_event_device *evt)
>   {
> +

    scripts/checkpatch.pl should protest about this empty line, it's not 
needed at all.

WBR, Sergei

