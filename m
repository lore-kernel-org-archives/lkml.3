Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759332Ab3GZPo5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 11:44:57 -0400
Received: from www.linutronix.de ([62.245.132.108]:37891 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759195Ab3GZPow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 11:44:52 -0400
Date: Fri, 26 Jul 2013 17:44:50 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Bin Liu <binmlist@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        george.cherian@ti.com
Subject: Re: [PATCH 14/16] usb: musb: dsps: add MUSB_DEVCTL_SESSION back
 after removal
Message-ID: <20130726154450.GA29819@linutronix.de>
References: <1374516607-2705-1-git-send-email-bigeasy@linutronix.de>
 <1374516607-2705-15-git-send-email-bigeasy@linutronix.de>
 <CADYTM3a5xzs+-VCTeKLGiRjo7JOqOJ5H4EWDACpTMovY5_ooRA@mail.gmail.com>
 <51EEBE05.2040000@linutronix.de>
 <CADYTM3ZfvDDKY6NyAv9xGSZ0angGYVOGf8uUDR2vU1jDwCGmzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CADYTM3ZfvDDKY6NyAv9xGSZ0angGYVOGf8uUDR2vU1jDwCGmzA@mail.gmail.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Bin Liu | 2013-07-23 13:55:27 [-0500]:

>Hi Sebastian,
Hi Bin,

>> In my testing the bit remains set. How is the bit supposed to come back
>> after I connect a host device?
>The bit remains even when no device is plugged and ID ping is float?
After I set it, it remains set yes.

>what platform do you use to test it?
AM335x evm

>'a host device'? you meant a usb device? By the otg specs, the session
>will not automatically start. The user/app has to issue the command,
>either by SRP or HNP, or something else. In TI 3.2 kernel, there is
>workaround in otg_timer() to _toggle_ the SESSION bit to detect if ID
>pin is grounded, which means a USB device is connected.

I see. Let me check that TI kernel. The same thing happens however if
the musb is configured as host (not OTG). 

>Regards,
>-Bin.

Sebastian
