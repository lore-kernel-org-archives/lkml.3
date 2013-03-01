Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454Ab3CAI4n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 03:56:43 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63229 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab3CAI4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 03:56:41 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkda=i5cXSbYCyb0gH0OLKj7396qguup1nqgqn0m-S1x1wg@mail.gmail.com>
References: <1361917047-29230-1-git-send-email-daniel.lezcano@linaro.org>
	<1361917047-29230-4-git-send-email-daniel.lezcano@linaro.org>
	<CACRpkda=i5cXSbYCyb0gH0OLKj7396qguup1nqgqn0m-S1x1wg@mail.gmail.com>
Date: Fri, 1 Mar 2013 09:56:39 +0100
Message-ID: <CAKfTPtA=7pTPrwFHr61WiffXGv2Ztmaiji5q_vJpPj9XgyeZMg@mail.gmail.com>
Subject: Re: [PATCH 3/4] ARM: nomadik: add dynamic irq flag to the timer
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Rickard ANDERSSON <rickard.andersson@stericsson.com>,
        john.stultz@linaro.org, tglx@linutronix.de,
        jacob.jun.pan@linux.intel.com, linus.walleij@stericsson.com,
        linux-pm@vger.kernel.org, viresh.kumar@linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 March 2013 02:13, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Tue, Feb 26, 2013 at 11:17 PM, Daniel Lezcano
> <daniel.lezcano@linaro.org> wrote:
>
>> Add the dynamic irq affinity feature to the timer clock device.
>>
>> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>
> Looks reasonable to me, sadly I do not fully grasp the patch set,
> Vincent+Rickard can you have a look at this?

ux500 is able to trig the wake up on one CPU and let the other one in
WFI. This patch will minimize the spurious wake up of CPU0 when CPU1
is the target CPU of the broadcast timer. One main consequence is that
we will not uselessly execute all the deferrable and newly idle
activities on the CPU0 .

you can add my reviewed-by if you want

Vincent

>
> Yours,
> Linus Walleij
