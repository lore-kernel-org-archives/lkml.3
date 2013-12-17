Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab3LQW3w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 17:29:52 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:63365 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283Ab3LQW3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 17:29:50 -0500
MIME-Version: 1.0
In-Reply-To: <20131217210403.GA1196@katana>
References: <20131217023745.24573.3660.sendpatchset@w520>
	<20131217023804.24573.82351.sendpatchset@w520>
	<20131217210403.GA1196@katana>
Date: Wed, 18 Dec 2013 07:29:48 +0900
Message-ID: <CANqRtoRn--Ze3ayoag71iYTKXEG1eNa8qyXEAJ7vCZhRo5yHPw@mail.gmail.com>
Subject: Re: [PATCH 02/05 v2] pinctrl: sh-pfc: r7s72100 base support
From: Magnus Damm <magnus.damm@gmail.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        "Simon Horman [Horms]" <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

On Wed, Dec 18, 2013 at 6:04 AM, Wolfram Sang <wsa@the-dreams.de> wrote:
> Hi,
>
>> +#define _P_DATA(bank, pin, name, sfx)                                        \
>> +     PINMUX_DATA(name##_DATA, name##_PMC_0, name##_PIPC_0,           \
>> +                 name##_PIBC_1, name##_PBDC_1)
>> +
>> +#define _P_FN(n, fn, pfcae, pfce, pfc)                                       \
>> +     PINMUX_DATA(n##_MARK_FN##fn, n##_PMC_1, n##_PIPC_1,             \
>> +                 n##_PFCAE_##pfcae, n##_PFCE_##pfce, n##_PFC_##pfc)
>
> I need to apply this patch, otherwise my i2c pinmuxing fails?

Thanks. It looks to me like the _P_FN() bits would be mainly needed.
Can you try to omit the _P_DATA() portion and check if it is still
behaving as expected?

Cheers,

/ magnus
