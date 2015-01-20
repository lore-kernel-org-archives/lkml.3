Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbbATOGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 09:06:24 -0500
Received: from www.linutronix.de ([62.245.132.108]:49068 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbbATOGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 09:06:23 -0500
Date: Tue, 20 Jan 2015 15:05:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexander Kuleshov <kuleshovmail@gmail.com>
cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] x86: earlyprintk cleanup
In-Reply-To: <CANCZXo6e4VWtUq=i=3GFjnzd1j3xJ7f-OkOGst41ob5350tucg@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1501201505380.5526@nanos>
References: <1421658254-22042-1-git-send-email-kuleshovmail@gmail.com> <alpine.DEB.2.11.1501201103360.5526@nanos> <CANCZXo6e4VWtUq=i=3GFjnzd1j3xJ7f-OkOGst41ob5350tucg@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jan 2015, Alexander Kuleshov wrote:
> 2015-01-20 16:29 GMT+06:00 Thomas Gleixner <tglx@linutronix.de>:
> > On Mon, 19 Jan 2015, Alexander Kuleshov wrote:
> >
> >> The following two patches remove unused macro definitions from
> >> early_serial_console and early_printk x86 code.
> >
> > Sigh. These mechanical 'follow the output of some code analyzer'
> > changes are really horrible.
> >
> > Why not doing the obvious: Move the duplicated defines into a common
> > header file and be done with it?
> >
> > And if you look deeper, then you'll notice that those defines are used
> > in two other files as well.
> >
> > What's worse is that the whole set of defines is readily available in
> > include/uapi/linux/serial_reg.h already (just with different symbols).
> >
> > So what's the point of these removal patches?
> >
> 
> To get rid of unused code. Will it be better to move general serial
> definitions to the arch/x86/include/asm/serial.h? Or it is wrong
> place...

Care to read what I wrote before?
