Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab3KVQdN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 11:33:13 -0500
Received: from www.linutronix.de ([62.245.132.108]:45969 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787Ab3KVQdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 11:33:08 -0500
Message-ID: <528F8741.1060406@linutronix.de>
Date: Fri, 22 Nov 2013 17:33:05 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Mark Jackson <mpfj-list@newflow.co.uk>
CC: linux-usb@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        jkosina@suse.cz, anatol.pomozov@gmail.com,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Bin Liu <binmlist@gmail.com>
Subject: Re: [PATCH] Allow MUSB DSPS to use "force host" mode
References: <528F7E8F.5050807@newflow.co.uk>
In-Reply-To: <528F7E8F.5050807@newflow.co.uk>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2013 04:55 PM, Mark Jackson wrote:
> The IDDIG input pin is normally used to determine the USB mode
> (i.e. HOST or DEVICE).
> 
> On some systems (e.g. AM335x) leaving this pin floating allows
> the USB mode to be set via software.

So you have a board where musb is used only as host or only as device
and the ID pin not on ground or 3.3V?
What are the side effects? I remember correctly Bin wanted to avoid
settings this if it could be avoided.

Sebastian
