Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab3HPPNf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 11:13:35 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:40817 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab3HPPNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 11:13:33 -0400
MIME-Version: 1.0
In-Reply-To: <87ob92rilt.fsf@kernel.org>
References: <1376149225-3997-1-git-send-email-Julia.Lawall@lip6.fr>
	<1376149225-3997-2-git-send-email-Julia.Lawall@lip6.fr>
	<1376151231.2083.32.camel@joe-AO722>
	<87ob92rilt.fsf@kernel.org>
Date: Fri, 16 Aug 2013 17:13:32 +0200
Message-ID: <CACRpkdYL8cOqM_S2LvZBHZPEG9_fGON0Ufb3FLN+0Wd4SVE9pg@mail.gmail.com>
Subject: Re: [PATCH 1/5] drivers/gpio/gpio-omap.c: convert comma to semicolon
From: Linus Walleij <linus.walleij@linaro.org>
To: Kevin Hilman <khilman@linaro.org>
Cc: Joe Perches <joe@perches.com>, Julia Lawall <Julia.Lawall@lip6.fr>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        kernel-janitors@vger.kernel.org,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 6:15 PM, Kevin Hilman <khilman@linaro.org> wrote:
> Joe Perches <joe@perches.com> writes:
>
>> On Sat, 2013-08-10 at 17:40 +0200, Julia Lawall wrote:
>>> From: Julia Lawall <Julia.Lawall@lip6.fr>
>>> Replace a comma between expression statements by a semicolon.
>> []
>>> I can't tell if the assignment to ct->regs.mask is really intended to be
>>> under the if.  The proposed patch preserves the current semantics, but not
>>> the current indentation.
>>
>> I'd suspect more that the indentation is correct
>> and the comma use incorrect.
>>
>> It also looks more like a copy/paste error from
>> commit f8b46b583 when the code was restructured
>> a bit.
>>
>> Kevin?
>
> Yes, looks like a copy/paste error.  The comma should simply be replaced
> by a semi-colon.

So can I have a patch for this? Pretty please...

Yours,
Linus Walleij
