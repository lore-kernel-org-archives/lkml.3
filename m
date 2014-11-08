Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365AbaKHTzv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 14:55:51 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:62622 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaKHTzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 14:55:50 -0500
MIME-Version: 1.0
In-Reply-To: <87lhnlwqm4.fsf@free.fr>
References: <1414941415-13146-1-git-send-email-robert.jarzmik@free.fr>
	<CALT56yOCBN1NAfNw=vThVZ_o=ONGOTvzKHBH5tCTQShJY0wkrQ@mail.gmail.com>
	<87lhnlwqm4.fsf@free.fr>
Date: Sat, 8 Nov 2014 23:55:49 +0400
Message-ID: <CALT56yNOXq-ssvsjafz=ae+uWv1GyscoQ3RQ_h--i740zm4trA@mail.gmail.com>
Subject: Re: [PATCH v1 0/3] Transition pxa25x clock to common clocks
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mike Turquette <mturquette@linaro.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Ian Molton <ian.molton@codethink.co.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Daniel Mack <zonque@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-08 20:26 GMT+03:00 Robert Jarzmik <robert.jarzmik@free.fr>:
> Dmitry Eremin-Solenikov <dbaryshkov@gmail.com> writes:
>
>> Hello,
>> Tested in qemu (pxa25x target).
>>
>> 2) sa1100-rtc could not find a clock and thus failed to be probed.
>> 4) Got an issue with IrDA driver - it gets -ENODEV for UARTCLK clock
>
> Hi Dmitry,
>
> Would you mind retesting with the patch in [1] applied to see if points 2 and 4
> are fixed ? Alternatively you can refetch from the github tree, I included that
> incremental patch there too.
>
> If it works correctly for you, could I have your Tested-by ? If not, tell me and
> I'll try to figure out what's wrong.

Tested in qemu, everything works fine. I will test on the real hardware tomorow.

BTW: It looks like pxa27x also shows the same behaviour wrt. sa1100-rtc and
pxa2xx-ir (after reverting a revert).

-- 
With best wishes
Dmitry
