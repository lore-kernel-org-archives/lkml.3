Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750928AbaEAFs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 01:48:28 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:33727 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbaEAFs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 01:48:26 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <CAD=FV=U-_0FWNHrqWp+rfmucKO5GQibCr8N09M8NVSb180ieBQ@mail.gmail.com>
References: <1398850015-17761-1-git-send-email-ch.naveen@samsung.com> <1398850015-17761-6-git-send-email-ch.naveen@samsung.com> <536161F5.7090508@kernel.org> <CAD=FV=U-_0FWNHrqWp+rfmucKO5GQibCr8N09M8NVSb180ieBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH 5/5 v3] iio: exynos_adc: do a reinit_completion before the conversion
From: Jonathan Cameron <jic23@kernel.org>
Date: Thu, 01 May 2014 06:48:19 +0100
To: Doug Anderson <dianders@chromium.org>
CC: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-iio <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naveen Krishna <naveenkrishna.ch@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>, "cpgs ." <cpgs@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Tomasz Figa <t.figa@samsung.com>
Message-ID: <dbdb414d-81d9-453b-871e-d5d0359f7efe@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On May 1, 2014 12:23:27 AM GMT+01:00, Doug Anderson <dianders@chromium.org> wrote:
>Jonathan,
>
>On Wed, Apr 30, 2014 at 1:49 PM, Jonathan Cameron <jic23@kernel.org>
>wrote:
>> On 30/04/14 10:26, Naveen Krishna Chatradhi wrote:
>>>
>>> Add reinit_completion() before the wait_for_completion_timeout in
>>> raw_read() call.
>>>
>>> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>>> Reviewed-by: Doug Anderson <dianders@chromium.org>
>>
>> Applied to the togreg branch of iio.git
>> I wasn't sure if this one was technically a fix, but as it isn't
>> marked clearly as such it can go in during the next merge window.
>> I won't have pushed this out to a non rebasing branch until tomorrow
>> so if this fixes an observed issue then let me know and it might move
>> to the fixes-togreg branch.
>
>As far as I know this doesn't fix an observed issue.  I believe it was
>requested as part of a previous review and is finally reposted.  I
>believe it's just extra precautions to make sure that some old IRQ
>didn't accidentally complete us between the last transaction and this
>one.
>
>Old discussion is somewhere around here
><https://patchwork.kernel.org/patch/2279591/>
Thanks for clarifying this.

J
>
>Thanks!
>
>-Doug

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
