Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308Ab3EXRZr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 13:25:47 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37553 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757210Ab3EXRZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 13:25:44 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <20130524171709.GH24476@game.jcrosoft.org>
References: <1369410151-7837-1-git-send-email-nicolas.ferre@atmel.com>
	<CAOesGMjvKhVKZf9A70K7VzXikY902KVyKR==4ivnb-gxhyRCPQ@mail.gmail.com>
	<20130524171709.GH24476@game.jcrosoft.org>
Date: Fri, 24 May 2013 10:25:43 -0700
Message-ID: <CAOesGMjOaWardKRq-8BM_v8JKx+-Vgzg6XRRL5E1FQTut_ePdQ@mail.gmail.com>
Subject: Re: [GIT PULL] at91: fixes for 3.10 #2
From: Olof Johansson <olof@lixom.net>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        b.brezillon@overkiz.com,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 10:17 AM, Jean-Christophe PLAGNIOL-VILLARD
<plagnioj@jcrosoft.com> wrote:
> On 10:11 Fri 24 May     , Olof Johansson wrote:
>> Hi,
>>
>> I'll pull this for now, but...
>>
>>
>> > Jean-Christophe PLAGNIOL-VILLARD (1):
>> >       ARM: at91: at91sam9n12: move external irq declatation to DT
>>
>> This one is not a fix. While OK this time, please stick to only
>> sending true fixes for 3.10 from here on out.
>
> it's as you must specify them via DT, the C code is not event use in case of
> DT
> I should have put fix in the commit
>

I don't understand.


-Olof
