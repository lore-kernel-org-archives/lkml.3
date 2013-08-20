Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251Ab3HTNMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 09:12:18 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:64529 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab3HTNMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 09:12:17 -0400
Message-ID: <52136B2C.3030509@gmail.com>
Date: Tue, 20 Aug 2013 15:12:12 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
CC: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 08/17] ARM: mvebu: remove custom .init_time hook
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com> <1376964271-22715-9-git-send-email-sebastian.hesselbarth@gmail.com> <20130820125012.GA4272@localhost>
In-Reply-To: <20130820125012.GA4272@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/13 14:50, Ezequiel Garcia wrote:
> I've only received a few patches of this series. I *think*
> using "RFC" alone is not correct in LAKML and for some reason
> you're required to use RFC/PATCH.

Ezequiel,

we already sorted out, why they got stuck on LAKML. It is because
of the missing PATCH prefix, I'll add that in future postings for sure.

But the patches should have been managed to get through to LKML.

> Maybe that's why I'm getting only the patches where I'm Cced?

I try to keep Cc list as short as possible, so I only put Gregory as the 
maintainer of mach-mvebu on Cc.

> Could you please re-send this? The series looks promising and I'd like
> to take a peep :-)

No, I am not going to resend v1 but only updates. For a single mach
you need patches [1], [2], and the one supposed for your mach.

> BTW, some of this (but not all) has already been posted [1, 2] and
> is on its way to v3.12 through Daniel Lezcano.
>
> (Maybe you already noticed, but just in case...)
>
> [1] http://www.spinics.net/lists/arm-kernel/msg265509.html
> [2] http://comments.gmane.org/gmane.linux.ports.arm.kernel/260179

I expect machs to move until all of it has been Ack'ed, so I
based in on most recent tag of linux-next yesterday.

Sebastian

[1] https://lkml.org/lkml/2013/8/19/591
[2] https://lkml.org/lkml/2013/8/19/592

