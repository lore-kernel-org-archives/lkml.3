Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab3JQOXp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 10:23:45 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:48018 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab3JQOXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 10:23:44 -0400
Message-ID: <525FF2E4.8030304@gmail.com>
Date: Thu, 17 Oct 2013 16:23:32 +0200
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        linux-usb@vger.kernel.org, kishon@ti.com
Subject: Re: [PATCH 1/2] dma: cppi41: redo descriptor collection in abort
 case
References: <1382019576-25105-1-git-send-email-bigeasy@linutronix.de> <525FF234.8010105@linutronix.de>
In-Reply-To: <525FF234.8010105@linutronix.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2013 04:20 PM, Sebastian Andrzej Siewior wrote:
> On 10/17/2013 04:19 PM, Sebastian Andrzej Siewior wrote:
>> This patch changes the logic here to look on both queues for the
>> descriptor.
> 
> Daniel, could please look if this solves your suspend / resume warnings?

Will do (hopefully) tomorrow. So this is a replacement for my "dma:
cppi41: move -EAGAIN in tear_down" patch, or does it go on top of it?
How does your patch queue look like? Someone should probably re-collect
all necessary patches for the next merge window eventually, so Vinod
knows what to apply :)


Thanks,
Daniel

