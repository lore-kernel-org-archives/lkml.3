Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758816Ab3GZQbH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 12:31:07 -0400
Received: from www.linutronix.de ([62.245.132.108]:38135 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758367Ab3GZQbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 12:31:03 -0400
Date: Fri, 26 Jul 2013 18:31:01 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Bin Liu <binmlist@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        george.cherian@ti.com
Subject: Re: [PATCH 14/16] usb: musb: dsps: add MUSB_DEVCTL_SESSION back
 after removal
Message-ID: <20130726163101.GB29819@linutronix.de>
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

>either by SRP or HNP, or something else. In TI 3.2 kernel, there is
>workaround in otg_timer() to _toggle_ the SESSION bit to detect if ID
>pin is grounded, which means a USB device is connected.

I've been looking at
  http://downloads.ti.com/sitara_linux/esd/AM335xSDK/latest/index_FDS.html

and I can't find what you are talking about. My MUSB_DEVCTL doesn't
change after I connect a device and the SESSION bit is not set. Also I
remain in a_idle state. Do you have maybe a hint for me? :)

>Regards,
>-Bin.

Sebastian
