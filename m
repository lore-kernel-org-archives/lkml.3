Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113AbaFIOC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 10:02:27 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:49022 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933523AbaFIOCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 10:02:20 -0400
Date: Mon, 9 Jun 2014 16:02:15 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Igor Mammedov <imammedo@redhat.com>, Toshi Kani <toshi.kani@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [BISECTED][REGRESSION] Kernel does not boot on EeePC
Message-ID: <20140609140215.GA1579@gmail.com>
References: <20140608090223.GA8703@sucs.org>
 <20140608094517.GB12736@gmail.com>
 <5394A260.8000900@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5394A260.8000900@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 06/08/2014 02:45 AM, Ingo Molnar wrote:
> > 
> > * Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> > 
> >> Hi,
> >>
> >> The latest kernel (c593e8978722f7f4a12932733cfeed6c0c74fbaa) refuses to
> >> boot on my EeePC - after grub is finished the screen just remains black
> >> and the only thing that does something is pressing the power button. The
> >> problem commit seems to be:
> >>
> >> commit 3e1a878b7ccdb31da6d9d2b855c72ad87afeba3f
> >> Author: Igor Mammedov <imammedo@redhat.com>
> >> Date:   Thu Jun 5 15:42:45 2014 +0200
> >>
> >>     x86/smpboot: Initialize secondary CPU only if master CPU will wait for it
> > 
> > Argh, and have read this just a minute after expressing my hope that 
> > the hotplug fix is correct :-/
> > 
> > Linus, please revert commit 3e1a878b7ccdb.
> > 
> >   Acked-by: Ingo Molnar <mingo@kernel.org>
> > 
> 
> I really want to say *THANK YOU* to Sitsofe for a very timely and 
> complete report.  You really saved us some highly valuable time.

Seconded!

Thanks,

	Ingo
