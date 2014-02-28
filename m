Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773AbaB1Iys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 03:54:48 -0500
Received: from moutng.kundenserver.de ([212.227.17.24]:60948 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbaB1Iyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 03:54:46 -0500
Message-ID: <53104E91.6070109@linux-pingi.de>
Date: Fri, 28 Feb 2014 09:53:37 +0100
From: Karsten Keil <kkeil@linux-pingi.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@osdl.org>, "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Jens Axboe <axboe@kernel.dk>, Karsten Keil <isdn@linux-pingi.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-atm-general@lists.sourceforge.net, linux-media@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 00/16] sleep_on removal, second try
References: <1393412516-3762435-1-git-send-email-arnd@arndb.de>
In-Reply-To: <1393412516-3762435-1-git-send-email-arnd@arndb.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:2TEHO/tSk+NiA8lcTB0NEHaXgEyee3UES6wIY5BXu+k
 PVeiHT1MqBesnggoDRUYs4t31R5q7BgddVE2RjDFjJfWGC+LOj
 Xu3x7/g6GZy56j6cYlX0DPG3YYtQvwTcZAvZhwcoB1A9J5T8mY
 cCBzK9EhiFFrncHputXkz0AsnDOQjIWcKw0vct49RYHck0PnZA
 1UZXQ9kAE+WFJ6jlp/i53Zl48Br8PHE7j5vaBqfgwelwgGPctD
 Cq38txnMhlrKBHkzWjXvsvveNSwBIwIL0vxe0gbu6iBhsDalyK
 25+kcD3wDFVYLCpt9fEDDzb0Wkb2tlVA8jkpF3/LPtKo+a4Lmw
 kjtNB96kS1ZCDdyOk9WROlRHn3Zxlm3tenZzO3FwVU5xuQ1nrI
 oUq5yWHSlWZmA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.02.2014 12:01, schrieb Arnd Bergmann:
> It's been a while since the first submission of these patches,
> but a lot of them have made it into linux-next already, so here
> is the stuff that is not merged yet, hopefully addressing all
> the comments.
> 
> Geert and Michael: the I was expecting the ataflop and atari_scsi
> patches to be merged already, based on earlier discussion.
> Can you apply them to the linux-m68k tree, or do you prefer
> them to go through the scsi and block maintainers?
> 
> Jens: I did not get any comments for the DAC960 and swim3 patches,
> I assume they are good to go in. Please merge.
> 
> Hans and Mauro: As I commented on the old thread, I thought the
> four media patches were on their way. I have addressed the one
> comment that I missed earlier now, and used Hans' version for
> the two patches he changed. Please merge or let me know the status
> if you have already put them in some tree, but not yet into linux-next
> 
> Greg or Andrew: The parport subsystem is orphaned unfortunately,
> can one of you pick up that patch?
> 
> Davem: The two ATM patches got acks, but I did not hear back from
> Karsten regarding the ISDN patches. Can you pick up all six, or
> should we wait for comments about the ISDN patches?
>


Ack on the ISDN stuff (12,13,14,15)


