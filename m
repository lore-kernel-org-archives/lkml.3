Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911AbaJCNIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 09:08:20 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:54787 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751885AbaJCNIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 09:08:15 -0400
Message-ID: <542E9FB8.3080201@hurleysoftware.com>
Date: Fri, 03 Oct 2014 09:08:08 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-serial@vger.kernel.org
CC: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, balbi@ti.com,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 00/13 v10] omap 8250 based UART + DMA
References: <1412014009-13315-1-git-send-email-bigeasy@linutronix.de>
In-Reply-To: <1412014009-13315-1-git-send-email-bigeasy@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2014 02:06 PM, Sebastian Andrzej Siewior wrote:
> The queue is getting smaller. The highlights of v9…v10
> - the DMA stall Frans Klaver reported which popped up in yocto is gone. It
>   also seems that the "ack the err-irq even if nothing happened" in EDMA
>   can be dropped.
> - the RX- and TX-DMA callbacks are now OMAP-only and no "bugs" flags are
>   introduced into the generic DMA code. This also means that there is
>   custom IRQ routine in case of DMA.

For the series:

Reviewed-by: Peter Hurley <peter@hurleysoftware.com>
