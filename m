Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782AbaDWSwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 14:52:24 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:45728 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665AbaDWSwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 14:52:21 -0400
MIME-Version: 1.0
In-Reply-To: <1398130543-19454-1-git-send-email-haojian.zhuang@linaro.org>
References: <1398130543-19454-1-git-send-email-haojian.zhuang@linaro.org>
Date: Wed, 23 Apr 2014 13:52:20 -0500
Message-ID: <CAL_JsqKo0uV9_SX5aAfgPyRSa0Cv5O=tdp4s1oSQs=76vZC+ww@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: pl061: get gpio base from alias id
From: Rob Herring <robherring2@gmail.com>
To: Haojian Zhuang <haojian.zhuang@linaro.org>
Cc: xuwei5@hisilicon.com, Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        baruch@tkos.co.il
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 8:35 PM, Haojian Zhuang
<haojian.zhuang@linaro.org> wrote:
> If gpio base number isn't specified, the gpio base will be find from
> the end of gpio number. In order to keep with schematics, use alias
> to get the ID of gpio chip.

NAK. This is an abuse aliases.

> Signed-off-by: Haojian Zhuang <haojian.zhuang@linaro.org>
> ---
>  .../devicetree/bindings/gpio/gpio-pl061.txt        | 31 ++++++++++++++++++++++

Is something wrong with the binding doc already in pl061-gpio.txt?

Rob
