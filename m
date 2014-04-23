Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbaDWPsP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:48:15 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:42907 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217AbaDWPsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:48:08 -0400
MIME-Version: 1.0
In-Reply-To: <20140423115102.GO21613@lee--X1>
References: <1397689950-1568-1-git-send-email-dianders@chromium.org>
	<1397689950-1568-5-git-send-email-dianders@chromium.org>
	<20140423115102.GO21613@lee--X1>
Date: Wed, 23 Apr 2014 08:48:07 -0700
X-Google-Sender-Auth: 7Ya3Emo-diaoTfF_mMfgCxmKkHI
Message-ID: <CAD=FV=WN4hVibiK_8+mpNfO7UQnd35ZT9EXA9fuw-mnBzzb1cA@mail.gmail.com>
Subject: Re: [PATCH v3 4/5] regulator: tps65090: Allow setting the overcurrent
 wait time
From: Doug Anderson <dianders@chromium.org>
To: Lee Jones <lee.jones@linaro.org>, Mark Brown <broonie@kernel.org>
Cc: Anton Vorontsov <anton@enomsg.org>, Olof Johansson <olof@lixom.net>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        AJAY KUMAR RAMAKRISHNA SHYMALAMMA <ajaykumar.rs@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Simon Glass <sjg@chromium.org>, Michael Spang <spang@chromium.org>,
        Sean Paul <seanpaul@chromium.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lee,

On Wed, Apr 23, 2014 at 4:51 AM, Lee Jones <lee.jones@linaro.org> wrote:
>> The tps65090 regulator allows you to specify how long you want it to
>> wait before detecting an overcurrent condition.  Allow specifying that
>> through the device tree (or through platform data).
>>
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> Signed-off-by: Simon Glass <sjg@chromium.org>
>> Signed-off-by: Michael Spang <spang@chromium.org>
>> Signed-off-by: Sean Paul <seanpaul@chromium.org>
>> ---
>> Changes in v3:
>> - Fixed kernel-doc notation for return
>>
>> Changes in v2:
>> - Separated the overcurrent and retries changes into two patches.
>> - Now set overcurrent at probe time since it doesn't change.
>>
>>  .../devicetree/bindings/regulator/tps65090.txt     |  4 ++
>>  drivers/regulator/tps65090-regulator.c             | 56 ++++++++++++++++++++++
>>  include/linux/mfd/tps65090.h                       |  5 ++
>>  3 files changed, 65 insertions(+)
>
> Applied, thanks.

Ummmm, Mark said that he had already applied this patch to his tree (I
mentioned it in my recent summary and you can see it in this thread
too).  I don't see it on git.kernel.org though
<https://git.kernel.org/cgit/linux/kernel/git/broonie/regulator.git/log/?h=for-next>

I'm worried this will cause a merge conflict if you both apply it.

-Doug
