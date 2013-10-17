Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674Ab3JQOg1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 10:36:27 -0400
Received: from www.linutronix.de ([62.245.132.108]:35434 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755695Ab3JQOg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 10:36:26 -0400
Message-ID: <525FF5E6.2090709@linutronix.de>
Date: Thu, 17 Oct 2013 16:36:22 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Daniel Mack <zonque@gmail.com>
CC: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        linux-usb@vger.kernel.org, kishon@ti.com
Subject: Re: [PATCH 1/2] dma: cppi41: redo descriptor collection in abort
 case
References: <1382019576-25105-1-git-send-email-bigeasy@linutronix.de> <525FF234.8010105@linutronix.de> <525FF2E4.8030304@gmail.com>
In-Reply-To: <525FF2E4.8030304@gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2013 04:23 PM, Daniel Mack wrote:
>> Daniel, could please look if this solves your suspend / resume warnings?
> 
> Will do (hopefully) tomorrow. So this is a replacement for my "dma:
> cppi41: move -EAGAIN in tear_down" patch, or does it go on top of it?

I applied your three patches and manage to break 2 of 4 tests I had. It
was still the same without your patch. So I made this change and merged
it back into your patch so this patch should apply ontop of your 2/3.

> How does your patch queue look like? Someone should probably re-collect
> all necessary patches for the next merge window eventually, so Vinod
> knows what to apply :)

dma: cppi41: add support for suspend and resume
dma: cppi41: restore more registers
dma: cppi41: use cppi41_pop_desc() where possible
dma: cppi41: redo descriptor collection in abort case
dma: cppi41: return code > 0 of pm_runtime_get_sync() is not an error

The first one is in Vinod's tree.

> 
> Thanks,
> Daniel

Sebastian

