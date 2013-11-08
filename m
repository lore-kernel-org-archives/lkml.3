Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab3KHJhn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 04:37:43 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:51704 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab3KHJhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 04:37:40 -0500
MIME-Version: 1.0
In-Reply-To: <1402665.MHsL7r71dU@flatron>
References: <1381869563-16083-1-git-send-email-grant.likely@linaro.org>
 <1773667.KXPxL5WsyI@amdc1227> <CAL_JsqKUaioiz2dw3Sr8f7UfqzjagWH_je2-u_QGYXRK5g1=yg@mail.gmail.com>
 <1402665.MHsL7r71dU@flatron>
From: Grant Likely <grant.likely@linaro.org>
Date: Fri, 8 Nov 2013 09:37:19 +0000
X-Google-Sender-Auth: J_uojuomQqGNf2uV6wHeElQ0HDs
Message-ID: <CACxGe6tNwBHgM=Yr+mtSiwAdTg_90_j-7RUY93QOry9VTAYxUQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] of: irq: Fix interrupt-map entry matching
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Rob Herring <robherring2@gmail.com>, Tomasz Figa <t.figa@samsung.com>,
        Olof Johansson <olof@lixom.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 7, 2013 at 10:11 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> On Thursday 07 of November 2013 10:40:16 Rob Herring wrote:
>> On Thu, Nov 7, 2013 at 5:32 AM, Tomasz Figa <t.figa@samsung.com> wrote:
>> > Hi Grant,
>> >
>> > Could you pick this patch up? It fixes boot-up at least on several
>> > Exynos based platforms, which use interrupt-map nodes with
>> > #interrupt-cells higher than 1.
>> >
>> > Also please disregard patch 2/2, as your fix that has been merged
>> > seems
>> > to be fine.
>>
>> I've applied the 1st patch.
>
> Thanks Rob.

Thanks Rob and Tomasz. That was definitely a brown-paper-bag mistake on my part.

g.
