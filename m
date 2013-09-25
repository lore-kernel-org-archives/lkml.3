Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab3IYSVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 14:21:16 -0400
Received: from mail-qe0-f45.google.com ([209.85.128.45]:46135 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab3IYSVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 14:21:15 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <87zjr04vnh.fsf@linaro.org>
References: <1380117790-19390-1-git-send-email-maxime.ripard@free-electrons.com>
	<87zjr04vnh.fsf@linaro.org>
Date: Wed, 25 Sep 2013 11:14:46 -0700
Message-ID: <CAOesGMhTZS1MdHW9cL4s_X8jUXHS3VkNZupCfX4ZGroL6k4gEw@mail.gmail.com>
Subject: Re: [PATCH 0/5] Allwinner SoCs High Speed Timer support
From: Olof Johansson <olof@lixom.net>
To: Kevin Hilman <khilman@linaro.org>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, Emilio Lopez <emilio@elopez.com.ar>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 11:13 AM, Kevin Hilman <khilman@linaro.org> wrote:

>> However, the A20 and A31 come with 4 of these high speed timers, while the A10s
>> and A13 only have two, hence why we introduce two different compatibles.
>
> ...but the A10 has 2?
>
> -ECONFUSED

A10s != A10. Yes, confusing. :)


-Olof
