Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929Ab3FEMcN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 08:32:13 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:33572 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab3FEMcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 08:32:12 -0400
MIME-Version: 1.0
In-Reply-To: <2771350.uHLSSD79no@wuerfel>
References: <1370360208-6500-1-git-send-email-lee.jones@linaro.org>
	<2771350.uHLSSD79no@wuerfel>
Date: Wed, 5 Jun 2013 14:32:11 +0200
Message-ID: <CACRpkdbs=K_aa+mS4EHZk3qVZ1GA-gT6sB1zPOMEVWP=h50WqA@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: ux500: Silence compiler warnings due to missing
 ux500_read_asicid() __init
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 4, 2013 at 5:55 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 04 June 2013 16:36:47 Lee Jones wrote:
>> WARNING: vmlinux.o(.text.unlikely+0x1e8): Section mismatch in reference from\
>>  the function ux500_read_asicid() to the function .init.text:iotable_init()
>> The function ux500_read_asicid() references
>> the function __init iotable_init().
>> This is often because ux500_read_asicid lacks a __init
>>
>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
>
> This is also part of my other patch to ux500_read_asicid that
> Linus just applied, but we could take yours for 3.10 if he thinks
> it's important.

We don't need two patches conflicting about such small
things, so I'll drop this in favor of your patch.

Yours,
Linus Walleij
