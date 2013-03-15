Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108Ab3COUJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 16:09:26 -0400
Received: from smtp0.epfl.ch ([128.178.224.218]:39387 "HELO smtp0.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753522Ab3COUJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 16:09:25 -0400
Message-ID: <51437FEA.20807@epfl.ch>
Date: Fri, 15 Mar 2013 21:09:14 +0100
From: Florian Vaussard <florian.vaussard@epfl.ch>
Reply-To: florian.vaussard@epfl.ch
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, linux-leds@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Florian Vaussard <florian.vaussard@epfl.ch>
Subject: Re: [PATCH v3 3/3] leds: leds-pwm: Defer led_pwm_set() if PWM can
 sleep
References: <1359381659-24454-1-git-send-email-florian.vaussard@epfl.ch> <1359381659-24454-4-git-send-email-florian.vaussard@epfl.ch> <20130130081728.GC13568@avionic-0098.mockup.avionic-design.de> <512E2F98.6070404@epfl.ch> <51347B06.8090604@epfl.ch> <20130304105806.GA28735@avionic-0098.mockup.avionic-design.de> <513EFE17.6030203@epfl.ch> <CAK5ve-+TfHmvx8fiim2yyZhKbhgieO-WDqd+HG7ViLm=Fk3zNA@mail.gmail.com> <20130315185953.GA11351@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20130315185953.GA11351@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/15/2013 07:59 PM, Thierry Reding wrote:
>>
>> Hi Florian and Thierry,
>>
>> Sorry, guys. My bad! I'm using GMAIL filtering my emails. This email
>> goes into my arm-linux mail list archive and I totally missed it.
>>
>> I can merge this patch into my for-next branch, but it will be in 3.10
>> not 3.9-rcX.
>>
>> Or Thierry, can you merge that to 3.9-rcX through your tree with my Ack?
>
> I think 3.10 would be fine. We missed the merge window on this one and
> it isn't really a fix so it's a bit late for 3.9 now.
>
> If Florian really absolutely needs this it can probably be done, but if
> he can wait another few weeks it's certainly worth taking it through
> linux-next for a while just to be safe.
>

I agree, another few weeks is not a problem :) Bryan, I let you merge 
this, ok?

Thank you,

Florian
