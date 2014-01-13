Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbaAMTC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 14:02:57 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:64881 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbaAMTCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 14:02:54 -0500
Date: Mon, 13 Jan 2014 20:02:51 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Mike Travis <travis@sgi.com>
Cc: Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hedi Berriche <hedi@sgi.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Russ Anderson <rja@sgi.com>
Subject: Re: [PATCH 0/3] : KGDB/KDB/UV updates.
Message-ID: <20140113190251.GB9667@gmail.com>
References: <20131018185334.272062791@asylum.americas.sgi.com>
 <20131019085617.GA9717@gmail.com>
 <52D42C99.6050505@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D42C99.6050505@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> On 10/19/2013 1:56 AM, Ingo Molnar wrote:
> > 
> > * Mike Travis <travis@sgi.com> wrote:
> > 
> >>
> >> * Change the fix for KDB not defined build problem by changing
> >>   the kgdb_nmicallin() interface to include the KDB specific
> >>   reason code.  This removes a dependency on KDB in the debug
> >>   core.  Also requires a change the call in from UV NMI handler.
> >>
> >> * Fix some problems found by the kbuild test robot.
> >>
> >> * Fix UV call into kgdb to depend only on whether KGDB is defined
> >>   and not both KGDB and KDB.  This allows the power nmi command
> >>   to use the gdb remote connection if enabled.  Note new action
> >>   of 'kgdb' needs to be set as well to indicate user wants to
> >>   wait for gdb to be connected.  If it's set to 'kdb' then an
> >>   error message is displayed if KDB is not configured.
> >> --
> > 
> > This looks better.
> > 
> > Jason, any objections?
> > 
> > Thanks,
> > 
> > 	Ingo
> > 
> 
> I haven't heard anything back about this update.  Were there
> objections?  Looks like another merge window is closing?

Please resend the series.

Thanks,

	Ingo
