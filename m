Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982AbaJAHso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 03:48:44 -0400
Received: from smtp65.ord1c.emailsrvr.com ([108.166.43.65]:53540 "EHLO
	smtp65.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751053AbaJAHsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 03:48:42 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
Message-ID: <542BB2B1.9010107@smartplayin.com>
Date: Wed, 01 Oct 2014 13:22:17 +0530
From: Pramod Gurav <pramod.gurav@smartplayin.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Subject: Re: [PATCH 1/2] gpio: remove remaining users of gpiochip_remove()
 retval
References: <1412086542-1662-1-git-send-email-pramod.gurav@smartplayin.com> <CACRpkdaCcaNmv=fciiVJdmu3M7-dhqjqgAuP6eeJkkfptFbA1Q@mail.gmail.com>
In-Reply-To: <CACRpkdaCcaNmv=fciiVJdmu3M7-dhqjqgAuP6eeJkkfptFbA1Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 October 2014 01:13 PM, Linus Walleij wrote:
> On Tue, Sep 30, 2014 at 4:15 PM, Pramod Gurav
> <pramod.gurav@smartplayin.com> wrote:
> 
>> Some driver in gpio still check for return value from gpiochip_remove
>> Get rid of the check for return value.
>>
>> Cc: Linus Walleij <linus.walleij@linaro.org>
>> Cc: Alexandre Courbot <gnurou@gmail.com>
>> Cc: linux-gpio@vger.kernel.org
>>
>> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
> 
> This is already fixed in the GPIO tree, and in linux-next.
> 
> I have got more patches like this from other people, and cannot
> quite understand what kind of tree you are actually looking at?
> 
Sorry for this Linus. I have applied these patches on linux-next's
3.17-rc6. Just checked the other patch fixing these have come after rc6.
Should have done on master or gpio tree master.

Will be more careful next time.

> Yours,
> Linus Walleij
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
