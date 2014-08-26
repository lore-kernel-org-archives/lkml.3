Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbaHZAy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 20:54:26 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:54318 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbaHZAyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 20:54:25 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:fd1f:fcd6:25f1:aa:c632]
In-Reply-To: <CAOesGMhmer-V9qXQboeULK91fkrVLQ=4uKuJtOOOnxMGs5WQfA@mail.gmail.com>
References: <1407960049-1591-1-git-send-email-computersforpeace@gmail.com>
	<20140825173542.GX18411@ld-irv-0074>
	<CAOesGMhmer-V9qXQboeULK91fkrVLQ=4uKuJtOOOnxMGs5WQfA@mail.gmail.com>
Date: Mon, 25 Aug 2014 17:54:23 -0700
Message-ID: <CAOesGMgbF4aX8Y1Pr+WDG-rB3uyvx1fcmtejZ4RnJG-KpSSThw@mail.gmail.com>
Subject: Re: [PATCH] ARM: brcmstb: revert SMP support
From: Olof Johansson <olof@lixom.net>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Matt Porter <mporter@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Marc Carino <marc.ceeeee@gmail.com>,
        Gregory Fong <gregory.0xf0@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 11:03 AM, Olof Johansson <olof@lixom.net> wrote:
> Hi,
>
> On Mon, Aug 25, 2014 at 10:35 AM, Brian Norris
> <computersforpeace@gmail.com> wrote:
>> Hi Matt, Olof,
>>
>> Can this go into 3.17? Besides the other improvements that need to be
>> made to this code, more people are noticing the build errors Russell
>> noticed previously.
>>
>>   http://article.gmane.org/gmane.linux.ports.arm.kernel/350226
>>
>> I meant to have put [PATCH -3.17] in the subject, in case that would
>> help it get the attention it deserved.
>
> Yeah, I'll apply this one directly.

Applied and pushed now. Likely missed today's -next.


-Olof
