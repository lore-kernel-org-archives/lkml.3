Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357Ab3C0VUb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 17:20:31 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:58799 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab3C0VUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 17:20:30 -0400
MIME-Version: 1.0
In-Reply-To: <CAD6h2NSnnET95sQKhDRcQ064nwJtzWnWXb0j2guQ57ys0+sX4Q@mail.gmail.com>
References: <1363163037-23995-1-git-send-email-haojian.zhuang@linaro.org>
	<CACRpkdasacB-jVtzgKimEWhf0Xhm8u5jAQgN6EqNLkEE_htUrg@mail.gmail.com>
	<CAD6h2NSnnET95sQKhDRcQ064nwJtzWnWXb0j2guQ57ys0+sX4Q@mail.gmail.com>
Date: Wed, 27 Mar 2013 22:20:30 +0100
Message-ID: <CACRpkdY-cpoEG95D9+kkuRBOp4We0_y=YkB=bLkCi0QJoPxA_Q@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: remove pxa pinctrl driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Haojian Zhuang <haojian.zhuang@linaro.org>
Cc: linux-kernel@vger.kernel.org, Patch Tracking <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 2:21 AM, Haojian Zhuang
<haojian.zhuang@linaro.org> wrote:
> On 14 March 2013 03:03, Linus Walleij <linus.walleij@linaro.org> wrote:
>> On Wed, Mar 13, 2013 at 9:23 AM, Haojian Zhuang
>> <haojian.zhuang@linaro.org> wrote:
>>
>>> pinctrl-pxa driver doesn't support well on DT mode. Now pinctrl-single
>>> could support DT mode & pin configuration. Use pinctrl-single driver to
>>> support MMP/PXA silicons instead.
>>>
>>> Signed-off-by: Haojian Zhuang <haojian.zhuang@linaro.org>
>>
>> Is the switch to pinctrl-single already done for these platforms,
>> i.e. the device trees are updated to contain pinctrl-single data?
>>
>> And is ATAG code path removed, so noone needs the old driver?
>>
>> And is the defconfig or Kconfig for PXA/MMP altered to select
>> the single driver instead?
>>
>> Else I cannot merge it...
>>
>> Yours,
>> Linus Walleij
>
> pinctrl-pxa driver is used for PXA/MMP silicons. But the old MFP driver
> also exists and be using. PXA/MMP didn't really switch to pinctrl-pxa
> driver. So it doesn't matter to remove pinctrl-pxa.
>
> In the Kconfig, PXA/MMP already selected to pinctrl-single driver instead.

OK then, patch applied!

Sorry for slowness on getting back on this.

Yours,
Linus Walleij
