Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbbAKMK0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 07:10:26 -0500
Received: from cassarossa.samfundet.no ([193.35.52.29]:43311 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbbAKMKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 07:10:24 -0500
Date: Sun, 11 Jan 2015 13:10:12 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] avr32: remove fake at91 cpu identification
Message-ID: <20150111121012.GB4050@samfundet.no>
References: <1420941616-2777-1-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420941616-2777-1-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Sun 11 Jan 2015 03:00:16 +0100 or thereabout, Alexandre Belloni wrote:
> cpu_is_at91* are not used in any driver outside mach-at91. Remove those useless
> definitions.

Great, thank you for cleaning.

> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
>

Acked-by: Hans-Chrisitan Egtvedt <egtvedt@samfundet.no>

> ---
> 
> Hans-Christian,
> 
> If you want, I guess that one could go through the at91 tree. Unless you have
> more material and you want to do a pull request for 3.20.

I have another patch in the pipe wiring up syscalls for AVR32, so I'll push
this through my tree for 3.20.

>  arch/avr32/mach-at32ap/include/mach/cpu.h | 26 +-------------------------
>  1 file changed, 1 insertion(+), 25 deletions(-)

<snipp diff>

-- 
HcE
