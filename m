Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbaJ1J7A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 05:59:00 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:32892 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbaJ1J66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 05:58:58 -0400
MIME-Version: 1.0
In-Reply-To: <1413289246-31650-5-git-send-email-k.kozlowski@samsung.com>
References: <1413289246-31650-1-git-send-email-k.kozlowski@samsung.com>
	<1413289246-31650-5-git-send-email-k.kozlowski@samsung.com>
Date: Tue, 28 Oct 2014 10:58:57 +0100
Message-ID: <CACRpkdbL8dn-GVvXU83u_Wx-VKCer-mc6pisZhtPXgBNMo4rtA@mail.gmail.com>
Subject: Re: [PATCH 4/8] power: ab8500: Use power_supply_*() API for accessing
 function attrs
From: Linus Walleij <linus.walleij@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Anton Vorontsov <anton@enomsg.org>, Guenter Roeck <linux@roeck-us.net>,
        Pavel Machek <pavel@ucw.cz>, Myungjoo Ham <myungjoo.ham@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 2:20 PM, Krzysztof Kozlowski
<k.kozlowski@samsung.com> wrote:

> Replace direct calls to power supply function attributes with wrappers.
> Wrappers provide safe access access in case of unregistering the power
> supply (.e.g by removing the driver). Replace:
>  - get_property -> power_supply_get_property
>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
