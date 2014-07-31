Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187AbaGaHQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 03:16:31 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33364 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080AbaGaHQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 03:16:29 -0400
Date: Thu, 31 Jul 2014 09:16:25 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH v4 0/9] perf, x86: large PEBS interrupt threshold
Message-ID: <20140731071625.GA4209@gmail.com>
References: <1406789104-25863-1-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406789104-25863-1-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yan, Zheng <zheng.z.yan@intel.com> wrote:

> This patch series implements large PEBS interrupt threshold. For some
> limited cases, it can significantly reduce the sample overhead. Please
> read patch 6's commit message for more information.
> 
> changes since v1:
>   - drop patch 'perf, core: Add all PMUs to pmu_idr'
>   - add comments for case that multiple counters overflow simultaneously
> changes since v2:
>   - rename perf_sched_cb_{enable,disable} to perf_sched_cb_user_{inc,dec} 
>   - use flag to indicate auto reload mechanism
>   - move codes that setup PEBS sample data to separate function
>   - output the PEBS records in batch 
>   - enable this for All (PEBS capable) hardware 
>   - more description for the multiplex
> changes since v3:
>   - ignore conflicting PEBS record

Please include performance measurements, 'significantly reduces sample 
overhead' is a totally inadequate description to judge this patch set.

Please also include total diffstat in the 0/N mail.

Thanks,

	Ingo
