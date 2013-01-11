Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab3AKLZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 06:25:51 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:43585 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab3AKLZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 06:25:49 -0500
Message-ID: <50EFF6B9.5090303@gmail.com>
Date: Fri, 11 Jan 2013 12:25:45 +0100
From: Adrian Byszuk <adrian.byszuk@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Icedove/17.0
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: BUG: kernel panic on Dell Vostro 3560 when plugging in AC adapter
References: <50ED371A.3080903@gmail.com> <20130109120732.GA8016@liondog.tnic> <50ED98AA.1090304@gmail.com> <20130109170119.GA17840@liondog.tnic> <50EDB070.9020908@gmail.com> <20130109181520.GB17840@liondog.tnic> <50EE9F24.8010908@gmail.com> <20130110113511.GB23008@liondog.tnic> <50EECA0B.2050407@gmail.com> <50EEF8A9.5070406@gmail.com> <20719.47186.830126.689552@gargle.gargle.HOWL>
In-Reply-To: <20719.47186.830126.689552@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/13 07:59, Sujith Manoharan wrote:
> Adrian Byszuk wrote:
>> Aaaand failure again!
>> I haven't finished bisecting yet, but as of now I have ~20 commits left:
>> all related to 'mtd' - propably not a source of troubles too.
>> Any other way to diagnose this bug?
> 
> I think this has been fixed by:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=3935e89505a1c3ab3f3b0c7ef0eae54124f48905
> 
> For Arch Linux, it was tracked here:
> https://bugs.archlinux.org/task/33095
> 
> Sujith
> 

Aaaah... yes, looks like this is it. I'll wait for the 3.7.2 and if it
isn't fixed then I'll mail here again.

Thanks!
