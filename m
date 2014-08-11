Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151AbaHKT5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 15:57:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:35943 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641AbaHKT5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 15:57:00 -0400
Date: Mon, 11 Aug 2014 21:56:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com
Subject: Re: [PATCH v2 0/4] perf/x86: simplify PEBS event constraint
 management
Message-ID: <20140811195659.GG3935@laptop>
References: <1407785233-32193-1-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407785233-32193-1-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 09:27:09PM +0200, Stephane Eranian wrote:
> This patchkit revamps the PEBS tables on most Intel CPUs, both simplifying
> and fixing a couple of problems on Haswell processors:
>  - All PEBS event supported
>  - data address and data source is now reported correctly for all events
> 
> We simplify the tables by using the fact that non-PEBS event when used
> in PEBS mode do not generate any PEBS records , thus they are safe to use.
> This helps simplify the PEBS event constraints because they do not need
> to list all suported PEBS events anymore. They only need to list
> the special PEBS events, such as precise store and load latency.
> This avoid some issues where the kernel is missing some PEBS events.
> 
> In V2, we cleanup some more the precise_datala() for store events.

Ah, I just queued your v1, time to swap patches around I suppose :-)
