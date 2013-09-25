Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab3IYSNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 14:13:25 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:54365 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab3IYSNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 14:13:24 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        Emilio Lopez <emilio@elopez.com.ar>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] Allwinner SoCs High Speed Timer support
References: <1380117790-19390-1-git-send-email-maxime.ripard@free-electrons.com>
Date: Wed, 25 Sep 2013 11:13:22 -0700
In-Reply-To: <1380117790-19390-1-git-send-email-maxime.ripard@free-electrons.com>
	(Maxime Ripard's message of "Wed, 25 Sep 2013 17:03:05 +0300")
Message-ID: <87zjr04vnh.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maxime Ripard <maxime.ripard@free-electrons.com> writes:

> Hi everyone,
>
> Here is a few patches adding support for the High Speed Timers running on the
> Allwinner SoCs.
>
> These timers are 64 bits timers running at a much higher speed than the timers
> used for now on these SoCs, since they are no longer wired to the 24MHz
> oscillator, but to the AHB clock.
>
> This HS timers are actually found in all the supported SoCs but the A10.

hmm, timers not found in the A10...

> However, the A20 and A31 come with 4 of these high speed timers, while the A10s
> and A13 only have two, hence why we introduce two different compatibles.

...but the A10 has 2?

-ECONFUSED

Kevin
