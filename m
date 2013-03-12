Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978Ab3CLLiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 07:38:16 -0400
Received: from mail-ia0-f175.google.com ([209.85.210.175]:52211 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932940Ab3CLLiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 07:38:14 -0400
MIME-Version: 1.0
In-Reply-To: <513A0109.9060801@linaro.org>
References: <1362219013-18173-1-git-send-email-daniel.lezcano@linaro.org>
	<513A0109.9060801@linaro.org>
Date: Tue, 12 Mar 2013 12:38:13 +0100
Message-ID: <CACRpkdarxZN8wqFWsHi+N1VSRo_miyqFtA_FedA=0LceKrTAFA@mail.gmail.com>
Subject: Re: [PATCH 3/4][V2] ARM: nomadik: add dynamic irq flag to the timer
From: Linus Walleij <linus.walleij@linaro.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: john.stultz@linaro.org, tglx@linutronix.de, linus.walleij@stericsson.com,
        viresh.kumar@linaro.org, jacob.jun.pan@linux.intel.com,
        linux-arm-kernel@lists.infradead.org, santosh.shilimkar@ti.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        rickard.andersson@stericsson.com, vincent.guittot@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 8, 2013 at 4:17 PM, Daniel Lezcano
<daniel.lezcano@linaro.org> wrote:
>> Add the dynamic irq affinity feature to the timer clock device.
>>
>> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>> Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
>> Acked-by: Rickard Andersson <rickard.andersson@stericsson.com>
>> ---
>
> Hi Linus,
>
> AFAIU, you are ok with this patch, Rickard acked it and Vincent reviewed it.
>
> Thomas agreed to merge it into its tree as I requested because we will
> need to wait for your tree to gain visibility to this new flag before
> submitting this patch, which can take awhile.
>
> Could you please ack it if it is ok for you ?

Oh of course!
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
