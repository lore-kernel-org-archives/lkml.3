Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbaGLQPV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 12:15:21 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:56081 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaGLQPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 12:15:20 -0400
Date: Sat, 12 Jul 2014 09:15:43 -0700
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        ARM Maintainers <arm@kernel.org>, Bo Shen <voice.shen@atmel.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        jiri.prchal@aksignal.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: at91: at91sam9x5: add clocks for usb device
Message-ID: <20140712161543.GA3107@quad.lixom.net>
References: <1405096496-4139-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405096496-4139-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 06:34:56PM +0200, Nicolas Ferre wrote:
> From: Bo Shen <voice.shen@atmel.com>
> 
> Add clocks for usb device, or else switch to CCF, the gadget
> won't work.
> 
> Reported-by: Jiri Prchal <jiri.prchal@aksignal.cz>
> Signed-off-by: Bo Shen <voice.shen@atmel.com>
> Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> Tested-by: Jiri Prchal <jiri.prchal@aksignal.cz>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
> Arnd, Olof, Kevin,
> 
> This fix is the only one that I have for 3.16-rc currently. Can you please
> take it as a patch and queue it? It can go on top of already sent AT91 fixes
> for 3.16 or a 3.16-rc4.

Certainly. Appled to fixes now.


-Olof
