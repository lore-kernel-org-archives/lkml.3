Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab3G2P6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 11:58:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:47715 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755648Ab3G2P6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 11:58:44 -0400
Date: Mon, 29 Jul 2013 17:58:43 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        george.cherian@ti.com
Subject: Re: [PATCH 2/4] usb: phy: add am335x pieces to generic phy
Message-ID: <20130729155843.GC827@linutronix.de>
References: <1374869757-923-1-git-send-email-bigeasy@linutronix.de>
 <1374869757-923-3-git-send-email-bigeasy@linutronix.de>
 <20130729122218.GG24801@radagast>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130729122218.GG24801@radagast>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi | 2013-07-29 15:22:18 [+0300]:

>On Fri, Jul 26, 2013 at 10:15:55PM +0200, Sebastian Andrzej Siewior wrote:
>> This patch copies the phy support bits from dsps into the generic phy
>> driver. Most code can be re-used except for the on/off.
>> The additional am335x can be removed once we have a phy driver that does
>> more than this.
>> 
>> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>
>this is good too, but looking at the amount of am335x-specific code in
>the driver now it makes me wonder if we want to convert phy-generic.c
>into a library...

So I just looked over George Cherian phy driver. I think the simplest
thing would be to add the usb wakeup path to the driver here. Earlier I
hoped that we could just remove the am335x bits and avoid the library
thingy :)
Since the library probably makes sense:
- before or after this patch
- where do I get the memory for this wakeup register? It is somewhere in
  the "reset module" of the am335x

Sebastian
