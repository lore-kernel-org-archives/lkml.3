Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623AbaJAIPq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 04:15:46 -0400
Received: from smtp81.ord1c.emailsrvr.com ([108.166.43.81]:59105 "EHLO
	smtp81.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751615AbaJAIPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 04:15:43 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
Message-ID: <542BB904.1010705@smartplayin.com>
Date: Wed, 01 Oct 2014 13:49:16 +0530
From: Pramod Gurav <pramod.gurav@smartplayin.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-input@vger.kernel.org,
        linux-gpio@vger.kernel.org
Subject: Re: [PATCH] HID: cp2112: remove use of gpiochip_remove() retval
References: <1412087049-4368-1-git-send-email-pramod.gurav@smartplayin.com> <alpine.LNX.2.00.1410010917000.26311@pobox.suse.cz> <542BACB3.3010203@smartplayin.com> <alpine.LNX.2.00.1410011000450.26311@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1410011000450.26311@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 October 2014 01:31 PM, Jiri Kosina wrote:
> On Wed, 1 Oct 2014, Pramod Gurav wrote:
> 
>>>>> Cc: Linus Walleij <linus.walleij@linaro.org>
>>>>> Cc: Alexandre Courbot <gnurou@gmail.com>
>>>>> Cc: Jiri Kosina <jkosina@suse.cz>
>>>>> Cc: linux-input@vger.kernel.org 
>>>>> Cc: linux-gpio@vger.kernel.org
>>>>>
>>>>> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
>>> I guess this depends on some other patch that hasn't gone to Linus yet, 
>>> right? As Linus' tree currently has this prototype:
>>>
>>> 	int gpiochip_remove(struct gpio_chip *chip)
>>
>> Yes. It is yet to make it to linus's tree. But the change is there in
>> linux-next master branch.
> 
> Alright. It probably makes most sense to take this patch together with the 
> prototype change in one pile (i.e. not through my tree).
> 
> For that purpose
> 
> 	Acked-by: Jiri Kosina <jkosina@suse.cz>

Jiri,

Just realized when Linus told me these changes are already in his tree
as well as in mast of linux-tree. Sorry for spaming and late realizing this.

> 
