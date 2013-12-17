Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751128Ab3LQJCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 04:02:44 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36107 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab3LQJCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 04:02:41 -0500
Date: Tue, 17 Dec 2013 10:02:11 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        acme@redhat.com, jolsa@redhat.com, zheng.z.yan@intel.com, bp@alien8.de,
        vincent.weaver@maine.edu, maria.n.dimakopoulou@gmail.com
Subject: Re: [PATCH 0/2] perf/x86: various RAPL improvements
Message-ID: <20131217090211.GZ21999@twins.programming.kicks-ass.net>
References: <1387225224-27799-1-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387225224-27799-1-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 09:20:22PM +0100, Stephane Eranian wrote:
> This short patch series provides the following improvements
> to the RAPL support for perf_events:
>  - Intel Haswell Celeron (model 69) support
>  - support for RAPL PP1 energy counter
> 
> The PP1 counter maps to the builtin graphic card for client
> processors. The new energy event is:
>  - name: power/energy-gfx/
>  - code: 0x4
>  - unit: Joules
>  - scaling factor: 2^-32 Joules.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>

Thanks!
