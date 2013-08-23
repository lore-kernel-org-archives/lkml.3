Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab3HWHPN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 03:15:13 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:52820 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482Ab3HWHPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 03:15:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAME+o4mMxJD-TBgEeGNG9yDCgMGrBSTXMYZrJ09Z1M_qc6=TBw@mail.gmail.com>
References: <1371146190-16786-1-git-send-email-zoran.markovic@linaro.org>
	<CAPDyKFrD=q4hOQps5ENJdmAPJyKG1cj7+P6MtXdQ8KQ1cPjnpQ@mail.gmail.com>
	<CAME+o4mM-YmcZ4pcdWo7mzrDUi2R2LhihgcnbYixOm8KnGfnBA@mail.gmail.com>
	<CAMbhsRRokPi59J8SghGL0QhUWKDqMuvfbT3TdPosXud_WxRV2Q@mail.gmail.com>
	<CAPDyKFqy9EEb6o8wYABYT6zE-7Rb0xxo8Y0DuAwooeYZp5=Grw@mail.gmail.com>
	<CAMbhsRSC5XhhSK-DAoS7_JAj7XUfaM_Topp4UcBaVwRCYXSscQ@mail.gmail.com>
	<CAPDyKFpMGS-JA47pY_n7xvqdtbPumGpc2fdnYZnSVQ_Rybre3g@mail.gmail.com>
	<CAMbhsRQwGbpa4a1RziV92qnw4VFh6+=oQiadfqa17FANEiK8_Q@mail.gmail.com>
	<CAPDyKFroFY3-NJCFpkDYyBVx25CSfk492H_TnoS60jn2CdfWUQ@mail.gmail.com>
	<CAMbhsRTR9im-BsJ-1m+DD-67LM=s0=KOoy-o+2PmnkDyLOP0Gg@mail.gmail.com>
	<CAPDyKFoX-ioDVVkfQ21epJyTqQD98xvsqBR1FXzgP9bN6_Zxjg@mail.gmail.com>
	<CAME+o4=WrfpvJo=jN1KZ_JHnYq9Frfk3EPcwtG10=aCwrbY+Rw@mail.gmail.com>
	<CAPDyKFpKYeqoFn=S6P2tu1s2C28daCh4vcHTUCCRUOx2_MHShg@mail.gmail.com>
	<CAME+o4kpsPkoTpS7_0STDpMQpZr0KyfD1prbYYJs147-5DiMkg@mail.gmail.com>
	<CAME+o4mMxJD-TBgEeGNG9yDCgMGrBSTXMYZrJ09Z1M_qc6=TBw@mail.gmail.com>
Date: Fri, 23 Aug 2013 09:15:10 +0200
Message-ID: <CAPDyKFpdhj7jmsok17JNgP5ZY20F0T-Br6sxwcQLkDAD-zwoZw@mail.gmail.com>
Subject: Re: [RFC PATCH] mmc: Enable wakeup_sources for mmc core
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Zoran Markovic <zoran.markovic@linaro.org>
Cc: Colin Cross <ccross@android.com>, lkml <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>, San Mehat <san@google.com>,
        John Stultz <john.stultz@linaro.org>, Chris Ball <cjb@laptop.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Konstantin Dorfman <kdorfman@codeaurora.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 August 2013 19:08, Zoran Markovic <zoran.markovic@linaro.org> wrote:
> Ulf,
>> I got confirmation from Broadcom that all cell phone reference designs
>> have card insert/removal configured as a wakeup IRQ. Unless our
>> customers change that - which I doubt - this results in a considerable
>> number of products implementing this feature.
>>
>> Please let me know how you wish to proceed.
>
> I think this patch would be useful for all mobile applications. What
> are the chances of getting this in the next kernel version?
>

Hi Zoran,

Recently got back from vacation, sorry for the delayed response.

I am about to set up test using this patch, to validate this for a
ux500 Android build. Please give me a few days to provide you with
some results and input.

Kind regards
Ulf Hansson

> Thanks,
> Zoran
