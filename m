Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbaIWPaK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 11:30:10 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:58792 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932214AbaIWPaG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 11:30:06 -0400
MIME-Version: 1.0
In-Reply-To: <542179BD.9070406@samsung.com>
References: <54216FC9.5060605@gmail.com>
	<542179BD.9070406@samsung.com>
Date: Tue, 23 Sep 2014 11:30:04 -0400
Message-ID: <CAAxn8Jnz2CJJmp6Pc2ctRVgTSi=W203EvhAshDq-WK9fM4JR+w@mail.gmail.com>
Subject: Re: FIX Me in pgtable.h
From: Nicholas Krause <yocto6@gmail.com>
To: =?UTF-8?Q?Krzysztof_Koz=C5=82owski?= <k.kozlowski@samsung.com>
Cc: linux@arm.linux.org.uk, Laura Abbott <lauraa@codeaurora.org>,
        steve.capper@arm.com, will.deacon@arm.com,
        "julia.lawall@lip6.fr oneukum@suse.de" <linux-kernel@vger.kernel.org>,
        Steve Capper <steve.capper@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't have any hardware to test this over, however I can emulate a
arm system over qemu if needed.
I was just trying to help out if we need hardware I can't test and
again I am sorry for the terrible patches.
It was never my goal to be a nuisance.
Nick
On Tue, Sep 23, 2014 at 9:46 AM, Krzysztof Kozłowski
<k.kozlowski@samsung.com> wrote:
> On 23.09.2014 15:04, nick wrote:
>>
>> Greetings Arm Maintainers,
>> I am wondering about the fix me in pgtable.h for define kern_addr_valid
>> and how to set it to a correct
>> value as you state that this needs to be fixed as the defined macro is
>> still 1. This is probably incorrect
>> and should be changed.
>
>
> Dear Nick Krause,
>
> Before you start coding - do you have necessary ARM-based hardware to test
> your changes?
>
> Changing email won't remove LKML archives...
>
> Best regards,
> Krzysztof
>
