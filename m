Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014Ab3DPJg0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 05:36:26 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:62893 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433Ab3DPJgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 05:36:25 -0400
Date: Tue, 16 Apr 2013 11:36:20 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jacob Shin <jacob.shin@amd.com>,
        Fr??d??ric Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] perf: Add support for hardware breakpoint address
 masks
Message-ID: <20130416093620.GH9569@gmail.com>
References: <1365528113-5458-1-git-send-email-jacob.shin@amd.com>
 <20130415172803.GA18406@jshin-Toonie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130415172803.GA18406@jshin-Toonie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jacob Shin <jacob.shin@amd.com> wrote:

> On Tue, Apr 09, 2013 at 12:21:48PM -0500, Jacob Shin wrote:
> > The following patchset adds address masks to existing perf hardware
> > breakpoint mechanism to allow trapping on an address range (currently
> > only single address) on supported architectures.
> > 
> > perf uapi is updated, x86 AMD implementation (for AMD Family 16h and
> > beyond) is provided, and perf tool has been extended to do:
> > 
> >   $ perf stat -e mem:0x1000:w:0xf a.out
> >                               ^^^
> >                               "don't care" bit mask
> > 
> >   which will count writes to [0x1000 ~ 0x1010)
> 
> Ping .. Ingo?

breakpoint patches usually come to me through (or with the acks of) Frederic 
and/or Oleg.

Frederic, Oleg, mind having a look?

Thanks,

	Ingo
