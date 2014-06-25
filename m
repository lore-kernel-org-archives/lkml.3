Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435AbaFYP0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 11:26:53 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:56844 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559AbaFYP0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 11:26:52 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <53AAE603.500@st.com>
References: <1401195188-23677-1-git-send-email-lee.jones@linaro.org>
	<20140625145354.GK13518@lee--X1>
	<53AAE603.500@st.com>
Date: Wed, 25 Jun 2014 08:26:51 -0700
Message-ID: <CAOesGMiR1tKZH7BeZUuiAPUsw=oRnUg6q--Nby+RROd=p6zMaA@mail.gmail.com>
Subject: Re: [PATCH] ARM: STi: DT: STiH41x: Convert all uppercase non-defines
 to lowercase
From: Olof Johansson <olof@lixom.net>
To: Maxime Coquelin <maxime.coquelin@st.com>
Cc: Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`On Wed, Jun 25, 2014 at 8:08 AM, Maxime Coquelin
<maxime.coquelin@st.com> wrote:
>
>
> On 06/25/2014 04:53 PM, Lee Jones wrote:
>>> Suggested-by: Olof Johansson <olof@lixom.net>
>>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
>>> ---
>>>  arch/arm/boot/dts/stih415-pinctrl.dtsi   | 340 +++++++++++++++---------------
>>>  arch/arm/boot/dts/stih416-b2020-revE.dts |   6 +-
>>>  arch/arm/boot/dts/stih416-pinctrl.dtsi   | 342 +++++++++++++++----------------
>>>  arch/arm/boot/dts/stih41x-b2000.dtsi     |   6 +-
>>>  arch/arm/boot/dts/stih41x-b2020.dtsi     |   6 +-
>>>  5 files changed, 350 insertions(+), 350 deletions(-)
>>
>> What happened to this Maxime?
>>
>> It was Acked by Olof, then died.  Did it slip through the net?
>>
>
> You sent it to the ML after my last pull request for v3.16.
> I think to take it for v3.17, but maybe you think it can go in next v3.16 rc?
> If so, maybe Arnd or Olof can pick it directly, since we only have this single
> patch for v3.16 fixes currently?

If you have only one patch, then please send it to us as a fresh copy
with git send-email to arm@kernel.org + the usual lists.

You need to apply it and test it on hardware before anyway, right? We
certainly can't do that for you.



-Olof
