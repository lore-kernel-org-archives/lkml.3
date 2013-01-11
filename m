Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab3AKNaY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 08:30:24 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44864 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219Ab3AKNaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 08:30:23 -0500
Date: Fri, 11 Jan 2013 14:30:20 +0100
From: Borislav Petkov <bp@alien8.de>
To: Adrian Byszuk <adrian.byszuk@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc: Sujith Manoharan <sujith@msujith.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: BUG: kernel panic on Dell Vostro 3560 when plugging in AC adapter
Message-ID: <20130111133020.GC10751@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Adrian Byszuk <adrian.byszuk@gmail.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	Sujith Manoharan <sujith@msujith.org>, linux-kernel@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	John Stultz <john.stultz@linaro.org>
References: <50EDB070.9020908@gmail.com>
 <20130109181520.GB17840@liondog.tnic>
 <50EE9F24.8010908@gmail.com>
 <20130110113511.GB23008@liondog.tnic>
 <50EECA0B.2050407@gmail.com>
 <50EEF8A9.5070406@gmail.com>
 <20719.47186.830126.689552@gargle.gargle.HOWL>
 <50EFF6B9.5090303@gmail.com>
 <20130111114648.GA10751@liondog.tnic>
 <50F00A59.70808@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50F00A59.70808@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 01:49:29PM +0100, Adrian Byszuk wrote:
> I've got both of your emails. I've just tested this patch, and so far
> things seem to work flawlessly. So I would strongly recommend it for
> the stable series :-)

Ok, good.

@Greg,

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=3935e89505a1c3ab3f3b0c7ef0eae54124f48905

somehow didn't make it into the 3.7.2 lineup and we have another bug
report which is fixed by this patch. Can you please pick it up?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
