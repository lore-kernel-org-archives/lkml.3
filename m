Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab3D1Qet (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 12:34:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622Ab3D1Qes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 12:34:48 -0400
Date: Sun, 28 Apr 2013 18:31:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH V4 0/3] perf/x86/amd: AMD Family 16h Data Breakpoint
	Extensions
Message-ID: <20130428163127.GA25477@redhat.com>
References: <1367129152-11621-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367129152-11621-1-git-send-email-jacob.shin@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28, Jacob Shin wrote:
>
> The following patchset enables hardware breakpoint bp_len greater than
> HW_BREAKPOINT_LEN_8 on AMD Family 16h and later.
>
>   $ perf stat -e mem:0x1000/16:w a.out
>                             ^^
>                             bp_len
>
> Will count writes to [0x1000 ~ 0x1010)

Obviously I can't ack the changes in this area, but to me the whole
series looks fine.

Afaics this needs more work to actually support a range on executable
breakpoint, but I believe this needs another series.

Oleg.

