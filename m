Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751221AbaCHHvW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 02:51:22 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:54156 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaCHHvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 02:51:21 -0500
Message-ID: <1394265078.7215.11.camel@marge.simpson.net>
Subject: Re: perf samples too long without perf running (?!?)
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sat, 08 Mar 2014 08:51:18 +0100
In-Reply-To: <CALCETrWSyhJHwfKSBT3giSb0AtvHFBR9PYmhFhFJa=Yabw25iw@mail.gmail.com>
References: <CALCETrWSyhJHwfKSBT3giSb0AtvHFBR9PYmhFhFJa=Yabw25iw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-07 at 17:57 -0800, Andy Lutomirski wrote: 
> On recent (3.13) kernels, I'm frequently getting messages like:
> 
> perf samples too long (2503 > 2500), lowering
> kernel.perf_event_max_sample_rate to 50000
> 
> a few seconds to minutes after bootup.  As far as I know, I'm not
> using perf.  What's going on here?

14c63f17b1

I get those all the time too, just building kernels.

[  598.583918] perf samples too long (2539 > 2500), lowering kernel.perf_event_max_sample_rate to 50000

Darn nmi_watchdog is an expensive employee.  Scarier are the ones from
2ab00456ea when using perf.  Firing the dog makes it all batter.

-Mike

