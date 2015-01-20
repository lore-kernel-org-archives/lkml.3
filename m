Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523AbbATPuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 10:50:10 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:24021 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbbATPuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 10:50:08 -0500
Message-ID: <54BE7916.4060204@atmel.com>
Date: Tue, 20 Jan 2015 16:49:42 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Lee Jones <lee.jones@linaro.org>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>, Wim Van Sebroeck <wim@iguana.be>,
        Guenter Roeck <linux@roeck-us.net>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-watchdog@vger.kernel.org>
Subject: Re: [PATCH v3 2/8] mfd: Add atmel-st driver
References: <1421077023-30954-1-git-send-email-alexandre.belloni@free-electrons.com> <1421077023-30954-3-git-send-email-alexandre.belloni@free-electrons.com> <20150119094224.GJ21886@x1> <20150119225923.GG5014@piout.net> <20150120094739.GM5767@x1> <20150120150501.GH5014@piout.net>
In-Reply-To: <20150120150501.GH5014@piout.net>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 20/01/2015 16:05, Alexandre Belloni a écrit :
> On 20/01/2015 at 09:47:39 +0000, Lee Jones wrote :
>>>> This driver looks pretty pointless.  Why can't you request the sysconf
>>>> registers from within the drivers themselves?
>>>>
>>>
>>> How would you probe the watchdog driver then? Would you had the
>>> "atmel,at91rm9200-st" compatible there?
>>>
>>> At some point in time, we should add the reset driver, would you also
>>> match it on "atmel,at91rm9200-st"?
>>>
>>> I'm fine with that as this allows to avoid the mfd driver.
>>
>> I'm sorry, I don't follow.  Why can't each driver have their own
>> compatible strings?
>>
> 
> The same IP provides a clocksource, a watchdog and is also the reset
> controller. I think that the DT guidelines requires that the DT
> describes the hardware and so use one compatible for that IP;

I would add also that the registers within the IP are kind of mixed,
there is no way to separate by logical functions.

Bye,
-- 
Nicolas Ferre
