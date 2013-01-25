Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab3AYSib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 13:38:31 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:36866 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab3AYSi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 13:38:29 -0500
Date: Fri, 25 Jan 2013 19:38:25 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: linux-tip-commits@vger.kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, kernel@savoirfairelinux.com,
        tglx@linutronix.de
Subject: Re: [tip:x86/platform] x86: Add TS-5500 platform support
Message-ID: <20130125183825.GC31022@gmail.com>
References: <20130125073735.GC18243@gmail.com>
 <1344460915.280514.1359132048723.JavaMail.root@mail.savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344460915.280514.1359132048723.JavaMail.root@mail.savoirfairelinux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vivien Didelot <vivien.didelot@savoirfairelinux.com> wrote:

> Hi Ingo,
> 
> > This patch still appears to have some problems with certain
> > (rare) LEDS .config variations:
> > 
> >  arch/x86/built-in.o: In function `ts5500_init':
> >  ts5500.c:(.init.text+0xdae6): undefined reference to
> >  `led_classdev_register'
> > 
> > Config attached.
> > 
> > Please fix & resend.
> 
> I think the attached config might not be the right one. [...]

Hm, yes - sorry. The failure happened on a testbox and I might 
have misplaced the config.

> [...] This issue happens when the ts5500 support is selected 
> (CONFIG_TS5500=y) but the LED class (CONFIG_NEW_LEDS and 
> CONFIG_LEDS_CLASS) is not.
> 
> Thanks for pointing this out.
> The following patch below solves this issue. Is it ok, or should
> I resend to whole board support patch?

This one's OK, I'll resurrect the old one and amend it with your 
delta fix.

Thanks!

	Ingo
