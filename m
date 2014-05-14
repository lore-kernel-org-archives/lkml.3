Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbaENTVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:21:55 -0400
Received: from exprod7og115.obsmtp.com ([64.18.2.217]:36151 "EHLO
	exprod7og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbaENTVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:21:54 -0400
MIME-Version: 1.0
In-Reply-To: <6334605.NlytHCzYVP@wuerfel>
References: <cover.1400072260.git.anders.berg@avagotech.com>
	<6334605.NlytHCzYVP@wuerfel>
Date: Wed, 14 May 2014 21:21:53 +0200
Message-ID: <CAE0=X_2Fcf=mcx2zKtCqKzFH+Fgwz5C6SEm-DQi_mVAWzh=Zdg@mail.gmail.com>
Subject: Re: [PATCH v3 0/6] Add platform support for LSI AXM55xx
From: Anders Berg <anders.berg@avagotech.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Olof Johansson <olof@lixom.net>, Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 8:56 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 14 May 2014 20:37:55 Anders Berg wrote:
>>
>> This is version 3 of this series to introduces basic platform support for the LSI
>> AXM5516 SoC.
>>
>> No major changes since v2. Ready to be applied to the arm-soc tree?
>
> I think it's good, but I'm not sure if we should put them all into arm-soc.
> There are no dependencies between the drivers that I can see, so why not
> merge the clock and reset drivers through the individual subsystem maintainers?
>
> We can take patches 1/3/4/6, and the others if there is a good reason
> not to have the regular maintainers pick them up.

Sure, that'll work to take 1,3,4,6.

>
> The hip04 platform series is also adding a multi_v7_lpae_defconfig file.
> it would be good to add axxia to that config and also to the regular
> multi_v7_defconfig, but that can be an add-on patch once we have merged
> hip04.

Ok.

Thanks,
Anders
