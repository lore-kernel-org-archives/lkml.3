Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbaIZCWy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 22:22:54 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:49959 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195AbaIZCWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 22:22:52 -0400
MIME-Version: 1.0
In-Reply-To: <11277081.DWgcnnZv54@wuerfel>
References: <1410168160-3624-1-git-send-email-lftan@altera.com>
	<3608975.MxU44B73lk@wuerfel>
	<CAFiDJ58h4VKrr-wHe6iD+aPB8QU=xLo03kW5k6QDpLW5Et0DGw@mail.gmail.com>
	<11277081.DWgcnnZv54@wuerfel>
Date: Fri, 26 Sep 2014 10:22:50 +0800
X-Google-Sender-Auth: CBH7HdumGQyYnYyOD-oZ01rQScg
Message-ID: <CAFiDJ58Y1iQhkkS-OVwMBdowJnXKKbYfHttQibmBh_qa5vgOmQ@mail.gmail.com>
Subject: Re: [PATCH v3 01/29] asm-generic: add generic futex for !CONFIG_SMP
From: Ley Foon Tan <lftan@altera.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 6:54 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 25 September 2014 16:33:33 Ley Foon Tan wrote:
>> There are 4 patches that touching code outside of arch/nios2,
>> including this patch.
>> Do we have maintainers for common files for patch #15, #27 and #28
>> below? Can't find this info from MAINTAINERS file.
>> It is good if you can take a look this v3 patchset so I can send pull
>> request if no further issue. Thanks!
>>
>> [PATCH v3 01/29] asm-generic: add generic futex for !CONFIG_SMP
>
> You already have my Ack, which is sufficient here.
Okay, thanks.
>
>> [PATCH v3 15/29] Add ELF machine define for Nios2
>
> I'm not maintaining this one, but it looks very obvious, please
> add my Ack as well. I don't think you need to wait for anybody's
> input here.
Will add your ACK.
>
>> [PATCH v3 27/29] MAINTAINERS: Add nios2 maintainer
>
> This one is fine to go in. You basically own the entry though, so if
> anybody wants to change the text for nios2 later, they should ask
> for your Ack.
Okay.
>
>> [PATCH v3 28/29] Documentation: Add documentation for Nios2 architecture
>
> Randy Dunlap <rdunlap@infradead.org> is the maintainer listed for
> Documentation, and I see you already have linux-doc@vger.kernel.org
> on Cc here. Please make sure that Randy is on Cc for the documentation
> patches as well. A lot of documentation patches go in without his
> Ack, which I think is fine as long as someone else (i.e. you) is
> responsible for maintaining that documentation later.
Okay, will add Randy to CC list for Documentation patch.


Let me know if you done the review for v3 patchset. Thanks.

Regards
Ley Foon
