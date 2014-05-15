Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbaEOMh3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 08:37:29 -0400
Received: from exprod7og112.obsmtp.com ([64.18.2.177]:54656 "EHLO
	exprod7og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699AbaEOMh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 08:37:27 -0400
MIME-Version: 1.0
In-Reply-To: <6334605.NlytHCzYVP@wuerfel>
References: <cover.1400072260.git.anders.berg@avagotech.com>
	<6334605.NlytHCzYVP@wuerfel>
Date: Thu, 15 May 2014 14:37:26 +0200
Message-ID: <CAE0=X_15Yk3VhHTwG-piA_eYL1mKW9wu_Szp-yL0YyfL8m0ecA@mail.gmail.com>
Subject: Re: [PATCH v3 0/6] Add platform support for LSI AXM55xx
From: Anders Berg <anders.berg@avagotech.com>
To: Arnd Bergmann <arnd@arndb.de>, Mike Turquette <mturquette@linaro.org>
Cc: Olof Johansson <olof@lixom.net>, Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 8:56 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 14 May 2014 20:37:55 Anders Berg wrote:
>>
>> This is version 3 of this series to introduces basic platform support for the LSI
>> AXM5516 SoC.
>>
>> No major changes since v2. Ready to be applied to the arm-soc tree?
>
> I think it's good, but I'm not sure if we should put them all into arm-soc.
> There are no dependencies between the drivers that I can see, so why not
> merge the clock and reset drivers through the individual subsystem maintainers?
>

After suggestions from Mike on the clk driver (and it's dts binding)
I've done an updated clock driver patch - and a dependency surfaced...
The file <dt-bindings/clock/lsi,axm5516-clks.h>. Which way should this
take, arm-soc or Mikes clk tree? Perhaps this is a reason to take it
all through arm-soc?

/Anders
