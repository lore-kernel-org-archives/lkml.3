Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab3GQMOK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 08:14:10 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:51139 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816Ab3GQMOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 08:14:02 -0400
Message-ID: <51E68A86.3020703@linaro.org>
Date: Wed, 17 Jul 2013 14:13:58 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jonas Jensen <jonas.jensen@gmail.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, john.stultz@linaro.org, tglx@linutronix.de,
        u.kleine-koenig@pengutronix.de, tomasz.figa@gmail.com,
        linus.walleij@linaro.org, thomas.petazzoni@free-electrons.com,
        arnd@arndb.de
Subject: Re: [PATCH v8] ARM: clocksource: add support for MOXA ART SoCs
References: <1373024773-24574-1-git-send-email-jonas.jensen@gmail.com> <1373985880-23469-1-git-send-email-jonas.jensen@gmail.com> <51E56043.1010509@linaro.org> <CACmBeS129VOmFjnF+-iRH1viS+zpoaNMYMaWZ_UiPVxa6ncYeQ@mail.gmail.com>
In-Reply-To: <CACmBeS129VOmFjnF+-iRH1viS+zpoaNMYMaWZ_UiPVxa6ncYeQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2013 10:14 AM, Jonas Jensen wrote:
> On 16 July 2013 17:01, Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
>> 1. could you elaborate the patch log: as it is a new driver, a nice
>> description of the timer hardware would be valuable for people willing
>> to understand the code (eg. some specificities of the driver).
> 
> A short description is now added to the commit message, I hope this is
> what you wanted, I can reformat the text if needed.

It is ok. Thanks for the update.


>> 2. fix the alignment below
> 
> I don't see the alignment error, I think this is because git adds the
> one '+' character, it should be correct once applied?

Ok. I will check it.

Thanks
  -- Daniel

-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

