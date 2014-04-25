Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636AbaDYKeG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 06:34:06 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:50780 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbaDYKd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 06:33:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ley Foon Tan <lftan@altera.com>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        cltang@codesourcery.com
Subject: Re: [PATCH 14/28] nios2: DMA mapping API
Date: Fri, 25 Apr 2014 12:33:56 +0200
Message-ID: <5211486.kMbLRJnNBP@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAFiDJ58__vjDk93crSxGe1us0K7a3kSUwScgk=VaJYy+VqXsWQ@mail.gmail.com>
References: <1397824031-4892-1-git-send-email-lftan@altera.com> <201404221552.00501.arnd@arndb.de> <CAFiDJ58__vjDk93crSxGe1us0K7a3kSUwScgk=VaJYy+VqXsWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:CLYwUFmFvHVgvJgORC24NANu1/ut7k2Lel0CekrrT4p
 Rg1iKHx0TD28cfcGEV/tL0TGMG2uQ4iS6+xQ1FkKKRsK39pIds
 TPX20+aH2u3BEVfSwE7HAaajONvQjsR9lUOjz2636c2Hh6mGHH
 TBYsDJLRfNb0qskf1snhob9YcH5DTfLJpNJKRs5CEIchdz2xON
 5dYedVQFQ9Hlr3yUMEM5nH9BMMTveZPFZtdelg6P216XpUd5Rv
 kRrPGzb/rbwlx/8+mWHQs5L7DXM9xakxkdhkMvw/g/7yUaBy80
 ezWnutmuIxhPJwDlwygVW3lSSmBSk1ewH/kX0RZt3Ew6jWPW+J
 ebG8N2w2LuOC5k1R5S9k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 April 2014 18:13:31 Ley Foon Tan wrote:
> Actually, nios2 doesn't have DMA master with 0x00ffffff mask. I will
> change it to return 1, same as some other architectures
> implementation.
> And the ZONE_DMA stuff will remove as well, it shouldn't have ZONE_DMA
> limitation.

Ok, excellent!

	Arnd
