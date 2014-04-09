Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933372AbaDINn0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 09:43:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932748AbaDINnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 09:43:24 -0400
Date: Wed, 9 Apr 2014 15:42:42 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, eranian@google.com, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/2] perf, tools, stat: Initialize statistics correctly
Message-ID: <20140409134242.GD2556@krava.brq.redhat.com>
References: <1395768699-16060-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395768699-16060-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 10:31:38AM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> perf stat did initialize the stats structure used to compute
> stddev etc. incorrectly. It merely zeroes it. But one member
> (min) needs to be set to a non zero value. This causes min
> to be not computed at all. Call init_stats() correctly.
> 
> It doesn't matter for stat currently because it doesn't use
> min, but it's still better to do it correctly.
> 
> The other users of statistics are already correct.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Acked-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka
