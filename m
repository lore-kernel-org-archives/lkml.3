Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755Ab3KRNcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 08:32:17 -0500
Received: from mail.skyhub.de ([78.46.96.112]:43007 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742Ab3KRNcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 08:32:13 -0500
Date: Mon, 18 Nov 2013 14:32:10 +0100
From: Borislav Petkov <bp@alien8.de>
To: Francis Moreau <francis.moro@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 3.12: kernel panic when resuming from suspend to RAM (x86_64)
Message-ID: <20131118133210.GG24851@pd.tnic>
References: <52888F6D.6000802@gmail.com>
 <20131117132531.GB27696@pd.tnic>
 <5288E5BF.2020608@gmail.com>
 <20131117160126.GG27323@pd.tnic>
 <CAC9WiBikz8kTAmKs1HVBmeb2Wu6hfHCh2d=w1sQC03EVHa1QOQ@mail.gmail.com>
 <20131117195358.GO27323@pd.tnic>
 <CAC9WiBggfssh+31_MqVCT-hDf2E8zTuc81q-DhLYQuVF053mEA@mail.gmail.com>
 <20131117220611.GQ27323@pd.tnic>
 <528A05D0.30907@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <528A05D0.30907@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 01:19:28PM +0100, Francis Moreau wrote:
> Just out of curiosity, running "objdump -D" doesn't seem to show the
> same thing here. How did you get such dump with function names for
> example ?

There's another, non-stripped vmlinux in the kernel package:

$ objdump -D usr/src/linux-3.12.0-1-ARCH/vmlinux | less

> The thing is that I'd like to avoid to oops my kernel to avoid to
> corrupt my filesystem.

Then debugging this thing would be very hard, if not impossible but it
is your decision at the end of the day...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
