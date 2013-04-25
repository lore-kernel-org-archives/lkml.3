Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab3DYNYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 09:24:25 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:36539 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932299Ab3DYNYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 09:24:22 -0400
MIME-Version: 1.0
In-Reply-To: <20130425132025.GM4623@gmail.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
	<1366279934-30761-5-git-send-email-lee.jones@linaro.org>
	<CACRpkdaauDYTdoBHGG9FO4kKqvCYyCrjY8EGWs5gAQWErGW6_A@mail.gmail.com>
	<20130425090612.GC4623@gmail.com>
	<CACRpkdbV8yEK0470q_-DWv6Q0hAG2wGntXFi5kaLUMgm9b=e-Q@mail.gmail.com>
	<20130425132025.GM4623@gmail.com>
Date: Thu, 25 Apr 2013 15:24:21 +0200
Message-ID: <CACRpkdbpbQTCxeQ6cCbAkvvQXJMQUhLv8=qcbBgvBVnMDdysOA@mail.gmail.com>
Subject: Re: [PATCH 04/32] dmaengine: ste_dma40: Amalgamate DMA source and
 destination channel numbers
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Per Forlin <per.forlin@stericsson.com>, Rabin Vincent <rabin@rab.in>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 3:20 PM, Lee Jones <lee.jones@linaro.org> wrote:
> On Thu, 25 Apr 2013, Linus Walleij wrote:

>> As we may want to support DEV_TO_DEV at some point.
>>
>> Then no longer, and that is not related to $SUBJECT.
>
> That's not why I'm removing it. The statement can never be true due to
> the fact that the second evaluation (src_event_group != dst_event_group)
> can never be true, which is a direct effect of 'THIS_PATCH'.

OK that is correct, I'm fine with this then ... as part of that other
patch dealing with unreacable conditions I keep talking about...

Yours,
Linus Walleij
