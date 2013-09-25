Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab3IYUVL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 16:21:11 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:39452 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755311Ab3IYUVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 16:21:09 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Olof Johansson <olof@lixom.net>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, Emilio Lopez <emilio@elopez.com.ar>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] Allwinner SoCs High Speed Timer support
References: <1380117790-19390-1-git-send-email-maxime.ripard@free-electrons.com>
	<87zjr04vnh.fsf@linaro.org>
	<CAOesGMhTZS1MdHW9cL4s_X8jUXHS3VkNZupCfX4ZGroL6k4gEw@mail.gmail.com>
Date: Wed, 25 Sep 2013 13:21:06 -0700
In-Reply-To: <CAOesGMhTZS1MdHW9cL4s_X8jUXHS3VkNZupCfX4ZGroL6k4gEw@mail.gmail.com>
	(Olof Johansson's message of "Wed, 25 Sep 2013 11:14:46 -0700")
Message-ID: <87fvss7ivh.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olof Johansson <olof@lixom.net> writes:

> On Wed, Sep 25, 2013 at 11:13 AM, Kevin Hilman <khilman@linaro.org> wrote:
>
>>> However, the A20 and A31 come with 4 of these high speed timers,
>>> while the A10s
>>> and A13 only have two, hence why we introduce two different compatibles.
>>
>> ...but the A10 has 2?
>>
>> -ECONFUSED
>
> A10s != A10. Yes, confusing. :)

Aaaaaah.  Silly me for thinking that the trailing 's' meant plural.

Thanks for clarifying.

Kevin
