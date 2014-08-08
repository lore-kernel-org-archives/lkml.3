Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848AbaHHNz4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 09:55:56 -0400
Received: from mail-oi0-f52.google.com ([209.85.218.52]:55373 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756795AbaHHNzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 09:55:54 -0400
MIME-Version: 1.0
In-Reply-To: <53E4600C.4030505@de.bosch.com>
References: <1407435706-19441-1-git-send-email-mathieu.poirier@linaro.org>
	<1407435706-19441-8-git-send-email-mathieu.poirier@linaro.org>
	<53E4600C.4030505@de.bosch.com>
Date: Fri, 8 Aug 2014 07:55:54 -0600
Message-ID: <CANLsYkzDbOyBbqMCp41nt6e84MSCJTWnRDZ0JBJ1jYgtL3ZPFA@mail.gmail.com>
Subject: Re: [PATCH 07/10 v3] coresight-etm: add CoreSight ETM/PTM driver
From: Mathieu Poirier <mathieu.poirier@linaro.org>
To: Dirk Behme <dirk.behme@de.bosch.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rob Herring <robherring2@gmail.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Robert Marklund <robbelibobban@gmail.com>, Al Grant <Al.Grant@arm.com>,
        Patch Tracking <patches@linaro.org>,
        Marcin Jabrzyk <marcin.jabrzyk@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Panchaxari Prasannamurthy Tumkur 
	<panchaxari.prasannamurthy@linaro.org>,
        "r.sengupta@samsung.com" <r.sengupta@samsung.com>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        Tony Armitstead <Tony.Armitstead@arm.com>,
        John Stultz <john.stultz@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        James King <james.king@linaro.org>,
        Pratik Patel <pratikp@codeaurora.org>,
        Vikas Varshney <varshney@ti.com>,
        Jonas Svennebring <jonas.svennebring@avagotech.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 August 2014 23:28, Dirk Behme <dirk.behme@de.bosch.com> wrote:
> On 07.08.2014 20:21, mathieu.poirier@linaro.org wrote:
>>
>> From: Pratik Patel <pratikp@codeaurora.org>
>>
>> This driver manages CoreSight ETM (Embedded Trace Macrocell) that
>> supports processor tracing. Currently supported version are ARM
>> ETMv3.x and PTM1.x.
>>
>> Signed-off-by: Pratik Patel <pratikp@codeaurora.org>
>> Signed-off-by: Panchaxari Prasannamurthy
>> <panchaxari.prasannamurthy@linaro.org>
>> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
>> ---
>
> ...
>>
>> +static struct amba_id etm_ids[] = {
>> +       {       /* ETM 3.3 */
>> +               .id     = 0x0003b921,
>> +               .mask   = 0x0003ffff,
>> +       },
>> +       {       /* ETM 3.5 */
>> +               .id     = 0x0003b956,
>> +               .mask   = 0x0003ffff,
>> +       },
>> +       {       /* PTM */
>> +               .id     = 0x0003b95f,
>> +               .mask   = 0x0003ffff,
>> +       },
>> +       { 0, 0},
>
>
> Maybe you like to add PTM 1.0 [1] here, too?

You got it.
