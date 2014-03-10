Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbaCJKmq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 06:42:46 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43842 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaCJKmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 06:42:44 -0400
MIME-Version: 1.0
In-Reply-To: <20140310103905.GK14976@lee--X1>
References: <1394100057-32677-1-git-send-email-sachin.kamat@linaro.org>
	<1394100057-32677-2-git-send-email-sachin.kamat@linaro.org>
	<1394102406.25853.4.camel@AMDC1943>
	<CAK9yfHyv+PhLCfy131KCS4GWaAEgQ9qmS5X27bTYHWYUspkYjA@mail.gmail.com>
	<20140310093551.GE14976@lee--X1>
	<CAK9yfHy9iwCa7JPHTtJNw0pYhehUCd-GLPSW3Gw0G36ELBqsrA@mail.gmail.com>
	<20140310103812.GJ14976@lee--X1>
	<20140310103905.GK14976@lee--X1>
Date: Mon, 10 Mar 2014 16:12:44 +0530
Message-ID: <CAK9yfHyybqc6YSyDrZ451RaBmqFMTAaHfQSpZf1VgtNidDOHSA@mail.gmail.com>
Subject: Re: [PATCH v3 Resend 2/3] regulator: Add support for S2MPA01 regulator
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>, Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 March 2014 16:09, Lee Jones <lee.jones@linaro.org> wrote:
>> > >> >> Add support for S2MPA01 voltage and current regulator.
>> > >>
>> > >> >> +
>> > >> >> +struct s2mpa01_info {
>> > >> >> +     struct regulator_dev *rdev[S2MPA01_REGULATOR_MAX];
>> > >> >
>> > >> > Hi,
>> > >> >
>> > >> > It seems that s2mpa01_info->rdev is not used anywhere, except as return
>> > >> > value of devm_regulator_register. I think you can remove it completely.
>> > >>
>> > >> Yes. I will send a follow up patch for this.
>> > >
>> > > Let's not break things and fix them up later. Fix it in this patch.
>> >
>> > Nothing is broken in this patch. What is suggested is just a code cleanup.
>> > I did not want to disturb the existing patch set as it is already reviewed
>> > and ready for merging. Anyway I can re-spin with this suggested change.
>> >
>> > >
>> > >> > Beside that, can this driver be merged into existing s2mps11 regulator
>> > >> > driver?
>> > >>
>> > >> Haven't analyzed this yet. Will look into the possibility of consolidation
>> > >> later.
>> > >
>> > > As above. If consolidation is possible it should be take care of in
>> > > the first instance.
>> >
>> > I need to analyze and see if this is really possible and the extent of
>> > re-usability.
>> > If possible, this might take a while for me before I start
>> > implementing it. Considering
>> > that this patch set is now over 2 months old and consolidations do
>> > happen subsequently
>> > I request you to queue this patch set in its current form (with the
>> > above change if you
>> > deem it necessary to be part of current patch set).
>>
>> I think the suggestion above should be fixed-up.
>>
>> Whether to consider consolidation or not is Mark's decision.
>
> Oh, Mark (the maintainer) isn't on CC? I think this is a mistake.

Sorry for missing. Thanks for fixing, Lee.

-- 
With warm regards,
Sachin
