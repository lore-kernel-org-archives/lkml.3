Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbaBQLIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 06:08:45 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:42846 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbaBQLIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 06:08:44 -0500
Message-ID: <5301EDB6.9020102@atmel.com>
Date: Mon, 17 Feb 2014 12:08:38 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/3] ARM: at91: Add at91sam9rl DT SoC support
References: <1392426860-19589-1-git-send-email-alexandre.belloni@free-electrons.com> <1392426860-19589-2-git-send-email-alexandre.belloni@free-electrons.com> <20140217112013.723a4e12@skate> <20140217105439.GC21303@piout.net>
In-Reply-To: <20140217105439.GC21303@piout.net>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/02/2014 11:54, Alexandre Belloni :
> On 17/02/2014 at 11:20:13 +0100, Thomas Petazzoni wrote :
>> Dear Alexandre Belloni,
>>
>> On Sat, 15 Feb 2014 02:14:18 +0100, Alexandre Belloni wrote:
>>
>>> +	model = "Atmel AT91SAM9RL family SoC";
>>> +	compatible = "atmel,at91sam9rl";
>>
>> Since you have it in your board .dts file, I guess you should add the
>> atmel,at91sam9 compatible string here:
>>
>> 	compatible = "atmel,at91sam9rl", "atmel,at91sam9";
> 
> 
> I agree that it would be better but that is not done on other at91sam9
> socs. Nicolas, can you comment ?

I do agree with Thomas. It is true that it is missing in other sam9 dtsi
files.
On the other hand, it is present in sama5d3.dtsi file. So we might have
figured it out at some point ;-)

Bye,
-- 
Nicolas Ferre
