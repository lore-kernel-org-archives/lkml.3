Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab3CABNc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 20:13:32 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:48488 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab3CABN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 20:13:29 -0500
MIME-Version: 1.0
In-Reply-To: <1361917047-29230-4-git-send-email-daniel.lezcano@linaro.org>
References: <1361917047-29230-1-git-send-email-daniel.lezcano@linaro.org>
	<1361917047-29230-4-git-send-email-daniel.lezcano@linaro.org>
Date: Fri, 1 Mar 2013 02:13:29 +0100
Message-ID: <CACRpkda=i5cXSbYCyb0gH0OLKj7396qguup1nqgqn0m-S1x1wg@mail.gmail.com>
Subject: Re: [PATCH 3/4] ARM: nomadik: add dynamic irq flag to the timer
From: Linus Walleij <linus.walleij@linaro.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Rickard ANDERSSON <rickard.andersson@stericsson.com>
Cc: john.stultz@linaro.org, tglx@linutronix.de, jacob.jun.pan@linux.intel.com,
        linus.walleij@stericsson.com, linux-pm@vger.kernel.org,
        viresh.kumar@linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 11:17 PM, Daniel Lezcano
<daniel.lezcano@linaro.org> wrote:

> Add the dynamic irq affinity feature to the timer clock device.
>
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>

Looks reasonable to me, sadly I do not fully grasp the patch set,
Vincent+Rickard can you have a look at this?

Yours,
Linus Walleij
