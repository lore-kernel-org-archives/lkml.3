Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955AbaAJQE2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 11:04:28 -0500
Received: from mail-qe0-f49.google.com ([209.85.128.49]:38486 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbaAJQEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 11:04:25 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <CA+55aFx-+qP=8cz4xrwjde1sknObwjan3CUvg-n1StNMpr0Fcg@mail.gmail.com>
References: <20140109085251.GA30534@quad.lixom.net>
	<CA+55aFx-+qP=8cz4xrwjde1sknObwjan3CUvg-n1StNMpr0Fcg@mail.gmail.com>
Date: Fri, 10 Jan 2014 08:04:25 -0800
Message-ID: <CAOesGMjSD1Ud3gFDoYSfTcCh5wK_xgd3zRKXn+DK2LJ=u4G3FQ@mail.gmail.com>
Subject: Re: [GIT PULL] ARM: SoC fixes for 3.13
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ARM SoC <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 12:56 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Jan 9, 2014 at 4:52 PM, Olof Johansson <olof@lixom.net> wrote:
>>
>> ARM: SoC fixes for 3.13-rc
>>
>> Hopefully the last set of arm-soc fixes for 3.13, or at least only a
>> few stray patches after this.
>>
>> There are a few fixes for Renesas platforms to fixup DMA masks (this
>> started causing errors once the DMA API added checks for valid masks in
>> 3.13). Two more dealing with resources for MMC and PWM setup.
>>
>> There's also a few TI/OMAP/DRA fixes for smaller stuff and a fix for
>> compilation failures on a PXA platform.
>
> Hmm. Most of that was all in your _previous_ pull request. When I pull
> this time, I just get the few fixes for  Renesas DMA masks.

I had a stale remote for your tree when I generated the pull request,
and I had forgotten that I sent most of it already so I didn't notice.

> I pulled that and edited up the resulting merge message, but you
> should double-check that I now have what you expected. Because your
> pull request seems a bit confused about what's been going on..

Yeah, looks good. Apologies for the confusion.


-Olof
