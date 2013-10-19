Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939Ab3JSI4X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 04:56:23 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:64110 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab3JSI4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 04:56:21 -0400
Date: Sat, 19 Oct 2013 10:56:17 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Jason Wessel <jason.wessel@windriver.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hedi Berriche <hedi@sgi.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] : KGDB/KDB/UV updates.
Message-ID: <20131019085617.GA9717@gmail.com>
References: <20131018185334.272062791@asylum.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131018185334.272062791@asylum.americas.sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> 
> * Change the fix for KDB not defined build problem by changing
>   the kgdb_nmicallin() interface to include the KDB specific
>   reason code.  This removes a dependency on KDB in the debug
>   core.  Also requires a change the call in from UV NMI handler.
> 
> * Fix some problems found by the kbuild test robot.
> 
> * Fix UV call into kgdb to depend only on whether KGDB is defined
>   and not both KGDB and KDB.  This allows the power nmi command
>   to use the gdb remote connection if enabled.  Note new action
>   of 'kgdb' needs to be set as well to indicate user wants to
>   wait for gdb to be connected.  If it's set to 'kdb' then an
>   error message is displayed if KDB is not configured.
> --

This looks better.

Jason, any objections?

Thanks,

	Ingo
