Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbaAJKPa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 05:15:30 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:56944 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbaAJKP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 05:15:28 -0500
MIME-Version: 1.0
In-Reply-To: <20140110100342.GC28141@lee--X1>
References: <1389266554-23463-1-git-send-email-sachin.kamat@linaro.org>
	<20140110100342.GC28141@lee--X1>
Date: Fri, 10 Jan 2014 15:45:27 +0530
Message-ID: <CAK9yfHx2peeKT1Z6RELp6BzSPY7Srt3x_ves=tenRGmJrsRE7Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] mfd: Add support for S2MPA01 device
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Patch Tracking <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 January 2014 15:33, Lee Jones <lee.jones@linaro.org> wrote:
>> Add the necessary entries required for S2MPA01 multi-function
>> device. While at it also convert whitespaces to tabs in core.h.
>>
>> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
>> ---
>> * Fixed nits pointed out by Lee.
>> ---
>>  drivers/mfd/sec-core.c              |   45 +++++++-
>>  include/linux/mfd/samsung/core.h    |   16 ++-
>>  include/linux/mfd/samsung/irq.h     |   50 +++++++++
>>  include/linux/mfd/samsung/s2mpa01.h |  192 +++++++++++++++++++++++++++++++++++
>>  4 files changed, 295 insertions(+), 8 deletions(-)
>>  create mode 100644 include/linux/mfd/samsung/s2mpa01.h
>
> Acked-by: Lee Jones <lee.jones@linaro.org>

Thanks Lee.
Btw, how do you plan to handle these patches? Mark has already ack'd
the regulator patch.


-- 
With warm regards,
Sachin
