Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbbAML0w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 06:26:52 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:38348 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbbAML0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 06:26:51 -0500
Message-ID: <54B500F9.4000507@atmel.com>
Date: Tue, 13 Jan 2015 12:26:49 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, <khilman@kernel.org>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Patrice Vilchez <patrice.vilchez@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>,
        ARM Maintainers <arm@kernel.org>
Subject: Re: [PATCH] ARM: at91/Documentation: add a README for Atmel SoCs
References: <1420809631-26923-1-git-send-email-nicolas.ferre@atmel.com> <20150113020325.GB28758@quad.lixom.net>
In-Reply-To: <20150113020325.GB28758@quad.lixom.net>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 13/01/2015 03:03, Olof Johansson a écrit :
> On Fri, Jan 09, 2015 at 02:20:31PM +0100, Nicolas Ferre wrote:
>> Add a README file to describe Atmel SoCs (aka AT91) support in Mainline Linux:
>> - SoC list + datasheet web links
>> - Basic but useful information
>> - Device Tree conventions and Work In Progress statement.
>>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> Cc: ARM Maintainers <arm@kernel.org>
> 
> Acked-by: Olof Johansson <olof@lixom.net>
> 
> With the understanding that:
> 
>> +Device Tree for AT91 SoCs and boards
>> +------------------------------------
>> +All AT91 SoCs are converted to Device Tree. Since Linux 3.19, these products
>> +must use this method to boot the Linux kernel.
>> +
>> +Work In Progress statement:
>> +Device Tree files and Device Tree bindings that apply to AT91 SoCs and boards are
>> +considered as "Unstable". To be completely clear, any at91 binding can change at
>> +any time. So, be sure to use a Device Tree Binary and a Kernel Image generated from
>> +the same source tree.
>> +Please refer to the Documentation/devicetree/bindings/ABI.txt file for a
>> +definition of a "Stable" binding/ABI.
>> +This statement will be removed by AT91 MAINTAINERS when appropriated.
> 
> While this statement is here, at the end of the day if you break a user
> you're responsible for fixing them. I.e. if a tree falls in the forest
> and nobody notices, then so be it.
> 
> But you can't break existing users and point to this and get away with
> it. However, hopefully based on this doc users will go with practices
> that means that you can revise bindings if you have to.

Yes, that was the intention.

Thanks, bye,
-- 
Nicolas Ferre
