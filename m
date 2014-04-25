Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbaDYA2b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 20:28:31 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:34505 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230AbaDYA23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 20:28:29 -0400
MIME-Version: 1.0
In-Reply-To: <CAL_JsqKo0uV9_SX5aAfgPyRSa0Cv5O=tdp4s1oSQs=76vZC+ww@mail.gmail.com>
References: <1398130543-19454-1-git-send-email-haojian.zhuang@linaro.org>
	<CAL_JsqKo0uV9_SX5aAfgPyRSa0Cv5O=tdp4s1oSQs=76vZC+ww@mail.gmail.com>
Date: Fri, 25 Apr 2014 08:28:28 +0800
Message-ID: <CAD6h2NSZY5PNEmRVzVBuBnU_QoKVJ8WGyw4yxOQpcGRMEB_tMw@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: pl061: get gpio base from alias id
From: Haojian Zhuang <haojian.zhuang@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Xu Wei <xuwei5@hisilicon.com>, Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Baruch Siach <baruch@tkos.co.il>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 April 2014 02:52, Rob Herring <robherring2@gmail.com> wrote:
> On Mon, Apr 21, 2014 at 8:35 PM, Haojian Zhuang
> <haojian.zhuang@linaro.org> wrote:
>> If gpio base number isn't specified, the gpio base will be find from
>> the end of gpio number. In order to keep with schematics, use alias
>> to get the ID of gpio chip.
>
> NAK. This is an abuse aliases.
>
>> Signed-off-by: Haojian Zhuang <haojian.zhuang@linaro.org>
>> ---
>>  .../devicetree/bindings/gpio/gpio-pl061.txt        | 31 ++++++++++++++++++++++
>
> Is something wrong with the binding doc already in pl061-gpio.txt?
>
Oh. I just copy my old patch to here. I didn't notice there's a new
pl061-gpio.txt. Thanks for reminder.

Regards
Haojian
