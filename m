Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab3KZA4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 19:56:41 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:58285 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691Ab3KZA4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 19:56:38 -0500
Message-ID: <5293F19D.70901@ti.com>
Date: Mon, 25 Nov 2013 19:55:57 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>
CC: "Khoronzhuk, Ivan" <ivan.khoronzhuk@ti.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@kernel.crashing.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 10/12] mtd: nand: davinci: don't set timings if AEMIF
 is used
References: <1384187188-5776-1-git-send-email-ivan.khoronzhuk@ti.com>, <1384187188-5776-11-git-send-email-ivan.khoronzhuk@ti.com> <4F5844B3A985794BA902E12C070812375F8D53@DNCE04.ent.ti.com> <528307F0.6000805@ti.com> <52838941.4060207@ti.com> <5284ABB9.70608@ti.com> <5284DFE7.70308@ti.com> <528E3DD4.7030607@ti.com> <528F968F.40306@ti.com> <5291CB01.1010506@ti.com>
In-Reply-To: <5291CB01.1010506@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 24 November 2013 04:46 AM, Sekhar Nori wrote:
> On Friday 22 November 2013 11:08 PM, Santosh Shilimkar wrote:
>> On Thursday 21 November 2013 12:07 PM, Nori, Sekhar wrote:
>>> On 11/14/2013 8:06 PM, Santosh Shilimkar wrote:

[..]

>>> Yes, that would be the ideal way. But the reality is that there is close
>>> to zero chance of all the DaVinci platforms using AEMIF ever getting
>>> converted to DT. This means that we will never be able to get rid of
>>> this piece of code.
>>>
>> Well that means some of those platforms support will get deprecated
>> soon considering other basic frameworks like irq, timer wheel etc
>> is assuming the DT direction. But its your call because if you
>> want those platforms to live, you need to convert them to DT.
>>  
>>> I do agree platform data is not the direction you want to take on ARM
>>> but at the same time its not really a deprecated mechanism as far as the
>>> broader kernel is concerned.
>>>
>>> So, can we consider adding platform data mechanism to the AEMIF driver?
>>>
>> Sorry but answer is "NO". If the above hack is really bothering you,
>> we can actually rip out the above code in question and move it
>> to mach-davinci. Infact thats the best direction to make the
>> mtd nandn driver independent of any platform quirks(dt, pdata etc)
>>
>> Ivan already has a patch to do that and he is going to post
>> that patch. With that patch, we won't need $subject patch.
>>
> 
> Okay I will wait for the patch.
> 
Ivan has posted a patch already and you are copied on it.

Regards,
Santosh
