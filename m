Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbaDYA1o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 20:27:44 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:42880 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502AbaDYA1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 20:27:41 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdbzoPNEEJ6UbisqHOiRwuxEb6XSrDL=MiUmDPgyY=rVuw@mail.gmail.com>
References: <1398130543-19454-1-git-send-email-haojian.zhuang@linaro.org>
	<CACRpkdbzoPNEEJ6UbisqHOiRwuxEb6XSrDL=MiUmDPgyY=rVuw@mail.gmail.com>
Date: Fri, 25 Apr 2014 08:27:40 +0800
Message-ID: <CAD6h2NQ4XdpE+HnTVpuSE4jW3-5_UqJmEJJcAkpD3xxqJKy3aA@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: pl061: get gpio base from alias id
From: Haojian Zhuang <haojian.zhuang@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@linaro.org>, Xu Wei <xuwei5@hisilicon.com>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Baruch Siach <baruch@tkos.co.il>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 April 2014 21:21, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Tue, Apr 22, 2014 at 3:35 AM, Haojian Zhuang
> <haojian.zhuang@linaro.org> wrote:
>
>> If gpio base number isn't specified, the gpio base will be find from
>> the end of gpio number. In order to keep with schematics, use alias
>> to get the ID of gpio chip.
>>
>> Signed-off-by: Haojian Zhuang <haojian.zhuang@linaro.org>
>
> The idea with GPIO numbers is not that these shall correspond
> to schematics or data sheets or anything like that. It's a completely
> Linux-internal number and has nothing to do with anything else.
>
> The same is true for IRQ numbers.
>
> The long term goal is to get rid of both GPIO and IRQ numbers
> and deal only with descriptors in the kernel.

Go it. But the gpio sysfs interface is using the gpio name with an
internal number. It'll make developer confusion since it's different
from datasheet
or schematics. Is there any plan to remove the confusion?

Regards
Haojian
