Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbaIDO4c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 10:56:32 -0400
Received: from www.linutronix.de ([62.245.132.108]:52759 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbaIDO4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 10:56:30 -0400
Message-ID: <54087D94.7000208@linutronix.de>
Date: Thu, 04 Sep 2014 16:56:20 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: balbi@ti.com, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Vinod Koul <vinod.koul@intel.com>, Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH 15/15] tty: serial: 8250: omap: add dma support
References: <53FF84DF.7080406@linutronix.de> <20140828225454.GM16006@atomide.com> <540048B4.7010807@linutronix.de> <20140829161221.GO16006@atomide.com> <5404B149.6010400@linutronix.de> <54060EDA.6060204@linutronix.de> <20140902201536.GC11766@atomide.com> <540745CC.2090901@linutronix.de> <20140903174845.GE11766@atomide.com> <54086CA7.8020507@linutronix.de> <20140904145203.GR11766@atomide.com>
In-Reply-To: <20140904145203.GR11766@atomide.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2014 04:52 PM, Tony Lindgren wrote:
> Yeah makes sense to me. Thanks for ensuring the bug
> compability :)

Thanks. What about the ttyOx vs ttySx. Do you want me to add kernel
line fixup somewhere arch/arm or we ignore this for now? Greg didn't
say anything…

> 
> Regards,
> 
> Tony
> 

Sebastian
