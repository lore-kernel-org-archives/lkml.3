Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbaJAUhl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 16:37:41 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:38003 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbaJAUhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 16:37:39 -0400
Date: Wed, 1 Oct 2014 21:37:36 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH 01/11] perf stat: Fix AGGR_CORE segfault on multi-socket
 system
Message-ID: <20141001203736.GE14343@console-pimps.org>
References: <1412174192-7010-1-git-send-email-matt@console-pimps.org>
 <1412174192-7010-2-git-send-email-matt@console-pimps.org>
 <20141001170829.GD2799@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141001170829.GD2799@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Oct, at 02:08:29PM, Arnaldo Carvalho de Melo wrote:
> 
> So, is this still needed after applying Andi's patch:
> 
>   perf stat: Fix --per-core on multi socket systems
> 
>   https://git.kernel.org/cgit/linux/kernel/git/acme/linux.git/commit/?h=perf/core&id=da88c7f78d842a6938d9adde6af87a2ce262051d
> 
> Or should this be applied on top of that one, after fixing up the
> conflicts?

No, this patch is no longer needed now that Andi's commit has been
picked up.

-- 
Matt Fleming, Intel Open Source Technology Center
