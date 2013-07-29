Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab3G2VMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 17:12:16 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:52658 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888Ab3G2VMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 17:12:14 -0400
MIME-Version: 1.0
In-Reply-To: <51F6D88B.80202@gmail.com>
References: <1375130839-5523-1-git-send-email-jwerner@chromium.org>
	<51F6D88B.80202@gmail.com>
Date: Mon, 29 Jul 2013 14:12:13 -0700
X-Google-Sender-Auth: H3r3nKSsn9xKRQTGkSP1uGqPqX0
Message-ID: <CAODwPW-hxtazAO=scZR+ZWK5hwdWMQXFBeYLd1qqau+a9tMCvA@mail.gmail.com>
Subject: Re: [PATCH] usb: phy-samsung-usb: Simplify PMU register handling
From: Julius Werner <jwerner@chromium.org>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Julius Werner <jwerner@chromium.org>, Felipe Balbi <balbi@ti.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-samsung-soc@vger.kernel.org,
        Tomasz Figa <t.figa@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>, devicetree@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> -       if (sphy->phy_type == USB_PHY_TYPE_DEVICE) {
>> -               reg = sphy->pmuregs + sphy->drv_data->devphy_reg_offset;
>> -               en_mask = sphy->drv_data->devphy_en_mask;
>> -       } else if (sphy->phy_type == USB_PHY_TYPE_HOST) {
>> -               reg = sphy->pmuregs + sphy->drv_data->hostphy_reg_offset;
>> -               en_mask = sphy->drv_data->hostphy_en_mask;
>> -       }
>
>
> How is en_mask supposed to get initialized, now when this code is removed ?
> It's always 0 now, isn't it ?
>

Whoops... oh, I'm really sorry about that. I ported the patch from a
branch with slightly different code there and overlooked this. Thanks
for catching it, will send v2 in a minute.
