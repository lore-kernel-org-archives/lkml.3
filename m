Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbaCJJ4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 05:56:41 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:48804 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbaCJJ4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 05:56:37 -0400
MIME-Version: 1.0
In-Reply-To: <20140310093551.GE14976@lee--X1>
References: <1394100057-32677-1-git-send-email-sachin.kamat@linaro.org>
	<1394100057-32677-2-git-send-email-sachin.kamat@linaro.org>
	<1394102406.25853.4.camel@AMDC1943>
	<CAK9yfHyv+PhLCfy131KCS4GWaAEgQ9qmS5X27bTYHWYUspkYjA@mail.gmail.com>
	<20140310093551.GE14976@lee--X1>
Date: Mon, 10 Mar 2014 15:26:37 +0530
Message-ID: <CAK9yfHy9iwCa7JPHTtJNw0pYhehUCd-GLPSW3Gw0G36ELBqsrA@mail.gmail.com>
Subject: Re: [PATCH v3 Resend 2/3] regulator: Add support for S2MPA01 regulator
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On 10 March 2014 15:05, Lee Jones <lee.jones@linaro.org> wrote:
>> >> Add support for S2MPA01 voltage and current regulator.
>>
>> >> +
>> >> +struct s2mpa01_info {
>> >> +     struct regulator_dev *rdev[S2MPA01_REGULATOR_MAX];
>> >
>> > Hi,
>> >
>> > It seems that s2mpa01_info->rdev is not used anywhere, except as return
>> > value of devm_regulator_register. I think you can remove it completely.
>>
>> Yes. I will send a follow up patch for this.
>
> Let's not break things and fix them up later. Fix it in this patch.

Nothing is broken in this patch. What is suggested is just a code cleanup.
I did not want to disturb the existing patch set as it is already reviewed
and ready for merging. Anyway I can re-spin with this suggested change.

>
>> > Beside that, can this driver be merged into existing s2mps11 regulator
>> > driver?
>>
>> Haven't analyzed this yet. Will look into the possibility of consolidation
>> later.
>
> As above. If consolidation is possible it should be take care of in
> the first instance.

I need to analyze and see if this is really possible and the extent of
re-usability.
If possible, this might take a while for me before I start
implementing it. Considering
that this patch set is now over 2 months old and consolidations do
happen subsequently
I request you to queue this patch set in its current form (with the
above change if you
deem it necessary to be part of current patch set).

-- 
With warm regards,
Sachin
