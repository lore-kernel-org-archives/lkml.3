Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658Ab3KRJxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 04:53:30 -0500
Received: from eu1sys200aog125.obsmtp.com ([207.126.144.159]:44953 "EHLO
	eu1sys200aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750836Ab3KRJxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 04:53:23 -0500
Message-ID: <5289E313.9020100@st.com>
Date: Mon, 18 Nov 2013 09:51:15 +0000
From: srinivas kandagatla <srinivas.kandagatla@st.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>, <linux-kernel@vger.kernel.org>,
        Stuart Menefy <stuart.menefy@st.com>
Subject: Re: [PATCH 1/4] clocksource: arm_global_timer: Switch to sched_clock_register()
References: <1384559315-18699-1-git-send-email-sboyd@codeaurora.org> <1384559315-18699-2-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1384559315-18699-2-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.65.51.59]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/11/13 23:48, Stephen Boyd wrote:
> The 32 bit sched_clock interface now supports 64 bits. Upgrade to
> the 64 bit function to allow us to remove the 32 bit registration
> interface. While we're here increase the number of bits that
> sched_clock can handle to 64 to make full use of the counter.
> 
> Cc: Stuart Menefy <stuart.menefy@st.com>
> Cc: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/clocksource/arm_global_timer.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/clocksource/arm_global_timer.c b/drivers/clocksource/arm_global_timer.c
> index c639b1a..0fc31d0 100644
> --- a/drivers/clocksource/arm_global_timer.c
> +++ b/drivers/clocksource/arm_global_timer.c
> @@ -202,7 +202,7 @@ static struct clocksource gt_clocksource = {

Thankyou for the patch.

Acked-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>

