Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab3AKLqv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 06:46:51 -0500
Received: from mail.skyhub.de ([78.46.96.112]:35556 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753137Ab3AKLqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 06:46:50 -0500
Date: Fri, 11 Jan 2013 12:46:48 +0100
From: Borislav Petkov <bp@alien8.de>
To: Adrian Byszuk <adrian.byszuk@gmail.com>
Cc: Sujith Manoharan <sujith@msujith.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: BUG: kernel panic on Dell Vostro 3560 when plugging in AC adapter
Message-ID: <20130111114648.GA10751@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Adrian Byszuk <adrian.byszuk@gmail.com>,
	Sujith Manoharan <sujith@msujith.org>, linux-kernel@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	John Stultz <john.stultz@linaro.org>
References: <50ED98AA.1090304@gmail.com>
 <20130109170119.GA17840@liondog.tnic>
 <50EDB070.9020908@gmail.com>
 <20130109181520.GB17840@liondog.tnic>
 <50EE9F24.8010908@gmail.com>
 <20130110113511.GB23008@liondog.tnic>
 <50EECA0B.2050407@gmail.com>
 <50EEF8A9.5070406@gmail.com>
 <20719.47186.830126.689552@gargle.gargle.HOWL>
 <50EFF6B9.5090303@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50EFF6B9.5090303@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 12:25:45PM +0100, Adrian Byszuk wrote:
> Aaaah... yes, looks like this is it. I'll wait for the 3.7.2 and if it
> isn't fixed then I'll mail here again.

Sorry, I just noticed I had email trouble and you've probably didn't see
my email yet - this patch is not in the 3.7.2 lineup for some reason so
you should cherrypick it ontop of 3.7.1 and test.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
