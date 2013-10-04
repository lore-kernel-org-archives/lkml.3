Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab3JDKA6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 06:00:58 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:37803 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab3JDKA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 06:00:57 -0400
Message-ID: <524E91D5.5020804@atmel.com>
Date: Fri, 4 Oct 2013 12:00:53 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LAK <linux-arm-kernel@lists.infradead.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, Marc Pignat <marc.pignat@hevs.ch>,
        "Ludovic Desroches" <ludovic.desroches@atmel.com>,
        <john.stultz@linaro.org>, <kernel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Ronald Wahl <ronald.wahl@raritan.com>
Subject: Re: Timekeeping on at91rm9200 [Was: [PATCH v2] clockevents: Sanitize
 ticks to nsec conversion]
References: <alpine.DEB.2.02.1309191629040.4089@ionos.tec.linutronix.de> <1380052223-24139-1-git-send-email-u.kleine-koenig@pengutronix.de> <20130924211139.GE16106@pengutronix.de>
In-Reply-To: <20130924211139.GE16106@pengutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/09/2013 23:11, Uwe Kleine-König :
> Hello Nicolas, hello Jean-Christophe,
>
> I expect you should be able to revert
>
> 	b7a8ca5 (ARM: at91: rm9200 fix time support)
>
> which reverted
>
> 	838a2ae (ARM: use clockevents_config_and_register() where possible)
>
> for at91rm9200 on top of the patch this mail is a reply to.
>
> Can you please test that?

I have just tested that on at91rm9200-ek:
- revert the revert (!)
- experience the crash
- then apply the v2 patch
- and finally see it working nicely!

Thanks a lot for having corrected this. Now, do you want that I stack 
this revert-of-revert on the AT91 git tree or you are able to apply it 
through the clock git tree together with the patch that is fixing the 
issue (it may prevent synchronization difficulties)? (BTW, I do not see 
it yet in "next").

Anyway, if it is required, you can add my:

Tested-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Thanks, bye,
-- 
Nicolas Ferre
