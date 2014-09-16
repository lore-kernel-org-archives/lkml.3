Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986AbaIPM5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 08:57:43 -0400
Received: from www.linutronix.de ([62.245.132.108]:41794 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206AbaIPM5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 08:57:42 -0400
Message-ID: <541833C0.5020106@linutronix.de>
Date: Tue, 16 Sep 2014 14:57:36 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        balbi@ti.com, gregkh@linuxfoundation.org
Subject: Re: [PATCH 00/16 v9] omap 8250 based uart + DMA
References: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de> <20140912224324.GK18849@atomide.com> <5416D2A0.5020407@linutronix.de>
In-Reply-To: <5416D2A0.5020407@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2014 01:50 PM, Sebastian Andrzej Siewior wrote:
> I changed the restore function the fix the am335x-evm + less "freeze".
> And now we have this. So let me search…

IER was 0 by accident. It fixed in TX path.
I pushed uart_v10_pre1 which should have it fixed aport from other
things…
I am going to address the review comments, to split the DMA callbacks
as requested and if nobody comes up with something fancy we will have a
v10 :)

>> Regards,
>>
>> Tony

Sebastian
