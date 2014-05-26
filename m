Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbaEZREi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 13:04:38 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:39101 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbaEZREg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 13:04:36 -0400
Message-ID: <5383741F.8010205@linaro.org>
Date: Mon, 26 May 2014 18:04:31 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>,
        linux-mmc <linux-mmc@vger.kernel.org>, Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v3 06/13] mmc: mmci: Qcomm: Add 3 clock cycle delay after
 register write
References: <1400849362-7007-1-git-send-email-srinivas.kandagatla@linaro.org>	<1400849504-7302-1-git-send-email-srinivas.kandagatla@linaro.org> <CAPDyKFoSjXy8ptyrk_wN3N4Ovvy==HpX9S0n0endsh0Ca2kMtA@mail.gmail.com>
In-Reply-To: <CAPDyKFoSjXy8ptyrk_wN3N4Ovvy==HpX9S0n0endsh0Ca2kMtA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
> I am not sure I like this approach. For each and every writel
> (including pio_writes) you will add a few cpu cycles, since you need
> to  check for "mclk_delayed_writes" no matter of variant.
>

> How about, adding a new function pointer in the struct mmci_host, for
> "writel operations" which you could set up in probe phase instead?
>

Yes, this is an additional check for other variants. I will try the 
function pointer method that you suggested.

Thanks,
srini


> Kind regards
> Ulf Hansson
>
