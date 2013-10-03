Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab3JCSBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 14:01:35 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:59686 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789Ab3JCSBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 14:01:33 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <CAAQKjZPwyKCpju4Ndd+MB_aN24-zA5xTHFsFsun2617h7YT6dw@mail.gmail.com>
References: <1380670860-17621-1-git-send-email-seanpaul@chromium.org>
	<1380670860-17621-4-git-send-email-seanpaul@chromium.org>
	<CAAQKjZN_r-=-sj=Vb-o-KUS4ab5=cjCq1ni3VZeMeVc3NL=MMg@mail.gmail.com>
	<CAOw6vbLiJLLKn=gb1=j5TBeM0ijEK13+goG-=mw7MZTyNT1kpQ@mail.gmail.com>
	<CAAQKjZPwyKCpju4Ndd+MB_aN24-zA5xTHFsFsun2617h7YT6dw@mail.gmail.com>
Date: Thu, 3 Oct 2013 11:01:30 -0700
Message-ID: <CAOesGMgKastzdFHYQzyL8gxkBN=86wFZ4jbgP8BHxfkOuZvJxg@mail.gmail.com>
Subject: Re: [PATCH 3/5] drm/bridge: Add PTN3460 bridge driver
From: Olof Johansson <olof@lixom.net>
To: Inki Dae <inki.dae@samsung.com>
Cc: Sean Paul <seanpaul@chromium.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 3, 2013 at 10:39 AM, Inki Dae <inki.dae@samsung.com> wrote:
> 2013/10/3 Sean Paul <seanpaul@chromium.org>:
>> On Thu, Oct 3, 2013 at 9:55 AM, Inki Dae <inki.dae@samsung.com> wrote:
>>> Can a regulator be used instead of gpio in other board case?
>>>
>>
>> No, not to my knowledge.
>>
>
> Hm.. plz check it out again. the gpio pin is specific to board, and
> the the gpio be used as power source trigger could be replaced with a
> regulator according to board design. So you should consider all
> possibilities even though there are no other cases yet: other board
> could  use a regulator instead.

Take a look at the data sheet, it is publicly available.

PD_N is not a power supply input, so modelling it as a regulator makes no sense:

"If PD_N is LOW, then the device is in Deep power-down completely,
even if supply rail is ON; for the device to be able to operate, the
PD_N pin must be HIGH."



-Olof
