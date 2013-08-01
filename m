Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab3HAJ2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 05:28:11 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:33739 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab3HAJ2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 05:28:09 -0400
MIME-Version: 1.0
In-Reply-To: <CACQ1gAj_KCJUnBGzv0bnGaUwMgWq-7Noe280YdLGPxK8Ofp3Bw@mail.gmail.com>
References: <1375339733-3488-1-git-send-email-b.brezillon@overkiz.com> <CACQ1gAj_KCJUnBGzv0bnGaUwMgWq-7Noe280YdLGPxK8Ofp3Bw@mail.gmail.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Thu, 1 Aug 2013 11:27:48 +0200
Message-ID: <CACQ1gAjQ4raVHbMUfPZM=BQ-+SCbOJvxmR_5Vh=xpX592MZo7A@mail.gmail.com>
Subject: Re: [PATCH 0/8] ARM: at91/dt: make use of periph id macros
To: Boris BREZILLON <b.brezillon@overkiz.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/8/1 Richard Genoud <richard.genoud@gmail.com>:
> 2013/8/1 Boris BREZILLON <b.brezillon@overkiz.com>:
>> Hello,
>>
>> This patch series move at91 SoCs peripheral id definitions from machine
>> specific include dir to dt-bindings include dir.
>> These macros are used to reference interrupts instead of peripheral numbers.
>>
>> This makes dt definitions cleaner and easier to debug (one can easily tell if
>> the peripheral macro used to reference an interrupt line is not the good one).
>>
>> These macros will be used for clk definitions and references too.
>>
>> I am not sure 'include/dt-bindings/at91/xxx' is the best place to put these
>> definitions as there are no soc specific directories in dt-bindings include
>> dir right now. Maybe something like 'include/dt-bindings/soc/at91/xxx' or
>> 'include/dt-bindings/peripherals/at91/xxx' would be better.
>> What do you think ?
> Well, I'd rather use "atmel" than "at91" because, AFAIK, this prefix
> has been dropped for new atmel SoCs (sama5 for instance).

[changed Mark Brown address from opensource.wolfsonmicro.com to
kernel.org (the 1st one failed)]

The whole serie seems good to me (add adding the missing defines is great).

You can add my:
Reviewed-by: Richard Genoud <richard.genoud@gmail.com>
on the whole serie.

and my
Tested-by: Richard Genoud <richard.genoud@gmail.com>
on patch 7/8


Richard.
