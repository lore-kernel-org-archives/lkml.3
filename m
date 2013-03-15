Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab3CORJU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 13:09:20 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:46679 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab3CORJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 13:09:19 -0400
MIME-Version: 1.0
In-Reply-To: <513EFE17.6030203@epfl.ch>
References: <1359381659-24454-1-git-send-email-florian.vaussard@epfl.ch>
 <1359381659-24454-4-git-send-email-florian.vaussard@epfl.ch>
 <20130130081728.GC13568@avionic-0098.mockup.avionic-design.de>
 <512E2F98.6070404@epfl.ch> <51347B06.8090604@epfl.ch> <20130304105806.GA28735@avionic-0098.mockup.avionic-design.de>
 <513EFE17.6030203@epfl.ch>
From: Bryan Wu <cooloney@gmail.com>
Date: Fri, 15 Mar 2013 10:08:57 -0700
Message-ID: <CAK5ve-+TfHmvx8fiim2yyZhKbhgieO-WDqd+HG7ViLm=Fk3zNA@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] leds: leds-pwm: Defer led_pwm_set() if PWM can sleep
To: florian.vaussard@epfl.ch
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Richard Purdie <rpurdie@rpsys.net>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, linux-leds@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 3:06 AM, Florian Vaussard
<florian.vaussard@epfl.ch> wrote:
> Hi Bryan,
>
>
>>>>>
>>>>> Bryan, I assume that you'll be taking this? It doesn't apply cleanly to
>>>>> my tree, probably because of Peter's recent changes that you took
>>>>> through your tree and Florian based his patches on top of that. The
>>>>> conflict resolution should be trivial, though.
>>>>>
>>>>
>>>> It seems that this patch was not taken. Could you pull it, as the other
>>>> part is already in linux-pwm? Or is there any show stopper?
>>>>
>>>
>>> Ping? Who should merge this?
>>
>>
>> I assume Bryan will take it through the LED tree? Patches 1 & 2 went
>> into v3.9-rc1 through the PWM tree.
>>
>
> Ping ?
>

Hi Florian and Thierry,

Sorry, guys. My bad! I'm using GMAIL filtering my emails. This email
goes into my arm-linux mail list archive and I totally missed it.

I can merge this patch into my for-next branch, but it will be in 3.10
not 3.9-rcX.

Or Thierry, can you merge that to 3.9-rcX through your tree with my Ack?

Thanks,
-Bryan
