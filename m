Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536Ab3IPL2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 07:28:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48271 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757396Ab3IPL2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 07:28:37 -0400
Date: Mon, 16 Sep 2013 13:28:25 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@kernel.org, acme@infradead.org, linux-kernel@vger.kernel.org,
        eranian@google.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 6/6] perf, x86: Suppress duplicated abort LBR records
Message-ID: <20130916112825.GB9326@twins.programming.kicks-ass.net>
References: <1379095716-4705-1-git-send-email-andi@firstfloor.org>
 <1379095716-4705-7-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379095716-4705-7-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 11:08:36AM -0700, Andi Kleen wrote:
> -		cpuc->lbr_entries[i].from	= from;
> -		cpuc->lbr_entries[i].to		= to;
> -		cpuc->lbr_entries[i].mispred	= mis;
> -		cpuc->lbr_entries[i].predicted	= pred;
> -		cpuc->lbr_entries[i].in_tx	= in_tx;
> -		cpuc->lbr_entries[i].abort	= abort;
> -		cpuc->lbr_entries[i].reserved	= 0;

> +		cpuc->lbr_entries[out].from	= from;
> +		cpuc->lbr_entries[out].to	= to;
> +		cpuc->lbr_entries[out].mispred	= mis;
> +		cpuc->lbr_entries[out].predicted = pred;
> +		cpuc->lbr_entries[out].in_tx	= in_tx;
> +		cpuc->lbr_entries[out].abort	= abort;
> +		cpuc->lbr_entries[out].reserved	= 0;

just add an extra space before the '=' so they're all nicely aligned
again.
