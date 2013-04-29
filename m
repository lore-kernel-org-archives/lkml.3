Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425Ab3D2LMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 07:12:54 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:58703 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296Ab3D2LMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 07:12:53 -0400
Date: Mon, 29 Apr 2013 13:12:48 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jacob Shin <jacob.shin@amd.com>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH V4 0/3] perf/x86/amd: AMD Family 16h Data Breakpoint
 Extensions
Message-ID: <20130429111248.GA12816@gmail.com>
References: <1367129152-11621-1-git-send-email-jacob.shin@amd.com>
 <20130428163127.GA25477@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130428163127.GA25477@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> On 04/28, Jacob Shin wrote:
> >
> > The following patchset enables hardware breakpoint bp_len greater than
> > HW_BREAKPOINT_LEN_8 on AMD Family 16h and later.
> >
> >   $ perf stat -e mem:0x1000/16:w a.out
> >                             ^^
> >                             bp_len
> >
> > Will count writes to [0x1000 ~ 0x1010)
> 
> Obviously I can't ack the changes in this area, but to me the whole
> series looks fine.

Thanks Oleg - can I add your Reviewed-by tags?

	Ingo
