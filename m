Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab3AUVnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:43:46 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:53013 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab3AUVnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:43:45 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdaV3VvhkOQ1Byvqc23oiONddcLVtKnRQbEA9q0U0YW4cg@mail.gmail.com>
References: <1355995215-6273-1-git-send-email-linus.walleij@stericsson.com>
	<CACRpkdaV3VvhkOQ1Byvqc23oiONddcLVtKnRQbEA9q0U0YW4cg@mail.gmail.com>
Date: Mon, 21 Jan 2013 22:43:43 +0100
Message-ID: <CACRpkdYL=qJ1KwTXFxqtWdxCpNT3GS06G=rO2m9Zxh-BL78SNQ@mail.gmail.com>
Subject: Re: [PATCH v2] mfd: db8500-prcmu: fix irqdomain usage
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Anmar Oueja <anmar.oueja@linaro.org>,
        stable@kernel.org, Lee Jones <lee.jones@linaro.org>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 11:26 PM, Linus Walleij
<linus.walleij@linaro.org> wrote:
> On Thu, Dec 20, 2012 at 10:20 AM, Linus Walleij
> <linus.walleij@stericsson.com> wrote:
>
>> From: Linus Walleij <linus.walleij@linaro.org>
>>
>> This fixes two issues with the DB8500 PRCMU irqdomain:
>> - You have to state the irq base 0 to get a linear domain
>>   for the DT case from irq_domain_add_simple()
>> - The irqdomain was not used to translate the initial irq
>>   request using irq_create_mapping() making the linear
>>   case fail as it was lacking a proper descriptor.
>>
>> I took this opportunity to fix two lines of whitespace
>> errors in related code as I was anyway messing around with
>> it.
>>
>> Cc: stable@kernel.org
>> Cc: Lee Jones <lee.jones@linaro.org>
>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>
> Sam, this regression fix has been around for a month soon,
> could you please apply it if there are no problems with it?

Ping on this!

Yours,
Linus Walleij
