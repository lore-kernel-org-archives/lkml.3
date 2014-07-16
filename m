Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759439AbaGPBgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 21:36:17 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:63834 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbaGPBgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 21:36:15 -0400
MIME-Version: 1.0
In-Reply-To: <5671533.7yANBX1RSQ@wuerfel>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
	<6364841.e2Acy30lOs@wuerfel>
	<20140715111237.GF7668@distanz.ch>
	<5671533.7yANBX1RSQ@wuerfel>
Date: Wed, 16 Jul 2014 09:36:14 +0800
Message-ID: <CAFiDJ5-Q4eKV1kT5dsQQshQ942GCD0BwC+y9+qbSWBT2dTacPw@mail.gmail.com>
Subject: Re: [PATCH v2 24/29] nios2: Module support
From: "LF.Tan" <lftan.linux@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tobias Klauser <tklauser@distanz.ch>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 8:21 PM, Arnd Bergmann <arnd@arndb.de> wrote:

>>
>> AFAIR this is due to relocation issues, as the FIXME comment in the
>> "original" code [1] states. I don't know whether this still applies,
>> though (or what would be the proper fix for this to overcome the
>> relocation issues).
>>
>> [1] https://github.com/tklauser/linux-nios2/blob/nios2/arch/nios2/kernel/module.c#L45
>>
>
> Ah, I see. Please at least copy over that comment then.
Will copy over the comment.

>
> A long-term solution would be to copy what ARM does, since that
> has the same problem. The modules are allocated with
> __vmalloc_node_range, passing a virtual address range that
> is just before the kernel virtual address, taken out of the
> top 16MB of the user space addresses.
Noted, will investigate this for long-term solution.

Thanks.

Regards
Ley Foon
