Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab3KRBEi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 20:04:38 -0500
Received: from mail.skyhub.de ([78.46.96.112]:41832 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102Ab3KRBEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 20:04:30 -0500
Date: Mon, 18 Nov 2013 02:04:28 +0100
From: Borislav Petkov <bp@alien8.de>
To: Kevin Easton <kevin@guarana.org>
Cc: Francis Moreau <francis.moro@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 3.12: kernel panic when resuming from suspend to RAM (x86_64)
Message-ID: <20131118010428.GT27323@pd.tnic>
References: <52888F6D.6000802@gmail.com>
 <20131117132531.GB27696@pd.tnic>
 <5288E5BF.2020608@gmail.com>
 <20131117160126.GG27323@pd.tnic>
 <CAC9WiBikz8kTAmKs1HVBmeb2Wu6hfHCh2d=w1sQC03EVHa1QOQ@mail.gmail.com>
 <20131117195358.GO27323@pd.tnic>
 <20131117220611.GQ27323@pd.tnic>
 <20131118003325.GA25843@chicago.guarana.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131118003325.GA25843@chicago.guarana.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 11:33:25AM +1100, Kevin Easton wrote:
> That's part of an ASCII string, "DEP=2\0SE", so if that looks familiar
> to anyone (part of a kernel command line?) it might give a clue to
> where the timer callback pointer is being overwritten.

Yeah, it could be anything, maybe even part of dmesg although nothing
matches "DEP" in there.

And command line is:

[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-linux root=UUID=b588f212-e32e-4914-9841-5246e0bd7632 rw quiet

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
