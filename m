Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab3BPLjA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 06:39:00 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:48690 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab3BPLi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 06:38:57 -0500
Subject: Re: [PATCH] [Watchdog][Trivial] Added comments to explain
 watchdog_disabled variable
From: anish kumar <anish198519851985@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Don Zickus <dzickus@redhat.com>, akpm@linux-foundation.org,
        tglx@linutronix.de, chuansheng.liu@intel.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <20130216084245.GD18953@gmail.com>
References: <1359907275-15410-1-git-send-email-anish198519851985@gmail.com>
	 <CAK7N6vpT_X7s7Vid0-EYenb0w7k=nL8d-ov=fExFMuSYcV47Wg@mail.gmail.com>
	 <20130213092101.GD7630@gmail.com>
	 <CAK7N6vqh_c31bWiHgVgJLLckya7mykshMKYiqLTdkScMCoXcsg@mail.gmail.com>
	 <20130215162959.GF98867@redhat.com>  <20130216084245.GD18953@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 16 Feb 2013 17:08:45 +0530
Message-ID: <1361014725.1672.0.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-02-16 at 09:42 +0100, Ingo Molnar wrote:
> * Don Zickus <dzickus@redhat.com> wrote:
> 
> > > >> > +       /*
> > > >> > +        * We shouldn't enable watchdog threads if it is
> > > >> > +        * disabled.This is done by watchdog_disabled
> > > >> > +        * variable check in watchdog_*_all_cpus function.
> > > >
> > > > It has two grammatic and a stylistic error in it, plus misses
> > > Would you mind pointing it out to me the grammatical mistakes
> > > as I am not that good with grammar.
> > 
> > I am not entirely sure which ones Ingo is referring to, but what I see are
> > 
> > 'disabled.This' needs a space after period
> > 'This is done by watchdog_disabled' needs a 'the' after 'by'
> > 'variable check in watchdog..' needs a 'the' after 'in'.
> > 
> > in addition to the missing ()'s after 'watchdog_*_all_cpus.
> 
> There's also a plural/singular mismatch between 'watchdog 
> threads' and 'if it is disabled'.
Thanks, I will update the same in the next patch.
> 
> Thanks,
> 
> 	Ingo


