Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392Ab3A3Q1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 11:27:51 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:54716 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab3A3Q1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 11:27:48 -0500
MIME-Version: 1.0
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F00207A707B4BE@AUSP01VMBX24.collaborationhost.net>
References: <1359547209-15712-1-git-send-email-geert@linux-m68k.org>
	<ADE657CA350FB648AAC2C43247A983F00207A707B4BE@AUSP01VMBX24.collaborationhost.net>
Date: Wed, 30 Jan 2013 17:27:45 +0100
X-Google-Sender-Auth: IyhOs7GiKJiXA4SP3wvb3-ZbYko
Message-ID: <CAMuHMdVzvAcYMk9AqsYZXupVud7PksR5O+eXPw4UTiF0jBdQYQ@mail.gmail.com>
Subject: Re: [PATCH -next] staging: comedi: ISA DMA drivers should depend on ISA_DMA_API
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mori Hess <fmhess@users.sourceforge.net>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 5:24 PM, H Hartley Sweeten
<hartleys@visionengravers.com> wrote:
> On Wednesday, January 30, 2013 5:00 AM, Geert Uytterhoeven wrote:
>
>> m68k allmodconfig:
>
> <snip>
>
>> Make PCL816, PCL818, DAS16, DAS1800, DT282X, and NI_AT_A2150 depend on
>> ISA_DMA_API to fix this.
>>
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>
> Looks like we have the first fallout from Greg's patch to enable comedi for
> all architectures... :-)

Yep.

BTW, I was actually surprised to see the old

       depends on BROKEN || FRV || M32R || MN10300 || SUPERH || TILE || \
                  X86 || ARM

as none of FRV, M32R, MN10300, SUPERH, TILE implement the ISA DMA API...

> Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
