Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbaBOOp6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 09:45:58 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:50803 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbaBOOp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 09:45:57 -0500
MIME-Version: 1.0
In-Reply-To: <20140209194501.GD573@drone.musicnaut.iki.fi>
References: <1391952745.25424.6.camel@x220>
	<CAOiHx=mi3sW7C0ZGwAhobRryikMs=Hj0UL19ENuUMECqk0EW5g@mail.gmail.com>
	<20140209194501.GD573@drone.musicnaut.iki.fi>
Date: Sat, 15 Feb 2014 22:45:55 +0800
Message-ID: <CAAhV-H6f5BqYPyyn6dZHCpOJJK5ZyM=WHaJKeRVk3wgdk82i6w@mail.gmail.com>
Subject: Re: [PATCH] MIPS: Replace CONFIG_MIPS64 and CONFIG_MIPS32_R2
From: Huacai Chen <chenhuacai@gmail.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Jonas Gorski <jogo@openwrt.org>, Paul Bolle <pebolle@tiscali.nl>,
        Ralf Baechle <ralf@linux-mips.org>,
        MIPS Mailing List <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think Paul Bolle's patch is correct and my first patch is not
enough. So it needn't to make a separate patch, just take Paul's patch
and my second patch is enough.

On Mon, Feb 10, 2014 at 3:45 AM, Aaro Koskinen <aaro.koskinen@iki.fi> wrote:
> Hi,
>
> On Sun, Feb 09, 2014 at 05:26:59PM +0100, Jonas Gorski wrote:
>> On Sun, Feb 9, 2014 at 2:32 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
>> > Commit 597ce1723e0f ("MIPS: Support for 64-bit FP with O32 binaries")
>> > introduced references to two undefined Kconfig macros. CONFIG_MIPS32_R2
>> > should clearly be replaced with CONFIG_CPU_MIPS32_R2. And CONFIG_MIPS64
>> > should apparently be replaced with CONFIG_64BIT.
>>
>> While I agree about the CONFIG_MIPS64 => CONFIG_64BIT replacement, I
>> wonder if CONFIG_MIPS32_R2 shouldn't rather be CONFIG_CPU_MIPSR2
>> (maybe even the existing CONFIG_CPU_MIPS32_R2 are wrong here).
>
> FYI, the 64BIT part is already fixed by
> <http://patchwork.linux-mips.org/patch/6506/>. I guess these two changes
> could be separate patches.
>
> A.
>
