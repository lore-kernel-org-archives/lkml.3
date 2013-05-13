Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab3EMJZV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 05:25:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:46691 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab3EMJZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 05:25:19 -0400
Date: Mon, 13 May 2013 11:25:17 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Borislav Petkov <bp@alien8.de>
cc: Takashi Iwai <tiwai@suse.de>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: irq fun, reloaded
In-Reply-To: <20130512161847.GA6205@pd.tnic>
Message-ID: <alpine.LFD.2.02.1305131121330.2863@ionos>
References: <20130512161847.GA6205@pd.tnic>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boris,

On Sun, 12 May 2013, Borislav Petkov wrote:
> Hi Thomas,
> 
> you're gonna love this:

definitely!
 
> This is 3.10-rc1 with "acpi_osi=Linux" on the command line. If I get
> bored, I could try to update the BIOS but who knows what else could
> break...

Well, I don't think it will be worse than it is already ....
 
> [ 8546.455856]  [<ffffffff810b469d>] __report_bad_irq+0x3d/0xe0
> [ 8546.613327] handlers:
> [ 8546.617580] [<ffffffff814aa090>] azx_interrupt
> [ 8546.624012] Disabling IRQ #16

No idea what to do about that :(

Thanks,

	tglx
