Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbaAJI4z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 03:56:55 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:41547 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbaAJI4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 03:56:50 -0500
MIME-Version: 1.0
In-Reply-To: <20140109085251.GA30534@quad.lixom.net>
References: <20140109085251.GA30534@quad.lixom.net>
Date: Fri, 10 Jan 2014 16:56:46 +0800
X-Google-Sender-Auth: gL4zZobTZytU2c4U71qFtKcETQ4
Message-ID: <CA+55aFx-+qP=8cz4xrwjde1sknObwjan3CUvg-n1StNMpr0Fcg@mail.gmail.com>
Subject: Re: [GIT PULL] ARM: SoC fixes for 3.13
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Olof Johansson <olof@lixom.net>
Cc: ARM SoC <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 9, 2014 at 4:52 PM, Olof Johansson <olof@lixom.net> wrote:
>
> ARM: SoC fixes for 3.13-rc
>
> Hopefully the last set of arm-soc fixes for 3.13, or at least only a
> few stray patches after this.
>
> There are a few fixes for Renesas platforms to fixup DMA masks (this
> started causing errors once the DMA API added checks for valid masks in
> 3.13). Two more dealing with resources for MMC and PWM setup.
>
> There's also a few TI/OMAP/DRA fixes for smaller stuff and a fix for
> compilation failures on a PXA platform.

Hmm. Most of that was all in your _previous_ pull request. When I pull
this time, I just get the few fixes for  Renesas DMA masks.

I pulled that and edited up the resulting merge message, but you
should double-check that I now have what you expected. Because your
pull request seems a bit confused about what's been going on..

           Linus
