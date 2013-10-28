Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab3J1LKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 07:10:49 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:48104 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529Ab3J1LKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 07:10:47 -0400
Message-ID: <526E4634.1070505@gmail.com>
Date: Mon, 28 Oct 2013 12:10:44 +0100
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        linux-usb@vger.kernel.org, kishon@ti.com
Subject: Re: [PATCH 1/2] dma: cppi41: redo descriptor collection in abort
 case
References: <1382019576-25105-1-git-send-email-bigeasy@linutronix.de> <525FF234.8010105@linutronix.de> <525FF2E4.8030304@gmail.com> <525FF5E6.2090709@linutronix.de> <5260F961.1000308@gmail.com>
In-Reply-To: <5260F961.1000308@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2013 11:03 AM, Daniel Mack wrote:
> Hi Sebastian,
> 
> On 10/17/2013 04:36 PM, Sebastian Andrzej Siewior wrote:
>> On 10/17/2013 04:23 PM, Daniel Mack wrote:
>>>> Daniel, could please look if this solves your suspend / resume warnings?
> 
> Looking very good :)
> 
>> dma: cppi41: add support for suspend and resume
>> dma: cppi41: restore more registers
>> dma: cppi41: use cppi41_pop_desc() where possible
>> dma: cppi41: redo descriptor collection in abort case
>> dma: cppi41: return code > 0 of pm_runtime_get_sync() is not an error
> 
> Tested with those patches applied, and did dozens of sleep/resume cycley
> - no problem seen.
> 
> Thanks a bunch again. Vinod, you can add my
> 
> 	Tested-by: Daniel Mack <zonque@gmail.com>
> 
> if you want.

Vinod, in case you're ok with these changes, it would be good to have
them for 3.13. Sebastian recently resent them all again (3 from me, 2
from him).


Thanks,
Daniel

