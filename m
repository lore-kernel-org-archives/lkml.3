Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab3GGVjX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 17:39:23 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:36844 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185Ab3GGVjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 17:39:19 -0400
MIME-Version: 1.0
In-Reply-To: <20130707041714.GB16653@intel.com>
References: <20130707041714.GB16653@intel.com>
Date: Sun, 7 Jul 2013 14:39:18 -0700
X-Google-Sender-Auth: qymQIQka9Wu2vzFixdRfb6ZA5MQ
Message-ID: <CA+55aFw3c2RO-MeocJ0YL_pEy3X1+mAwvQBeVAiND9ia6M-vJA@mail.gmail.com>
Subject: Re: [GIT PULL] slave-dmaengine updates
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dan Williams <djbw@fb.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 6, 2013 at 9:17 PM, Vinod Koul <vinod.koul@intel.com> wrote:
>
> Once you have some time from extended weekend celebrations please consider
> pulling the following to get:
> - Various fixes and PCI driver for dw_dmac by Andy
> - DT binding for imx-dma by Markus & imx-sdma by Shawn
> - DT fixes for dmaengine by Lars
> - jz4740 dmac driver by Lars
> - and various fixes across the drivers

Sadly, I noticed much too late that I should have checked the
time-stamps on this too. Almost all of the commits seem to have been
rebased recently. Not quite minutes before the pull request, but 90%
of the commits seem to have been created long after the merge window
opened.

I have already pushed this out so it's too late now, but if I had
noticed earlier I would have rejected this pull too.

Today has not been a good day for pulling. If it wasn't for the
__cpuinit removal pull, I wouldn't have had *anything* today that did
things properly.

                     Linus "very annoyed" Torvalds
