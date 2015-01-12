Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbbALIzJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 03:55:09 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:60517 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbbALIzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 03:55:04 -0500
Message-ID: <54B38BE7.1070203@atmel.com>
Date: Mon, 12 Jan 2015 09:55:03 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Haavard Skinnemoen <hskinnemoen@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] avr32: remove fake at91 cpu identification
References: <1420941616-2777-1-git-send-email-alexandre.belloni@free-electrons.com> <20150111121012.GB4050@samfundet.no>
In-Reply-To: <20150111121012.GB4050@samfundet.no>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 11/01/2015 13:10, Hans-Christian Egtvedt a écrit :
> Around Sun 11 Jan 2015 03:00:16 +0100 or thereabout, Alexandre Belloni wrote:
>> cpu_is_at91* are not used in any driver outside mach-at91. Remove those useless
>> definitions.
> 
> Great, thank you for cleaning.
> 
>> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
>>
> 
> Acked-by: Hans-Chrisitan Egtvedt <egtvedt@samfundet.no>
> 
>> ---
>>
>> Hans-Christian,
>>
>> If you want, I guess that one could go through the at91 tree. Unless you have
>> more material and you want to do a pull request for 3.20.
> 
> I have another patch in the pipe wiring up syscalls for AVR32, so I'll push
> this through my tree for 3.20.

Okay, so you can add my:
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Bye,

>>  arch/avr32/mach-at32ap/include/mach/cpu.h | 26 +-------------------------
>>  1 file changed, 1 insertion(+), 25 deletions(-)
> 
> <snipp diff>
> 


-- 
Nicolas Ferre
