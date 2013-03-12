Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463Ab3CLKGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 06:06:21 -0400
Received: from smtp5.epfl.ch ([128.178.224.8]:38589 "HELO smtp5.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932241Ab3CLKGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 06:06:20 -0400
Message-ID: <513EFE17.6030203@epfl.ch>
Date: Tue, 12 Mar 2013 11:06:15 +0100
From: Florian Vaussard <florian.vaussard@epfl.ch>
Reply-To: florian.vaussard@epfl.ch
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Bryan Wu <cooloney@gmail.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        Richard Purdie <rpurdie@rpsys.net>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, linux-leds@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Florian Vaussard <florian.vaussard@epfl.ch>
Subject: Re: [PATCH v3 3/3] leds: leds-pwm: Defer led_pwm_set() if PWM can
 sleep
References: <1359381659-24454-1-git-send-email-florian.vaussard@epfl.ch> <1359381659-24454-4-git-send-email-florian.vaussard@epfl.ch> <20130130081728.GC13568@avionic-0098.mockup.avionic-design.de> <512E2F98.6070404@epfl.ch> <51347B06.8090604@epfl.ch> <20130304105806.GA28735@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20130304105806.GA28735@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan,

>>>>
>>>> Bryan, I assume that you'll be taking this? It doesn't apply cleanly to
>>>> my tree, probably because of Peter's recent changes that you took
>>>> through your tree and Florian based his patches on top of that. The
>>>> conflict resolution should be trivial, though.
>>>>
>>>
>>> It seems that this patch was not taken. Could you pull it, as the other
>>> part is already in linux-pwm? Or is there any show stopper?
>>>
>>
>> Ping? Who should merge this?
>
> I assume Bryan will take it through the LED tree? Patches 1 & 2 went
> into v3.9-rc1 through the PWM tree.
>

Ping ?

Florian
