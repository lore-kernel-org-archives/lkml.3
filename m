Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722Ab3KSKP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 05:15:27 -0500
Received: from mail.skyhub.de ([78.46.96.112]:54321 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823Ab3KSKPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 05:15:25 -0500
Date: Tue, 19 Nov 2013 11:15:21 +0100
From: Borislav Petkov <bp@alien8.de>
To: Francis Moreau <francis.moro@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 3.12: kernel panic when resuming from suspend to RAM (x86_64)
Message-ID: <20131119101521.GA3515@pd.tnic>
References: <20131117132531.GB27696@pd.tnic>
 <5288E5BF.2020608@gmail.com>
 <20131117160126.GG27323@pd.tnic>
 <CAC9WiBikz8kTAmKs1HVBmeb2Wu6hfHCh2d=w1sQC03EVHa1QOQ@mail.gmail.com>
 <20131117195358.GO27323@pd.tnic>
 <CAC9WiBggfssh+31_MqVCT-hDf2E8zTuc81q-DhLYQuVF053mEA@mail.gmail.com>
 <20131117220611.GQ27323@pd.tnic>
 <528A05D0.30907@gmail.com>
 <20131118133210.GG24851@pd.tnic>
 <528B36EA.20301@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <528B36EA.20301@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 11:01:14AM +0100, Francis Moreau wrote:
> I think the easiest way to do it is to install a minimal system on a
> USB stick and try to reproduce first in order to preserve my system.

Yep, sounds simple enough.

> Then I'll try to see if this issue exists in a previous kernel version
> and if so, I'll do a git-bisect session.
>
> I can't find a quicker way to do that although using git-bisect (which
> implies several kernel builds) is a PITA.

You can start with a coarse bisect by testing the major kernel versions
first, i.e. 3.11, 3.10, 3.9 ... and once you find good and bad, then you
can do the git-bisect thing.

Also, you can check for BIOS updates for your machine and if there are,
check their changelogs whether they fix something suspend-related.

Good luck!

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
