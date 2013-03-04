Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab3CDC5i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 21:57:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:38879 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012Ab3CDC5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 21:57:37 -0500
Message-ID: <51340DC0.8070708@infradead.org>
Date: Sun, 03 Mar 2013 18:58:08 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nishanth Menon <nm@ti.com>, Carlos Chinea <carlos.chinea@nokia.com>,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH resend] hsi: fix kernel-doc warnings
References: <5130FD73.9030601@infradead.org> <CACRpkdb83GYi7FNjz-ZgbatTQzgZsB=PdkiCuVFt4TK1s2kM+g@mail.gmail.com>
In-Reply-To: <CACRpkdb83GYi7FNjz-ZgbatTQzgZsB=PdkiCuVFt4TK1s2kM+g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/13 18:56, Linus Walleij wrote:
> On Fri, Mar 1, 2013 at 8:11 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
> 
>> From: Randy Dunlap <rdunlap@infradead.org>
>>
>> Fix kernel-doc warnings in hsi files:
>>
>> Warning(include/linux/hsi/hsi.h:136): Excess struct/union/enum/typedef member 'e_handler' description in 'hsi_client'
>> Warning(include/linux/hsi/hsi.h:136): Excess struct/union/enum/typedef member 'pclaimed' description in 'hsi_client'
>> Warning(include/linux/hsi/hsi.h:136): Excess struct/union/enum/typedef member 'nb' description in 'hsi_client'
>> Warning(drivers/hsi/hsi.c:434): No description found for parameter 'handler'
>> Warning(drivers/hsi/hsi.c:434): Excess function parameter 'cb' description in 'hsi_register_port_event'
>>
>> Don't document "private:" fields with kernel-doc notation.
>> If you want to leave them fully documented, that's OK, but
>> then don't mark them as "private:".
>>
>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>> Cc: Carlos Chinea <carlos.chinea@nokia.com>
>> Cc: Linus Walleij <linus.walleij@linaro.org>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: linux-kernel@vger.kernel.org
>> Cc: linux-omap@vger.kernel.org
>> Acked-by: Nishanth Menon <nm@ti.com>
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> HSI is basically orphaned FTM.
> 
> Andrew can you pick this into your orphanage?

Linus (Torvalds) already merged it.  Thanks.


-- 
~Randy
