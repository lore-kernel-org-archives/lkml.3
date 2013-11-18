Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751266Ab3KRCnV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 21:43:21 -0500
Received: from chicago.guarana.org ([192.210.136.102]:54610 "EHLO
	chicago.guarana.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab3KRCnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 21:43:16 -0500
Date: Mon, 18 Nov 2013 13:43:15 +1100
From: Kevin Easton <kevin@guarana.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Francis Moreau <francis.moro@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 3.12: kernel panic when resuming from suspend to RAM (x86_64)
Message-ID: <20131118024315.GA26395@chicago.guarana.org>
References: <52888F6D.6000802@gmail.com>
 <20131117132531.GB27696@pd.tnic>
 <5288E5BF.2020608@gmail.com>
 <20131117160126.GG27323@pd.tnic>
 <CAC9WiBikz8kTAmKs1HVBmeb2Wu6hfHCh2d=w1sQC03EVHa1QOQ@mail.gmail.com>
 <20131117195358.GO27323@pd.tnic>
 <20131117220611.GQ27323@pd.tnic>
 <20131118003325.GA25843@chicago.guarana.org>
 <20131118010428.GT27323@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131118010428.GT27323@pd.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 02:04:28AM +0100, Borislav Petkov wrote:
> On Mon, Nov 18, 2013 at 11:33:25AM +1100, Kevin Easton wrote:
> > That's part of an ASCII string, "DEP=2\0SE", so if that looks familiar
> > to anyone (part of a kernel command line?) it might give a clue to
> > where the timer callback pointer is being overwritten.
> 
> Yeah, it could be anything, maybe even part of dmesg although nothing
> matches "DEP" in there.

We actually have the following long as well, from the .data member.
Pasting them together gives "DEP=2\0SEQNUM=223" which looks like udev.

    - Kevin 
