Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074Ab3A3WjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 17:39:17 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:34542 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122Ab3A3WjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 17:39:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Borislav Petkov <bp@alien8.de>, Bjorn Helgaas <bhelgaas@google.com>,
        x86@kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
Date: Wed, 30 Jan 2013 23:45:27 +0100
Message-ID: <3120802.QvTiDSHyPj@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc5; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51099BE2.5090706@suse.cz>
References: <20130129202848.GE25415@pd.tnic> <2240511.0oyl5pIt1j@vostro.rjw.lan> <51099BE2.5090706@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 30, 2013 11:17:06 PM Jiri Slaby wrote:
> On 01/30/2013 10:39 PM, Rafael J. Wysocki wrote:
> >> What is cool is that I have steps to reproduce:
> >> 1) boot
> >> 2) run the attached script (turn on all possible power savings -- in
> >> fact everything what powertop suggests)
> >> 3) suspend to _disk_ (mem is not enough, BIOS apparently has to
> >> interfere here)
> > 
> > No, I don't think it's the BIOS.  Most likely the boot kernel.
> 
> Or that...
> 
> >> 4) resume from disk
> >> 5) boom
> >>
> >> I tried to remove also wireless drivers, no change.
> > 
> > Is the resume boot kernel the same as the one in the image?
> 
> Yeah, the same ones: 3.7.5

Well, I guess that we leak some state from the boot kernel to the image kernel.
I have no idea what it is, but I suspect something arch-specific.

I wonder what the affected systems have in common apart from e1000e?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
