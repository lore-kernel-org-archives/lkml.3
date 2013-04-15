Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab3DOXXM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 19:23:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465Ab3DOXXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 19:23:10 -0400
Date: Tue, 16 Apr 2013 01:22:52 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Stephane Eranian <eranian@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] perf: Add support for hardware breakpoint address
 masks
Message-ID: <20130415232252.GA1385@krava.redhat.com>
References: <1365528113-5458-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365528113-5458-1-git-send-email-jacob.shin@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 12:21:48PM -0500, Jacob Shin wrote:
> The following patchset adds address masks to existing perf hardware
> breakpoint mechanism to allow trapping on an address range (currently
> only single address) on supported architectures.
> 
> perf uapi is updated, x86 AMD implementation (for AMD Family 16h and
> beyond) is provided, and perf tool has been extended to do:
> 
>   $ perf stat -e mem:0x1000:w:0xf a.out
>                               ^^^
>                               "don't care" bit mask
> 
>   which will count writes to [0x1000 ~ 0x1010)
> 
> Jacob Shin (2):
>   perf: Add hardware breakpoint address mask
>   perf, x86: AMD implementation for hardware breakpoint address mask
> 
> Suravee Suthikulpanit (3):
>   perf tools: Add breakpoint address mask to the mem event parser
>   perf tools: Add breakpoint address mask syntax to perf list and
>     documentation
>   perf tools: Add breakpoint address mask test case to
>     tests/parse-events
hi,
the perf tool patches look ok.. thanks for tests! ;)

jirka
