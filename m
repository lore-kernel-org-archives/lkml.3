Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722Ab3EOIyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 04:54:12 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:46484 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602Ab3EOIyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 04:54:09 -0400
MIME-Version: 1.0
In-Reply-To: <20130514155835.10068.93655@quantum>
References: <1368019749-19455-1-git-send-email-lee.jones@linaro.org>
	<1368019749-19455-4-git-send-email-lee.jones@linaro.org>
	<20130514155835.10068.93655@quantum>
Date: Wed, 15 May 2013 10:54:09 +0200
Message-ID: <CACRpkdZjvQF9e_isiuUgmcH0RgoGGF=dmg_E7oQjs4oY9f+dFQ@mail.gmail.com>
Subject: Re: [PATCH 3/9] clk: ux500: Provide device enumeration number suffix
 for SMSC911x
From: Linus Walleij <linus.walleij@linaro.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 5:58 PM, Mike Turquette <mturquette@linaro.org> wrote:
> Quoting Lee Jones (2013-05-08 06:29:03)
>> First Ethernet device has a ".0" appended onto the device name. It
>> appears that we need this in order to obtain the correct clock.
>>
>> Cc: Ulf Hansson <ulf.hansson@linaro.org>
>> Cc: Mike Turquette <mturquette@linaro.org>
>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
>
> Looks good to me.  Can I take this into clk-next or are you looking for
> an Ack?

You can probably take it through the clk tree, but this series
deals with regression fixes so it should go into the -rc series
I think.

Yours,
Linus Walleij
