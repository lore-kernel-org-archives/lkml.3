Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab3BPImv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 03:42:51 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:44951 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab3BPImt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 03:42:49 -0500
Date: Sat, 16 Feb 2013 09:42:45 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Don Zickus <dzickus@redhat.com>
Cc: anish singh <anish198519851985@gmail.com>, akpm@linux-foundation.org,
        tglx@linutronix.de, chuansheng.liu@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [Watchdog][Trivial] Added comments to explain
 watchdog_disabled variable
Message-ID: <20130216084245.GD18953@gmail.com>
References: <1359907275-15410-1-git-send-email-anish198519851985@gmail.com>
 <CAK7N6vpT_X7s7Vid0-EYenb0w7k=nL8d-ov=fExFMuSYcV47Wg@mail.gmail.com>
 <20130213092101.GD7630@gmail.com>
 <CAK7N6vqh_c31bWiHgVgJLLckya7mykshMKYiqLTdkScMCoXcsg@mail.gmail.com>
 <20130215162959.GF98867@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130215162959.GF98867@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Don Zickus <dzickus@redhat.com> wrote:

> > >> > +       /*
> > >> > +        * We shouldn't enable watchdog threads if it is
> > >> > +        * disabled.This is done by watchdog_disabled
> > >> > +        * variable check in watchdog_*_all_cpus function.
> > >
> > > It has two grammatic and a stylistic error in it, plus misses
> > Would you mind pointing it out to me the grammatical mistakes
> > as I am not that good with grammar.
> 
> I am not entirely sure which ones Ingo is referring to, but what I see are
> 
> 'disabled.This' needs a space after period
> 'This is done by watchdog_disabled' needs a 'the' after 'by'
> 'variable check in watchdog..' needs a 'the' after 'in'.
> 
> in addition to the missing ()'s after 'watchdog_*_all_cpus.

There's also a plural/singular mismatch between 'watchdog 
threads' and 'if it is disabled'.

Thanks,

	Ingo
