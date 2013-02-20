Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759020Ab3BTSJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 13:09:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55651 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698Ab3BTSJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 13:09:36 -0500
Message-ID: <51251101.5070008@zytor.com>
Date: Wed, 20 Feb 2013 10:08:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Alessandro Rubini <rubini@gnudd.com>
CC: x86@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        linux-kernel@vger.kernel.org, Davide Ciminaghi <ciminaghi@gnudd.com>
Subject: Re: tip/x86/amba
References: <20130220073554.GA10939@mail.gnudd.com>
In-Reply-To: <20130220073554.GA10939@mail.gnudd.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2013 11:35 PM, Alessandro Rubini wrote:
> Hello Peter and maintainers.
> 
> I wonder what are the plans for the branch x86/amba, part of the tip
> repository.  Of the 7 patches in that branch, 2 are already upstream
> and the other 5 rebase perfectly (only conflicts are in the header
> stanzas). This is the reverse log from next to my current working tree:
> 
>   0e7e31f DMA: PL330: use prefix in reg names to build under x86
>   1e8486a watchdog: sp805_wdt depends on ARM
>   6417077 mmc: Use the new <linux/sizes.h>
>   52b9f4e drivers/amba: add support for a PCI bridge
>   d8d2313 x86: add CONFIG_ARM_AMBA, selected by STA2X11
> 
> They all have the proper acked and signed-off, as well as references
> to the original mailing list message by my mate Davide who submitted
> them.
> 
> Shall I just wait for you to merge or shall I repost to the mailing
> lists? In the latte case, with or without the various ack/signoff?
> 

We have been waiting for you to sort out the breakages and let us know
that the problems has been resolved.  Sorry, the number of email threads
have been absolutely crazy and so I have not tracked them all.

We have not been testing this branch.

What are the upstream commits?

	-hpa

