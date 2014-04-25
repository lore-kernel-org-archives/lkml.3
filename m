Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015AbaDYKgP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 06:36:15 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:36269 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbaDYKgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 06:36:11 -0400
MIME-Version: 1.0
In-Reply-To: <5211486.kMbLRJnNBP@wuerfel>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
	<201404221552.00501.arnd@arndb.de>
	<CAFiDJ58__vjDk93crSxGe1us0K7a3kSUwScgk=VaJYy+VqXsWQ@mail.gmail.com>
	<5211486.kMbLRJnNBP@wuerfel>
Date: Fri, 25 Apr 2014 18:36:10 +0800
X-Google-Sender-Auth: L7ppkDAe07UDEkFWQp2g4YBxUqg
Message-ID: <CAFiDJ58tCgczGMrQ4LCMoEfsjpjn6ZM428Uz31EKQpcHHo6GLw@mail.gmail.com>
Subject: Re: [PATCH 14/28] nios2: DMA mapping API
From: Ley Foon Tan <lftan@altera.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        cltang@codesourcery.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 6:33 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 25 April 2014 18:13:31 Ley Foon Tan wrote:
>> Actually, nios2 doesn't have DMA master with 0x00ffffff mask. I will
>> change it to return 1, same as some other architectures
>> implementation.
>> And the ZONE_DMA stuff will remove as well, it shouldn't have ZONE_DMA
>> limitation.
>
> Ok, excellent!
>
Thanks. BTW, do you have any chance to review other patches? :)

Regards
Ley Foon
