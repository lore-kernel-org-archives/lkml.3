Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbaEVWJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 18:09:37 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:47415 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbaEVWJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 18:09:36 -0400
MIME-Version: 1.0
In-Reply-To: <1400520995-27365-7-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1400520995-27365-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1400520995-27365-7-git-send-email-sebastian.hesselbarth@gmail.com>
Date: Fri, 23 May 2014 00:09:35 +0200
Message-ID: <CACRpkdbP++c+3LPOZ2LPbuEuxQorvYv0atROU_oD=uu4Nzyy7Q@mail.gmail.com>
Subject: Re: [PATCH v4 6/7] dt-binding: ARM: add pinctrl binding docs for
 Marvell Berlin2 SoCs
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        zhiming Xu <zmxu@marvell.com>, Jisheng Zhang <jszhang@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 7:36 PM, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:

> From: Antoine Tenart <antoine.tenart@free-electrons.com>
>
> Add pin control binding documentation to the SoC binding documentaion
> as pinctrl is part of chip/system control registers. The documentation
> also explains how to configure this group based controller.
>
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Changelog:
> v3->v4:
> - move documentation of an exclusive pinctrl node to the Berlin SoC
>   binding documentation of chip/system control nodes instead.
> - remove "marvell," prefix from pinctrl function/groups property

This patch does not apply to my tree, obviously there are dependencies.

Take it wherever it works:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
