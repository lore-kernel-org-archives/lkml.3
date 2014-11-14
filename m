Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbaKNImY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 03:42:24 -0500
Received: from www.linutronix.de ([62.245.132.108]:51121 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440AbaKNImX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 03:42:23 -0500
Message-ID: <5465C06C.90705@linutronix.de>
Date: Fri, 14 Nov 2014 09:42:20 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>, balbi@ti.com
CC: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: musb: core: Disable the Interrupts till BABBLE is
 fully handled
References: <1415953486-6000-1-git-send-email-george.cherian@ti.com>
In-Reply-To: <1415953486-6000-1-git-send-email-george.cherian@ti.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2014 09:24 AM, George Cherian wrote:
> Disable the MUSB interrupts till MUSB is recovered fully from BABBLE
> condition. There are chances that we could get multiple interrupts
> till the time the babble recover work gets scheduled. Sometimes
> this could even end up in an endless loop making MUSB itself unusable.

How do you trigger the babble error? Is this something that happens
during suspend resume, plugging / unplugging a device or randomly while
the device is used?

Sebastian

