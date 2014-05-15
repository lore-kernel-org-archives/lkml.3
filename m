Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023AbaEOOuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 10:50:40 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:65353 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbaEOOui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 10:50:38 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkda6+0LyHsqP5J-OTHaau1QPJaJRAup1d3KQq5zu2XC=HA@mail.gmail.com>
References: <1397756521-29387-1-git-send-email-leif.lindholm@linaro.org>
 <1397756521-29387-2-git-send-email-leif.lindholm@linaro.org> <CACRpkda6+0LyHsqP5J-OTHaau1QPJaJRAup1d3KQq5zu2XC=HA@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 15 May 2014 15:50:17 +0100
X-Google-Sender-Auth: 2Sffo3ofLralklHcHzsQAjCQohM
Message-ID: <CACxGe6sfjZxCuOTHwRswWW2rMQ_gJyxS+R=+5HQHnzT-BNzekg@mail.gmail.com>
Subject: Re: [PATCH 1/3] arm: dts: add device_type="memory" for ste-ccu8540
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Leif Lindholm <leif.lindholm@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Patch Tracking <patches@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 2:26 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Thu, Apr 17, 2014 at 7:41 PM, Leif Lindholm <leif.lindholm@linaro.org> wrote:
>
>> The current .dts for ste-ccu8540 lacks a 'device_type = "memory"' for
>> its memory node, relying on an old ppc quirk in order to discover its
>> memory. Add this, to permit that quirk to be made ppc only.
>>
>> Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: devicetree@vger.kernel.org
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Lee Jones <lee.jones@linaro.org>
>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>
> There are no systems like this deployed so this patch set will not
> affect anything in the wild.

I may as well take all three of these patches through my tree (I've
changed my mind on the last one). There are actually not a huge number
of systems with ram starting at 0, so the impact is contained.

Applied, thanks.

g.
