Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab3EMJeq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 05:34:46 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34442 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982Ab3EMJeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 05:34:44 -0400
Date: Mon, 13 May 2013 11:34:42 +0200
From: Borislav Petkov <bp@alien8.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Takashi Iwai <tiwai@suse.de>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: irq fun, reloaded
Message-ID: <20130513093442.GD4759@pd.tnic>
References: <20130512161847.GA6205@pd.tnic>
 <alpine.LFD.2.02.1305131121330.2863@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1305131121330.2863@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 11:25:17AM +0200, Thomas Gleixner wrote:
> > This is 3.10-rc1 with "acpi_osi=Linux" on the command line. If I get
> > bored, I could try to update the BIOS but who knows what else could
> > break...
> 
> Well, I don't think it will be worse than it is already ....
>  
> > [ 8546.455856]  [<ffffffff810b469d>] __report_bad_irq+0x3d/0xe0
> > [ 8546.613327] handlers:
> > [ 8546.617580] [<ffffffff814aa090>] azx_interrupt
> > [ 8546.624012] Disabling IRQ #16
> 
> No idea what to do about that :(

Nothing really. I consider it a complete waste of time of having to deal
with BIOS idiocy caused by a 9-to-5 programming monkey.

I'll update the BIOS and see what happens.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
