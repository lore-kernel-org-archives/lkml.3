Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759324Ab3K1RRI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 12:17:08 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:46479 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757452Ab3K1RRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 12:17:05 -0500
MIME-Version: 1.0
In-Reply-To: <CA+a=Yy5Q=urtPfLEcu0WDJngo_COOZGnBuuVkkwUezKfcoGEwA@mail.gmail.com>
References: <CA+a=Yy60b7nCjsXfczpOebbG27kJNoa9hPcdMHLJrN7qT5mfdg@mail.gmail.com>
	<CAMuHMdVS-EU0y+yLzdM=H20j7ewHKc_DAWFNL4Y1WE9_iNWVLA@mail.gmail.com>
	<CA+a=Yy5Q=urtPfLEcu0WDJngo_COOZGnBuuVkkwUezKfcoGEwA@mail.gmail.com>
Date: Thu, 28 Nov 2013 18:17:02 +0100
Message-ID: <CAFLxGvykU+KZg9q1pq68_p+2gfg+5auABX34df88qAF9v0vzMw@mail.gmail.com>
Subject: Re: How to create a config that doesn't set CONFIG_PROC_FS
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Peng Tao <lkml.bergwolf@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 4:02 PM, Peng Tao <lkml.bergwolf@gmail.com> wrote:
> On Thu, Nov 28, 2013 at 9:20 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>> On Thu, Nov 28, 2013 at 11:53 AM, Peng Tao <lkml.bergwolf@gmail.com> wrote:
>>> Even if I use `make allnoconfig`, CONFIG_PROC_FS is still set. So I'm
>>> wondering how to create a config without CONFIG_PROC_FS for build
>>> testing?
>>
>> It can be disabled only if CONFIG_EXPERT=y.
> Cool. Thank you very much!

Out of curiosity, for which use case do you need that?
Is is possible to run a sane userspace without procfs?

-- 
Thanks,
//richard
