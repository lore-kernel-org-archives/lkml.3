Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbaH2QcC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 12:32:02 -0400
Received: from www.linutronix.de ([62.245.132.108]:48039 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbaH2QcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 12:32:00 -0400
Message-ID: <5400AAF7.5060401@linutronix.de>
Date: Fri, 29 Aug 2014 18:31:51 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: balbi@ti.com, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH 15/15] tty: serial: 8250: omap: add dma support
References: <20140815210211.GD9239@atomide.com> <53F5AF0D.5060409@linutronix.de> <20140821184416.GF10066@atomide.com> <53FE3779.5090908@linutronix.de> <20140827202313.GF16006@atomide.com> <20140828082348.GA5413@linutronix.de> <20140828164645.GG16006@atomide.com> <53FF84DF.7080406@linutronix.de> <20140828225454.GM16006@atomide.com> <540048B4.7010807@linutronix.de> <20140829161221.GO16006@atomide.com>
In-Reply-To: <20140829161221.GO16006@atomide.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2014 06:12 PM, Tony Lindgren wrote:
> Looks like the paste bug is there for sure, doing off idle and pasting
> 240 characters to the console can hang the UART RX after few attempts,
> and pasting 16 charactes won't show up at all if the system is idling.
> So you may want to play with that too a bit :)

Oh. perfect. Please note that we the threshold moved from 16 to 48.
However I see that usually we lose a lot of characters before the uart
wakes up and does its job. Usually I see a couple characters but
sometimes is see broken characters which suggests that the clock was
not (yet) perfect. And I managed not get get it woken once.
So let me look at this once I am through with the review responses…

> 
> Regards,
> 
> Tony
> 
Sebastian
