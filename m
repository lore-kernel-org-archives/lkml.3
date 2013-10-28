Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402Ab3J1SXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 14:23:19 -0400
Received: from alpha.arachsys.com ([91.203.57.7]:59141 "EHLO
	alpha.arachsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756672Ab3J1SXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 14:23:18 -0400
Date: Mon, 28 Oct 2013 18:23:09 +0000
From: Richard Davies <richard@arachsys.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: Unnecessary mass OOM kills on Linux 3.11 virtualization host
Message-ID: <20131028182309.GA21822@alpha.arachsys.com>
References: <20131024224326.GA19654@alpha.arachsys.com>
 <20131025103946.GA30649@alpha.arachsys.com>
 <20131028082825.GA30504@alpha.arachsys.com>
 <526EA947.7060608@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <526EA947.7060608@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> Richard Davies wrote:
> > I further attach some other types of memory manager errors found in the
> > kernel logs around the same time. There are several occurrences of each, but
> > I have only copied one here for brevity:
> >
> > 19:18:27 kernel: BUG: Bad page map in process qemu-system-x86  pte:00000608 pmd:1d57fd067
>
> FWIW, I took a quick look through your OOM report and didn't see any
> obvious causes for it.  But, INMHO, you should probably ignore the OOM
> issue until you've fixed these "Bad page map" problems.   Those are a
> sign of a much deeper problem.

Thanks! What investigation should I do for these? It is on stock 3.11.3.

Richard.
