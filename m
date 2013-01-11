Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab3AKHA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 02:00:29 -0500
Received: from sg2plsmtpa01-01.prod.sin2.secureserver.net ([182.50.145.6]:40382
	"EHLO sg2plsmtpa01-01.prod.sin2.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193Ab3AKHA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 02:00:28 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20719.47186.830126.689552@gargle.gargle.HOWL>
Date: Fri, 11 Jan 2013 12:29:30 +0530
To: Adrian Byszuk <adrian.byszuk@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: BUG: kernel panic on Dell Vostro 3560 when plugging in AC adapter
In-Reply-To: <50EEF8A9.5070406@gmail.com>
References: <50ED371A.3080903@gmail.com>
	<20130109120732.GA8016@liondog.tnic>
	<50ED98AA.1090304@gmail.com>
	<20130109170119.GA17840@liondog.tnic>
	<50EDB070.9020908@gmail.com>
	<20130109181520.GB17840@liondog.tnic>
	<50EE9F24.8010908@gmail.com>
	<20130110113511.GB23008@liondog.tnic>
	<50EECA0B.2050407@gmail.com>
	<50EEF8A9.5070406@gmail.com>
X-Mailer: VM 8.2.0b under 24.2.1 (x86_64-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Byszuk wrote:
> Aaaand failure again!
> I haven't finished bisecting yet, but as of now I have ~20 commits left:
> all related to 'mtd' - propably not a source of troubles too.
> Any other way to diagnose this bug?

I think this has been fixed by:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=3935e89505a1c3ab3f3b0c7ef0eae54124f48905

For Arch Linux, it was tracked here:
https://bugs.archlinux.org/task/33095

Sujith
