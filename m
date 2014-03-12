Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938AbaCLRVO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 13:21:14 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:39638 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908AbaCLRVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 13:21:12 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20140312105746.GK13905@piout.net>
References: <1394038675-15809-1-git-send-email-alexandre.belloni@free-electrons.com> <1394038675-15809-2-git-send-email-alexandre.belloni@free-electrons.com> <5318C950.7060900@kernel.org> <20140312105746.GK13905@piout.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH 1/3] iio: adc: at91_adc: Repair broken platform_data support
From: Jonathan Cameron <jic23@kernel.org>
Date: Wed, 12 Mar 2014 17:21:03 +0000
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Josh Wu <josh.wu@atmel.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org
Message-ID: <1a787464-2945-4106-901b-0152627d09cd@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On March 12, 2014 10:57:46 AM GMT+00:00, Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:
>Hi Jonathan,
>
>On 06/03/2014 at 19:15:28 +0000, Jonathan Cameron wrote :
>> It's late in the cycle so I'll send this on to Greg KH with a note
>> to say either send it to Linus if he is happy doing so - or send
>> it early in 3.15, then it'll get picked up for stable.
>> 
>> I'll give it a day or so to see if I the at91 maintainers are happy
>> with the other two parts as it is probably cleaner if all 3 go
>together.
>> 
>> Applied to the fixes-togreg branch of iio.git
>> 
>
>I don't recall seeing you sending that to Greg. Could you do that,
>along
>with the two other patches that got acked by Nicolas ?
Sorry spot of man flu, messy weekend and manic day job have made for an interesting
 week.  Given regression has already snuck out in a release and Greg doesn't have other
 fixes queued I think we are talking soon after merge window and rc1.  I'll check with Greg though...
>
>Anyway, if it is too late, we'll push for stable.
>
>Thanks !

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
