Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbaD1Gf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 02:35:27 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:35697 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaD1GfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 02:35:24 -0400
MIME-Version: 1.0
In-Reply-To: <20140312192037.GC28891@katana>
References: <1385100851-32254-1-git-send-email-ch.naveen@samsung.com>
 <1391748195-12490-1-git-send-email-ch.naveen@samsung.com> <20140312192037.GC28891@katana>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Mon, 28 Apr 2014 12:05:02 +0530
Message-ID: <CAHfPSqCg-BqezXCTfDjtKwvaD3G8Ej79OCFKAfshfO0uZvyewg@mail.gmail.com>
Subject: Re: [PATCH 2/2 v4] i2c: exynos5: configure fifo_depth based on HSI2C
 module variant
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

On 13 March 2014 00:50, Wolfram Sang <wsa@the-dreams.de> wrote:
> On Fri, Feb 07, 2014 at 10:13:15AM +0530, Naveen Krishna Chatradhi wrote:
>> fifo_depth of the HSI2C is not constant
>> Exynos5420 and Exynos5250 supports fifo_depth of 64bytes
>> Exynos5260 supports fifo_depth of 16bytes.
>>
>> This patch configures the fifo_depth based on HSI2C modules version.
>>
>> Signed-off-by: Naveen Krishna Chatradhi <ich.naveen@samsung.com>
>> [For finding out the difference and initial contribution]
>> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
>
> I know Tomasz said differently, but I prefer the patches squashed (and
> the commit message extended).
Please accept my apologies for coming back late on this CL.
Will squash and fix the compilation error and submit.

Thanks,
>



-- 
Shine bright,
(: Nav :)
