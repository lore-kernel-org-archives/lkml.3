Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbaABSvb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 13:51:31 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:57688 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbaABSva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 13:51:30 -0500
Message-ID: <52C5B52E.6080609@linaro.org>
Date: Thu, 02 Jan 2014 19:51:26 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
CC: olof@lixom.net, khilman@linaro.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: Re: [PATCH 01/17] ARM: spear: Remove deprecated IRQF_DISABLED flag
References: <1388419771-30075-1-git-send-email-daniel.lezcano@linaro.org> <201401021929.46581.arnd@arndb.de>
In-Reply-To: <201401021929.46581.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2014 07:29 PM, Arnd Bergmann wrote:
> On Monday 30 December 2013, Daniel Lezcano wrote:
>> This flag is a NOOP and scheduled to be removed
>>
>> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>
> Thanks for sending this series. I think the patches are duplicates of stuff that
> Michael Opdenacker has sent before (actually multiple times). I have no problem
> applying either version into arm-soc, but I think it would be better to attribute
> them to Michael, since he came first. Can you two please coordinate and send a
> single pull request for the arm-soc related patches that haven't made it into
> linux-next yet?

Michael removed the flag for:

pxa (ed7936f913456e4c01aed75deba6cfaf830fa8cf)
samsung (fa53d5cdbffbce421c3bd2f937b5626fc044fedc)
avr32 (7155530d9eb692994d208836e4965da06b17c99d)
ep93xx (3a71ae4796fdaedbdbdab94660b7b7b5bfe61d1d)
plat-orion (eb4d552b933ac59c0c8e0604ff435c5208a82679)

The patchset I sent is on top of arm/for-next and finishes to remove 
this flag for arch/arm. It should not overlap with what Michael did.

I'm ok to attribute the patchset to Michael if that can help to accept 
this patchset and kill this flag for arch/arm.

Thanks
   -- Daniel


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

