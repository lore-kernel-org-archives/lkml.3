Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518Ab3I3USL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 16:18:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32254 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756425Ab3I3USI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 16:18:08 -0400
Date: Mon, 30 Sep 2013 22:17:21 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, acme@infradead.org, mingo@kernel.org,
        peterz@infradead.org, eranian@google.com
Subject: Re: perf, x86: Add last TSX PMU code for Haswell v2
Message-ID: <20130930201721.GA1079@krava>
References: <1379688044-14173-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379688044-14173-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 07:40:38AM -0700, Andi Kleen wrote:
> [This has kernel and user parts, so will need
> review/ack/merges from both perf kernel and user land maintainers]
> [v2: Address Peter's feedback for the kernel parts]
> 
> This is currently the last part of the TSX PMU code,
> just adding the left over bits:
> 
> This adds some changes to the user interfaces.
> I'll send patches for the manpage separately.
> 
> - Report the transaction abort flags to user space
> using a new field, and add the code to display them.
> This is used to classify abort types, also fairly
> important for tuning as it guides the tuning process,
> together with the abort weight that was added earleir.
> 
> [3 patches, generic, x86, user tools]
> 
> - Add support for reporting the two new TSX LBR flags: in_tx
> and abort_tx. The code to handle the LBRs was already
> added earlier, this just adds the code to report,
> filter and display them.

perf tool changes look ok

Reviewed-by: Jiri Olsa <jolsa@redhat.com>

btw, kernel changes didn't apply cleanly on tip tree for me
last week.. I couldn't test on Haswel, but I at least tried
your changes with no data and all seem ok ;-)

jirka
