Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbaD1IQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 04:16:27 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:50343 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbaD1IQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 04:16:15 -0400
MIME-Version: 1.0
In-Reply-To: <20140312191851.GB28891@katana>
References: <1385100726-32165-1-git-send-email-ch.naveen@samsung.com>
 <1391748171-12451-1-git-send-email-ch.naveen@samsung.com> <20140312191851.GB28891@katana>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Mon, 28 Apr 2014 13:45:54 +0530
Message-ID: <CAHfPSqDAUpJWO3Udnjxim-LRY_hjW4+W2j5eTm+Xuk_Np+jhFA@mail.gmail.com>
Subject: Re: [PATCH 1/2 v4] i2c: exynos5: add support for HSI2C on Exynos5260 SoC
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Wolfram,

On 13 March 2014 00:48, Wolfram Sang <wsa@the-dreams.de> wrote:
> On Fri, Feb 07, 2014 at 10:12:51AM +0530, Naveen Krishna Chatradhi wrote:
>> This patch adds a new compatible and uses variant struct to support
>> HSI2C module on Exynos5260. Updates the Documentation dt bindings.
>> Also resets the module as an init sequence (Needed by Exynos5260).
>>
>> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>
> This patch has clearly not been tested :( Build failure!
comma was missing, Not sure, how i missed it.
Will fix it.
>
>> +struct exynos_hsi2c_variant {
>> +     unsigned int                fifo_depth;
>> +};
>
> Why so many tabs? In general, I'd prefer one space.
>
>> -     exynos5_i2c_init(i2c);
>> +     exynos5_i2c_reset(i2c);
>
> Is this a related change?
Exynos5260 needs the HSI2C module to be reset during the init.
As per Tomasz's comment on earlier version. We will reset the status
during init for every SoC.
>



-- 
Shine bright,
(: Nav :)
