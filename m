Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab3GCAAp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 20:00:45 -0400
Received: from mail-qe0-f53.google.com ([209.85.128.53]:38106 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab3GCAAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 20:00:44 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <CA+55aFzV12kJgNOax7B1rM8capK2uYLH66wHnQRNn4k5wa1LMQ@mail.gmail.com>
References: <201307022055.50717.arnd@arndb.de>
	<201307022104.01826.arnd@arndb.de>
	<20130702231706.GF24642@n2100.arm.linux.org.uk>
	<CA+55aFzV12kJgNOax7B1rM8capK2uYLH66wHnQRNn4k5wa1LMQ@mail.gmail.com>
Date: Tue, 2 Jul 2013 17:00:43 -0700
Message-ID: <CAOesGMifPRVr=TVWJfEOm83tMVE0aXFCBVNvAKLV8mvqbDEJmQ@mail.gmail.com>
Subject: Re: [GIT PULL 3/7] ARM SoC specific changes
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ARM SoC <arm@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 2, 2013 at 4:51 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Jul 2, 2013 at 4:17 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
>> Please don't merge this yet.
>
> Oops, too late. The ARM SoC pull requests got merged a couple of hours ago..

It should hopefully not be a big problem, you'll see a merge conflict
(so will sfr) when merging from Russell due to add/add conflicts been
resolved by ordering them in opposite order in
arch/arm/include/asm/glue-proc.h.

Feel free to flip them back to Russell's preferred ordering at that
time, of course.


-Olof
